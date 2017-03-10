//
//  SortByViewController.h
//  PipaBella
//
//  Created by Ranosys on 08/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductListViewController.h"
#import "SearchProductViewController.h"
#import "HomeViewController.h"
@interface SortByViewController : UIViewController
@property(nonatomic,retain)ProductListViewController * objProductListing;

@property(nonatomic,retain)SearchProductViewController * objSearchProductListing;
@property(nonatomic,retain)HomeViewController * objHomeView;
@property(nonatomic,retain)NSMutableArray *sortBySelectedArray;
@property(nonatomic,assign)BOOL isSearchScreen;
@property(nonatomic,assign)BOOL isHomeScreen;

@end
