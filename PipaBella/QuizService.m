//
//  QuizService.m
//  PipaBella
//
//  Created by Ranosys on 24/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "QuizService.h"
#import "QuizXMLParser.h"


#define kUrlQuizListing                @"generalApiQuizQuestionGetRequestParam"



@implementation QuizService
{
    NSMutableDictionary *webserviceData;
}

#pragma mark - Singleton instance
+ (id)sharedManager
{
    static QuizService *sharedMyManager = nil;
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

#pragma mark - Product Listing

-(void)quizListing:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [webserviceData removeAllObjects];
    NSLog(@"sessionId %@",[UserDefaultManager getValue:@"sessionId"]);
      myDelegate.methodName=@"generalApiQuizQuestionGetRequestParam";
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"]};
    
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlQuizListing success:^(id data)
     {
         //Handle fault cases
         webserviceData = [[QuizXMLParser sharedManager]loadxmlByDataArray:data];
         success(webserviceData);
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
}
#pragma mark - end


@end
