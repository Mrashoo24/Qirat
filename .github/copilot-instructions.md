# Copilot Instructions for Qira E-Commerce App

## Project Overview
Flutter e-commerce app implementing **Clean Architecture** with **TDD**, **BLoC state management**, and **Firebase backend**. Named "eshop" in code but "Qira" in repository.

## Architecture Patterns

### Clean Architecture Layers
- **Domain** (`lib/domain/`): Business logic, entities, repositories (interfaces), use cases
- **Data** (`lib/data/`): Repository implementations, data sources (local/remote), models
- **Presentation** (`lib/presentation/`): UI, BLoC components, widgets
- **Core** (`lib/core/`): Shared utilities, constants, errors, dependency injection

### Key Architectural Rules
- **Dependencies flow inward**: Presentation → Domain ← Data
- **Use cases** are the entry point for business logic (`lib/domain/usecases/`)
- **Repositories** define contracts in domain, implemented in data layer
- **Models** extend entities and handle JSON serialization in data layer
- **Entities** are pure business objects in domain layer

### Dependency Injection Pattern
All dependencies registered in `lib/core/services/services_locator.dart` using **GetIt**:
```dart
// Service Locator pattern with 3-layer registration:
// 1. BLoCs (Factory - new instance each time)
// 2. Use Cases (Lazy Singleton)  
// 3. Repositories & Data Sources (Lazy Singleton)
```

## State Management with BLoC

### BLoC Structure
- **Events**: User actions (`lib/presentation/blocs/*/[feature]_event.dart`)
- **States**: UI states with immutable data (`lib/presentation/blocs/*/[feature]_state.dart`)  
- **BLoCs**: Business logic processors (`lib/presentation/blocs/*/[feature]_bloc.dart`)

### State Pattern
All states extend base classes and include:
- `products`, `metaData`, `params` properties for data persistence
- States: `Initial`, `Loading`, `Loaded`, `Error`
- Use `Equatable` for state comparison

### Navigation
- **GoRouter** for web-friendly routing (`lib/core/router/app_router.dart`)
- Routes defined as constants in `AppRouter` class
- Complex data passed via `state.extra` parameter

## Firebase Integration

### Services Setup
```dart
// Firebase services registered in services_locator.dart:
FirebaseAuth, FirebaseFirestore, FirebaseAnalytics, 
FirebaseCrashlytics, FirebasePerformance
```

### Data Flow
- **Remote data sources** use HTTP client for API calls
- **Local data sources** use SharedPreferences + FlutterSecureStorage
- **Repository implementations** coordinate between local/remote with network checking

## Testing Strategy

### TDD Approach
- Tests in parallel structure: `test/` mirrors `lib/` structure
- **Mocktail** for mocking (not Mockito)
- **bloc_test** for BLoC testing
- Test pattern: Arrange → Act → Assert

### Test Types
```dart
// Use Case Tests - test business logic
// Repository Tests - test data coordination  
// BLoC Tests - test state transitions
// Widget Tests - test UI components
```

## Development Workflows

### Essential Commands
```bash
flutter pub get                    # Dependencies
flutter run lib/main_old.dart         # Run app  
flutter test                      # Run all tests
flutter analyze                   # Static analysis
flutter build web                 # Web build
```

### Environment Setup
- **Flutter 3.x** with Dart SDK >=3.0.0
- **Multi-platform**: Android, iOS, Web supported
- **Firebase project** required for backend features

## Code Conventions

### Import Organization
```dart
// 1. Dart/Flutter imports
// 2. Package imports  
// 3. Local relative imports (../../../)
```

### File Naming
- `snake_case` for files and directories
- Feature-based organization: `[feature]/[layer]/[file]_[type].dart`
- Test files: `[source_file]_test.dart`

### Error Handling
- **Either<Failure, Success>** pattern using `dartz` package
- Custom failure types in `lib/core/error/failures.dart`
- Network connectivity checking with `NetworkInfo`

## Key Features & Business Logic

### E-Commerce Entities
- **Product**: Browsing, filtering, pagination
- **Category**: Hierarchical product organization
- **Cart**: Item management, local/remote sync
- **User**: Authentication, profile management
- **Order**: Checkout process, order history
- **DeliveryInfo**: Address management

### Data Synchronization
- **Offline-first** approach with local caching
- **Sync patterns** coordinate local/remote data
- **Network-aware** operations with connection checking

## Firebase Configuration
- Platform-specific config in `firebase_options.dart`
- Web deployment uses `HashUrlStrategy` for routing
- Analytics, Crashlytics, and Performance monitoring integrated

## Development Tips
- Always implement use case → repository → data source for new features
- Add BLoC events/states for UI interactions  
- Mock all external dependencies in tests
- Use `semantic_search` to find similar implementation patterns
- Follow the existing pagination pattern for list features