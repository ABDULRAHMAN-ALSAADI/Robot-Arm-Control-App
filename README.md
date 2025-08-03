# 🤖 Robot Arm Control App

A comprehensive mobile application for controlling a 6-DOF robot arm with real-time positioning, move management, and database integration.

## 🖼️ App Screenshots

![APP PIC 1](https://github.com/user-attachments/assets/4944e024-7a42-45a4-9015-e0265f61576f)


## ✨ Features

🎛️ Control Interface

- 6 Joint Sliders (0-180°) with real-time value display
- Reset Function - Instantly return all joints to 90° home position
- Live Position Feedback - See exact joint angles as you adjust

💾 Move Management

- Save Custom Moves - Store complex positions with custom names
- Database Integration - All moves persist in MySQL database
- Load & Execute - Recall saved moves instantly
- Delete Management - Remove unwanted moves from database

🚀 Robot Control

- Run Commands - Execute moves with HTTP communication to ESP32
- Stop Function - Emergency stop for immediate halt
- Status Tracking - Real-time running/stopped status display
- JSON Communication - Structured data format for reliable transmission

## 🏗️ System Architecture

```
📱 Flutter App → 🌐 XAMPP/PHP API → 🗄️ MySQL Database → 📡 ESP32 → 🤖 Robot Arm
```

## 🧱 Tech Stack

- Flutter (UI & Logic)

- Android Studio (Development)

- XAMPP (Localhost server)

- SQL (Data storage)

- ESP32 (Motor control hardware)

## 📊 Database Schema

- robot_moves Table

```sql
id (INT) | name (VARCHAR) | joint1-6 (DECIMAL) | created_at (TIMESTAMP)
```

- robot_status Table

```sql
id (INT) | move_id (INT) | move_name (VARCHAR) | joint1-6 (DECIMAL) | status (INT) | updated_at (TIMESTAMP)
```







