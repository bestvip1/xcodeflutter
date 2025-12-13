import 'package:flutter/foundation.dart';
import 'package:flutter_sixvalley_ecommerce/features/bogo/domain/models/bogo_offer_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/bogo/domain/services/bogo_service_interface.dart';

class BogoController extends ChangeNotifier {
  final BogoServiceInterface bogoServiceInterface;

  BogoController({required this.bogoServiceInterface});

  // State variables
  bool _isLoading = false;
  bool _isLoadingProducts = false;
  List<BogoOfferModel> _bogoOffers = [];
  Map<int, ProductBogoInfo> _productBogoCache = {};
  Map<String, BogoCalculationModel> _calculationCache = {};
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  bool get isLoadingProducts => _isLoadingProducts;
  List<BogoOfferModel> get bogoOffers => _bogoOffers;
  String? get errorMessage => _errorMessage;

  /// Get all BOGO offers
  Future<void> getBogoOffers({String? offerType, int? sellerId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final offers = await bogoServiceInterface.getBogoOffers(
        offerType: offerType,
        sellerId: sellerId,
      );

      if (offers != null) {
        _bogoOffers = offers;
        _errorMessage = null;
      } else {
        _bogoOffers = [];
        _errorMessage = 'Failed to load BOGO offers';
      }
    } catch (e) {
      _bogoOffers = [];
      _errorMessage = e.toString();
      if (kDebugMode) {
        debugPrint('Error loading BOGO offers: $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Check if a product has BOGO offer (with caching)
  Future<ProductBogoInfo?> checkProductBogo(int productId) async {
    // Check cache first
    if (_productBogoCache.containsKey(productId)) {
      return _productBogoCache[productId];
    }

    try {
      final bogoInfo = await bogoServiceInterface.checkProductBogo(productId);

      if (bogoInfo != null) {
        _productBogoCache[productId] = bogoInfo;
        notifyListeners();
        return bogoInfo;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error checking product BOGO: $e');
      }
    }

    return null;
  }

  /// Get BOGO info from cache
  ProductBogoInfo? getCachedProductBogo(int productId) {
    return _productBogoCache[productId];
  }

  /// Check if product has BOGO from cache
  bool hasBogoFromCache(int productId) {
    final info = _productBogoCache[productId];
    return info?.hasBogo == true && info?.bestOffer != null;
  }

  /// Calculate BOGO discount for cart items (with caching)
  Future<BogoCalculationModel?> calculateBogoDiscount({
    required int productId,
    required int quantity,
    required double unitPrice,
  }) async {
    // Create cache key
    final cacheKey = '${productId}_${quantity}_$unitPrice';

    // Check cache first
    if (_calculationCache.containsKey(cacheKey)) {
      return _calculationCache[cacheKey];
    }

    try {
      final calculation = await bogoServiceInterface.calculateBogoDiscount(
        productId: productId,
        quantity: quantity,
        unitPrice: unitPrice,
      );

      if (calculation != null) {
        _calculationCache[cacheKey] = calculation;
        notifyListeners();
        return calculation;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error calculating BOGO discount: $e');
      }
    }

    return null;
  }

  /// Get BOGO calculation from cache
  BogoCalculationModel? getCachedCalculation(int productId, int quantity, double unitPrice) {
    final cacheKey = '${productId}_${quantity}_$unitPrice';
    return _calculationCache[cacheKey];
  }

  /// Calculate BOGO discount for multiple products in cart
  Future<Map<int, BogoCalculationModel>> calculateCartBogo(
    Map<int, Map<String, dynamic>> cartItems,
  ) async {
    Map<int, BogoCalculationModel> results = {};

    for (var entry in cartItems.entries) {
      final productId = entry.key;
      final item = entry.value;
      final quantity = item['quantity'] as int? ?? 1;
      final unitPrice = item['unit_price'] as double? ?? 0.0;

      if (quantity > 0 && unitPrice > 0) {
        final calculation = await calculateBogoDiscount(
          productId: productId,
          quantity: quantity,
          unitPrice: unitPrice,
        );

        if (calculation != null && calculation.hasBogo == true) {
          results[productId] = calculation;
        }
      }
    }

    return results;
  }

  /// Get total BOGO discount for cart
  double getTotalBogoDiscount(Map<int, BogoCalculationModel> bogoCalculations) {
    double total = 0;

    for (var calculation in bogoCalculations.values) {
      if (calculation.discountAmount != null) {
        total += calculation.discountAmount!;
      }
    }

    return total;
  }

  /// Clear all caches
  void clearCache() {
    _productBogoCache.clear();
    _calculationCache.clear();
    notifyListeners();
  }

  /// Clear product BOGO cache for specific product
  void clearProductCache(int productId) {
    _productBogoCache.remove(productId);
    
    // Remove calculation cache for this product
    _calculationCache.removeWhere((key, value) => key.startsWith('${productId}_'));
    
    notifyListeners();
  }

  /// Load products with BOGO offers
  Future<List<dynamic>?> getProductsWithBogo({int limit = 20, int offset = 0}) async {
    _isLoadingProducts = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final products = await bogoServiceInterface.getProductsWithBogo(
        limit: limit,
        offset: offset,
      );

      _isLoadingProducts = false;
      notifyListeners();

      return products;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoadingProducts = false;
      notifyListeners();
      
      if (kDebugMode) {
        debugPrint('Error loading products with BOGO: $e');
      }
      
      return null;
    }
  }

  /// Get active BOGO offers (only currently valid)
  List<BogoOfferModel> getActiveOffers() {
    return _bogoOffers.where((offer) => offer.isCurrentlyValid()).toList();
  }

  /// Get BOGO offers by type
  List<BogoOfferModel> getOffersByType(String type) {
    return _bogoOffers.where((offer) => offer.offerType == type).toList();
  }

  /// Check if there are any active BOGO offers
  bool hasActiveOffers() {
    return getActiveOffers().isNotEmpty;
  }
}
