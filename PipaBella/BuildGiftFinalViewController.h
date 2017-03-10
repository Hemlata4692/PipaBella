//
//  BuildGiftFinalViewController.h
//  PipaBella
//
//  Created by Sumit on 10/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuildGiftViewController.h"
@interface BuildGiftFinalViewController : GlobalViewController
@property (nonatomic,retain)NSMutableArray * dataArray;
@property(retain,nonatomic)UIImage * bannerImage;
@property (nonatomic,retain)NSMutableArray * sendingDataArray;
@property(nonatomic,retain)NSString * productId;
@property(nonatomic,assign)int stockQuantity;
@property(nonatomic,retain) BuildGiftViewController * objBuildGift;
@end
