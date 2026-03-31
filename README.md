# ✈️ Wanderlust AI — Travel & Tourism Management System

Wanderlust AI is a **full-stack AI-powered travel management web application** that enables users to explore destinations, book travel packages, and generate personalized travel plans using artificial intelligence.

Built using **Flask, MySQL, and Groq (LLaMA 3.3)**, the system combines traditional booking functionality with intelligent features such as chatbots, itinerary generation, and smart recommendations.

---

## 🚀 Features

### 👤 User Features

* 🔐 Secure User Registration & Login
* 📦 Browse Travel Packages
* 📅 Book Travel Packages
* 📊 User Dashboard (view & manage bookings)
* ❌ Cancel Bookings

---

### 🤖 AI Features

* 💬 **Travel Chatbot**
  Ask travel-related questions and get intelligent responses

* 🗺️ **Itinerary Generator**
  Generate detailed day-wise travel plans

* ⭐ **Smart Recommendations**
  Personalized destination suggestions based on user preferences

---

### 🛠️ Admin Features

* 📊 Admin Dashboard (users, bookings, revenue)
* ➕ Add Packages
* ✏️ Edit Packages
* ❌ Delete Packages
* 📋 Manage Bookings
* 🔄 Update Booking Status

---

## 🏗️ Tech Stack

### Backend

* Python (Flask)
* MySQL
* PyMySQL

### Frontend

* HTML
* CSS
* JavaScript
* Jinja2 Templates

### AI Integration

* Groq API (LLaMA 3.3 model)

---

## 📁 Project Structure

```id="h4j2ka"
travel_management/
│
├── app.py
├── config.py
├── requirements.txt
├── .env
│
├── database/
│   └── schema.sql
│
├── models/
│   └── db.py
│
├── routes/
│   ├── auth.py
│   ├── packages.py
│   ├── bookings.py
│   ├── admin.py
│   └── ai_features.py
│
├── templates/
│   ├── base.html
│   ├── index.html
│   ├── 404.html
│   ├── auth/
│   ├── admin/
│   ├── bookings/
│   ├── dashboard/
│   ├── packages/
│   └── ai/
│
├── static/
│   ├── css/style.css
│   └── js/main.js
│
└── venv/
```

---

## ⚙️ Installation & Setup

### 1️⃣ Clone the Repository

```bash id="d8j2ms"
git clone <your-repo-url>
cd travel_management
```

### 2️⃣ Create Virtual Environment

```bash id="k3j1ns"
python -m venv venv
source venv/bin/activate      # Mac/Linux
venv\Scripts\activate         # Windows
```

### 3️⃣ Install Dependencies

```bash id="a7d92k"
pip install -r requirements.txt
```

### 4️⃣ Setup Database

```bash id="n2k9sk"
mysql -u root -p
CREATE DATABASE travel_management;
USE travel_management;
SOURCE database/schema.sql;
```

### 5️⃣ Configure Environment Variables

Create a `.env` file:

```id="s9dk2k"
SECRET_KEY=your_secret_key

DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=travel_management

GROQ_API_KEY=your_groq_api_key
```

---

## ▶️ Run the Application

```bash id="k29dk2"
python app.py
```

Open in browser:
👉 http://127.0.0.1:5000

---

## 🔑 Demo Credentials

### Admin Login

```
Email: admin@travel.com  
Password: admin123
```

---

## 🧠 AI Capabilities

* Natural language travel queries
* AI-generated itineraries
* Budget-based recommendations
* Context-aware conversation

---

## 🔒 Security Notes

* 🔐 Passwords are hashed using bcrypt
* 🔒 Sessions managed securely
* 🛡️ Parameterized SQL queries (prevents SQL injection)

⚠️ **Important:** Never hardcode API keys in production

---

## 📌 Future Enhancements

* 💳 Payment gateway integration
* 📱 Improved mobile responsiveness
* 📍 Google Maps integration
* 📧 Email notifications
* ⭐ Reviews & ratings system

---

## 👨‍💻 Author

**Anish Fathima**

---

## 📜 License

This project is for **educational purposes only**. You are free to modify and use it.

---

## 🌟 Support

If you found this project useful, consider giving it a ⭐ on GitHub and sharing it!

---