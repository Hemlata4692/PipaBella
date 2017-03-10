//
//  ManageAddressesViewController.h
//  PipaBella
//
//  Created by Ranosys on 21/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReturnOrderThreeViewController.h"

@interface ManageAddressesViewController : GlobalViewController
@property (strong, nonatomic)ReturnOrderThreeViewController *checkVC;
@property (nonatomic)BOOL isReturnScreen;
@end
