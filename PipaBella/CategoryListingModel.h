//
//  CategoryListingModel.h
//  PipaBella
//
//  Created by Sumit on 21/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryListingModel : NSObject
@property(nonatomic,retain)NSString * catName;
@property(nonatomic,retain)NSString * catId;
@property(nonatomic,retain)NSString * catIcon;
@property(nonatomic,retain)NSMutableArray * subCatArray;
@property(nonatomic,retain)NSString * type;
@property(nonatomic,retain)NSString * productType;
@property(nonatomic,retain)NSString * productId;
@property(nonatomic,retain)NSString * isInstock;
@end
