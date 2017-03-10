//
//  ReturnOrderOneViewController.h
//  PipaBella
//
//  Created by Ranosys on 06/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderHistoryViewController.h"
@interface ReturnOrderOneViewController : GlobalViewController
@property(nonatomic,retain)NSString * orderIdForReturn;
@property(nonatomic,retain)OrderHistoryViewController * objOrderHistory;
@end
