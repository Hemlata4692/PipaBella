//
//  ReturnOrderService.m
//  PipaBella
//
//  Created by Ranosys on 07/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "ReturnOrderService.h"
#import "ReturnOrderXMLParser.h"
#define kUrlReturnOrder              @"generalApiRmaRequestParam"
#define kUrlSubmitReturnOrder        @"generalApiRmaprocessRequestParam"




@implementation ReturnOrderService
{
    NSMutableDictionary *webserviceData;
}

#pragma mark - singleton instance
+ (id)sharedManager
{
    static ReturnOrderService *sharedMyManager = nil;
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


#pragma mark - Return order

-(void)returnOrder:(NSString *)orderId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [webserviceData removeAllObjects];
    myDelegate.methodName = @"generalApiRmaRequestParam";
    NSLog(@"sessionId %@",[UserDefaultManager getValue:@"sessionId"]);
    NSLog(@"customerId %@",[UserDefaultManager getValue:@"customer_id"]);

    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"customerId":[UserDefaultManager getValue:@"customer_id"],@"storeId":@"1",@"orderId":orderId};
    
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlReturnOrder success:^(id data)
     {
         //Handle fault cases
         webserviceData = [[ReturnOrderXMLParser sharedManager]loadxmlByData:data];
         
         if ([[[ReturnOrderXMLParser sharedManager]status] isEqualToString:@"0"])
         {
             [webserviceData setObject:[[ReturnOrderXMLParser sharedManager]status] forKey:@"status"];
             [webserviceData setObject:[[ReturnOrderXMLParser sharedManager]responseString] forKey:@"message"];
             success(webserviceData);
         }
         else
         {
             success(webserviceData);
         }
         
     }
       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;

    
 }
#pragma mark - end

#pragma mark - Submit return order

-(void)submitReturnOrder:(NSString *)reasonId orderIncrementId:(NSString *)orderIncrementId additionalinfo:(NSString *)additionalinfo orderData:(NSMutableDictionary*)orderData requesttype:(NSString *)requesttype packageopened:(NSString *)packageopened pick_from:(NSString *)pick_from address:(NSString *)address success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [webserviceData removeAllObjects];
    myDelegate.methodName = @"generalApiRmaprocessRequestParam";
    NSLog(@"sessionId %@",[UserDefaultManager getValue:@"sessionId"]);
    NSLog(@"customerId %@",[UserDefaultManager getValue:@"customer_id"]);
    
    
    NSArray* ids = orderData.allKeys;
    NSMutableArray* orderDatas = [NSMutableArray new];
 //   NSString* complexString = @"<complexObjectArray>";
   // NSString* complexString = @"";
    for (int i = 0; i < ids.count; i++) {
        NSDictionary *dataDic = @{@"complexObjectArray":
                                      @{@"key":[ids objectAtIndex:i], @"value":[orderData objectForKey:[ids objectAtIndex:i]]
                                        }
                                  };
        [orderDatas addObject:dataDic];
        
       // complexString = [NSString stringWithFormat:@"%@<key>%@</key><value>%@</value>",complexString,[ids objectAtIndex:i],[orderData objectForKey:[ids objectAtIndex:i]]];
    }
//    complexString = [NSString stringWithFormat:@"%@</complexObjectArray>",complexString];
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"customerId":[UserDefaultManager getValue:@"customer_id"],@"orderIncrementId":orderIncrementId,@"reasonId":reasonId,@"requesttype":requesttype,@"packageopened":packageopened,@"pick_from":pick_from,@"address":address,@"additionalinfo":additionalinfo ,@"orderitems":orderDatas};
                                      
                                 
    
    // NSDictionary * parameters = @{@"sessionId":@"a553730f911d891e4109e2095670198b",@"customerId":@"2730",@"storeId":@"1",@"orderId":orderId};
    
    
    [[Webservice sharedManager] fireWebserviceForArr:parameters methodName:kUrlSubmitReturnOrder success:^(id data)
     {
         //Handle fault cases
         webserviceData = [[ReturnOrderXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
    
    
}
#pragma mark - end





@end
