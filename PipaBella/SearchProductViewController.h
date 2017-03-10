//
//  SearchProductViewController.h
//  PipaBella
//
//  Created by Ranosys on 23/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchProductViewController : UIViewController
@property(nonatomic,retain)NSMutableArray *searchProductDataArray;


@property(nonatomic,retain)NSString * sortByPrice;
@property(nonatomic,retain)NSString * sortbyColor;
@property(nonatomic,retain)NSString * sortByinStock;
@property(nonatomic,retain)NSString * sortByWhatsNew;
@property(nonatomic,retain)NSString * colorString;
@property(nonatomic,retain)NSString * searchKeyword;
@property(nonatomic,assign)int pageNumber;
@property(nonatomic,retain)NSMutableArray *sortBySelectedArray;

@end
