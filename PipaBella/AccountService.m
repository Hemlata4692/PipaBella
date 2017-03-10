//
//  AccountService.m
//  PipaBella
//
//  Created by Ranosys on 01/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "AccountService.h"
#import "AccountXMLParser.h"

#define kUrlChangePassword              @"generalApiChangePasswordRequestParam"
#define kUrlCurrency                    @"generalApiCurrency"
#define kUrlgetAddressList              @"customerAddressListRequestParam"
#define kUrladdAddress                  @"customerAddressCreateRequestParam"
#define kUrlupdateAddress               @"customerAddressUpdateRequestParam"
#define kUrldeleteAddress               @"customerAddressDeleteRequestParam"
#define kUrlcountryList                 @"generalApiDirectoryCountryListRequestParam"
#define kUrlregionList                  @"directoryRegionListRequestParam"

@implementation AccountService
{
    NSMutableDictionary *webserviceData;
}

#pragma mark - Singleton instance
+ (id)sharedManager
{
    static AccountService *sharedMyManager = nil;
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

#pragma mark - Change password
-(void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [webserviceData removeAllObjects];
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"email":[UserDefaultManager getValue:@"userEmail"],@"old_password":oldPassword,@"new_password":newPassword};
    
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlChangePassword success:^(id data)
     {
         //Handle fault cases
         webserviceData = [[AccountXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
}
#pragma mark - end

#pragma mark - Add address
-(void)addAddress:(NSString *)firstName lastName:(NSString *)lastName phoneNumber:(NSString *)phoneNumber address1:(NSString *)address1 address2:(NSString *)address2 city:(NSString *)city country:(NSString *)country state:(NSString *)state postalCode:(NSString *)postalCode customerAddressId:(NSString *)customerAddressId regionId:(NSString *)regionId isEdit:(BOOL)isEdit success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [webserviceData removeAllObjects];
    
    NSLog(@"sessionId %@",[UserDefaultManager getValue:@"sessionId"]);
    NSLog(@"customer_id %@",[UserDefaultManager getValue:@"customer_id"]);
    
    NSString* street = [NSString stringWithFormat:@"<complexObjectArray>%@</complexObjectArray> <complexObjectArray>%@</complexObjectArray>",address1,address2];
    NSDictionary * addressData = @{@"city":city,@"company":@"",@"country_id":country,@"fax":@"",@"firstname":firstName,@"lastname":lastName,@"middlename":@"",@"postcode":postalCode,@"prefix":@"",@"region_id":regionId,@"region":state,@"street":street,@"suffix":@"",@"telephone":phoneNumber,@"is_default_billing":@"0",@"is_default_shipping":@"1"};
    
    
    if (isEdit==YES)
    {
        NSDictionary *parameters= @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"addressId":customerAddressId,@"addressData":addressData};
        [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlupdateAddress success:^(id data)
         {
             //Handle fault cases
             webserviceData = [[AccountXMLParser sharedManager]loadxmlByData:data];
             success(webserviceData);
             
         }
                                           failure:^(NSError *error)
         {
             //Handle if response is nil
             
         }] ;

    }
    else
    {
        NSDictionary *parameters= @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"customerId":[UserDefaultManager getValue:@"customer_id"],@"addressData":addressData};
        [[Webservice sharedManager] fireWebservice:parameters methodName:kUrladdAddress success:^(id data)
         {
             //Handle fault cases
             webserviceData = [[AccountXMLParser sharedManager]loadxmlByData:data];
             success(webserviceData);
             
         }
                                           failure:^(NSError *error)
         {
             //Handle if response is nil
             
         }] ;

        
    }
    
}
#pragma mark - end

#pragma mark - Get addresses list
-(void)addressList:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [webserviceData removeAllObjects];
    //NSLog(@"sessionId %@",[UserDefaultManager getValue:@"sessionId"]);
   // NSLog(@"customer_id %@",[UserDefaultManager getValue:@"customer_id"]);

    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"customerId":[UserDefaultManager getValue:@"customer_id"]};
    
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlgetAddressList success:^(id data)
     {
         //Handle fault cases
         webserviceData = [[AccountXMLParser sharedManager]loadxmlByDataArray:data];
         success(webserviceData);
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
}


#pragma mark - end

#pragma mark - Delete address
-(void)deleteAddress:(NSString *)customerAddressId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [webserviceData removeAllObjects];
    //NSLog(@"sessionId %@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"addressId":customerAddressId};
    
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrldeleteAddress success:^(id data)
     {
         //Handle fault cases
         webserviceData = [[AccountXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
}
#pragma mark - end

#pragma mark - Country list
-(void)countryList:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [webserviceData removeAllObjects];
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"]};
    
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcountryList success:^(id data)
     {
         //Handle fault cases
         webserviceData = [[AccountXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
}
#pragma mark - end

#pragma mark - Region list
-(void)regionList:(NSString *)countryId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [webserviceData removeAllObjects];
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"country":countryId};
    
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlregionList success:^(id data)
     {
         //Handle fault cases
         webserviceData = [[AccountXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
}
#pragma mark - end


#pragma mark - Currency

-(void)currency:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [webserviceData removeAllObjects];
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"]};
    
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlCurrency success:^(id data)
     {
         //Handle fault cases
         webserviceData = [[AccountXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
}
#pragma mark - end
#pragma mark - CMS pages

-(void)cmspages:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [webserviceData removeAllObjects];
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"]};
    
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlCurrency success:^(id data)
     {
         //Handle fault cases
         webserviceData = [[AccountXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
}

#pragma mark - end
@end
