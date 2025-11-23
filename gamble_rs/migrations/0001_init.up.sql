-- Add up migration script here
ALTER DATABASE `game` DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NULL,
  `email` VARCHAR(255) NULL,
  `password` varchar(255) NULL,
  `mobile` varchar(255) NULL,
  `otp` varchar(255) NULL,
  `refresh_token` varchar(255) NULL DEFAULT "",
  `wallet` varchar(255) NOT NULL DEFAULT "0",
  `role` ENUM('SYSTEM', 'ADMIN', 'WORKER', 'USER', 'NONE') NOT NULL DEFAULT 'NONE',
  `status` ENUM('ACTIVE', 'INACTIVE', 'BLOCKED', 'NONE') NOT NULL DEFAULT 'NONE',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` INT NULL,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` INT NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` INT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_unique` (`email`),
  UNIQUE KEY `mobile_unique` (`mobile`)
);

DROP TABLE IF EXISTS `file_uploads`;

CREATE TABLE `file_uploads` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `userid` INT NOT NULL,
    `file_type` VARCHAR(255) NOT NULL,
    `path` varchar(255) NOT NULL,
    `name` varchar(255) NOT NULL,
    `status` ENUM('ACTIVE', 'INACTIVE', 'NONE') NOT NULL DEFAULT 'NONE',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_by` INT NOT NULL,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `updated_by` INT NULL,
    `deleted_at` DATETIME NULL,
    `deleted_by` INT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`userid`) REFERENCES `users`(`id`),
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`updated_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`deleted_by`) REFERENCES `users`(`id`)
);


DROP TABLE IF EXISTS `payment_gateway`;

CREATE TABLE `payment_gateway` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `image` VARCHAR(255) NOT NULL,
    `short_image` VARCHAR(255) NULL,
    `payment_type` ENUM('UPI', 'QR', 'BANK', 'NONE') NOT NULL DEFAULT 'NONE',
    `status` ENUM('ACTIVE', 'INACTIVE', 'NONE') NOT NULL DEFAULT 'NONE',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_by` INT NOT NULL,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `updated_by` INT NULL,
    `deleted_at` DATETIME NULL,
    `deleted_by` INT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`updated_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`deleted_by`) REFERENCES `users`(`id`)
);


DROP TABLE IF EXISTS `workers_account`;

CREATE TABLE `workers_account` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `worker_id` INT NOT NULL,
    `gateway_id` INT NOT NULL,
    `upi_address` VARCHAR(255) NULL,
    `contact` VARCHAR(255) NULL,
    `qr_image` VARCHAR(255) NULL,
    `worker_email` VARCHAR(255) NULL,
    `bank_name` VARCHAR(255) NULL,
    `account_holder` VARCHAR(255) NULL,
    `ifsc_code` VARCHAR(255) NULL,
    `account_number` VARCHAR(255) NULL,
    `payment_type` ENUM('UPI', 'QR', 'BANK', "NONE") NOT NULL DEFAULT 'NONE',
    `status` ENUM('ACTIVE', 'INACTIVE', 'NONE') NOT NULL DEFAULT 'NONE',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_by` INT NOT NULL,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `updated_by` INT NULL,
    `deleted_at` DATETIME NULL,
    `deleted_by` INT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`worker_id`) REFERENCES `users`(`id`),
    FOREIGN KEY (`gateway_id`) REFERENCES `payment_gateway`(`id`),
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`updated_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`deleted_by`) REFERENCES `users`(`id`)
);

DROP TABLE IF EXISTS `withdrawal_request`;


CREATE TABLE `withdrawal_request` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT NOT NULL,
    `worker_id` INT NOT NULL,
    `amount` VARCHAR(255) NOT NULL DEFAULT "0",
    `bank_name` VARCHAR(255) NULL,
    `account_holder` VARCHAR(255) NULL,
    `ifsc_code` VARCHAR(255) NULL,
    `account_number` VARCHAR(300) NULL,
    `status` ENUM('ACTIVE', 'INACTIVE', 'NONE') NOT NULL DEFAULT 'NONE',
    `payment_status` ENUM('ACCEPT', 'REJECT', 'PROCESSING', 'PENDING', 'REFUNDED') NOT NULL DEFAULT 'PENDING',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_by` INT NOT NULL,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `updated_by` INT NULL,
    `deleted_at` DATETIME NULL,
    `deleted_by` INT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY (`worker_id`) REFERENCES `users`(`id`),
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`updated_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`deleted_by`) REFERENCES `users`(`id`)
);

