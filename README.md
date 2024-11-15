## Overview

This backend is a Rails-based API for a blog platform where my grandfather can share life stories, literary works, and engage with readers through comments. The platform provides the ability for adin users to create, update, view, and manage stories, while also allowing regular users to comment on them.

## Features

- User Authentication: Secure login system with JWT tokens.
- Roles: Two types of users:
  - Admin: Can manage all users and stories.
  - User: Can create comments for stories.
- Story Management: Admins can create, update, and delete stories. Stories can be in a draft or published state.
- Comments: Users can comment on published stories. Only the author of a comment or an admin can modify or delete comments.
- Categories: Stories are organized into categories, and stories can be retrieved by category.
- Health Check: Simple endpoint to check if the application is running (`/health`).

## Routes

### Health Check

- GET /health: Returns `ok` if the application is running.

### Users

- POST /users: Create a new user (registration).
- GET /users/:id: View user profile.
- PUT /users/:id: Update user profile (only accessible for authenticated users).
- GET /profile: Get the authenticated user's profile.

### Sessions (Authentication)

- POST /sessions: Log in and receive a JWT token.

### Stories

- GET /stories: Retrieve a list of published stories (public).
- GET /stories/:id: Retrieve a single story by its ID.
- POST /stories: Create a new story (requires authentication).
- PUT /stories/:id: Update an existing story (requires authentication).
- DELETE /stories/:id: Delete a story (requires admin privileges).
- GET /stories/published: Retrieve a list of all published stories (public).
- GET /stories/drafts: Retrieve a list of draft stories (admin only).

### Categories

- GET /categories: List all categories.
- GET /categories/:id: Retrieve a single category by its ID.
- GET /categories/:id/stories: List all stories belonging to a specific category.

### Comments

- GET /stories/:story_id/comments: Retrieve a list of comments on a specific story.
- POST /stories/:story_id/comments: Create a comment on a story (requires authentication).
- PUT /stories/:story_id/comments/:id: Update an existing comment (only the author or admin can update).
- DELETE /stories/:story_id/comments/:id: Delete a comment (only the author or admin can delete).

## Authentication

The backend uses JWT (JSON Web Tokens) for user authentication. When a user logs in, they receive a JWT token that must be included in the `Authorization` header for subsequent requests that require authentication.

- Example: `Authorization: Bearer <your_token_here>`

### Login

To log in, send a POST request to `/sessions` with the user's email and password.

POST /sessions
{
"email": "user@example.com",
"password": "password123"
}

The response will contain a JWT token, which can then be used for authenticated requests.

### Protecting Routes

Certain routes require users to be authenticated (e.g., creating/updating stories or posting comments). If the user is not authenticated, a `401 Unauthorized` response will be returned.

## Models

### User

The `User` model represents a person who interacts with the blog. A user can be either an `admin` or a `user`.

- Attributes:
  - `email` (string): Email address (must be unique).
  - `password` (string): Hashed password for authentication.
  - `name` (string): User's name.
  - `role` (string): User's role (`admin` or `user`).

### Story

The `Story` model represents a blog post or article. It can have two statuses: `draft` or `published`.

- Attributes:
  - `title` (string): Title of the story.
  - `content` (text): Body content of the story (supports rich text).
  - `status` (string): Story status (`draft` or `published`).
  - `category_id` (integer): Category to which the story belongs.
  - `user_id` (integer): The user who created the story.
  - `photo` (file): An optional attached image for the story.

### Category

The `Category` model is used to group stories into different categories.

- Attributes:
  - `name` (string): The name of the category.

### Comment

The `Comment` model represents a comment left by a user on a story.

- Attributes:
  - `content` (text): The text content of the comment.
  - `story_id` (integer): The story to which the comment belongs.
  - `user_id` (integer): The user who left the comment.

## Serializers

The API uses serializers to format the data before sending it to the client. There are serializers for `User`, `Story`, `Comment`, and `Category`.

- UserSerializer: Formats the user data to include the user's name and email.
- StorySerializer: Formats the story data and includes the associated user and category.
- CommentSerializer: Formats the comment data and includes user information.
- CategorySerializer: Formats the category data with the name.

## Installation and Setup

1. Clone the repository:

   git clone <repository-url>
   cd <project-folder>

2. Install dependencies:

   bundle install

3. Set up the database:

   rails db:create
   rails db:migrate
   rails db:seed

4. Start the Rails server:

   rails server

5. Access the app:

   The backend will be running at `http://localhost:3000`. You can test the API using Postman, cURL, or any other API testing tool.

## Development Notes

- Authentication: The system uses JWT for secure authentication. Ensure you pass the JWT in the Authorization header for requests that require authentication.
- Roles: Admins have full control over users and stories, while regular users can only manage their own stories.
- Story Status: Stories can be in `draft` or `published` status. Only published stories are visible to public users.

## Conclusion

This backend is designed to be simple yet robust for sharing stories and literary works. By using JWT for authentication, it's secure and allows for role-based access control. Admin can use this platform to easily share life stories, and interact with readers through comments.

If you have any questions or need further assistance with setting up or extending the platform, feel free to reach out!
