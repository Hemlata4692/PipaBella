//
//  HomeViewController.h
//  PipaBella
//
//  Created by Ranosys on 20/10/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
@property(nonatomic,retain)NSString * sortByPrice;
@property(nonatomic,retain)NSString * sortbyColor;
@property(nonatomic,retain)NSString * sortByinStock;
@property(nonatomic,retain)NSString * sortByWhatsNew;
@property(nonatomic,retain)NSString * colorString;
@property(nonatomic,retain)NSMutableArray *sortBySelectedArray;
@property(nonatomic,retain)NSMutableArray *bestsellersDataArray;
@property(nonatomic,retain)NSMutableArray *restockDataArray;

-(void)setParameters;
@end
