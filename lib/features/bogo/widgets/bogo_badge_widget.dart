import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/bogo/domain/models/bogo_offer_model.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class BogoBadgeWidget extends StatelessWidget {
  final BogoOfferModel offer;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderRadius? borderRadius;

  const BogoBadgeWidget({
    super.key,
    required this.offer,
    this.fontSize,
    this.padding,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeSmall,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: backgroundColor != null
              ? [backgroundColor!, backgroundColor!]
              : [
                  ColorResources.getPrimary(context),
                  ColorResources.getPrimary(context).withOpacity(0.8),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_offer,
            size: fontSize ?? 12,
            color: textColor ?? Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            offer.getShortBadgeText(),
            style: textRobotoMedium.copyWith(
              color: textColor ?? Colors.white,
              fontSize: fontSize ?? 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class BogoOfferCard extends StatelessWidget {
  final BogoOfferModel offer;
  final VoidCallback? onTap;

  const BogoOfferCard({
    super.key,
    required this.offer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeDefault,
        vertical: Dimensions.paddingSizeExtraSmall,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      offer.title ?? 'BOGO Offer',
                      style: textRobotoBold.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  BogoBadgeWidget(offer: offer),
                ],
              ),
              
              if (offer.description != null && offer.description!.isNotEmpty) ...[
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Text(
                  offer.description!,
                  style: textRobotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).hintColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              
              const SizedBox(height: Dimensions.paddingSizeDefault),
              
              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: ColorResources.getPrimary(context).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.card_giftcard,
                      size: 20,
                      color: ColorResources.getPrimary(context),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(
                      child: Text(
                        offer.getDisplayText(),
                        style: textRobotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.getPrimary(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              if (offer.startDate != null || offer.endDate != null) ...[
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Theme.of(context).hintColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getValidityText(),
                      style: textRobotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getValidityText() {
    if (offer.endDate != null) {
      final endDate = DateTime.parse(offer.endDate!);
      final daysLeft = endDate.difference(DateTime.now()).inDays;
      
      if (daysLeft <= 0) {
        return 'Expired';
      } else if (daysLeft == 1) {
        return 'Ends today';
      } else if (daysLeft <= 7) {
        return 'Ends in $daysLeft days';
      } else {
        return 'Valid until ${endDate.day}/${endDate.month}/${endDate.year}';
      }
    }
    
    if (offer.startDate != null) {
      final startDate = DateTime.parse(offer.startDate!);
      if (startDate.isAfter(DateTime.now())) {
        return 'Starts on ${startDate.day}/${startDate.month}/${startDate.year}';
      }
    }
    
    return 'No expiry';
  }
}

class BogoCartDiscountWidget extends StatelessWidget {
  final BogoCalculationModel calculation;
  final EdgeInsetsGeometry? padding;

  const BogoCartDiscountWidget({
    super.key,
    required this.calculation,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (calculation.hasBogo != true || calculation.discountAmount == null || calculation.discountAmount! <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: padding ?? const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorResources.getPrimary(context).withOpacity(0.1),
            ColorResources.getPrimary(context).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ColorResources.getPrimary(context).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.celebration,
                color: ColorResources.getPrimary(context),
                size: 20,
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Text(
                'BOGO Offer Applied!',
                style: textRobotoBold.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: ColorResources.getPrimary(context),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: Dimensions.paddingSizeSmall),
          
          if (calculation.offer != null) ...[
            Text(
              calculation.offer!.getDisplayText(),
              style: textRobotoMedium.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).hintColor,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          ],
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Free Items: ${calculation.freeItems ?? 0}',
                style: textRobotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).hintColor,
                ),
              ),
              Text(
                'You Save: ${calculation.discountAmount!.toStringAsFixed(2)}',
                style: textRobotoBold.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
