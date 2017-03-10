//
//  ProductDetailViewController.h
//  PipaBella
//
//  Created by Ranosys on 17/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailViewController : GlobalViewController
@property(nonatomic,retain)NSString * productId;
@property(nonatomic,retain)NSString * productName;
@property(nonatomic,assign)bool isAddedtoWishlist;
@property(nonatomic,retain)NSString *isInStock;
@property(nonatomic,retain)NSMutableDictionary * personalizeDict;
@property(nonatomic,assign) int stockQuantity;
@property(nonatomic,assign)bool isInWaitlist;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSString *navigationTitle;
@property(nonatomic,assign)bool hasPersonalized;
@end
