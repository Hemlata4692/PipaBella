//
//  ReturnOrderTableViewCell.h
//  PipaBella
//
//  Created by Ranosys on 07/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReturnOrderModel.h"

@interface ReturnOrderTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *skuNumber;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;


-(void)displayData:(ReturnOrderModel*)returnOrderData;
@end
