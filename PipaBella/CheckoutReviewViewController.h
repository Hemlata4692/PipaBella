//
//  CheckoutReviewViewController.h
//  PipaBella
//
//  Created by Ranosys on 05/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckoutReviewViewController : GlobalViewController
@property(nonatomic,retain)NSMutableArray * cartArray;
@property(nonatomic,retain)NSString * totalPrice;
@property (strong, nonatomic) IBOutlet UIView *ViewControllerView;

@end
