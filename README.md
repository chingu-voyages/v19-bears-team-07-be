# DevHub #

DevHub is a web application for Developers to share their app portfolios with the public. This repo contains the code for the backend. The frontend code is [here](https://github.com/chingu-voyages/v19-bears-team-07).

Built with Ruby on Rails and Devise Authentication, as part of Chingu Voyage 19.

## Features

- CRUD APIs for apps, users/developers, app ratings/favorites, and comments
- Regex-based database search returns matches in ranked order
- Cross-domain, cookie-based authentication via Devise for whitelisted origins

## Major Dependencies

- Devise
- Rack-Cors
- Rails

## Build/Deploy Instructions

Prerequisites:

- Ruby >= 2.5.5
- Rails >= 6.0

Use `bundle install` to install all libraries, and run `rails db:migrate` and `rails db:seed` to set up the database.
To run tests, use `rails test`.

Running `rails server` will deploy locally at `http://localhost:8000`. You will then also have to build and deploy the [frontend repo](https://github.com/chingu-voyages/v19-bears-team-07) by following its README instructions.
