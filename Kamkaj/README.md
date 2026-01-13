# KamKaj - Worker Hailing Application 🛠️

**KamKaj** is a mobile application developed as a Final Year Project (FYP). It connects daily wage workers with clients, offering a seamless platform for hiring and job management.

## 🚀 Features

- **Role-Based Access**: Separate interfaces for Clients and Workers.
- **Authentication**: Secure login/signup via Email & Google Sign-In.
- **Job Posting**: Clients can post job requirements with details.
- **Job Bidding**: Workers can view available jobs and place bids.
- **Real-Time Updates**: Status tracking for ongoing jobs.
- **Profile Management**: User profiles for both clients and workers.

## 🛠️ Technology Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Node.js & Express (API), Firebase (Auth & Services)
- **Database**: MongoDB / Firebase Firestore (TBD)
- **State Management**: Provider

## 📂 Project Structure

- `kamkaj_app/`: The Flutter mobile application source code.
- `backend/`: The Node.js server API.

## 🏁 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Node.js](https://nodejs.org/)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/kanwalrai07/Kamkaj-FYP.git
   cd Kamkaj-FYP
   ```

2. **Setup the App:**
   ```bash
   cd kamkaj_app
   flutter pub get
   ```

3. **Setup the Backend (If running locally):**
   ```bash
   cd backend
   npm install
   npm run dev
   ```

4. **Run the App:**
   ```bash
   cd kamkaj_app
   flutter run
   ```

## 🤝 Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

## 📄 License

This project is for educational purposes.
