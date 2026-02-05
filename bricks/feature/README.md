# Feature Brick

A Mason brick template for generating new features following Clean Architecture principles with BLoC pattern.

## 📋 Overview

This brick generates a complete feature structure including:

- **Domain Layer**: Entities, Repository interfaces, Use cases
- **Data Layer**: Models, Data sources, Repository implementations
- **Presentation Layer**: BLoC (events, states), Pages

## 🚀 Installation

### 1. Install Mason CLI (if not already installed)

```bash
dart pub global activate mason_cli
```

### 2. Add the brick to the project

From the project root:

```bash
mason add feature --path ./bricks/feature
```

## 📖 Usage

### Generate a new feature

```bash
mason make feature
```

You'll be prompted to enter:
- `feature_name`: The name of your feature (e.g., "product", "profile", "order")

### Example

```bash
mason make feature --feature_name product
```

This will generate:

```
lib/features/product/
├── data/
│   ├── datasources/
│   │   └── product_remote_datasource.dart
│   ├── models/
│   │   └── product_model.dart
│   └── repositories/
│       └── product_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── product_entity.dart
│   ├── repositories/
│   │   └── product_repository.dart
│   └── usecases/
│       ├── get_product_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── product_bloc.dart
    │   ├── product_event.dart
    │   └── product_state.dart
    └── pages/
        └── product_page.dart
```

## 🔧 Customization

After generation, you'll need to customize the following:

### 1. Entity Properties

Edit `domain/entities/{feature_name}_entity.dart`:
- Add your specific properties
- Update the `props` list in Equatable

### 2. Model Mapping

Edit `data/models/{feature_name}_model.dart`:
- Implement `fromJson` with your properties
- Implement `toJson` with your properties
- Update `toEntity` method

### 3. Data Source Implementation

Edit `data/datasources/{feature_name}_remote_datasource.dart`:
- Add your HTTP client, Firebase, or other dependencies
- Implement the API calls for CRUD operations

### 4. Repository Implementation

Edit `data/repositories/{feature_name}_repository_impl.dart`:
- Implement entity-to-model conversion for create/update operations

### 5. UI Customization

Edit `presentation/pages/{feature_name}_page.dart`:
- Customize the UI to display your entity data
- Add forms for create/update operations
- Implement navigation and user interactions

## 📝 Generated Files

### Domain Layer

| File | Description |
|------|-------------|
| `{feature}_entity.dart` | Domain entity with Equatable |
| `{feature}_repository.dart` | Repository interface with CRUD methods |
| `get_{feature}_usecase.dart` | Use case to get single entity |

### Data Layer

| File | Description |
|------|-------------|
| `{feature}_model.dart` | Data model with JSON serialization |
| `{feature}_remote_datasource.dart` | Remote data source interface and implementation |
| `{feature}_repository_impl.dart` | Repository implementation with error handling |

### Presentation Layer

| File | Description |
|------|-------------|
| `{feature}_bloc.dart` | BLoC with CRUD event handlers |
| `{feature}_event.dart` | BLoC events (Load) |
| `{feature}_state.dart` | BLoC states (Initial, Loading, Loaded, Error) |
| `{feature}_page.dart` | Main page with BlocBuilder |

## 🎯 Features

- ✅ Clean Architecture structure
- ✅ BLoC pattern for state management
- ✅ Complete CRUD operations
- ✅ Error handling with Either<Failure, T>
- ✅ Equatable for value equality
- ✅ UseCase pattern
- ✅ Repository pattern
- ✅ Separation of concerns

## 💡 Tips

1. **Naming Convention**: Use singular names for features (e.g., "product" not "products")
2. **TODO Comments**: The generated code includes TODO comments to guide customization
3. **Incremental Development**: Start by implementing one use case at a time
4. **Testing**: Consider adding test files following the same structure

## 📚 Architecture

This brick follows Clean Architecture principles:

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│       (BLoC, Pages, Widgets)            │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│           Domain Layer                  │
│  (Entities, Repositories, Use Cases)    │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│           Data Layer                    │
│  (Models, Data Sources, Repo Impl)      │
└─────────────────────────────────────────┘
```

## 🤝 Contributing

To modify the brick template, edit files in `bricks/feature/__brick__/`.

## 📄 License

This brick template is part of the project and follows the same license.
