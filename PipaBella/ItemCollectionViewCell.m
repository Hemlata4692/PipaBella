//
//  ItemCollectionViewCell.m
//  PipaBella
//
//  Created by Ranosys on 13/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "ItemCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ItemCollectionViewCell
@synthesize itemImageView,skuLabel,quantityLabel,amountLabel;



#pragma mark - Setframes of objects

-(void)layoutView : (CGSize )rect index:(int)index
{
    self.itemImageView.translatesAutoresizingMaskIntoConstraints=YES;
    self.skuLabel.translatesAutoresizingMaskIntoConstraints=YES;
    self.quantityLabel.translatesAutoresizingMaskIntoConstraints=YES;
    self.amountLabel.translatesAutoresizingMaskIntoConstraints=YES;
    
    
    
    self.itemImageView.frame = CGRectMake(18, self.itemImageView.frame.origin.y,rect.width-36, self.itemImageView.frame.size.height);
    [[itemImageView layer] setBorderWidth:1.0f];
    [[itemImageView layer] setBorderColor:[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0].CGColor];
    
    self.skuLabel.frame = CGRectMake(self.skuLabel.frame.origin.x, self.itemImageView.frame.origin.y+self.itemImageView.frame.size.height+10, rect.width-20, self.skuLabel.frame.size.height);
    
    self.quantityLabel.frame = CGRectMake(self.quantityLabel.frame.origin.x, self.skuLabel.frame.origin.y+self.skuLabel.frame.size.height+4, rect.width-20, self.quantityLabel.frame.size.height);
    
    self.amountLabel.frame = CGRectMake(self.amountLabel.frame.origin.x, self.quantityLabel.frame.origin.y+self.quantityLabel.frame.size.height+4, rect.width-20, self.amountLabel.frame.size.height);

}

-(void)displayData:(OrderDetailModel*)orderDataModel
{
    [itemImageView sd_setImageWithURL:[NSURL URLWithString:orderDataModel.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    skuLabel.text = [NSString stringWithFormat:@"SKU : %@", orderDataModel.sku];
    quantityLabel.text = [NSString stringWithFormat:@"QUANTITY : %@", orderDataModel.quantity];
    amountLabel.text = [NSString stringWithFormat:@"AMOUNT PAID : %@", orderDataModel.amountPaid];
   
    
}


@end
