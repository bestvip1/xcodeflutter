import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/bogo/domain/repositories/bogo_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class BogoRepository implements BogoRepositoryInterface {
  final DioClient? dioClient;

  BogoRepository({required this.dioClient});

  @override
  Future<ApiResponseModel> getBogoOffers({String? offerType, int? sellerId}) async {
    try {
      String uri = '${AppConstants.baseUrl}/api/v1/bogo';
      
      Map<String, dynamic> queryParams = {};
      if (offerType != null) {
        queryParams['offer_type'] = offerType;
      }
      if (sellerId != null) {
        queryParams['seller_id'] = sellerId;
      }
      
      if (queryParams.isNotEmpty) {
        uri += '?${_buildQueryString(queryParams)}';
      }

      final response = await dioClient!.get(uri);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getBogoOfferById(int id) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.baseUrl}/api/v1/bogo/$id',
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> checkProductBogo(int productId) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.baseUrl}/api/v1/bogo/product/$productId/check',
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> calculateBogoDiscount({
    required int productId,
    required int quantity,
    required double unitPrice,
  }) async {
    try {
      final response = await dioClient!.post(
        '${AppConstants.baseUrl}/api/v1/bogo/calculate',
        data: {
          'product_id': productId,
          'quantity': quantity,
          'unit_price': unitPrice,
        },
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getProductsWithBogo({int limit = 20, int offset = 0}) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.baseUrl}/api/v1/bogo/products/with-bogo?limit=$limit&offset=$offset',
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  String _buildQueryString(Map<String, dynamic> params) {
    return params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
  }
}
