use std::collections::HashMap;

use chrono::Utc;
use sqlx::{mysql::MySqlRow, FromRow, MySql, Pool};

use crate::models::utils::LimitSearch;

use super::error::{ControllerError, Result};

/////////// get by id example //////////////
/*
let user: User = get_by_id(db, 1, "users".to_string()).await?;
*/

pub async fn get_by_id<T>(db: Pool<MySql>, id: i32, table: String) -> Result<T>
where
    T: for<'r> FromRow<'r, sqlx::mysql::MySqlRow> + Send + Unpin,
{
    let query = format!(
        "SELECT * FROM {} WHERE id = ? AND deleted_by IS NULL AND deleted_at IS NULL;",
        table
    );

    println!("{}", query);
    let is_exist: Option<T> = sqlx::query_as(query.as_str())
        .bind(id)
        .fetch_optional(&db)
        .await?;

    match is_exist {
        Some(data) => Ok(data),
        None => Err(ControllerError::DataBase(format!(
            "Invalid Id on table: {}",
            table.clone()
        ))),
    }
}

/////////// get all example //////////////
/*
let search: LimitSearch = LimitSearch {
    skip:0,
    take:10
};
let user: User = get_all(db, "users".to_string(), search).await?;
*/

pub async fn get_all<T>(db: Pool<MySql>, table: String, limit_search: LimitSearch) -> Result<Vec<T>>
where
    T: for<'r> FromRow<'r, sqlx::mysql::MySqlRow> + Send + Unpin,
{
    let query = format!(
        "SELECT * FROM {} WHERE deleted_by IS NULL AND deleted_at IS NULL LIMIT ? OFFSET ?;",
        table
    );
    println!("{}", query);

    println!("{}", query);

    let result: Vec<T> = sqlx::query_as(query.as_str())
        .bind(limit_search.take)
        .bind(limit_search.skip)
        .fetch_all(&db)
        .await?;

    // if result.is_empty() {
    //     Err(ControllerError::DataBase(format!(
    //         "No data found in table {}",
    //         table
    //     )))
    // } else {
    //     Ok(result)
    // }
    Ok(result)
}

pub async fn get_all_data<T>(db: Pool<MySql>, table: String) -> Result<Vec<T>>
where
    T: for<'r> FromRow<'r, sqlx::mysql::MySqlRow> + Send + Unpin,
{
    let query = format!(
        "SELECT * FROM {} WHERE deleted_by IS NULL AND deleted_at IS NULL;",
        table
    );

    let result: Vec<T> = sqlx::query_as(query.as_str()).fetch_all(&db).await?;

    if result.is_empty() {
        Err(ControllerError::DataBase(format!(
            "No data found in table {}",
            table
        )))
    } else {
        Ok(result)
    }
}

/////////// create data example //////////////

/*
#[derive(FromRow)]
struct User {
    id: u32,
    name: String,
    age: i32,
}

let mut data = HashMap::new();
data.insert("name".to_string(), "John Doe".to_string());
data.insert("age".to_string(), "30".to_string());

let inserted_user: User = create_data(db, "users".to_string(), data).await?;
println!("Inserted User: {} - {}", inserted_user.id, inserted_user.name);
 */

pub async fn create_data<T>(
    db: Pool<MySql>,
    table: String,
    data: HashMap<String, String>,
) -> Result<T>
where
    T: for<'r> FromRow<'r, sqlx::mysql::MySqlRow> + Send + Unpin,
{
    // Extract keys and values from the HashMap
    let columns: Vec<String> = data.keys().cloned().collect();
    let values: Vec<String> = data.values().cloned().collect();

    // Create placeholders for binding the values in the query (e.g., ?, ?, ?)
    let placeholders: String = (0..columns.len())
        .map(|_| "?".to_string())
        .collect::<Vec<String>>()
        .join(", ");

    // Construct the query string dynamically
    let query = format!(
        "INSERT INTO {} ({}) VALUES ({});",
        table,
        columns.join(", "),
        placeholders
    );
    println!("{}", query);

    // Prepare the query and bind the values
    let mut query_builder = sqlx::query(query.as_str());
    for value in values {
        query_builder = query_builder.bind(value);
    }

    // Execute the query and return the result
    let result = query_builder.execute(&db).await?;

    // Retrieve the last inserted id
    let last_insert_id = result.last_insert_id();

    // Construct a query to fetch the inserted row
    let select_query = format!("SELECT * FROM {} WHERE id = ?;", table);

    // Fetch and return the inserted row
    let inserted_row: Option<T> = sqlx::query_as(select_query.as_str())
        .bind(last_insert_id)
        .fetch_optional(&db)
        .await?;

    match inserted_row {
        Some(row) => Ok(row),
        None => Err(ControllerError::DataBase(format!(
            "Failed to retrieve inserted data"
        ))),
    }
}

