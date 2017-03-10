//
//  BuildGiftCell.h
//  PipaBella
//
//  Created by Sumit on 06/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuildGiftModel.h"
@interface BuildGiftCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightSeparator;
@property (weak, nonatomic) IBOutlet UILabel *bottomSeparator;
@property (weak, nonatomic) IBOutlet UIButton *addToWishlistButton;
@property (weak, nonatomic) IBOutlet UILabel *soldoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectionLbl;
-(void)layoutView : (CGRect )rect index:(int)index;
-(void)displayData:(BuildGiftModel *)productDataModel;
@end
