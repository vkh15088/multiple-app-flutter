# Mason Feature Brick - Quick Usage Guide

## 🚀 Quick Start

### 1. Generate a New Feature

```bash
mason make feature --feature_name product
```

This creates a complete feature structure in `lib/features/product/`

### 2. Customize Your Feature

#### Step 1: Define Entity Properties

Edit `lib/features/product/domain/entities/product_entity.dart`:

```dart
class ProductEntity extends Equatable {
  final String id;
  final String name;        // Add your properties
  final double price;
  final String? imageUrl;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, price, imageUrl];
}
```

#### Step 2: Update Model Serialization

Edit `lib/features/product/data/models/product_model.dart`:

```dart
factory ProductModel.fromJson(Map<String, dynamic> json) {
  return ProductModel(
    id: json['id'] as String,
    name: json['name'] as String,
    price: (json['price'] as num).toDouble(),
    imageUrl: json['imageUrl'] as String?,
  );
}

Map<String, dynamic> toJson() {
  return {
    'id': id,
    'name': name,
    'price': price,
    'imageUrl': imageUrl,
  };
}
```

#### Step 3: Implement Data Source

Edit `lib/features/product/data/datasources/product_remote_datasource.dart`:

```dart
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  
  ProductRemoteDataSourceImpl(this.client);

  @override
  Future<ProductModel> getProduct(String id) async {
    final response = await client.get(
      Uri.parse('https://api.example.com/products/$id'),
    );
    
    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }
  
  // Implement other methods...
}
```

#### Step 4: Complete Repository Implementation

Edit `lib/features/product/data/repositories/product_repository_impl.dart`:

```dart
@override
Future<Either<Failure, ProductEntity>> createProduct(ProductEntity entity) async {
  try {
    final model = ProductModel(
      id: entity.id,
      name: entity.name,
      price: entity.price,
      imageUrl: entity.imageUrl,
    );
    final result = await remoteDataSource.createProduct(model);
    return Right(result.toEntity());
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}
```

#### Step 5: Customize UI

Edit `lib/features/product/presentation/pages/product_page.dart` to build your UI.

### 3. Set Up Dependency Injection

```dart
// In your DI setup (e.g., using get_it)
final sl = GetIt.instance;

// Data sources
sl.registerLazySingleton<ProductRemoteDataSource>(
  () => ProductRemoteDataSourceImpl(sl()),
);

// Repositories
sl.registerLazySingleton<ProductRepository>(
  () => ProductRepositoryImpl(sl()),
);

// Use cases
sl.registerLazySingleton(() => GetProductUseCase(sl()));

// BLoC
sl.registerFactory(
  () => ProductBloc(
    getProductUseCase: sl(),
  ),
);
```

### 4. Add to Your App

```dart
// In your router or main.dart
BlocProvider(
  create: (context) => sl<ProductBloc>()..add(ProductLoadAllRequested()),
  child: const ProductPage(),
)
```

## 📋 Common Use Cases

### Load Single Item

```dart
context.read<ProductBloc>().add(ProductLoadRequested(id: '123'));
```

## 🎯 Tips

1. **Start Simple**: Begin with just the entity properties you need
2. **Add Gradually**: Implement one use case at a time
3. **Test Early**: Write tests as you implement each layer
4. **Customize UI**: The generated page is just a starting point
5. **Error Handling**: Customize error messages in the data source layer

## 📚 Generated Structure

```
lib/features/product/
├── data/               # Data layer
├── domain/             # Business logic
└── presentation/       # UI & state management
```

Each layer is independent and follows Clean Architecture principles!
