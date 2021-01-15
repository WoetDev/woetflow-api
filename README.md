# README

This README documents whatever steps are necessary to get the
application up and running.

## Ruby version
Ruby 2.7.2

## System dependencies
* Ruby
* Rails
* PostgreSQL
* Rspec
* Redis

## Configuration
Use of JWTSessions gem with cookies for XSS & CSRF safe authentication

## Database creation (PostgreSQL)
Created database user 'barry' with password
```
sudo -u postgres createuser -s barry -P
```

Added database user password as an environment variable
```
echo 'export WOETFLOW_DATABASE_PASSWORD="PostgreSQL_Role_Password"' >> ~/.bashrc
```

Export the variable for current session
```
source ~/.bashrc
```

Add user configuration to database.yml
```
...
default: &default
  adapter: postgresql
  encoding: unicode
  # For details on connection pooling, see Rails configuration guide
  # https://guides.rubyonrails.org/configuring.html#database-pooling
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: barry
  password: <%= ENV['WOETFLOW_DATABASE_PASSWORD'] %>

development:
  <<: *default
  database: woetflow_api_development
...
```

Create databases from database.yml
```
rails db:create
```

## Database initialization (PostgreSQL)
Restart database server
```
sudo service postgresql restart
```

## How to run the test suite
Test if application is running
```
curl http://127.0.0.1:3000
```

Run all tests
```
rspec
```

## Services
JWTSessions gem uses Redis as the default token store

Check if redis-server is running
```
sudo service redis-server status
```

Force restart redis-server
```
sudo service redis-server restart
```

Stop/start redis-server
```
sudo service redis-server stop
sudo service redis-server start
```

## Deployment instructions
Push repository to Heroku
```
git push heroku main
```