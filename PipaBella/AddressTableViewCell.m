//
//  AddressTableViewCell.m
//  PipaBella
//
//  Created by Ranosys on 01/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "AddressTableViewCell.h"

@implementation AddressTableViewCell
@synthesize nameLabel,addressTextView,mobileNumberLabel,borderView,selectAddressBtn,addAnotherAddress;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)displayData:(ManageAddressDataModel*)addressDataModel
{
   
    borderView.layer.borderWidth=1.0f;
    borderView.layer.borderColor = [UIColor colorWithRed:219.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1.0].CGColor;
    borderView.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0f];
    
    nameLabel.text = [NSString stringWithFormat:@"%@ %@",addressDataModel.firstname,addressDataModel.lastname];
    addressTextView.text=[NSString stringWithFormat:@"%@, %@, %@%@ %@ %@",addressDataModel.street,addressDataModel.city,@"\n",addressDataModel.stateName,@"-",addressDataModel.postcode];
    addressTextView.textColor=[UIColor colorWithRed:115.0/255.0 green:115.0/255.0 blue:115.0/255.0 alpha:1.0];
    addressTextView.contentInset = UIEdgeInsetsMake(-4,-4,0,0);
    mobileNumberLabel.text=addressDataModel.telephone;
    
    if (addressDataModel.checkSelectionState ==1)
    {
        selectAddressBtn.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
    }
    else
    {
        selectAddressBtn.backgroundColor=[UIColor clearColor];
    }
}
@end
