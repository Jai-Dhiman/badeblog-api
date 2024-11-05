Blog Backend

A Ruby on Rails API backend for a personal story-sharing platform, designed to help my grandfather document and share his life stories and memories.
Features

    JWT-based authentication
    Rich text story creation and management
    Photo attachments for stories
    Categorized content organization
    Comment system
    Soft deletion for stories
    Role-based access control (admin/user)

Technical Stack

    Ruby on Rails (API mode)
    PostgreSQL database
    Active Storage for file handling
    Action Text for rich text content
    JWT for authentication
    Paranoia gem for soft deletions

Database Schema

The application uses the following main models:

    Users (with authentication)
    Stories (with rich text and photo attachments)
    Categories
    Comments

API Endpoints
Authentication

    POST /api/v1/sessions - User login
    POST /api/v1/users - User registration

Stories

    GET /api/v1/stories - List all stories
    POST /api/v1/stories - Create a story
    GET /api/v1/stories/:id - Show story details
    PUT /api/v1/stories/:id - Update a story
    DELETE /api/v1/stories/:id - Delete a story

Categories

    GET /api/v1/categories - List all categories
    GET /api/v1/categories/:id - Show category details
    GET /api/v1/categories/:id/stories - List stories in category

Comments

    GET /api/v1/stories/:story_id/comments - List comments for a story
    POST /api/v1/stories/:story_id/comments - Create a comment

Authentication

The API uses JWT (JSON Web Tokens) for authentication. Include the token in the Authorization header:

Authorization: Bearer <your-jwt-token>

Models
User

    Has many stories and comments
    Includes role-based authorization (admin/user)
    Validates email uniqueness and presence
    Uses has_secure_password for authentication

Story

    Belongs to a user and category
    Has many comments
    Supports rich text content and photo attachments
    Implements soft deletion
    Supports draft/published status

Category

    Has many stories
    Requires unique name

Comment

    Belongs to user and story
    Requires content

Setup

    Clone the repository
    Install dependencies:

bash

bundle install

    Set up the database:

bash

rails db:create
rails db:migrate

    Set up your credentials:

bash

rails credentials:edit

    Start the server:

bash

rails server

Security

    JWT tokens expire after 24 hours
    Password encryption using bcrypt
    Role-based authorization
    Authenticated endpoints protected with authenticate_user filter

Development

The application is set up with:

    PostgreSQL for database
    Action Text for rich text handling
    Active Storage for file attachments
    Paranoia for soft deletions
    JWT for authentication

Notes

This API backend is designed to work with a Vue.js frontend, specifically tailored for my grandfather to document and share his life stories. The focus is on providing a robust and secure API while maintaining simplicity in implementation.
