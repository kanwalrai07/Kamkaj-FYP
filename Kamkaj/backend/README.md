# KamKaj Backend

Backend for the KamKaj Worker Hailing Application. Built with Node.js, Express, and MongoDB.

## Features
- **Authentication**: Signup and Login for Clients and Workers.
- **Security**: Password hashing (bcrypt) and JWT tokens.
- **Database**: MongoDB with Mongoose schemas.

## Setup Instructions

1.  **Install Dependencies**
    ```bash
    npm install
    ```

2.  **Configure Database**
    - Open `config/db.js`.
    - Update the `dbURI` with your MongoDB connection string.
    - Default is `mongodb://localhost:27017/kamkaj` (requires local MongoDB).

3.  **Run Server**
    - Development (auto-reload):
      ```bash
      npm run dev
      ```
    - Production:
      ```bash
      npm start
      ```

## API Endpoints

### Authentication

| Method | Endpoint | Body | Description |
| :--- | :--- | :--- | :--- |
| `POST` | `/api/signup` | `{ "name": "...", "email": "...", "password": "...", "type": "client" }` | Register a new user. Type can be 'client' or 'worker'. |
| `POST` | `/api/signin` | `{ "email": "...", "password": "..." }` | Login and receive a JWT token. |
| `POST` | `/tokenIsValid` | Header: `x-auth-token` | Check if token is valid (returns true/false). |
| `GET` | `/` | Header: `x-auth-token` | Get current user data. |

## Folder Structure
- `config/`: Database connection.
- `models/`: Mongoose schemas.
- `middleware/`: Auth middleware.
- `controllers/`: Logic for routes.
- `routes/`: API route definitions.
