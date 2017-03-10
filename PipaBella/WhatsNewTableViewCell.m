//
//  WhatsNewTableViewCell.m
//  PipaBella
//
//  Created by Ranosys on 19/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "WhatsNewTableViewCell.h"


@implementation WhatsNewTableViewCell
@synthesize bannerImageView,categoryLabel,type,productId;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Data display of objects
-(void)displayData:(DiscoverDataModel*)categoryData
{
    
    bannerImageView.contentMode = UIViewContentModeScaleAspectFit;
    categoryLabel.text = [categoryData.title uppercaseString];
    //[bannerImageView sd_setImageWithURL:[NSURL URLWithString:categoryData.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    [bannerImageView setImageWithURL:[NSURL URLWithString:categoryData.imageUrl]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
    {
        bannerImageView.contentMode = UIViewContentModeScaleToFill;
        bannerImageView.clipsToBounds = NO;
        bannerImageView.autoresizingMask =
        ( UIViewAutoresizingFlexibleBottomMargin
         | UIViewAutoresizingFlexibleHeight
         | UIViewAutoresizingFlexibleLeftMargin
         | UIViewAutoresizingFlexibleRightMargin
         | UIViewAutoresizingFlexibleTopMargin
         | UIViewAutoresizingFlexibleWidth );

                          }];
    productId=categoryData.productId;
    
}
#pragma mark - end


@end
