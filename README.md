# She Can

A Flutter application built with clean architecture principles.

## Folder Structure

This project follows clean architecture patterns to ensure maintainability, testability, and
scalability:

```
lib/
├── main.dart                 # Application entry point
├── core/                     # Core functionality shared across features
│   ├── di/                   # Dependency injection setup
│   ├── router/               # App routing configuration
│   ├── services/             # Core services (API, storage, etc.)
│   └── theme/                # App theming and styling
└── features/                 # Feature-based modules
    └── shecan/               # Main feature module
```

### Clean Architecture Benefits

- **Separation of Concerns**: Each layer has a specific responsibility
- **Testability**: Easy to unit test business logic independently
- **Maintainability**: Changes in one layer don't affect others
- **Scalability**: Easy to add new features without breaking existing code
