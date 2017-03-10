//
//  ProductListCollectionViewCell.h
//  PipaBella
//
//  Created by Ranosys on 02/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductListingDataModel.h"
#import "MyButton.h"
@interface ProductListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *soldoutLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightSeparator;
@property (weak, nonatomic) IBOutlet UILabel *bottomSeparator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *addToWishlistLoader;
@property (weak, nonatomic) IBOutlet MyButton *addToWishlistButton;
@property (weak, nonatomic) IBOutlet UIButton *addToWaitlistBtn;
-(void)layoutView : (CGRect )rect index:(int)index;
-(void)displayData:(ProductListingDataModel*)productDataModel;
@end
