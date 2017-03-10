//
//  HomeService.h
//  PipaBella
//
//  Created by Ranosys on 07/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeService : NSObject
//Singleton instance
+ (id)sharedManager;
//end


//WhatsNew
-(void)whatsNewWebservice:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end
@end
