//
//  WishlistCollectionViewCell.h
//  PipaBella
//
//  Created by Ranosys on 03/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WishlistCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightSeparator;
@property (weak, nonatomic) IBOutlet UILabel *bottomSeparator;
@property (weak, nonatomic) IBOutlet UIButton *removeFromWishlistButton;
@property (weak, nonatomic) IBOutlet UIButton *moveToCartButton;

-(void)layoutView : (CGRect )rect index:(int)index;
-(void)displayData : (NSMutableDictionary *)dataDict;
@end
