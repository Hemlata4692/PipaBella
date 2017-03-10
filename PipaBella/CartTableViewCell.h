//
//  CartTableViewCell.h
//  PipaBella
//
//  Created by Ranosys on 06/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@interface CartTableViewCell : SWTableViewCell

//Product cell
@property (weak, nonatomic) IBOutlet UIView *productContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *decButton;
@property (weak, nonatomic) IBOutlet UILabel *quantitylabel;
@property (weak, nonatomic) IBOutlet UIButton *incButton;
@property (weak, nonatomic) IBOutlet UIImageView *editIcon;

//Gift cell
@property (weak, nonatomic) IBOutlet UIButton *addGiftMessageButton;
@property (strong, nonatomic) IBOutlet UIButton *editGiftMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelEditMessageBtn;

//Payment cell
@property (weak, nonatomic) IBOutlet UIView *paymentContainerView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;

//Total amount cell
@property (weak, nonatomic) IBOutlet UIView *amountContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *cartImage;
@property (weak, nonatomic) IBOutlet UILabel *totalPayableLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIButton *cartBtn;
@property (weak, nonatomic) IBOutlet UIView *cellBg;
@property (weak, nonatomic) IBOutlet UILabel *personalizeLbl;


-(void)layoutView1 :(CGRect)rect;
-(void)layoutView2 :(CGRect)rect;
-(void)layoutView3 :(CGRect)rect count:(int)count;
-(void)layoutView4 :(CGRect)rect;
@end
