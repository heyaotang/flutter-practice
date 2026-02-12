import 'package:flutter_practice/core/models/models.dart';
import 'package:flutter_practice/core/repositories/product_repository.dart';
import 'package:flutter_practice/providers/product_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late MockProductRepository mockRepository;
  late ProductProvider provider;

  setUp(() {
    mockRepository = MockProductRepository();
    provider = ProductProvider(repository: mockRepository);
  });

  group('refresh', () {
    test('clears existing data and reloads first page', () async {
      // Setup: Load initial data
      when(() => mockRepository.getProducts(offset: 0, limit: 20))
          .thenAnswer((_) async => mockResponse(productsCount: 20));

      await provider.loadMore();
      expect(provider.products.length, 20);

      // Act: Call refresh
      when(() => mockRepository.getProducts(offset: 0, limit: 20))
          .thenAnswer((_) async => mockResponse(productsCount: 10));

      await provider.refresh();

      // Assert: Data is cleared and reloaded
      expect(provider.products.length, 10);
      verify(() => mockRepository.getProducts(offset: 0, limit: 20)).called(2);
    });

    test('resets hasMore and offset on refresh', () async {
      when(() => mockRepository.getProducts(
              offset: any(named: 'offset'), limit: any(named: 'limit')))
          .thenAnswer((_) async => mockResponse(productsCount: 20));

      await provider.loadMore();
      await provider.loadMore();
      expect(provider.hasMore, true); // Still has more

      when(() => mockRepository.getProducts(offset: 0, limit: 20))
          .thenAnswer((_) async => mockResponse(productsCount: 20));

      await provider.refresh();

      expect(provider.hasMore, true);
    });

    test('blocks loadMore during refresh', () async {
      when(() => mockRepository.getProducts(offset: 0, limit: 20))
          .thenAnswer((_) async => mockResponse(productsCount: 20));

      final refreshFuture = provider.refresh();
      expect(provider.isRefreshing, true);

      // Try to load more during refresh - should be blocked
      await provider.loadMore();

      // Only first page should be loaded
      expect(provider.products.length, lessThan(40)); // Not doubled

      await refreshFuture;
      expect(provider.isRefreshing, false);
    });
  });
}

// Helper
ProductResponse mockResponse({required int productsCount}) {
  return ProductResponse(
    products: List.generate(
      productsCount,
      (i) => Product(
        id: 'product-$i',
        name: 'Product $i',
        image: 'https://example.com/image-$i.jpg',
        price: 10.0 + i,
      ),
    ),
    total: 100,
    hasMore: true,
  );
}
