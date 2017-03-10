//
//  ProductListViewController.h
//  PipaBella
//
//  Created by Ranosys on 17/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductListViewController : GlobalViewController
{

}
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSString *navigationTitle;

@property(nonatomic,retain)NSString * sortByPrice;
@property(nonatomic,retain)NSString * sortbyColor;
@property(nonatomic,retain)NSString * sortByinStock;
@property(nonatomic,retain)NSString * sortByWhatsNew;
@property(nonatomic,retain)NSString * colorString;
@property(nonatomic,retain)NSMutableArray *sortBySelectedArray;
@property(nonatomic,retain)NSMutableArray *productDataArray;
@property(nonatomic,assign)int pageNumber;
@end