pub async fn create_multipal_data<T>(
    db: Pool<MySql>,
    table: &str,
    data_list: Vec<HashMap<String, String>>,
) -> Result<Vec<T>>
where
    T: for<'r> FromRow<'r, MySqlRow> + Send + Unpin,
{
    let mut transaction = db.begin().await?;

    if data_list.is_empty() {
        return Ok(Vec::new()); // Return empty vector if there's no data to insert
    }

    let columns: Vec<String> = data_list[0].keys().cloned().collect();

    // Create placeholders for the values (e.g., (?, ?), (?, ?), ...)
    let placeholders: String = data_list
        .iter()
        .map(|_| {
            format!(
                "({})",
                columns.iter().map(|_| "?").collect::<Vec<_>>().join(", ")
            )
        })
        .collect::<Vec<String>>()
        .join(", ");

    // Construct the bulk insert query
    let query = format!(
        "INSERT INTO {} ({}) VALUES {};",
        table,
        columns.join(", "),
        placeholders
    );

    let mut query_builder = sqlx::query(&query);

    // Bind all values for each row in the data_list by iterating over references
    for data in &data_list {
        for column in &columns {
            if let Some(value) = data.get(column) {
                query_builder = query_builder.bind(value);
            }
        }
    }

    let result = query_builder.execute(&mut *transaction).await?;

    // Retrieve the last inserted ID and the number of inserted rows
    let last_insert_id = result.last_insert_id();
    let num_inserted = data_list.len() as u64;

    // Fetch all inserted rows based on the ID range
    let select_query = format!("SELECT * FROM {} WHERE id >= ? AND id < ?;", table);

    let inserted_rows: Vec<T> = sqlx::query_as(&select_query)
        .bind(last_insert_id)
        .bind(last_insert_id + num_inserted)
        .fetch_all(&mut *transaction)
        .await?;

    transaction.commit().await?;
    Ok(inserted_rows)
}

pub async fn delete_by_id<T>(
    db: Pool<MySql>,
    id: i32,
    table: String,
    deleted_by: i32, // Now an integer representing user_id
) -> Result<T>
where
    T: for<'r> FromRow<'r, sqlx::mysql::MySqlRow> + Send + Unpin,
{
    // check if the deleted item exist or not
    get_by_id::<T>(db.clone(), id, table.clone()).await?;

    // Prepare the query to perform a soft delete
    let query = format!(
        "UPDATE {} SET deleted_by = ?, deleted_at = ? WHERE id = ?;",
        table
    );

    // Execute the update query with bindings for `deleted_by` (user_id), current time, and the `id`
    let result = sqlx::query(query.as_str())
        .bind(deleted_by) // Bind the user_id who is performing the deletion
        .bind(Utc::now()) // Set the current timestamp for deleted_at
        .bind(id) // Bind the id of the row to be deleted
        .execute(&db)
        .await?;

    // Check if the row was actually updated
    if result.rows_affected() == 0 {
        return Err(ControllerError::DataBase(format!("Invalid Id: {}", id)));
    }

    let data = get_by_id(db.clone(), id, table.clone()).await?;

    Ok(data)
}

