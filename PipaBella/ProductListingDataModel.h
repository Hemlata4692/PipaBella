//
//  ProductListingDataModel.h
//  PipaBella
//
//  Created by Hema on 18/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductListingDataModel : NSObject

@property(nonatomic,retain)NSString * productId;
@property(nonatomic,retain)NSString * productName;
@property(nonatomic,retain)NSString * productImage;
@property(nonatomic,retain)NSString * isInStock;
@property(nonatomic,retain)NSString * productPrice;
@property(nonatomic,retain)NSString * productPriceSymbol;
@property(nonatomic,retain)NSString * categoryImage;
@property(nonatomic,retain)NSString * totalProducts;
@property(nonatomic,retain)NSString * skuNumber;
@property(nonatomic,retain)NSString * specialPrice;
@property(nonatomic,retain)NSString * stockQuantity;
@property(nonatomic,assign)BOOL isAddedToWishlist;
@property(nonatomic,assign)BOOL isLoader;

@end
