//
//  HomeCollectionViewCell.m
//  PipaBella
//
//  Created by Ranosys on 17/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "CurrencyConverter.h"
@implementation HomeCollectionViewCell
@synthesize productImageView,productNameLabel,productPriceLabel,rightSeparator,bottomSeparator,addToWishlistButton,addToWishlistLoader,soldoutLabel,addToWaitlistBtn;


#pragma mark - Setframes of objects

-(void)layoutView : (CGRect )rect index:(int)index
{
    
    //self.rightSeparator.translatesAutoresizingMaskIntoConstraints=YES;
    self.bottomSeparator.translatesAutoresizingMaskIntoConstraints=YES;
    self.rightSeparator.frame =CGRectMake(rect.size.width-1, self.rightSeparator.frame.origin.y, 1, rect.size.height-30);
    if (index%2 == 0)
    {
        self.rightSeparator.hidden = NO;
        self.bottomSeparator.frame =CGRectMake(20, rect.size.height-1, rect.size.width+10, 1);
    }
    else
    {
        self.rightSeparator.hidden = YES;
        self.bottomSeparator.frame =CGRectMake(0, rect.size.height-1, rect.size.width, 1);
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
    if ([productDataModel.isInStock boolValue])
    {
        addToWaitlistBtn.hidden = YES;
        addToWishlistButton.hidden = NO;
    }
    else
    {
        addToWishlistButton.hidden = YES;
        addToWaitlistBtn.hidden = NO;
    }
    
    productDataModel.productName = [productDataModel.productName lowercaseString];
    productDataModel.productName = [productDataModel.productName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[productDataModel.productName substringToIndex:1] uppercaseString]];
    
    productNameLabel.text = [NSString stringWithFormat:@"%@",productDataModel.productName];
    productPriceLabel.text = [CurrencyConverter converCurrency:productDataModel.productPrice];
    [productImageView sd_setImageWithURL:[NSURL URLWithString:productDataModel.productImage] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
}

-(void)displayRestockedData:(ProductListingDataModel*)productDataModel
{
    if (productDataModel.isAddedToWishlist)
    {
        [addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_selected_full.png"] forState:UIControlStateNormal];
    }
    else
    {
        [addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_full.png"] forState:UIControlStateNormal];
    }
    if ([productDataModel.isInStock boolValue])
    {
        addToWaitlistBtn.hidden = YES;
        addToWishlistButton.hidden = NO;
    }
    else
    {
        addToWishlistButton.hidden = YES;
        addToWaitlistBtn.hidden = NO;
    }
    productDataModel.productName = [productDataModel.productName lowercaseString];
    productDataModel.productName = [productDataModel.productName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[productDataModel.productName substringToIndex:1] uppercaseString]];
    productNameLabel.text = [NSString stringWithFormat:@"%@",productDataModel.productName];
    productPriceLabel.text = [CurrencyConverter converCurrency:productDataModel.productPrice];
    [productImageView sd_setImageWithURL:[NSURL URLWithString:productDataModel.productImage] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}

#pragma mark - end


@end
