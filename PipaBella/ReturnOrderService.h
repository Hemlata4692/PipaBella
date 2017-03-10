//
//  ReturnOrderService.h
//  PipaBella
//
//  Created by Ranosys on 07/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReturnOrderService : NSObject
//Singleton instance
+ (id)sharedManager;
//end

//Return order
-(void)returnOrder:(NSString *)orderId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Submit return order
-(void)submitReturnOrder:(NSString *)reasonId orderIncrementId:(NSString *)orderIncrementId additionalinfo:(NSString *)additionalinfo orderData:(NSMutableDictionary*)orderData requesttype:(NSString *)requesttype packageopened:(NSString *)packageopened pick_from:(NSString *)pick_from address:(NSString *)address success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

@end
