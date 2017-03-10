//
//  OrderService.m
//  PipaBella
//
//  Created by Monika on 1/6/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "OrderService.h"
#import "OrderXMLParser.h"
#define kUrlsalesOrderListResponseParam                         @"salesOrderListRequestParam"
#define kUrlgeneralApiTrackOrderRequestParam                    @"generalApiTrackOrderRequestParam"
#define kUrlgeneralApiUserLoyaltiPointsRequestParam             @"generalApiUserLoyaltiPointsRequestParam"
#define kUrlgeneralApiLoyalityPageRequestParam                  @"generalApiLoyalityPageRequestParam"

//Checkout add coupon
#define kUrlshoppingCartCouponAddRequestParam                   @"shoppingCartCouponAddRequestParam"
#define kUrlgeneralApiShoppingCartRewardPointAddRequestParam    @"generalApiShoppingCartRewardPointAddRequestParam"
#define kUrlshoppingCartTotalsRequestParam @"shoppingCartTotalsRequestParam"
#define kUrlshoppingCartCustomerAddressesRequestParam @"shoppingCartCustomerAddressesRequestParam"

#define kUrlshoppingCartCouponRemoveRequestParam                @"shoppingCartCouponRemoveRequestParam"
#define kUrlgeneralApiShoppingCartRewardPointRemoveRequestParam                @"generalApiShoppingCartRewardPointRemoveRequestParam"
@implementation OrderService
{
    NSMutableDictionary *webserviceData;
}
#pragma mark - singleton instance
+ (id)sharedManager
{
    static OrderService *sharedMyManager = nil;
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
#pragma mark - My orders list

-(void)salesOrderListRequestParam:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [webserviceData removeAllObjects];
    
    myDelegate.methodName=@"salesOrderListRequestParam";
    
    NSDictionary * complexObjectArray=@{@"key":@"customer_id",@"value":[UserDefaultManager getValue:@"customer_id"]};
    NSDictionary * filter=@{@"complexObjectArray":complexObjectArray};
    NSDictionary * value=@{@"key":@"eq",@"value":[UserDefaultManager getValue:@"customer_id"]};
    NSDictionary * complexObjectArray1=@{@"key":@"customer_id",@"value":value};
    NSDictionary * complex_filter=@{@"complexObjectArray":complexObjectArray1};
    NSDictionary * filters=@{@"filter":filter,@"complex_filter":complex_filter};
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"filters":filters};
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlsalesOrderListResponseParam success:^(id data)
     {
         //Handle fault cases
         [myDelegate StopIndicator];
         webserviceData = [[OrderXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         [myDelegate StopIndicator];
     }] ;
}
#pragma mark - end

#pragma mark - Order detail

-(void)generalApiTrackOrderRequestParam:(NSString *)orderId email:(NSString *)email success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [webserviceData removeAllObjects];
    
    myDelegate.methodName=@"generalApiTrackOrderRequestParam";
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"orderIncrementId":orderId,@"email":email};
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlgeneralApiTrackOrderRequestParam success:^(id data)
     {
         //Handle fault cases
         [myDelegate StopIndicator];
         webserviceData = [[OrderXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         [myDelegate StopIndicator];
     }] ;
    
}
#pragma mark - end
#pragma mark - Add coupon
-(void)shoppingCartCouponAddRequestParam:(NSString *)couponCode success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [webserviceData removeAllObjects];
    
    myDelegate.methodName=@"shoppingCartCouponAddRequestParam";
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"couponCode":couponCode,@"store":@"1",@"quoteId":[UserDefaultManager getValue:@"quoteId"]};
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlshoppingCartCouponAddRequestParam success:^(id data)
     {
         //Handle fault cases
         [myDelegate StopIndicator];
         webserviceData = [[OrderXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         [myDelegate StopIndicator];
     }] ;
    
}
#pragma mark - end
#pragma mark - Redeem points
-(void)generalApiShoppingCartRewardPointAddRequestParam:(NSString *)points success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [webserviceData removeAllObjects];
    
    myDelegate.methodName=@"generalApiShoppingCartRewardPointAddRequestParam";
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"points_value":points,@"store_id":@"1",@"quote_id":[UserDefaultManager getValue:@"quoteId"],@"customer_id":[UserDefaultManager getValue:@"customer_id"]};
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlgeneralApiShoppingCartRewardPointAddRequestParam success:^(id data)
     {
         //Handle fault cases
         [myDelegate StopIndicator];
         webserviceData = [[OrderXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         [myDelegate StopIndicator];
     }] ;
    
}
#pragma mark - end
#pragma mark - Cart totals
-(void)shoppingCartTotalsRequestParam:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [webserviceData removeAllObjects];
    
    myDelegate.methodName=@"shoppingCartTotalsRequestParam";
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"store":@"1",@"quoteId":[UserDefaultManager getValue:@"quoteId"]};
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlshoppingCartTotalsRequestParam success:^(id data)
     {
         //Handle fault cases
         [myDelegate StopIndicator];
         webserviceData = [[OrderXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         [myDelegate StopIndicator];
     }] ;
    
}
#pragma mark - end

