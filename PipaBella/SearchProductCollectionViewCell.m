//
//  SearchProductCollectionViewCell.m
//  PipaBella
//
//  Created by Ranosys on 23/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "SearchProductCollectionViewCell.h"
#import "CurrencyConverter.h"
@implementation SearchProductCollectionViewCell
@synthesize productImageView,productNameLabel,productPriceLabel,rightSeparator,bottomSeparator,addToWishlistButton,addToWishlistLoader,soldoutLabel,addToWaitlistBtn;


#pragma mark - Setframes of objects

-(void)layoutView : (CGRect )rect index:(int)index
{
    
    self.rightSeparator.translatesAutoresizingMaskIntoConstraints=YES;
    self.bottomSeparator.translatesAutoresizingMaskIntoConstraints=YES;
    self.rightSeparator.frame =CGRectMake(rect.size.width-1, 9, 1, rect.size.height-19);
    
    if (index%2 == 0)
    {
        self.rightSeparator.hidden = NO;
        self.bottomSeparator.frame =CGRectMake(10, rect.size.height-1, rect.size.width-10, 1);
    }
    else
    {
        self.rightSeparator.hidden = YES;
        self.bottomSeparator.frame =CGRectMake(0, rect.size.height-1, rect.size.width-10, 1);
    }
}

-(void)displayData:(SearchProductModel*)searchProductDataModel{
    
    if (searchProductDataModel.isAddedToWishlist)
    {
        [addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_selected_full.png"] forState:UIControlStateNormal];
    }
    else
    {
        [addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_full.png"] forState:UIControlStateNormal];
    }
    if ([searchProductDataModel.isInStock boolValue])
    {
        addToWaitlistBtn.hidden = YES;
        addToWishlistButton.hidden = NO;
    }
    else
    {
        addToWishlistButton.hidden = YES;
        addToWaitlistBtn.hidden = NO;
    }
    searchProductDataModel.productName = [searchProductDataModel.productName lowercaseString];
    searchProductDataModel.productName = [searchProductDataModel.productName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[searchProductDataModel.productName substringToIndex:1] uppercaseString]];
    productNameLabel.text = [NSString stringWithFormat:@"%@",searchProductDataModel.productName];
    productPriceLabel.text = [CurrencyConverter converCurrency:searchProductDataModel.productPrice];
    [productImageView sd_setImageWithURL:[NSURL URLWithString:searchProductDataModel.productImage] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
}

#pragma mark - end

@end