DROP TABLE IF EXISTS `money_deposite`;

CREATE TABLE `money_deposite` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT NOT NULL,
    `worker_id` INT NOT NULL,
    `amount` VARCHAR(255) NOT NULL DEFAULT "0",
    `txn_id` VARCHAR(255) NOT NULL,
    `payment_gateway_id` INT NOT NULL,
    `worker_account_id` INT NOT NULL,
    `payment_screen_shot` VARCHAR(255) NOT NULL,
    `status` ENUM('ACTIVE', 'INACTIVE', 'NONE') NOT NULL DEFAULT 'NONE',
    `payment_status` ENUM('ACCEPT', 'REJECT', 'PROCESSING', 'PENDING', 'REFUNDED') NOT NULL DEFAULT 'PENDING',
    `rejected_reason` VARCHAR(255) DEFAULT NULL,
    `creteded_by` INT NOT NULL, 
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_by` INT NULL, 
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_by` INT NULL, 
    `deleted_at` DATETIME,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`updated_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`deleted_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`creteded_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY (`worker_id`) REFERENCES `users`(`id`),
    FOREIGN KEY (`payment_gateway_id`) REFERENCES `payment_gateway`(`id`),
    FOREIGN KEY (`worker_account_id`) REFERENCES `workers_account`(`id`)
);


DROP TABLE IF EXISTS `transition`;
CREATE TABLE `transition` ( 
    `id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT NOT NULL,
    `admin_id` INT NOT NULL,
    `amount` VARCHAR(255) DEFAULT "0",
    `tranisition_type` ENUM("DEBIT","CREDIT") NOT NULL DEFAULT 'DEBIT',
    `created_by` INT NOT NULL, 
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    `updated_by` INT NULL, 
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_by` INT NULL, 
    `status` ENUM("ACTIVE","INACTIVE") NOT NULL DEFAULT 'ACTIVE',
    `deleted_at` DATETIME NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY (`admin_id`) REFERENCES `users`(`id`),
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`updated_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`deleted_by`) REFERENCES `users`(`id`)
);



DROP TABLE IF EXISTS `games`;

CREATE TABLE `games` ( 
    `id` INT NOT NULL AUTO_INCREMENT,
    `uid` VARCHAR(255) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `start_time` DATETIME NOT NULL,
    `end_time` DATETIME NOT NULL,
    `max_number` INT NULL,
    `max_price` VARCHAR(255) NULL,
    `created_by` INT NOT NULL, 
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    `updated_by` INT NULL, 
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_by` INT NULL, 
    `status` ENUM("ACTIVE","INACTIVE","CANCELLED") NOT NULL DEFAULT 'ACTIVE',
    `deleted_at` DATETIME NULL,
    PRIMARY KEY (`id`),
    UNIQUE (`uid`),
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`updated_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`deleted_by`) REFERENCES `users`(`id`)
);


DROP TABLE IF EXISTS `daily_game`;

