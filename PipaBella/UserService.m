//
//  UserService.m
//  Digibi_ecommerce
//
//  Created by Sumit on 08/09/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import "UserService.h"
#import "UserXMLParser.h"
#define kUrlLogin                       @"loginParam"
#define kUrlUserLogin                   @"generalApiCustomerLoginRequestParam"
#define kUrlRegisterUser                @"customerCustomerCreateRequestParam"
#define kUrlForgotPassword              @"generalApiForgetPasswordRequestParam"
#define kUrlRewardPoints                @"generalApiAppViralityRequestParam"
@implementation UserService

{
    NSMutableDictionary *webserviceData;
}

#pragma mark - Singleton Instance
+ (id)sharedManager
{
    static UserService *sharedMyManager = nil;
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

#pragma mark - Get SessionId

-(void)getSessionId:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    myDelegate.methodName=@"loginParam";
    NSDictionary * parameters = @{@"username":@"ranosys",@"apiKey":@"ranosys1234"};
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlLogin success:^(id data)
     {
         [[UserXMLParser sharedManager]loadxmlByData:data];
         NSLog(@"Session Id is %@",[[UserXMLParser sharedManager] responseString]);
         success(data);
     }
        failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
}
#pragma mark - end

#pragma mark - Login
-(void )userLogin:(NSString *)email password:(NSString *)password facebook:(NSString *)facebook fbparams:(NSDictionary *)fbparams success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [webserviceData removeAllObjects];
    myDelegate.methodName=@"generalApiCustomerLoginRequestParam";
    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"email":email,@"password":password,@"devicetoken":@"",@"devicetype":@"i",@"isfb":facebook,@"fbparams":fbparams,@"quoteId":@""};
    
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlUserLogin success:^(id data)
     {
         //Handle fault cases
         
         webserviceData = [[UserXMLParser sharedManager]loadxmlByData:data];
         
         success(webserviceData);
     }
    failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }];
    
    
    
}
#pragma mark - end

#pragma mark - Register User

-(void)registerUser:(NSString *)name email:(NSString *)email password:(NSString *)password success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [webserviceData removeAllObjects];
    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    myDelegate.methodName=@"customerCustomerCreateRequestParam";
    
    NSDictionary*customerData=@{@"customer_id":@"",@"firstname":name,@"email":email,@"password":password,@"lastname":@"",@"middlename":@"",@"website_id":@"1",@"store_id":@"1",@"group_id":@"1",@"prefix":@"",@"suffix":@"",@"dob":@"",@"taxvat":@"",@"gender":@""};
    
    NSDictionary *parameters= @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"customerData":customerData};
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlRegisterUser success:^(id data)
     {
         //Handle fault cases
         webserviceData = [[UserXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
    
    
}
#pragma mark - end

#pragma mark - Forgot Password
-(void)forgotPassword:(NSString *)email success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [webserviceData removeAllObjects];
     myDelegate.methodName=@"generalApiForgetPasswordRequestParam";
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"email":email};
    
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlForgotPassword success:^(id data)
     {
         //Handle fault cases
         webserviceData = [[UserXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
    
    
    
}
#pragma mark - end
-(void)earnRewards:(NSString *)customerId points:(NSString *)points success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [webserviceData removeAllObjects];
    myDelegate.methodName=@"generalApiAppViralityRequestParam";
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"customer_id":customerId,@"points":points};
    
    NSLog(@"refer points %@",parameters);
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlRewardPoints success:^(id data)
     {
         //Handle fault cases
         webserviceData = [[UserXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;

}

@end
