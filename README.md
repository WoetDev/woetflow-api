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
Add cookies middleware in application config & controller for authentication

config/application.rb:
```
module WoetflowApi
  class Application < Rails::Application
    ...

    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
  end
end
```

controllers/application_controller.rb:
```
class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  protect_from_forgery with: :exception

  ...
end
```

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

## Services (job queues, cache servers, search engines, etc.)

## Deployment instructions
