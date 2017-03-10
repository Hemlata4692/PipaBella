//
//  OrderHistoryModel.h
//  PipaBella
//
//  Created by Monika on 1/6/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderHistoryModel : NSObject
@property(nonatomic,retain)NSString * OrderId;
@property(nonatomic,retain)NSString * date;
@property(nonatomic,retain)NSString * firstname;
@property(nonatomic,retain)NSString * lastname;
@property(nonatomic,retain)NSString * grandTotal;
@property(nonatomic,retain)NSString * currency;
@property(nonatomic,retain)NSString * status;
@property(nonatomic,retain)NSString * orderIdForReturnOrder;
@end
