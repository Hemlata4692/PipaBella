//
//  QuizService.h
//  PipaBella
//
//  Created by Ranosys on 24/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuizService : NSObject

//Singleton instance
+ (id)sharedManager;
//end


//Product listing
-(void)quizListing:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

@end
