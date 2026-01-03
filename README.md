# UniSaver: Technical Documentation

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=flat-square&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore%20%7C%20Crashlytics-FFCA28?style=flat-square&logo=firebase&logoColor=black)
![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-green?style=flat-square)

**UniSaver** is a Flutter-based academic utility application designed to calculate GPA scenarios using complex combination algorithms and automate data entry through local PDF parsing of official transcripts.

## 🏗 Architecture & Design Pattern

The application follows a **Modular Layered Architecture** to ensure separation of concerns, scalability, and testability.

* **Presentation Layer:** Handles UI components and local state management using `ValueNotifier` and `Provider`.
* **Domain/Business Logic Layer:** Contains the core algorithms for GPA calculation, recursive combination logic for grade scenarios, and data models.
* **Data Layer:** Manages data sources including local storage (SharedPreferences), secure cloud sync (Firestore), and file I/O operations (PDF parsing).

### State Management
* **Provider:** Used for dependency injection and global state management (e.g., User Persona, Theme Mode).
* **ValueNotifier:** Used for efficient, widget-level reactive state updates to minimize rebuilds in complex calculation screens.

---

## ⚙️ Core Technical Features

### 1. Local PDF Parsing & OCR
The application implements a custom parser to read e-Government transcript PDFs.
* **Mechanism:** Uses native Dart I/O to read file bytes and extracts text content using regular expressions (Regex).
* **Data Extraction:** Identifies patterns for "Course Name", "Credit", and "Letter Grade" to map them into Dart objects (`Course` models).
* **Privacy:** All parsing occurs **locally on the device's RAM**. No file upload occurs during this process.

### 2. Recursive Calculation Algorithm
A custom backtracking algorithm is used to determine potential grade combinations for a target GPA.
* **Input:** Current GPA, remaining courses, target GPA.
* **Process:** The algorithm recursively iterates through possible letter grade permutations for the remaining courses.
* **Optimization:** Pruning techniques are applied to discard branches that cannot mathematically satisfy the target condition, optimizing performance for high-credit scenarios.

### 3. Cloud Integration (Firebase)
* **Authentication:** Utilizes **Firebase Anonymous Auth** to create frictionless user sessions without requiring immediate credential input, preserving user privacy while maintaining data persistence.
* **Database:** **Cloud Firestore** is used to store user preferences (e.g., "Persona Type") and non-sensitive configuration data.
* **Stability:** Integrated with **Firebase Crashlytics** to track fatal/non-fatal errors in real-time, specifically monitoring PDF parsing exceptions across different iOS versions.

---

## 🔒 Data Privacy & Security

The application adheres to a strict **"Local-First"** data policy:
1.  **Transcript Data:** Parsed and processed entirely within the client-side sandbox. Raw PDF files are never transmitted to backend servers unless explicitly attached by the user in a Feedback report.
2.  **AdMob Compliance:** Implements `AppTrackingTransparency` (ATT) framework for iOS 14+ compliance, requesting explicit user permission for IDFA usage.
3.  **Data Deletion:** Includes a dedicated workflow for users to request permanent deletion of their anonymous IDs and associated data from Firestore.

---

## 📦 Key Dependencies

* `firebase_core`, `firebase_auth`, `cloud_firestore`: Backend infrastructure.
* `google_mobile_ads`: Monetization via Banner and Interstitial ads.
* `provider`: State management and dependency injection.
* `shared_preferences`: Local persistence for simple flags (e.g., onboarding status).
* `file_picker`: Handling local file system access for transcript uploads.

---

## 🚀 Build & Installation

### Prerequisites
* Flutter SDK: `>=3.0.0`
* Dart SDK: `>=3.0.0`
* CocoaPods (for iOS dependencies)
* Xcode (for iOS build)

### Setup
1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/yourusername/unisaver_flutter.git](https://github.com/yourusername/unisaver_flutter.git)
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **iOS Configuration:**
    * Navigate to the iOS folder: `cd ios`
    * Install pods: `pod install`
    * Ensure `GoogleService-Info.plist` is present in `ios/Runner`.
4.  **Run:**
    ```bash
    flutter run
    ```

---

## 📝 License

Proprietary Software. Developed by **Muhammed Said Mirza Bal**.
Copyright © 2026. All rights reserved.
