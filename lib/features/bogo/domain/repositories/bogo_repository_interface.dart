import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';

abstract class BogoRepositoryInterface {
  Future<ApiResponseModel> getBogoOffers({String? offerType, int? sellerId});
  Future<ApiResponseModel> getBogoOfferById(int id);
  Future<ApiResponseModel> checkProductBogo(int productId);
  Future<ApiResponseModel> calculateBogoDiscount({
    required int productId,
    required int quantity,
    required double unitPrice,
  });
  Future<ApiResponseModel> getProductsWithBogo({int limit = 20, int offset = 0});
}
