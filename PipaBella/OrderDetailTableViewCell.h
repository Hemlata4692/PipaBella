//
//  OrderDetailTableViewCell.h
//  PipaBella
//
//  Created by Ranosys on 10/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"
@interface OrderDetailTableViewCell : UITableViewCell

//Items cell
@property (weak, nonatomic) IBOutlet UIView *itemsContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemSubtotalLabel;

//Subtotal cell
@property (weak, nonatomic) IBOutlet UILabel *subtotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingLabel;
@property (weak, nonatomic) IBOutlet UILabel *vatLabel;
@property (weak, nonatomic) IBOutlet UILabel *grandTotalLabel;
@property (strong, nonatomic) IBOutlet UILabel *vatPerLabel;

//Points cell
@property (weak, nonatomic) IBOutlet UILabel *pointsGatheredLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsUsedLabel;

-(void)displayData:(OrderDetailModel*)orderDetailData;

-(void)displayData:(NSString *)subTotal shippingCharge:(NSString *)shippingCharge vatPercent:(NSString *)vatPercent vatAmount:(NSString *)vatAmount grandTotal:(NSString *)grandTotal;

-(void)displayData:(NSString *)pointsGathered pointUsed:(NSString *)pointUsed;
@end
