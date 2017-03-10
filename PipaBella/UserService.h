//
//  UserService.h
//  Digibi_ecommerce
//
//  Created by Sumit on 08/09/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserService : NSObject

//Singleton instance
+ (id)sharedManager;
//end

//Get session id from server
-(void)getSessionId:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Login
-(void )userLogin:(NSString *)email password:(NSString *)password facebook:(NSString *)facebook fbparams:(NSDictionary *)fbparams success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Register user
-(void)registerUser:(NSString *)name email:(NSString *)email password:(NSString *)password success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end


//Forgot password
-(void)forgotPassword:(NSString *)email success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Earn reward
-(void)earnRewards:(NSString *)customerId points:(NSString *)points success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

@end
