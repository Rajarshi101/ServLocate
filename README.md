# 📱 ServLocate App – Full Documentation

## Overview
ServLocate is an on-demand services platform built using Flutter and Firebase, integrated with CometChat UIKit for real-time messaging. It enables users to post, explore, book, and manage service requests across various categories like teaching, healthcare, cleaning, tech support, and more. Both clients and service providers operate from a single account, switching roles dynamically.

---
## ✅ Core Functionalities
* ***User Login*** via UID (CometChat)
* ***Service Posting*** with optional image upload
* ***Service Browsing & Filtering*** by category
* ***Booking Services*** with real-time updates
* ***Service Provider Dashboard*** to accept/reject bookings
* ***Booking History*** View for clients
* ***Real-time Chat*** using CometChat UIKit
* ***Mock Payment Screen*** (placeholder for real payment gateway) **[NOT YET INTEGRATED]**

---
## 🔧 Tech Stack
| Layer            | Technology                          |
| ---------------- | ----------------------------------- |
| Frontend         | Flutter (Dart)                      |
| State Management | Stateful Widgets                    |
| Backend          | Firebase (Firestore, Storage, Auth) |
| Realtime Chat    | CometChat UIKit                     |
| Image Handling   | image\_picker + Firebase Storage    |
| Authentication   | UID-based (via CometChat login)     |

---
## 📁 Project Structure
```
lib/
├── main.dart
├── models/
│   └── service_model.dart
├── screens/
│   ├── bookings/
│   │   ├── booking_history_screen.dart
│   │   ├── provider_booking_requests_screen.dart
│   │   └── provider_accepted_bookings_screen.dart
│   ├── services/
│   │   ├── post_service_screen.dart
│   │   ├── service_explorer_screen.dart
│   │   └── service_details_screen.dart
│   ├── auth/
│   │   └── login_screen.dart
│   ├── inbox_screen.dart
│   ├── splash_screen.dart
│   └── main_navigation_screen.dart
```

---
## 🧩 Dependencies
Add these to your `pubspec.yaml`:
```
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  cometchat_chat_uikit: ^4.0.0
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  firebase_storage: ^11.6.0
  image_picker: ^1.0.7
  uuid: ^4.3.3
  google_fonts: ^6.2.1
  cloud_firestore: ^4.15.0
```

---
## 🚀 Setup Instructions
1. Flutter Setup:
    ```
    flutter pub get
    ```
2. Firebase Setup:
    * Add your Android app to Firebase.
    * Download `google-services.json` and place it under `android/app/`.
3. NDK Fix (in `android/app/build.gradle.kts`):
    ```
    android {
      ndkVersion = "27.0.12077973"
      ...
    }
    ```
4. CometChat Setup:
    * Register at CometChat.
    * Replace `your_app_id`, `region`, and `auth_key` in your CometChat initialization.
5. Run the App:
    ```
    flutter run
    ```
6. Build APK for Release:
  ```
  flutter build apk --release
  ```

---
## 📲 User Flow
**Login**
* Users enter their UID to login (via CometChat).
* On success, redirected to `MainNavigationScreen`.
  
**Post a Service**
* Providers fill a form: title, description, price, location, category.
* Image upload is optional (stored in Firebase Storage).
* On submit, data is stored in Firestore.
  
**Browse & Book Services**
* Users can browse services in the `ServiceExplorerScreen`.
* Book a service: creates a booking request with status `pending`.
  
**Booking Management**
* Providers view incoming requests (`provider_booking_requests_screen.dart`).
* They can accept/reject requests.
* Accepted bookings appear in a separate section.
  
**Chat**
* Once a booking is accepted:
    * A new CometChat conversation becomes available.
    * Both provider and client can communicate via `InboxScreen`.

---
## 🧪 Testing Checklist
| Feature                            | Tested |
| ---------------------------------- | ------ |
| UID Login                          | ✅      |
| Post Service (with/without image)  | ✅      |
| View & Filter Services             | ✅      |
| Book Service                       | ✅      |
| View Bookings (Client)             | ✅      |
| Accept/Reject Bookings (Provider)  | ✅      |
| Chat Interface Opens               | ✅      |
| Message Notification on Acceptance | ✅      |
| Mock Payment Screen                | ⚠️     |

---
## 💬 Notes
* **Image Upload Optional:** Posting works even if no image is uploaded.
* **Mock Payment:** `mock_payment_screen.dart` is not integrated. Can be removed or enhanced for Razorpay/Stripe.
* **CometChat UID Login:** No Firebase Auth used—login is based on CometChat UID.
* **Firestore Collections:**
    * `services`
    * `bookings`

---
## 📌 Future Enhancements
* Integrate real payment gateway
* Add notifications (Firebase Cloud Messaging)
* Provider profile management
* Rating/review system for services
* Analytics dashboard for service usage

---
## 📷 Screenshots (Optional)
> Add screenshots of key flows like:
>* Login
>* Post Service
>* Book Service
>* Booking Requests
>* Chat Inbox
>* Chat Interface
