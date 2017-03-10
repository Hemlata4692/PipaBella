//
//  OrderHistoryTableViewCell.m
//  PipaBella
//
//  Created by Ranosys on 09/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "OrderHistoryTableViewCell.h"
#import "CurrencyConverter.h"
@implementation OrderHistoryTableViewCell
@synthesize containerView,orderIdLabel,orderDateLabel,shipToLabel,orderTotal,statusLabel,returnOrderButton,orderId,trackOrderBtn;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - Setframes of objects

-(void)layoutView : (CGRect )rect index:(int)index
{
    
}
#pragma mark - end
-(void)displayData:(OrderHistoryModel *)orderHistoryData
{
    //Order Id
    orderId.text = [NSString stringWithFormat:@"# %@",orderHistoryData.OrderId];
    orderId.contentInset = UIEdgeInsetsMake(-5.0,0.0,5.0,0.0);
    //Price
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    
    orderTotal.text =  [CurrencyConverter converCurrency:orderHistoryData.grandTotal];
    
    orderDateLabel.text=orderHistoryData.date;
    statusLabel.text=[orderHistoryData.status capitalizedString];
    shipToLabel.text=[NSString stringWithFormat:@"%@ %@",orderHistoryData.firstname,orderHistoryData.lastname];
    if ([orderHistoryData.status isEqualToString:@"canceled"])
    {
        statusLabel.textColor=[UIColor colorWithRed:255/255.0 green:65/255.0 blue:21/255.0 alpha:1.0];
        returnOrderButton.hidden=YES;
        trackOrderBtn.hidden = YES;

    }
    else if ([orderHistoryData.status isEqualToString:@"complete"])
    {
         statusLabel.textColor=[UIColor colorWithRed:29/255.0 green:190/255.0 blue:3/255.0 alpha:1.0];
        returnOrderButton.hidden=NO;
        trackOrderBtn.hidden = YES;
    }
    else
    {
        statusLabel.textColor=[UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1.0];
        returnOrderButton.hidden=YES;
        trackOrderBtn.hidden = NO;
        
    }
}

@end
