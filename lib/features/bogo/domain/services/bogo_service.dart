import 'package:flutter_sixvalley_ecommerce/features/bogo/domain/models/bogo_offer_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/bogo/domain/repositories/bogo_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/bogo/domain/services/bogo_service_interface.dart';

class BogoService implements BogoServiceInterface {
  final BogoRepositoryInterface bogoRepositoryInterface;

  BogoService({required this.bogoRepositoryInterface});

  @override
  Future<List<BogoOfferModel>?> getBogoOffers({String? offerType, int? sellerId}) async {
    final response = await bogoRepositoryInterface.getBogoOffers(
      offerType: offerType,
      sellerId: sellerId,
    );

    if (response.response != null &&
        response.response!.statusCode == 200 &&
        response.response!.data != null) {
      final data = response.response!.data;
      
      if (data['status'] == true && data['data'] != null) {
        List<BogoOfferModel> offers = [];
        
        for (var item in data['data']) {
          offers.add(BogoOfferModel.fromJson(item));
        }
        
        return offers;
      }
    }
    
    return null;
  }

  @override
  Future<BogoOfferModel?> getBogoOfferById(int id) async {
    final response = await bogoRepositoryInterface.getBogoOfferById(id);

    if (response.response != null &&
        response.response!.statusCode == 200 &&
        response.response!.data != null) {
      final data = response.response!.data;
      
      if (data['status'] == true && data['data'] != null) {
        return BogoOfferModel.fromJson(data['data']);
      }
    }
    
    return null;
  }

  @override
  Future<ProductBogoInfo?> checkProductBogo(int productId) async {
    final response = await bogoRepositoryInterface.checkProductBogo(productId);

    if (response.response != null &&
        response.response!.statusCode == 200 &&
        response.response!.data != null) {
      final data = response.response!.data;
      
      if (data['status'] == true && data['data'] != null) {
        return ProductBogoInfo.fromJson(data['data']);
      }
    }
    
    return null;
  }

  @override
  Future<BogoCalculationModel?> calculateBogoDiscount({
    required int productId,
    required int quantity,
    required double unitPrice,
  }) async {
    final response = await bogoRepositoryInterface.calculateBogoDiscount(
      productId: productId,
      quantity: quantity,
      unitPrice: unitPrice,
    );

    if (response.response != null &&
        response.response!.statusCode == 200 &&
        response.response!.data != null) {
      final data = response.response!.data;
      
      if (data['status'] == true && data['data'] != null) {
        return BogoCalculationModel.fromJson(data['data']);
      }
    }
    
    return null;
  }

  @override
  Future<List<dynamic>?> getProductsWithBogo({int limit = 20, int offset = 0}) async {
    final response = await bogoRepositoryInterface.getProductsWithBogo(
      limit: limit,
      offset: offset,
    );

    if (response.response != null &&
        response.response!.statusCode == 200 &&
        response.response!.data != null) {
      final data = response.response!.data;
      
      if (data['status'] == true && data['products'] != null) {
        return data['products'] as List<dynamic>;
      }
    }
    
    return null;
  }
}
