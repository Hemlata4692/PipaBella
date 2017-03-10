//
//  OrderDetailModel.h
//  PipaBella
//
//  Created by Monika on 1/7/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject
////Shipping address
//@property(nonatomic,retain)NSString * sfirstname;
//@property(nonatomic,retain)NSString * slastname;
//@property(nonatomic,retain)NSString * sstreet;
//@property(nonatomic,retain)NSString * scity;
//@property(nonatomic,retain)NSString * sregion;
//@property(nonatomic,retain)NSString * spostcode;
//@property(nonatomic,retain)NSString * stelephone;

////Billing address
//@property(nonatomic,retain)NSString * bfirstname;
//@property(nonatomic,retain)NSString * blastname;
//@property(nonatomic,retain)NSString * bstreet;
//@property(nonatomic,retain)NSString * bcity;
//@property(nonatomic,retain)NSString * bregion;
//@property(nonatomic,retain)NSString * bpostcode;
//@property(nonatomic,retain)NSString * btelephone;
//
//Product details
@property(nonatomic,retain)NSString * productId;
@property(nonatomic,retain)NSString * name;
@property(nonatomic,retain)NSString * quantity;
@property(nonatomic,retain)NSString * sku;
@property(nonatomic,retain)NSString * status;
@property(nonatomic,retain)NSString * amountPaid;
@property(nonatomic,retain)NSString * totalPrice;
@property(nonatomic,retain)NSString * subTotalPrice;
@property(nonatomic,retain)NSString * paymentMethod;
@property(nonatomic,retain)NSString * imageUrl;
@property(nonatomic,retain)NSString * parentId;






@end
