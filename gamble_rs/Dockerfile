FROM rust:1.91 

RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /backend_api

COPY Cargo*.toml /backend_api
COPY . /backend_api


# setting up sql database
RUN cargo install sqlx-cli
# RUN sqlx database create
# RUN sqlx migrate run
# RUN cargo build


LABEL name="backend-api"
LABEL version="0.1"
EXPOSE 5000
CMD [ "cargo", "run" ]


