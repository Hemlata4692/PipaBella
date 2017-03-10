//
//  OrderDetailViewController.h
//  PipaBella
//
//  Created by Ranosys on 09/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailViewController : GlobalViewController
@property(nonatomic,strong) NSString *orderId;
@property(nonatomic,strong) NSString *date;
@property(nonatomic,strong) NSString *price;
@end
