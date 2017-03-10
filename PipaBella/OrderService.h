//
//  OrderService.h
//  PipaBella
//
//  Created by Monika on 1/6/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderService : NSObject
//Singleton instance
+ (id)sharedManager;
//end

//My orders
-(void)salesOrderListRequestParam:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Order details
-(void)generalApiTrackOrderRequestParam:(NSString *)orderId email:(NSString *)email success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Add coupon 
-(void)shoppingCartCouponAddRequestParam:(NSString *)couponCode success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Redeem points
-(void)generalApiShoppingCartRewardPointAddRequestParam:(NSString *)points success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Cart totals
-(void)shoppingCartTotalsRequestParam:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Set address
-(void)shoppingCartCustomerAddressesRequestParam:(NSString*)fisrtname lastname:(NSString*)lastname shippingMode:(NSString*)shippingMode addressId:(NSString*)addressId streetAddress1:(NSString*)streetAddress1 city:(NSString*)city mobile:(NSString*)mobile countryCode:(NSString*)countryCode postcode:(NSString*)postcode streetAddress2:(NSString*)streetAddress2 state:(NSString*)state regionId:(NSString*)regionId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//My loyalty points
-(void)generalApiUserLoyaltiPointsRequestParam:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end


//Reward points
-(void)generalApiLoyalityPageRequestParam:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Remove coupon
-(void)shoppingCartCouponRemoveRequestParam:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Remove redeem points
-(void)generalApiShoppingCartRewardPointRemoveRequestParam:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end



@end
