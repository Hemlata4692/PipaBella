//
//  WaitlistCollectionViewCell.m
//  PipaBella
//
//  Created by Monika on 2/4/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "WaitlistCollectionViewCell.h"
#import "CurrencyConverter.h"

@implementation WaitlistCollectionViewCell
@synthesize productImageView,productNameLabel,productPriceLabel,rightSeparator,bottomSeparator,addToWishlistButton;
#pragma mark - Setframes of objects

-(void)layoutView : (CGRect )rect index:(int)index
{
    
    self.rightSeparator.translatesAutoresizingMaskIntoConstraints=YES;
    self.bottomSeparator.translatesAutoresizingMaskIntoConstraints=YES;
    self.rightSeparator.frame =CGRectMake(rect.size.width-1, 10, 1, rect.size.height-35);
//    [self.contentView bringSubviewToFront:addToWaitlistBtn];
    if (index%2 == 0)
    {
        self.rightSeparator.hidden = NO;
        self.bottomSeparator.frame =CGRectMake(10, rect.size.height-10, rect.size.width-10, 1);
    }
    else
    {
        self.rightSeparator.hidden = YES;
        self.bottomSeparator.frame =CGRectMake(0, rect.size.height-10, rect.size.width-10, 1);
    }
}

-(void)displayData:(ProductListingDataModel*)productDataModel
{
    
    if (productDataModel.isAddedToWishlist)
    {
        [addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_selected_full.png"] forState:UIControlStateNormal];
    }
    else
    {
        [addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_full.png"] forState:UIControlStateNormal];
    }
   
        addToWishlistButton.hidden = YES;
   
    productDataModel.productName = [productDataModel.productName lowercaseString];
    productDataModel.productName = [productDataModel.productName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[productDataModel.productName substringToIndex:1] uppercaseString]];
    productNameLabel.text = [NSString stringWithFormat:@"%@",productDataModel.productName];
    productPriceLabel.text = [CurrencyConverter converCurrency:productDataModel.productPrice];
    [productImageView sd_setImageWithURL:[NSURL URLWithString:productDataModel.productImage] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
}

#pragma mark - end

@end
