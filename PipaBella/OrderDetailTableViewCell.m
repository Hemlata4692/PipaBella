//
//  OrderDetailTableViewCell.m
//  PipaBella
//
//  Created by Ranosys on 10/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "OrderDetailTableViewCell.h"
#import "CurrencyConverter.h"
@implementation OrderDetailTableViewCell
@synthesize itemsContainerView,productImage,productNameLabel,productPrice,quantityLabel,itemSubtotalLabel;
@synthesize subtotalLabel,shippingLabel,vatLabel,grandTotalLabel,vatPerLabel;
@synthesize pointsGatheredLabel,pointsUsedLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)displayData:(OrderDetailModel*)orderDetailData
{
    
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    
    productNameLabel.text=orderDetailData.name;
    
    productPrice.text =  [CurrencyConverter converCurrency:orderDetailData.totalPrice];
    itemSubtotalLabel.text=[CurrencyConverter converCurrency:orderDetailData.subTotalPrice];

//    productPrice.text =  [NSString stringWithFormat:@"%@ %@",@"RS",[fmt stringFromNumber:[NSNumber numberWithFloat:[orderDetailData.totalPrice floatValue]]]];
//    itemSubtotalLabel.text=[NSString stringWithFormat:@"%@ %@",@"RS",[fmt stringFromNumber:[NSNumber numberWithFloat:[orderDetailData.subTotalPrice floatValue]]]];
    [productImage sd_setImageWithURL:[NSURL URLWithString:orderDetailData.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    
}

-(void)displayData:(NSString *)subTotal shippingCharge:(NSString *)shippingCharge vatPercent:(NSString *)vatPercent vatAmount:(NSString *)vatAmount grandTotal:(NSString *)grandTotal
{
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    
    //    subtotalLabel.text=[NSString stringWithFormat:@"%@ %@",@"RS",[fmt stringFromNumber:[NSNumber numberWithFloat:[subTotal floatValue]]]];
    //    shippingLabel.text=[NSString stringWithFormat:@"%@ %@",@"RS",[fmt stringFromNumber:[NSNumber numberWithFloat:[shippingCharge floatValue]]]];
    //
    vatPerLabel.text=[NSString stringWithFormat:@"%@ (%@ %@)",@"VAT",[fmt stringFromNumber:[NSNumber numberWithFloat:[vatPercent floatValue]]],@"%"];
    //
    //        vatLabel.text=[NSString stringWithFormat:@"%@ %@",@"RS",[fmt stringFromNumber:[NSNumber numberWithFloat:[vatAmount floatValue]]]];
    //    grandTotalLabel.text=[NSString stringWithFormat:@"%@ %@",@"RS",[fmt stringFromNumber:[NSNumber numberWithFloat:[grandTotal floatValue]]]];
    //
    
    
    subtotalLabel.text=[CurrencyConverter converCurrency:subTotal];
    shippingLabel.text=[CurrencyConverter converCurrency:shippingCharge];
    //  vatPerLabel.text=[CurrencyConverter converCurrency:vatPercent];
    vatLabel.text=[CurrencyConverter converCurrency:vatAmount];
    grandTotalLabel.text=[CurrencyConverter converCurrency:grandTotal];
}

-(void)displayData:(NSString *)pointsGathered pointUsed:(NSString *)pointUsed
{
    pointsGatheredLabel.text=pointsGathered;
    pointsUsedLabel.text=pointUsed;
}
@end
