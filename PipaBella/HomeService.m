//
//  HomeService.m
//  PipaBella
//
//  Created by Ranosys on 07/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "HomeService.h"
#import "HomeXMLParser.h"
#import "DiscoverDataModel.h"

#define kUrlHome              @"generalApiHomePageRequestParam"


@implementation HomeService
{
    NSMutableDictionary *webserviceData;
}

#pragma mark - singleton instance
+ (id)sharedManager
{
    static HomeService *sharedMyManager = nil;
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
#pragma mark - WhatsNew

-(void)whatsNewWebservice:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    
    [webserviceData removeAllObjects];
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"]};
    
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlHome success:^(id data)
     {
         //Handle fault cases
         
         webserviceData = [[HomeXMLParser sharedManager]loadxmlByData:data];
         success(webserviceData);
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
}
#pragma mark - end

@end
