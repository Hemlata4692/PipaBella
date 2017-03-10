//
//  GeneralInfoService.h
//  PipaBella
//
//  Created by Hema on 10/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneralInfoService : NSObject

//Singleton instance
+ (id)sharedManager;
//end


//CMS Pages 
-(void)customerapiCmsPageInfoRequestParam:(NSString *)urlKey success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Currency
-(void)currency:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end
//Currency
-(void)currencyConversion:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end
@end
