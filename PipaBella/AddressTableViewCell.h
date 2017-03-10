//
//  AddressTableViewCell.h
//  PipaBella
//
//  Created by Ranosys on 01/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManageAddressDataModel.h"

@interface AddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *mobileNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (weak, nonatomic) IBOutlet UIButton *addAnotherAddress;
@property (strong, nonatomic) IBOutlet UIButton *selectAddressBtn;
@property (strong, nonatomic) IBOutlet UILabel *deliveryTimeLabel;

-(void)displayData:(ManageAddressDataModel*)addressDataModel;
@end
