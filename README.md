# Bade Blog Backend

A Ruby on Rails API backend for a personal story-sharing platform, focusing on simple content management and user interaction.

## Features

- Story management with draft/publish workflow
- Category organization
- Comment system
- User authentication with JWT
- Image upload support
- Role-based access control (Admin/User)

## Tech Stack

- Ruby on Rails API
- PostgreSQL database
- Active Storage for image handling
- JWT authentication
- Docker support
- RSpec for testing

## Getting Started

1. Install dependencies:
   bundle install

2. Setup database:

rails db:create db:migrate db:seed

3. Start server:

rails server

## API Endpoints

- **Stories:** GET/POST/PUT/DELETE `/stories`
- **Categories:** GET `/categories`
- **Comments:** GET/POST/PUT/DELETE `/stories/:story_id/comments`
- **Auth:** POST `/sessions` (login), POST `/users` (signup)

## Docker Support

Build and run with Docker:

docker-compose up --build
