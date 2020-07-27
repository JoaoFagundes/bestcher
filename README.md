# Bestcher

The Bestcher is a REST Ruby on Rails API that implements the Best Batcher you'll see. It's purpose is to create a platform to receive **Purchase Orders** from other systems, group them on **Batches** and follow the Orders in the **production pipeline** until the dispatch.

## Dependencies & Installation

This project was implemented using [Docker](https://www.docker.com/) and so, this simplifies the proccess of installation in case you have Docker installed. Simply running `docker-compose build` would install all necessary dependencies and, after that is complete, a simple `docker-compose up` should be enough to have your API up and running.

In case you're not using Docker, you'll need Ruby 2.5, Rails 6.0 and Bundler 1.17.3 to properly run. In the project's root folder, please run `bundle install` and wait until the installation of dependencies is completed. When it's all set and done, start the server by running `rails server` and head to `localhost:3000` to see that you're in rails.

## Database setup

Batcher was built using PostgreSQL as its relational database, so you need to create and migrate the database before start messing around with our API. If you're using Docker, you must run `docker-compose run web rails db:create db:migrate db:seed` to create, migrate and seed the database with a few example data. The seed step is optional.

If docker is not being used, please make sure you have PostgreSQL service running in the background and simply run `rails db:create db:migrate db:seed` in the console from the project's root directory. Again, the seed step is optional.

## Test suite

Unit tests for both models and the services implemented were written using RSpec DSL. Acceptance tests for the endpoints in the application were also written using RSpec and Capybara and they can all be run from the projects root directory.

- To run the tests suite using docker:
```
docker-compose run web rspec .
```

- To run the tests suite normally:
```
rspec .
```
