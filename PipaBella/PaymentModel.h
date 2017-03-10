//
//  PaymentModel.h
//  PipaBella
//
//  Created by Ranosys on 12/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentModel : NSObject

@property(nonatomic,retain)NSString * shippingCode;
@property(nonatomic,retain)NSString * paymentCode;
@property(nonatomic,retain)NSString * method;
@property(nonatomic,retain)NSString * price;

@property(nonatomic,retain)NSString * title;

@property(nonatomic,retain)NSString * errorMessage;



@end
