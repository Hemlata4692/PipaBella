//
//  AddAddressViewController.h
//  PipaBella
//
//  Created by Ranosys on 01/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddAddressViewController : GlobalViewController

@property(strong,nonatomic)NSString *addressId;
@property(strong,nonatomic)NSString *firstName;
@property(strong,nonatomic)NSString *lastName;
@property(strong,nonatomic)NSString *address1;
@property(strong,nonatomic)NSString *address2;
@property(strong,nonatomic)NSString *city;
@property(strong,nonatomic)NSString *country;
@property(strong,nonatomic)NSString *regionId;
@property(strong,nonatomic)NSString *state;
@property(strong,nonatomic)NSString *postalCode;
@property(strong,nonatomic)NSString *phoneNumber;
@property(nonatomic,assign)BOOL isEditScreen;


@end
