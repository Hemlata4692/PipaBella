//
//  ItemCollectionViewCell.h
//  PipaBella
//
//  Created by Ranosys on 13/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"

@interface ItemCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;


-(void)layoutView : (CGSize )rect index:(int)index;
-(void)displayData:(OrderDetailModel*)orderDataModel;
@end
