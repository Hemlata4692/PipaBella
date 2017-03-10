//
//  CheckoutAddAddressViewController.h
//  PipaBella
//
//  Created by Ranosys on 05/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckoutManageAddressViewController.h"
@interface CheckoutAddAddressViewController : GlobalViewController
@property(strong,nonatomic)NSString *addressId;
@property(strong,nonatomic)NSString *firstNameStr;
@property(strong,nonatomic)NSString *lastNameStr;
@property(strong,nonatomic)NSString *address1;
@property(strong,nonatomic)NSString *address2;
@property(strong,nonatomic)NSString *cityStr;
@property(strong,nonatomic)NSString *countryStr;
@property(strong,nonatomic)NSString *regionId;
@property(strong,nonatomic)NSString *stateStr;
@property(strong,nonatomic)NSString *postalCodeStr;
@property(strong,nonatomic)NSString *phoneNumberStr;
@property(nonatomic,assign)BOOL isEditScreen;

@property (strong, nonatomic)CheckoutManageAddressViewController *checkVC;
@property(nonatomic)long indexPathPosition;

@end
