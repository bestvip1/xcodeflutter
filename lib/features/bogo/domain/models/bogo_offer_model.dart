class BogoOfferModel {
  int? id;
  String? title;
  String? description;
  String? offerType;
  int? buyQuantity;
  int? getQuantity;
  double? discountPercentage;
  List<int>? targetIds;
  String? badgeText;
  String? formattedOffer;
  int? priority;
  String? startDate;
  String? endDate;
  bool? isActive;
  String? addedBy;
  int? sellerId;

  BogoOfferModel({
    this.id,
    this.title,
    this.description,
    this.offerType,
    this.buyQuantity,
    this.getQuantity,
    this.discountPercentage,
    this.targetIds,
    this.badgeText,
    this.formattedOffer,
    this.priority,
    this.startDate,
    this.endDate,
    this.isActive,
    this.addedBy,
    this.sellerId,
  });

  BogoOfferModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    offerType = json['offer_type'];
    buyQuantity = json['buy_quantity'];
    getQuantity = json['get_quantity'];
    
    if (json['discount_percentage'] != null) {
      discountPercentage = double.tryParse(json['discount_percentage'].toString());
    }
    
    if (json['target_ids'] != null) {
      targetIds = [];
      if (json['target_ids'] is List) {
        json['target_ids'].forEach((v) {
          if (v is int) {
            targetIds!.add(v);
          } else if (v is String) {
            final parsed = int.tryParse(v);
            if (parsed != null) {
              targetIds!.add(parsed);
            }
          }
        });
      }
    }
    
    badgeText = json['badge_text'];
    formattedOffer = json['formatted_offer'];
    priority = json['priority'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    isActive = json['is_active'] == 1 || json['is_active'] == true;
    addedBy = json['added_by'];
    
    if (json['seller_id'] != null) {
      sellerId = int.tryParse(json['seller_id'].toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['offer_type'] = offerType;
    data['buy_quantity'] = buyQuantity;
    data['get_quantity'] = getQuantity;
    data['discount_percentage'] = discountPercentage;
    data['target_ids'] = targetIds;
    data['badge_text'] = badgeText;
    data['formatted_offer'] = formattedOffer;
    data['priority'] = priority;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['is_active'] = isActive;
    data['added_by'] = addedBy;
    data['seller_id'] = sellerId;
    return data;
  }

  // Helper method to check if offer is currently valid
  bool isCurrentlyValid() {
    if (isActive != true) return false;
    
    DateTime now = DateTime.now();
    
    if (startDate != null) {
      DateTime start = DateTime.parse(startDate!);
      if (start.isAfter(now)) return false;
    }
    
    if (endDate != null) {
      DateTime end = DateTime.parse(endDate!);
      if (end.isBefore(now)) return false;
    }
    
    return true;
  }

  // Get display text for the offer
  String getDisplayText() {
    if (discountPercentage != null && discountPercentage! > 0) {
      return "Buy $buyQuantity Get $getQuantity at ${discountPercentage!.toStringAsFixed(0)}% OFF";
    }
    return "Buy $buyQuantity Get $getQuantity FREE";
  }

  // Get short badge text
  String getShortBadgeText() {
    if (badgeText != null && badgeText!.isNotEmpty) {
      return badgeText!;
    }
    
    if (buyQuantity == 1 && getQuantity == 1) {
      return "BOGO";
    }
    
    return "Buy $buyQuantity Get $getQuantity";
  }
}

class BogoCalculationModel {
  bool? hasBogo;
  BogoOfferModel? offer;
  int? quantity;
  double? unitPrice;
  double? originalPrice;
  int? bogoSets;
  int? freeItems;
  int? paidItems;
  double? discountAmount;
  double? finalPrice;

  BogoCalculationModel({
    this.hasBogo,
    this.offer,
    this.quantity,
    this.unitPrice,
    this.originalPrice,
    this.bogoSets,
    this.freeItems,
    this.paidItems,
    this.discountAmount,
    this.finalPrice,
  });

  BogoCalculationModel.fromJson(Map<String, dynamic> json) {
    hasBogo = json['has_bogo'] == true;
    
    if (json['offer'] != null) {
      offer = BogoOfferModel.fromJson(json['offer']);
    }
    
    if (json['calculation'] != null) {
      final calc = json['calculation'];
      quantity = calc['quantity'];
      
      if (calc['unit_price'] != null) {
        unitPrice = double.tryParse(calc['unit_price'].toString());
      }
      
      if (calc['original_price'] != null) {
        originalPrice = double.tryParse(calc['original_price'].toString());
      }
      
      bogoSets = calc['bogo_sets'];
      freeItems = calc['free_items'];
      paidItems = calc['paid_items'];
      
      if (calc['discount_amount'] != null) {
        discountAmount = double.tryParse(calc['discount_amount'].toString());
      }
      
      if (calc['final_price'] != null) {
        finalPrice = double.tryParse(calc['final_price'].toString());
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['has_bogo'] = hasBogo;
    
    if (offer != null) {
      data['offer'] = offer!.toJson();
    }
    
    data['calculation'] = {
      'quantity': quantity,
      'unit_price': unitPrice,
      'original_price': originalPrice,
      'bogo_sets': bogoSets,
      'free_items': freeItems,
      'paid_items': paidItems,
      'discount_amount': discountAmount,
      'final_price': finalPrice,
    };
    
    return data;
  }

  // Calculate savings percentage
  double getSavingsPercentage() {
    if (originalPrice == null || originalPrice == 0 || discountAmount == null) {
      return 0;
    }
    return (discountAmount! / originalPrice!) * 100;
  }

  // Get formatted discount text
  String getDiscountText() {
    if (discountAmount == null || discountAmount == 0) {
      return "No discount";
    }
    return "Save ${discountAmount!.toStringAsFixed(2)}";
  }
}

class ProductBogoInfo {
  bool? hasBogo;
  int? productId;
  int? offersCount;
  BogoOfferModel? bestOffer;
  List<BogoOfferModel>? allOffers;

  ProductBogoInfo({
    this.hasBogo,
    this.productId,
    this.offersCount,
    this.bestOffer,
    this.allOffers,
  });

  ProductBogoInfo.fromJson(Map<String, dynamic> json) {
    hasBogo = json['has_bogo'] == true;
    productId = json['product_id'];
    offersCount = json['offers_count'];
    
    if (json['best_offer'] != null) {
      bestOffer = BogoOfferModel.fromJson(json['best_offer']);
    }
    
    if (json['all_offers'] != null) {
      allOffers = [];
      json['all_offers'].forEach((v) {
        allOffers!.add(BogoOfferModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['has_bogo'] = hasBogo;
    data['product_id'] = productId;
    data['offers_count'] = offersCount;
    
    if (bestOffer != null) {
      data['best_offer'] = bestOffer!.toJson();
    }
    
    if (allOffers != null) {
      data['all_offers'] = allOffers!.map((v) => v.toJson()).toList();
    }
    
    return data;
  }
}
