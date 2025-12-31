Inventory Management System

(Movement-Based Stock Tracking)

A simple yet industry-correct Inventory Management System built using Phoenix (Elixir) for the backend and React for the frontend.

Instead of storing stock directly, the system tracks inventory movements (IN, OUT, ADJUSTMENT) and derives stock dynamically, ensuring full auditability and correctness.

🚀 Key Features

Create items with unique SKU

Record inventory movements (IN / OUT / ADJUSTMENT)

View movement history per item

Stock calculated dynamically (no stock column)

Clean REST APIs

Automated backend tests (mix test)

Simple, functional frontend UI

🧠 Inventory Logic (Core Concept)

Stock is calculated using:

Stock = sum(IN) − sum(OUT) ± ADJUSTMENT

Why this design?

✅ Full audit trail of stock changes

✅ Prevents accidental stock corruption

✅ Easy debugging and reporting

✅ Used in real-world ERP / warehouse systems

🏗️ Tech Stack
Backend

Elixir

Phoenix Framework

Ecto

PostgreSQL

Frontend

React

Axios

Vite

Basic CSS

📂 Project Structure
inventory_assignment/
│
├── backend/
│ ├── lib/
│ ├── priv/repo/migrations/
│ ├── test/
│ └── mix.exs
│
└── frontend/
├── src/
├── package.json
└── vite.config.js

⚙️ Prerequisites

Ensure the following are installed:

Elixir (>= 1.15)

Erlang / OTP

PostgreSQL

Node.js (>= 18)

npm

🔧 Backend Setup (Phoenix)
1️⃣ Navigate to backend
cd backend

2️⃣ Install dependencies
mix deps.get

3️⃣ Configure database

Edit config/dev.exs:

config :backend, Backend.Repo,
username: "postgres",
password: "your_password",
database: "inventory_dev",
hostname: "localhost",
show_sensitive_data_on_connection_error: true,
pool_size: 10

4️⃣ Create & migrate database
mix ecto.create
mix ecto.migrate

5️⃣ Start Phoenix server
mix phx.server

Backend runs at:

http://localhost:4000

🧪 Running Backend Tests

The project uses Elixir’s built-in ExUnit framework.

Setup test database
MIX_ENV=test mix ecto.create
MIX_ENV=test mix ecto.migrate

Run all tests
mix test

Expected output
Finished in 0.x seconds
All tests passed

✔️ Always run tests before deployment or submission.

🎨 Frontend Setup (React)
1️⃣ Navigate to frontend
cd frontend

2️⃣ Install dependencies
npm install

3️⃣ Start frontend server
npm run dev

Frontend runs at:

http://localhost:5173

🔗 API Endpoints
Items
Method Endpoint Description
GET /api/items List all items
POST /api/items Create a new item
Inventory Movements
Method Endpoint Description
POST /api/movements Create inventory movement
GET /api/items/:id/movements Get movement history
📥 Sample API Requests
Create Item
POST /api/items
{
"name": "Keyboard",
"sku": "KEY-001",
"unit": "pcs"
}

Create Inventory Movement
POST /api/movements
{
"movement": {
"item_id": "item-uuid",
"movement_type": "IN",
"quantity": 25
}
}

Get Movement History
GET /api/items/:id/movements

📝 Assumptions

Quantity is always a positive integer

Movement type determines stock direction

Stock is derived, not stored

Authentication is not implemented (assignment scope)

UI kept minimal to focus on core logic

🚧 Future Enhancements

Prevent OUT when stock is insufficient

Running stock balance per movement

Pagination & filters for history

Authentication & authorization

Improved UI & UX

Export reports (CSV / Excel)

✅ Final Notes

This project demonstrates:

Correct inventory modeling

Clean Phoenix architecture

Proper use of Ecto & migrations

Test-driven backend design

Scalable and production-ready logic

It is assignment-ready, interview-ready, and easy to extend.

Author: Divyanshu Tripathi
Purpose: Backend / Full-Stack Assessment Project
