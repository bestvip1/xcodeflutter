import 'package:flutter_sixvalley_ecommerce/features/bogo/domain/models/bogo_offer_model.dart';

abstract class BogoServiceInterface {
  Future<List<BogoOfferModel>?> getBogoOffers({String? offerType, int? sellerId});
  Future<BogoOfferModel?> getBogoOfferById(int id);
  Future<ProductBogoInfo?> checkProductBogo(int productId);
  Future<BogoCalculationModel?> calculateBogoDiscount({
    required int productId,
    required int quantity,
    required double unitPrice,
  });
  Future<List<dynamic>?> getProductsWithBogo({int limit = 20, int offset = 0});
}