pub async fn update_status_by_id<T>(
    db: Pool<MySql>,
    id: i32,
    table: String,
    status: String,
    updated_by: i32,
) -> Result<T>
where
    T: for<'r> FromRow<'r, sqlx::mysql::MySqlRow> + Send + Unpin,
{
    // check if the deleted item exist or not
    get_by_id::<T>(db.clone(), id, table.clone()).await?;

    let query = format!(
        "UPDATE {} SET status = ?, updated_by = ? WHERE id = ? AND deleted_by IS NULL AND deleted_at IS NULL;",
        table
    );

    // Execute the update query with bindings for `deleted_by` (user_id), current time, and the `id`
    let result = sqlx::query(query.as_str())
        .bind(&status) // Bind the user_id who is performing the deletion
        .bind(updated_by) // Bind the id of the row to be deleted
        .bind(id) // Bind the id of the row to be deleted
        .execute(&db)
        .await?;

    if result.rows_affected() == 0 {
        return Err(ControllerError::DataBase(format!("Invalid Id: {}", id)));
    }

    let data = get_by_id(db.clone(), id, table.clone()).await?;

    Ok(data)
}

pub async fn update_data<T>(
    db: Pool<MySql>,
    table: String,
    id: i32,
    data: HashMap<String, String>,
    updated_by: i32,
) -> Result<T>
where
    T: for<'r> FromRow<'r, sqlx::mysql::MySqlRow> + Send + Unpin,
{
    // check if the deleted item exist or not
    get_by_id::<T>(db.clone(), id, table.clone()).await?;
    // Extract keys and values from the HashMap
    let columns: Vec<String> = data.keys().cloned().collect();
    let values: Vec<String> = data.values().cloned().collect();

    // Create the SET clause for the update query dynamically
    let set_clause: String = columns
        .iter()
        .map(|col| format!("{} = ?", col))
        .collect::<Vec<String>>()
        .join(", ");

    // Construct the update query string dynamically
    let query = format!(
        "UPDATE {} SET {}, updated_by = ? WHERE id = ? AND deleted_by IS NULL AND deleted_at IS NULL;",
        table, set_clause
    );

    // Prepare the query and bind the values
    let mut query_builder = sqlx::query(query.as_str());
    for value in values {
        query_builder = query_builder.bind(value);
    }
    query_builder = query_builder.bind(updated_by); // Bind the updated user id
    query_builder = query_builder.bind(id); // Bind the ID at the end

    // Execute the update query
    let result = query_builder.execute(&db).await?;

    // Check if any rows were affected
    if result.rows_affected() == 0 {
        return Err(ControllerError::DataBase(format!(
            "No rows updated with ID {} in table {}",
            id, table
        )));
    }

    Ok(get_by_id(db.clone(), id, table.clone()).await?)
}

pub async fn search_data<T>(
    db: Pool<MySql>,
    table: String,
    data: HashMap<String, String>,
    limit_search: LimitSearch,
) -> Result<Vec<T>>
where
    T: for<'r> FromRow<'r, sqlx::mysql::MySqlRow> + Send + Unpin,
{
    // Extract keys and values from the HashMap
    let columns: Vec<String> = data.keys().cloned().collect();
    let values: Vec<String> = data.values().cloned().collect();

    // Create the WHERE clause dynamically based on the provided data
    let where_clause: String = columns
        .iter()
        .map(|col| format!("{} = ?", col))
        .collect::<Vec<String>>()
        .join(" AND ");

    // Construct the query string dynamically with the LIMIT and OFFSET for pagination
    let query = format!(
        "SELECT * FROM {} WHERE {} AND deleted_by IS NULL AND deleted_at IS NULL LIMIT ? OFFSET ?;",
        table, where_clause
    );

    // Prepare the query and bind the values
    let mut query_builder = sqlx::query_as::<_, T>(query.as_str());
    for value in values {
        query_builder = query_builder.bind(value);
    }

    // Bind the limit and offset for pagination
    query_builder = query_builder
        .bind(limit_search.take)
        .bind(limit_search.skip);

    // Execute the query and fetch the results
    let result = query_builder.fetch_all(&db).await?;

    Ok(result)
}

pub async fn get_count<T>(db: Pool<MySql>, table: String) -> Result<usize>
where
    T: for<'r> FromRow<'r, sqlx::mysql::MySqlRow> + Send + Unpin,
{
    let query = format!(
        "SELECT * FROM {} WHERE deleted_by IS NULL AND deleted_at IS NULL;",
        table
    );

    let data: Vec<T> = sqlx::query_as(query.as_str()).fetch_all(&db).await?;

    if data.len() == 0 {
        return Err(ControllerError::DataBase(
            "There are not accounts found".to_string(),
        ));
    }

    Ok(data.len())
}
