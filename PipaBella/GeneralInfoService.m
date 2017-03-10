//
//  GeneralInfoService.m
//  PipaBella
//
//  Created by Hema on 10/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "GeneralInfoService.h"
#import "GeneralInfoXMLParser.h"

#define kUrlCmsPageInfo         @"generalApiCmsPageInfoRequestParam"
#define kUrlCurrency            @"generalApiCurrencyRequestParam"
#define kUrlCurrencyConvertre   @"generalApiCurrencyRequestParam"

@implementation GeneralInfoService
{
    NSMutableDictionary *webserviceData;
}

#pragma mark - singleton instance
+ (id)sharedManager
{
    static GeneralInfoService *sharedMyManager = nil;
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
#pragma mark - CMS Pages

-(void)customerapiCmsPageInfoRequestParam:(NSString *)urlKey success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [webserviceData removeAllObjects];
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"urlkey":urlKey};
    
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlCmsPageInfo success:^(id data)
     {
         //Handle fault cases
         webserviceData = [[GeneralInfoXMLParser sharedManager]loadxmlByData:data];
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
         webserviceData = [[GeneralInfoXMLParser sharedManager]loadxmlArrayByData:data];
         success(webserviceData);
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
}
-(void)currencyConversion:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    myDelegate.methodName = @"generalApiCurrencyRequestParam";
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"]};
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlCurrencyConvertre success:^(id data)
     {
         //Handle fault cases
         webserviceData = [[GeneralInfoXMLParser sharedManager]loadxmlArrayByData:data];
         success(webserviceData);
         
     }
      failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;



}
#pragma mark - end

@end
