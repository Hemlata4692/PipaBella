//
//  BuildGiftCell.m
//  PipaBella
//
//  Created by Sumit on 06/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "BuildGiftCell.h"
#import "CurrencyConverter.h"
@implementation BuildGiftCell
@synthesize productImageView,productNameLabel,productPriceLabel,rightSeparator,bottomSeparator,addToWishlistButton,soldoutLabel,selectionLbl;


-(void)layoutView : (CGRect )rect index:(int)index
{
    
    //self.rightSeparator.translatesAutoresizingMaskIntoConstraints=YES;
    self.bottomSeparator.translatesAutoresizingMaskIntoConstraints=YES;
    //self.rightSeparator.frame =CGRectMake(rect.size.width-1, self.rightSeparator.frame.origin.y, 1, rect.size.height-23);
    if (index%2 == 0)
    {
        self.rightSeparator.hidden = NO;
        self.bottomSeparator.frame =CGRectMake(20, rect.size.height-1, self.frame.size.width-20, 1);
    }
    else
    {
        self.rightSeparator.hidden = YES;
        self.bottomSeparator.frame =CGRectMake(0, rect.size.height-1, self.frame.size.width-20, 1);
    }
}
-(void)displayData:(BuildGiftModel *)productDataModel
{
    if ([[productDataModel.giftDict objectForKey:@"isWishlist"] isEqualToString:@"Yes"])
    {
        [addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_selected_full.png"] forState:UIControlStateNormal];
    }
    else
    {
        [addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_full.png"] forState:UIControlStateNormal];
    }
   
    NSString * productNameStr = [productDataModel.giftDict objectForKey:@"name"];
    
    productNameStr = [productNameStr lowercaseString];
    productNameStr = [productNameStr stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[productNameStr substringToIndex:1] uppercaseString]];
    productNameLabel.text = [NSString stringWithFormat:@"%@",productNameStr];
    productPriceLabel.text = [CurrencyConverter converCurrency:[productDataModel.giftDict objectForKey:@"price"]];
    [productImageView sd_setImageWithURL:[NSURL URLWithString:[productDataModel.giftDict objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    if ([[productDataModel.giftDict objectForKey:@"isSelected"]isEqualToString:@"Yes"])
    {
        
        selectionLbl.hidden = NO;
    }
    else
    {
        selectionLbl.hidden = YES;
    }
    
}
@end