CREATE TABLE `daily_game` ( 
    `id` INT NOT NULL AUTO_INCREMENT,
    `game_id` INT NOT NULL,
    `result` VARCHAR(255) NULL, 
    `status` ENUM("UPCOMING", "ACTIVE", "COMPLETED", "CANCELLED", "INACTIVE") NOT NULL DEFAULT 'UPCOMING',
    `created_by` INT NOT NULL, 
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    `updated_by` INT NULL, 
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_by` INT NULL, 
    `deleted_at` DATETIME NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`updated_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`deleted_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`game_id`) REFERENCES `games`(`id`)
);

DROP TABLE IF EXISTS `user_bet`;

CREATE TABLE `user_bet` ( 
    `id` INT NOT NULL AUTO_INCREMENT,
    `game_id` INT NOT NULL,
    `daily_game_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `game_type` ENUM("JODI", "ANDER","BAHER"),
    `bid_number` VARCHAR(255) NOT NULL DEFAULT "0",
    `status` ENUM("PENDING","ACTIVE","COMPLETED","CANCELLED") NOT NULL DEFAULT 'ACTIVE',
    `amount` VARCHAR(255) DEFAULT "0" NOT NULL,
    `created_by` INT NOT NULL, 
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    `updated_by` INT NULL, 
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_by` INT NULL, 
    `deleted_at` DATETIME NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`updated_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`deleted_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`game_id`) REFERENCES `games`(`id`),
    FOREIGN KEY (`daily_game_id`) REFERENCES `daily_game`(`id`)
);

DROP TABLE IF EXISTS `game_result`;

CREATE TABLE `game_result` ( 
    `id` INT NOT NULL AUTO_INCREMENT,
    `game_id` INT NOT NULL,
    `daily_game_id` INT NOT NULL,
    `transition_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `result` ENUM("WIN", "LOSS"),
    `amount` VARCHAR(255) NOT NULL,
    `created_by` INT NOT NULL, 
    `status` ENUM("INACTIVE","ACTIVE") NOT NULL DEFAULT 'ACTIVE',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    `updated_by` INT NULL, 
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_by` INT NULL, 
    `deleted_at` DATETIME NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`transition_id`) REFERENCES `transition`(`id`),
    FOREIGN KEY (`updated_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`daily_game_id`) REFERENCES `daily_game`(`id`),
    FOREIGN KEY (`deleted_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`game_id`) REFERENCES `games`(`id`)
);

DROP TABLE IF EXISTS `statement`;

-- CREATE TYPE GameLaunchStatus AS ENUM ('Pending', 'Active', 'Completed', 'Canceled'); 

CREATE TABLE `statement` ( 
    `id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT NULL,
    `game_id` INT NULL,
    `user_bet_id` INT NULL,
    `game_result_id` INT NULL,
    `money_deposite_id` INT NULL,
    `withdraw_request_id` INT NULL,
    `daily_game_id` INT NULL,
    `created_by` INT NOT NULL, 
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    `updated_by` INT NULL, 
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
    `deleted_by` INT NULL, 
    `deleted_at` DATETIME NULL,
    `statement_type` ENUM("WITHDRAW", "ADD", "GAME", "PLAY", "CASH") NOT NULL,
    `status` ENUM("INACTIVE","ACTIVE") NOT NULL DEFAULT 'ACTIVE',
    PRIMARY KEY (`id`),
    FOREIGN KEY (`game_id`) REFERENCES `games`(`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`updated_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`deleted_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`user_bet_id`) REFERENCES `user_bet`(`id`),
    FOREIGN KEY (`game_result_id`) REFERENCES `game_result`(`id`),
    FOREIGN KEY (`money_deposite_id`) REFERENCES `money_deposite`(`id`),
    FOREIGN KEY (`withdraw_request_id`) REFERENCES `withdrawal_request`(`id`),
    FOREIGN KEY (`daily_game_id`) REFERENCES `daily_game`(`id`)
);

DROP TABLE IF EXISTS `users_account`;

CREATE TABLE `users_account` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT NOT NULL,
    `bank_name` VARCHAR(255) NULL,
    `account_holder` VARCHAR(255) NULL,
    `ifsc_code` VARCHAR(255) NULL,
    `account_number` VARCHAR(300) NULL,
    `status` ENUM('ACTIVE', 'INACTIVE', 'NONE') NOT NULL DEFAULT 'NONE',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_by` INT NOT NULL,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `updated_by` INT NULL,
    `deleted_at` DATETIME NULL,
    `deleted_by` INT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`updated_by`) REFERENCES `users`(`id`),
    FOREIGN KEY (`deleted_by`) REFERENCES `users`(`id`)
);
