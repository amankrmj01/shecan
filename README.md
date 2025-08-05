# She Can

A Flutter application showcasing modern UI design and state management with BLoC pattern.

## Features

- User Authentication (Login/Signup)
- Dashboard with user statistics
- Leaderboard functionality
- Announcements system
- User profile management
- Theme mode selection (Light/Dark)
- Referral sharing with QR codes

## Dummy Data

This application uses dummy data for demonstration purposes:

### User Data

- **Username**: demo_user
- **Email**: demo@example.com
- **Score**: 1250 points
- **Rank**: #5 in leaderboard

### Dashboard Statistics

- Total points earned: 1250
- Current streak: 7 days
- Completed challenges: 23
- Friends referred: 5

### Leaderboard

- Sample users with varying scores (500-2000 points)
- Ranking system based on points
- User avatars and achievement badges

### Announcements

- Welcome announcement for new users
- Weekly challenge notifications
- System updates and maintenance notices
- Achievement unlock notifications

## Screenshots

### Authentication Screens

<img src="screenshots/login_screen.png" alt="Login Screen" width="300">

*Login screen with email and password fields*

<img src="screenshots/signup_screen.png" alt="Signup Screen" width="300">

*User registration with form validation*

<img src="screenshots/login_successful_screen.png" alt="Login Success" width="300">

*Success confirmation after login*

<img src="screenshots/signup_succesful_screen.png" alt="Signup Success" width="300">

*Registration completion confirmation*

### Main Application Screens

<img src="screenshots/dashboard_screen.png" alt="Dashboard" width="300">

*Main dashboard showing user stats and progress*

<img src="screenshots/leaderboard_screen.png" alt="Leaderboard" width="300">

*Competitive leaderboard with user rankings*

<img src="screenshots/announcement_screen.png" alt="Announcements" width="300">

*System announcements and notifications*

<img src="screenshots/user_profile_screen.png" alt="User Profile" width="300">

*User profile with personal information and settings*

### Additional Features

<img src="screenshots/theme_mode_selection.png" alt="Theme Selection" width="300">

*Light and dark theme toggle functionality*

<img src="screenshots/referal_sharing_qrcode.png" alt="Referral QR Code" width="300">

*QR code generation for referral sharing*

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (2.17.0 or higher)
- Android Studio / VS Code
- Android device or emulator

### Installation

1. Clone the repository:

```bash
git clone <repository-url>
cd shecan
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the application:

```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart
├── core/
│   ├── di/              # Dependency injection
│   ├── router/          # App routing
│   ├── services/        # Core services
│   ├── state/           # Global state management
│   └── theme/           # App theming
└── features/
    └── shecan/          # Main feature module
```

## State Management

This project uses the BLoC pattern for state management:

- **Cubit**: For simple state management
- **Bloc**: For complex business logic
- **Equatable**: For state comparison

## Dependencies

- `flutter_bloc`: State management
- `equatable`: Value equality
- `get_it`: Dependency injection
- Additional UI and utility packages

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
