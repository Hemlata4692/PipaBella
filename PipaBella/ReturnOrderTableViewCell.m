//
//  ReturnOrderTableViewCell.m
//  PipaBella
//
//  Created by Ranosys on 07/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "ReturnOrderTableViewCell.h"

@implementation ReturnOrderTableViewCell
@synthesize containerView,productImage,productName,skuNumber,quantityLabel,orderIdLabel,checkButton;


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Data display of objects
-(void)displayData:(ReturnOrderModel*)returnOrderData
{
    productName.text = [NSString stringWithFormat:@"%@",returnOrderData.name];
    skuNumber.text = [NSString stringWithFormat:@"%@",returnOrderData.sku];
    quantityLabel.text = [NSString stringWithFormat:@"%@",returnOrderData.qty];
    orderIdLabel.text = [NSString stringWithFormat:@"%@",returnOrderData.OrderId];
    [productImage sd_setImageWithURL:[NSURL URLWithString:returnOrderData.image] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    if ([returnOrderData.isVisible isEqualToString:@"Yes"])
    {     
        
        checkButton.hidden = NO;
        if (returnOrderData.checker)
        {
            [checkButton setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateNormal];
        }
        else
        {
            [checkButton setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        }
        
        
        
    }
    else if ([returnOrderData.isVisible isEqualToString:@"No"])
    {
         checkButton.hidden = YES;
    }
    
    
}
#pragma mark - end

@end
