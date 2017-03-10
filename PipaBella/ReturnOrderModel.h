//
//  ReturnOrderModel.h
//  PipaBella
//
//  Created by Ranosys on 07/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReturnOrderModel : NSObject
@property(nonatomic,retain)NSString * OrderId;
@property(nonatomic,retain)NSString * name;
@property(nonatomic,retain)NSString * itemId;
@property(nonatomic,retain)NSString * sku;
@property(nonatomic,retain)NSString * qty;
@property(nonatomic,retain)NSString * image;
@property(nonatomic,retain)NSString * isVisible;

@property(nonatomic)BOOL  checker;

@property(nonatomic,retain)NSString * reasonId;
@property(nonatomic,retain)NSString * reasonName;
@property(nonatomic,retain)NSString * typeId;
@property(nonatomic,retain)NSString * typeName;
@property(nonatomic,retain)NSString * packingName;
@property(nonatomic,retain)NSString * packingId;

@end
