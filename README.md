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

## Aditional Stuff

A few improvements were suggested as next steps for this project, and this is how I would implement it:

- A security layer: The simplest way I know to achieve that is by using the Devise gem that simplifies a lot of authentication and security problems, and it's very commonly used in RoR projects

- A permission layer: The `cancancan` gem is the [most downloaded gem](https://www.ruby-toolbox.com/categories/rails_authorization) for authorization and is quite simple to configure with its generated `Ability` class, providing simple helpers such as `can` and `cannot` which verify if a given user is able to execute a given action. Combined with the gem `rolify`, to add user roles in the application (such as admin, dev, support, etc), this can be a very powerful and simple solution.

- Modify orders in production: A simple admin dashboard with *unlimited power* would be enough to fix these small cases, of course, combined with a strong permission layer such as the mentioned above, to guarantee that only the correct users will have access to this dashboard.

- A Web UI: React is a framework that works very nicely when communicating to an API, using libraries such as Axios, although I believe that rails views, with some SCSS for styling and `.html.erb` files would be enough to implement an UI for this project given its simplicity
