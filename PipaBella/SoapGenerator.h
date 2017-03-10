//
//  SoapGenerator.h
//  DigiBi
//
//  Created by Sumit on 07/09/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoapGenerator : NSObject
+(NSString *)upperSoapPart : (NSString *)methodName;
+(NSString *)lowerSoapPart : (NSString *)methodName;
+(NSString *)getSoapString :(NSDictionary *)parameters methodName:(NSString *)methodName;
+(NSString *)getSoapStringWithArray :(NSDictionary *)parameters methodName:(NSString *)methodName;
@end
