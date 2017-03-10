//
//  WaitlistCollectionViewCell.h
//  PipaBella
//
//  Created by Monika on 2/4/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButton.h"
#import "ProductListingDataModel.h"

@interface WaitlistCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightSeparator;
@property (weak, nonatomic) IBOutlet UILabel *bottomSeparator;
@property (weak, nonatomic) IBOutlet MyButton *addToWishlistButton;
-(void)layoutView : (CGRect )rect index:(int)index;
-(void)displayData:(ProductListingDataModel*)productDataModel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *addToWishlistLoader;

@end
