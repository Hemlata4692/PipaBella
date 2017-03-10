//
//  WishlistCollectionViewCell.m
//  PipaBella
//
//  Created by Ranosys on 03/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "WishlistCollectionViewCell.h"
#import "CurrencyConverter.h"

@implementation WishlistCollectionViewCell
@synthesize productImageView,productNameLabel,productPriceLabel,rightSeparator,bottomSeparator,moveToCartButton,removeFromWishlistButton;

#pragma mark - Setframes of objects

-(void)layoutView : (CGRect )rect index:(int)index
{
    
    self.rightSeparator.translatesAutoresizingMaskIntoConstraints=YES;
    self.bottomSeparator.translatesAutoresizingMaskIntoConstraints=YES;
    
    self.rightSeparator.frame =CGRectMake(rect.size.width-1, self.rightSeparator.frame.origin.y, 1, rect.size.height-30);
    
    if (index%2 == 0)
    {
        self.rightSeparator.hidden = NO;
        self.bottomSeparator.frame =CGRectMake(20, rect.size.height-1, rect.size.width-20, 1);
    }
    else{
        self.rightSeparator.hidden = YES;
        self.bottomSeparator.frame =CGRectMake(0, rect.size.height-1, rect.size.width-20, 1);
    }
}
-(void)displayData : (NSMutableDictionary *)dataDict
{
    productNameLabel.text = [dataDict objectForKey:@"name"];
    productPriceLabel.text =[CurrencyConverter converCurrency:[dataDict objectForKey:@"product_price"]];
    [productImageView sd_setImageWithURL:[NSURL URLWithString:[dataDict objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}
#pragma mark - end

@end