#pragma mark - My loyalty points

-(void)generalApiUserLoyaltiPointsRequestParam:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [webserviceData removeAllObjects];
    
    NSLog(@"[UserDefaultManager getValue:customer_id] %@",[UserDefaultManager getValue:@"customer_id"]);
    myDelegate.methodName=@"generalApiUserLoyaltiPointsRequestParam";
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"customerId":[UserDefaultManager getValue:@"customer_id"],@"storeId":@"1"};
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlgeneralApiUserLoyaltiPointsRequestParam success:^(id data)
     {
         //Handle fault cases
         
         webserviceData = [[OrderXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
    
    
}
#pragma mark - end

#pragma mark - Reward points

-(void)generalApiLoyalityPageRequestParam:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [webserviceData removeAllObjects];
    
    myDelegate.methodName=@"generalApiLoyalityPageRequestParam";
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"]};
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlgeneralApiLoyalityPageRequestParam success:^(id data)
     {
         //Handle fault cases
         [myDelegate StopIndicator];
         webserviceData = [[OrderXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         [myDelegate StopIndicator];
     }] ;
}
#pragma mark - end

#pragma mark - Set address
-(void)shoppingCartCustomerAddressesRequestParam:(NSString*)fisrtname lastname:(NSString*)lastname shippingMode:(NSString*)shippingMode addressId:(NSString*)addressId streetAddress1:(NSString*)streetAddress1 city:(NSString*)city mobile:(NSString*)mobile countryCode:(NSString*)countryCode postcode:(NSString*)postcode streetAddress2:(NSString*)streetAddress2 state:(NSString*)state regionId:(NSString*)regionId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure

{
    [webserviceData removeAllObjects];
    
    myDelegate.methodName=@"shoppingCartCustomerAddressesRequestParam";
    
    NSMutableArray* customerAddressData = [NSMutableArray new];
    NSString *is_default_shipping;
    NSString *is_default_billing;
    for (int i = 0; i < 2; i++) {
        if (i==0)
        {
            shippingMode=@"shipping";
            is_default_shipping=@"1";
            is_default_billing=@"0";
        }
        else
        {
            shippingMode=@"billing";
            is_default_shipping=@"0";
            is_default_billing=@"1";
        }
        
        NSDictionary *dataDic = @{@"complexObjectArray":
                                      @{@"mode":shippingMode, @"address_id":addressId, @"firstname":fisrtname, @"lastname":lastname,@"company":@"",@"street":[NSString stringWithFormat:@"%@ %@",streetAddress1,streetAddress2],@"city":city,@"region":state,@"region_id":regionId,@"postcode":postcode,@"country_id":countryCode,@"telephone":mobile,@"fax":@"",@"is_default_billing":is_default_billing,@"is_default_shipping":is_default_shipping
                                        }
                                  
                                  };
        [customerAddressData addObject:dataDic];
        
    }
    
    
    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":[UserDefaultManager getValue:@"quoteId"], @"customerAddressData":customerAddressData,@"store":@"1" };
    
    //      NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"store":@"1",@"quoteId":[UserDefaultManager getValue:@"quoteId"]};
    [[Webservice sharedManager] fireWebserviceForArr:parameters methodName:kUrlshoppingCartCustomerAddressesRequestParam success:^(id data)
     {
         //Handle fault cases
         [myDelegate StopIndicator];
         webserviceData = [[OrderXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
     }
                                               failure:^(NSError *error)
     {
         //Handle if response is nil
         [myDelegate StopIndicator];
     }] ;
    
    
}
#pragma mark - end


#pragma mark - Remove coupon
-(void)shoppingCartCouponRemoveRequestParam:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [webserviceData removeAllObjects];
    
    myDelegate.methodName=@"shoppingCartCouponRemoveRequestParam";
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"store":@"1",@"quoteId":[UserDefaultManager getValue:@"quoteId"]};
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlshoppingCartCouponRemoveRequestParam success:^(id data)
     {
         //Handle fault cases
         
         webserviceData = [[OrderXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
    
}
#pragma mark - end

#pragma mark - Remove redeem points
-(void)generalApiShoppingCartRewardPointRemoveRequestParam:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [webserviceData removeAllObjects];
    
    myDelegate.methodName=@"generalApiShoppingCartRewardPointRemoveRequestParam";
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"customer_id":[UserDefaultManager getValue:@"customer_id"],@"quote_id":[UserDefaultManager getValue:@"quoteId"]};
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlgeneralApiShoppingCartRewardPointRemoveRequestParam success:^(id data)
     {
         //Handle fault cases
         [myDelegate StopIndicator];
         webserviceData = [[OrderXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         [myDelegate StopIndicator];
     }] ;
}
#pragma mark - end



@end
