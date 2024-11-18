# Journade - A SwiftUI-based Journaling App

## Introduction
Our project aims to develop a journaling app that enhances the user experience by providing motivational prompts and insights. With the implementation of cryptocurrency for secure transactions and Face ID for personalized access, this app will cater to a diverse audience. It will serve casual users seeking self-reflection, as well as mental health professionals looking to support their clients effectively.
Objective.

<p float="left">
  <img src="https://github.com/user-attachments/assets/ead6be70-8e2a-42bb-8c2e-fe20d870ca84" width="150" />
  <img src="https://github.com/user-attachments/assets/c7ca0542-b725-440c-bfc8-27c538afec6a" width="150" />
  <img src="https://github.com/user-attachments/assets/8c8e50c5-47c9-489e-9ca4-c112f460c0b4" width="150" />
  <img src="https://github.com/user-attachments/assets/f8966587-316d-435e-844a-0c23726ef778" width="150" />
</p>


## Objective
### Goal:
To develop a secure journaling app that motivates users to document their thoughts and emotions while ensuring complete privacy.

## Category
Lifestyle

## Target Audience
Individuals who love journalling .
Individuals who like their journals private.
People who want to start becoming self-aware through blogging in the easiest way.


## Features
- **Create and edit journal entries**: Write your thoughts and save them with a clean, simple, and beautiful interface.
- **Privacy first**:  Your journal entries are secured with Face ID or password authentication to ensure only you can access them.
- **Track your progress**: View the number of journal entries you’ve made this month through a dedicated widget on your home screen.
- **Encryption**: All your journal entries are encrypted using CryptoKit for added security. Only you can decrypt them through authentication.
- **Fade Journals**: Option to fade or hide your journal entries when you don’t want them to be visible.
- **Helpful Tips**: The app provides various tips to guide you through using the app effectively.
- **Express Yourself with Emojis**: Use emojis to express yourself and add personality to your entries.
- **Dark mode support**: The app seamlessly adapts to your system-wide appearance settings (light/dark mode).
- **classified entries by calendar**: View and access your journal entries categorized by the date via a built-in calendar.
- **Widget**: A dedicated home screen widget that shows the number of journal entries you’ve made in the current month.
- **Notification**: Receive daily motivational notifications to encourage you to keep journaling.


## Screenshots
![Simulator Screenshot - iPhone 16 Pro - 2024-11-18 at 10 20 20](https://github.com/user-attachments/assets/337a589e-dd11-46ac-9d78-82e22e936d61) ![Simulator Screenshot - iPhone 16 Pro - 2024-11-18 at 10 20 35](https://github.com/user-attachments/assets/737bfca4-973a-4dcf-b20e-59dad887d916) ![Simulator Screenshot - iPhone 16 Pro - 2024-11-18 at 10 20 40](https://github.com/user-attachments/assets/63daf04b-bfb3-4073-bf2b-fb718504e9e2) ![Simulator Screenshot - iPhone 16 Pro - 2024-11-18 at 10 23 17](https://github.com/user-attachments/assets/4ab7329b-7e05-4666-b886-84c595b5da0b)


## Installation
The app is available on the App Store. You can download it directly from the link below:
https://apps.apple.com/sa/app/journade/id6737888726


### Requirements
- Xcode 16.1+ (or later)
- iOS 18.0+ (or later)
- macOS Sequoia version 15.1 (for macOS development)


### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/Leen73XX/Journade_appstore_copy.git
Or open the project in Xcode
2. Build and run the app on a simulator or real device.


 ## Usage
1.  Open the app and start adding journal entries.
2.  You can either keep or fade your journal entries as you prefer.
3. To access your journal entries, click the calendar icon at the top right of the main screen.
4. In the calendar view, you can view your entries by selecting the respective date.
5. To access your journals, you must first authenticate using Face ID (you’ll need to grant permission) or your password.
6. Once authenticated, you’ll have the option to delete or manage your journal entries.
7. Add the Journade widget to your home screen to track the number of journal entries you’ve made this month. To do so:
8. Long-press on your home screen.
9. Tap the "+" icon and search for "Journade".
10. The widget will display the number of journal entries for the current month.
11. Allow Notifications when prompted to receive daily motivational reminders. You can manage notification settings through Settings > Journade.


## Technologies Used
SwiftUI: For building the app's user interface.
UserDefaults: To track the number of journal entries and store locally (e.g., widget data).
WidgetKit: To display the journal entry count on the home screen via a widget.
TipKit: To provide helpful tips and guidance throughout the app.
CryptoKit: To encrypt and securely store journal entries.
LocalAuthentication: To allow Face ID and password authentication for accessing journals.
UserNotifications: To send daily notifications to remind users to journal.
Combine: For handling reactive data streams and app state.
