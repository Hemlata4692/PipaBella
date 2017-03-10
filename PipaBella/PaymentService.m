//
//  PaymentService.m
//  PipaBella
//
//  Created by Ranosys on 12/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "PaymentService.h"
#import "PaymentXMLParser.h"

#define kUrlgeneralApiPayumoneyUpdateRequestParam               @"generalApiPayumoneyUpdateRequestParam"
#define kUrlgeneralApiPayAndShipMethodListRequestParam          @"generalApiPayAndShipMethodListRequestParam"
#define kUrlshoppingCartPaymentMethodRequestParam               @"shoppingCartPaymentMethodRequestParam"
#define kUrlshoppingCartShippingMethodRequestParam              @"shoppingCartShippingMethodRequestParam"
#define kUrlshoppingCartOrderRequestParam                       @"shoppingCartOrderRequestParam"
#define kUrlgeneralApiNewQuoteRequestParam                      @"generalApiNewQuoteRequestParam"
#define kUrlCancelOrder                                         @"generalApicancelRequestParam"



@implementation PaymentService
{
    NSMutableDictionary *webserviceData;
}
#pragma mark - singleton instance
+ (id)sharedManager
{
    static PaymentService *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      sharedMyManager = [[self alloc] init];
                  });
    return sharedMyManager;
}
- (id)init
{
    if (self = [super init])
    {
        webserviceData = [NSMutableDictionary new];
        
    }
    return self;
}
#pragma mark - end

#pragma mark - Pay And Ship Method
-(void)generalApiPayAndShipMethodListRequestParam:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    
    [webserviceData removeAllObjects];
    
    myDelegate.methodName=@"generalApiPayAndShipMethodListRequestParam";
    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":[UserDefaultManager getValue:@"quoteId"],@"storeId":@"1"};
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlgeneralApiPayAndShipMethodListRequestParam success:^(id data)
     {
         //Handle fault cases
         [myDelegate StopIndicator];
         webserviceData = [[PaymentXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         [myDelegate StopIndicator];
     }] ;
    
}
#pragma mark - end


#pragma mark - PayU order update
-(void)generalApiPayumoneyUpdateRequestParam:(NSString*)orderId price:(NSString*)price transactionId:(NSString*)transactionId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    
    [webserviceData removeAllObjects];
    
    myDelegate.methodName=@"generalApiPayumoneyUpdateRequestParam";
    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":[UserDefaultManager getValue:@"quoteId"], @"orderIncrementId":orderId, @"transectionId":transactionId, @"price": price};
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlgeneralApiPayumoneyUpdateRequestParam success:^(id data)
     {
         //Handle fault cases
         [myDelegate StopIndicator];
         webserviceData = [[PaymentXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         [myDelegate StopIndicator];
     }] ;
    
}
#pragma mark - end


#pragma mark - Shopping cart payment method
-(void)shoppingCartPaymentMethodRequestParam:(NSString *)method success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [webserviceData removeAllObjects];
    
    myDelegate.methodName=@"shoppingCartPaymentMethodRequestParam";
    
    
    
        NSLog(@"method is nil resulting the crash on COD.............???????>>>>>>>%@",method);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":[UserDefaultManager getValue:@"quoteId"],
                                  @"paymentData":
                                      @{@"po_number":@"", @"method":method, @"cc_cid":@"", @"cc_owner":@"",@"cc_number":@"",@"cc_type":@"",@"cc_exp_year":@"",@"cc_exp_month":@""
                                        }
                                  };
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlshoppingCartPaymentMethodRequestParam success:^(id data)
     {
         //Handle fault cases
         //[myDelegate StopIndicator];
         webserviceData = [[PaymentXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         [myDelegate StopIndicator];
     }] ;
}
#pragma mark - end
#pragma mark - Shopping cart shipping method
-(void)shoppingCartShippingMethodRequestParam:(NSString *)method success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [webserviceData removeAllObjects];

    myDelegate.methodName=@"shoppingCartShippingMethodRequestParam";
    
    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":[UserDefaultManager getValue:@"quoteId"],@"shippingMethod":method,@"store":@"1" };
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlshoppingCartShippingMethodRequestParam success:^(id data)
     {
         //Handle fault cases
         
         webserviceData = [[PaymentXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
     }
     failure:^(NSError *error)
     {
         //Handle if response is nil
         [myDelegate StopIndicator];
     }] ;
    
}
#pragma mark - end

#pragma mark - Placeorder
-(void)shoppingCartOrderRequestParam:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [webserviceData removeAllObjects];

    myDelegate.methodName=@"shoppingCartOrderRequestParam";
    
    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":[UserDefaultManager getValue:@"quoteId"],
                                  @"agreements":
                                      @{@"complexObjectArray":@"1"
                                        }
                                  };
    [Localytics tagEvent:@"Order placed"];
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlshoppingCartOrderRequestParam success:^(id data)
     {
         //Handle fault cases
//         [myDelegate StopIndicator];
         webserviceData = [[PaymentXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         [myDelegate StopIndicator];
     }] ;
    
    
}
#pragma mark - end

#pragma mark - Clear cart
-(void)generalApiNewQuoteRequestParam:(NSString*)orderId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
       [webserviceData removeAllObjects];
    
    myDelegate.methodName=@"generalApiNewQuoteRequestParam";
    
    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":[UserDefaultManager getValue:@"quoteId"],@"customerId":[UserDefaultManager getValue:@"customer_id"],
                                  @"orderid":orderId};
    
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlgeneralApiNewQuoteRequestParam success:^(id data)
     {
         //Handle fault cases
         webserviceData = [[PaymentXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
     }
  failure:^(NSError *error)
     {
         
         NSLog(@"Response is  ******************************** blank");
         //Handle if response is nil
         [myDelegate StopIndicator];
     }] ;


}

-(void)cancelOrder:(NSString*)orderId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [webserviceData removeAllObjects];
    
    myDelegate.methodName=@"generalApicancelRequestParam";
    
    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],
                                  @"orderIncrementId":orderId};
    
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlCancelOrder success:^(id data)
     {
         //Handle fault cases
        
     }
       failure:^(NSError *error)
     {
         
         NSLog(@"Response is ******************************** blank");
         //Handle if response is nil
         [myDelegate StopIndicator];
     }] ;

}

#pragma mark - end

@end
