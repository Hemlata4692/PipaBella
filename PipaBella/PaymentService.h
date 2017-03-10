//
//  PaymentService.h
//  PipaBella
//
//  Created by Ranosys on 12/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentService : NSObject
//Singleton instance
+ (id)sharedManager;
//end

//Pay And Ship Method
-(void)generalApiPayAndShipMethodListRequestParam:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end



//Shopping cart payment method
-(void)shoppingCartPaymentMethodRequestParam:(NSString *)method success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Shopping cart shipping method
-(void)shoppingCartShippingMethodRequestParam:(NSString *)method success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end


//PayU order update
-(void)generalApiPayumoneyUpdateRequestParam:(NSString*)orderId price:(NSString*)price transactionId:(NSString*)transactionId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end


//Placeorder
-(void)shoppingCartOrderRequestParam:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end


//Clear cart
-(void)generalApiNewQuoteRequestParam:(NSString*)orderId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Cancel order
-(void)cancelOrder:(NSString*)orderId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

@end
