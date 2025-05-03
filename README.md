# Flutter Notification Scheduler App

A Flutter-based notification scheduler app that allows users to schedule, display, and reschedule local notifications. The app also supports selecting custom images using a file picker to show in the notification, giving a rich and personalized notification experience.

## ✨ Features

- Schedule local notifications with custom title, body, and scheduled time.
- Reschedule existing notifications on card tap.
- Add new notifications using a dialog via Floating Action Button (FAB).
- View all scheduled notifications in a scrollable card-based UI.
- Persist notification data using `sqflite` database.
- Manage app state with `GetX`.
- Pick images from device storage using `file_picker` and show them in notifications.
- Uses custom notification IDs (you can use UUID for uniqueness).

## 📦 Dependencies

This project uses the following packages:

- [`flutter_local_notifications`](https://pub.dev/packages/flutter_local_notifications): For scheduling and displaying local notifications.
- [`getx`](https://pub.dev/packages/get): For lightweight state management and routing.
- [`sqflite`](https://pub.dev/packages/sqflite): For storing scheduled notifications persistently in a local SQLite database.
- [`file_picker`](https://pub.dev/packages/file_picker): To allow users to pick an image from local storage for custom notifications.
- [`path_provider`](https://pub.dev/packages/path_provider): For accessing local file paths if needed.

## 📁 Folder Structure

- `controllers/notification_controller.dart`: Handles all notification scheduling, rescheduling, and database sync logic using GetX.
- `models/notification_model.dart`: Defines the structure of a notification entry.
- `db/notification_db_helper.dart`: Handles all SQLite database operations (CRUD).
- `ui/notification_card.dart`: UI widget for displaying a notification in a card with reschedule capability.
- `ui/add_notification_dialog.dart`: A dialog box that collects user input for a new notification (title, body, time, image).
- `main.dart`: Initializes GetX, local notifications, and launches the home screen.

## 📱 Platform Support

- ✅ Android (fully supported)
- ⏳ iOS (partially supported; scheduling and image notifications need additional setup for iOS-specific permissions and configurations)

## ⚙️ How It Works

- On app launch, it checks if the app was opened via a notification.
- Users can tap on any existing notification card to modify and reschedule it.
- Users can add new notifications using the FAB, which opens a form in a dialog.
- Notifications include custom images selected from device storage (via file picker).
- All notification data is stored locally and retrieved using Sqflite.

## 📝 Notes

- Ensure that necessary permissions are added for file access (especially on Android 10+).
- For iOS, additional steps are required for displaying images and background notifications.
- Unique IDs are essential for managing multiple notifications—UUIDs or timestamps are good choices.

## 📌 Future Improvements

- iOS image support and testing.
- Notification categorization and filtering.
- Option to delete or disable a scheduled notification.
- Add recurring notifications (daily, weekly, etc.)

---
