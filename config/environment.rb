# frozen_string_literal: true

require 'pg'
require 'dotenv'
require 'connection_pool'
Dotenv.load

DB = ConnectionPool.new(size: ENV['DB_POOL_SIZE'].to_i, timeout: ENV['DB_POOL_TIMEOUT'].to_i) do
  PG.connect(
    dbname: ENV['DB_NAME'],
    user: ENV['DB_USER'],
    password: ENV['DB_PASSWORD'],
    host: ENV['DB_HOST'],
    port: ENV['DB_PORT'] || '5432'
  )
end
