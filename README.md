<p align="center">
  <img width="200" height="200" alt="MitraManas Icon" src="https://github.com/user-attachments/assets/1178fdae-d32b-496b-9167-d39b2786f5fb" />
</p>

<h1 align="center">🌌 MitraManas – AI-Powered Mental Wellness & Meditation App</h1>

<p align="center">
  <i>"Awaken your mind. Heal your soul. With AI by your side."</i>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-Frontend-blue.svg" />
  <img src="https://img.shields.io/badge/Node.js-Backend-green.svg" />
  <img src="https://img.shields.io/badge/Gemini%202.5%20Flash-AI%20Therapy-yellow.svg" />
  <img src="https://img.shields.io/badge/Firebase-Auth%20%26%20Firestore-orange.svg" />
  <img src="https://img.shields.io/badge/PostgreSQL-Aiven%20Cloud-blue.svg" />
  <img src="https://img.shields.io/badge/Render-Live%20Backend-purple.svg" />
</p>

---

## 📱 About MitraManas

**MitraManas** is a next-gen mental wellness app built with Flutter and supercharged by Node.js, Firebase, PostgreSQL, and Google’s Gemini 2.5 Flash API. It serves as a compassionate digital companion designed to promote emotional balance, mindfulness, and personal growth.

---

## ✨ App Highlights

### 🧘‍♂️ Meditation Module
- 🌤️ Daily motivational quotes (via Gemini)
- 🎯 Mood-tagged suggestions like *"I'm feeling anxious"* or *"I need focus"*
- 🔥 Unique glassmorphic **StreakProgressBar**
- 📆 Streaks stored & synced via Firestore

### 🎵 Music Player
- 🎶 Powered by `just_audio`  
- 🌌 Cosmic UI gradients & blurred cards  
- 🔊 Background playback & playlist support

### 💬 AI Therapy Chatbot: Miitra
- 🤖 Real-time conversation via **Gemini 2.5 Flash API**
- 🧠 Personalized, empathetic mental wellness replies
- 🔉 Text-to-Speech (`flutter_tts`)
- 💬 Animated floating chatbot action button

### 📰 Blogs & Articles
- 📚 Blogs stored in PostgreSQL DB via Node.js API
- 🧾 Full backend CRUD for blog management
- 📲 Flutter BlogListScreen with fade animation

### 👤 Profile & Streak View
- 🪟 Glassmorphism profile cards
- 👥 Display name, avatar, email, and streak history
- 🔄 Auth via Google Sign-In and Email/Password

---

## 🌐 Backend Infrastructure

### 🛠️ Node.js + Express.js API
- Built on **Express.js** and modular route handlers  
- REST APIs for:
  - 🧠 AI (Gemini) responses
  - 📰 Blog management
  - 📊 Streaks
- Middleware includes validation, error handling, and logging

### 📡 Hosting & Deployment
- 🌍 Hosted on **Render.com**  
- 🚦 Kept awake using **UptimeRobot** ping system  
- 🔐 `.env` secured via Render secrets dashboard

### 🗃️ PostgreSQL on Aiven
- Production DB hosted on **Aiven Cloud Services**
- ORM using `pg` module  
- Indexed schemas for:
  - Users
  - Blogs
  - Streaks
  - Feedback

### 🧠 Gemini 2.5 Flash API
- Used in AI Chatbot (Miitra) via `@google/generative-ai`
- Enables real-time empathetic, contextual answers

---

## 🔐 Firebase Integration

- ✅ Firebase Auth
  - Email/Password
  - Google Sign-In
  - SHA-1 & SHA-256 fingerprint used for Android
- 🗂️ Firestore
  - Store user profile, moods, and streaks
  - Indexed & structured per clean architecture
- 🔥 Firebase used with `flutterfire` + `firebase_core`, `firebase_auth`, `cloud_firestore`

---
## 🧠 Tech Stack

| Layer       | Tech                                                                 |
|-------------|----------------------------------------------------------------------|
| Frontend    | Flutter + BLoC + Clean Architecture                                  |
| Backend     | Node.js + Express.js (hosted on Render)                             |
| Database    | PostgreSQL (Aiven cloud services)                                    |
| API AI      | Google Gemini 2.5 Flash                                              |
| Auth        | Firebase Auth (Google + Email)                                       |
| Storage     | Firestore (remote) + Hive (local/offline)                            |
| Hosting     | Render.com + UptimeRobot (keep alive)                                |
| Local DB    | Hive for streaks, preferences, and offline data                      |

---
<p align="center">
  <img src="https://github.com/user-attachments/assets/c8565308-cc43-4f3c-9a8a-657154d6d070" width="100%" />
</p>

---

### 📸 Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/73aa6801-d816-4fcd-bf21-36ce1cbc0beb" width="140"/>
  <img src="https://github.com/user-attachments/assets/ce12a978-29b1-4f49-a5e4-96018e6b74d7" width="140"/>
  <img src="https://github.com/user-attachments/assets/5363477c-ea2b-4a94-a314-627df1f5e730" width="140"/>
  <img src="https://github.com/user-attachments/assets/e8463a6e-38cf-4ac6-b8da-afe46268d05c" width="140"/>
  <img src="https://github.com/user-attachments/assets/867d29f3-2fc7-4d69-84c4-3d22e7f06552" width="140"/>
  <img src="https://github.com/user-attachments/assets/b63224a3-cac2-4ecc-84ce-243235c4ec93" width="140"/>
</p>

---

### 👤 Developed by

**Harsh Vardhan Sahu**  
`Full-stack Developer | Flutter + Node.js | AI Integrator`

