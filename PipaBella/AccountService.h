//
//  AccountService.h
//  PipaBella
//
//  Created by Ranosys on 01/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountService : NSObject
//Singleton instance
+ (id)sharedManager;
//end


//Change password
-(void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Country list
-(void)countryList:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Region list
-(void)regionList:(NSString *)countryId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Add address
-(void)addAddress:(NSString *)firstName lastName:(NSString *)lastName phoneNumber:(NSString *)phoneNumber address1:(NSString *)address1 address2:(NSString *)address2 city:(NSString *)city country:(NSString *)country state:(NSString *)state postalCode:(NSString *)postalCode customerAddressId:(NSString *)customerAddressId regionId:(NSString *)regionId isEdit:(BOOL)isEdit success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Get address
-(void)addressList:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Delete address
-(void)deleteAddress:(NSString *)customerAddressId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Currency
-(void)currency:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

@end
