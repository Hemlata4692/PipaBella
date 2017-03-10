//
//  CartTableViewCell.m
//  PipaBella
//
//  Created by Ranosys on 06/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "CartTableViewCell.h"

@implementation CartTableViewCell
@synthesize productContainerView,productImage,productName,priceLabel,closeButton,decButton,quantitylabel,incButton,addGiftMessageButton,paymentContainerView,productNameLabel,productPriceLabel,amountContainerView,cartImage,totalPayableLabel,amountLabel,cartBtn,cellBg,editIcon,personalizeLbl;


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)layoutView1 :(CGRect)rect
{
    self.productContainerView.translatesAutoresizingMaskIntoConstraints = YES;
    self.productImage.translatesAutoresizingMaskIntoConstraints = YES;
    self.productName.translatesAutoresizingMaskIntoConstraints = YES;
    self.priceLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.closeButton.translatesAutoresizingMaskIntoConstraints = YES;
    self.decButton.translatesAutoresizingMaskIntoConstraints = YES;
    self.quantitylabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.incButton.translatesAutoresizingMaskIntoConstraints = YES;
    self.personalizeLbl.translatesAutoresizingMaskIntoConstraints = YES;
    
    self.productContainerView.frame = CGRectMake(0, self.productContainerView.frame.origin.y, rect.size.width, rect.size.height);
//    self.productContainerView.layer.borderColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0].CGColor;
//    self.productContainerView.layer.borderWidth = 1.0f;
    
    self.productImage.frame = CGRectMake(self.productImage.frame.origin.x, self.productImage.frame.origin.y, self.productImage.frame.size.width, self.productImage.frame.size.height);
    
    self.productName.frame = CGRectMake(self.productName.frame.origin.x, self.productName.frame.origin.y, self.productContainerView.frame.size.width - 100, self.productName.frame.size.height);
    self.personalizeLbl.frame = CGRectMake(self.personalizeLbl.frame.origin.x, self.personalizeLbl.frame.origin.y, self.productContainerView.frame.size.width - 220, self.personalizeLbl.frame.size.height);
    //self.personalizeLbl.backgroundColor = [UIColor redColor];
    
    self.priceLabel.frame = CGRectMake(self.priceLabel.frame.origin.x, self.priceLabel.frame.origin.y, self.priceLabel.frame.size.width, self.priceLabel.frame.size.height);
    
    self.closeButton.frame = CGRectMake(rect.size.width-20, self.closeButton.frame.origin.y, self.closeButton.frame.size.width, self.closeButton.frame.size.height);
    
    self.decButton.layer.borderColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0].CGColor;
    self.decButton.layer.borderWidth = 1.0f;
    
    self.quantitylabel.layer.borderColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0].CGColor;
    self.quantitylabel.layer.borderWidth = 1.0f;
    
    self.incButton.layer.borderColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0].CGColor;
    self.incButton.layer.borderWidth = 1.0f;
    
    
    self.decButton.frame = CGRectMake(rect.size.width-106, self.decButton.frame.origin.y, self.decButton.frame.size.width, self.decButton.frame.size.height);
    
    self.quantitylabel.frame = CGRectMake(rect.size.width-79, self.quantitylabel.frame.origin.y, self.quantitylabel.frame.size.width, self.quantitylabel.frame.size.height);
    
    self.incButton.frame = CGRectMake(rect.size.width-52, self.incButton.frame.origin.y, self.incButton.frame.size.width, self.incButton.frame.size.height);
}

-(void)layoutView2 :(CGRect)rect
{
    //self.addGiftMessageButton.translatesAutoresizingMaskIntoConstraints = YES;
    
    self.addGiftMessageButton.layer.borderColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0].CGColor;
    self.addGiftMessageButton.layer.borderWidth = 1.5f;
    cellBg.layer.borderColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0].CGColor;
    cellBg.layer.borderWidth = 1.5f;
//    self.editGiftMessageButton.layer.borderColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0].CGColor;
//    self.editGiftMessageButton.layer.borderWidth = 1.5f;
//
//    if ([self.addGiftMessageButton isSelected])
//    {
//        
//    }
    
    //self.addGiftMessageButton.frame = CGRectMake(self.addGiftMessageButton.frame.origin.x, self.addGiftMessageButton.frame.origin.y, self.addGiftMessageButton.frame.size.width, self.addGiftMessageButton.frame.size.height);
    
}

-(void)layoutView3 :(CGRect)rect count:(int)count
{
    self.paymentContainerView.translatesAutoresizingMaskIntoConstraints = YES;
    self.productNameLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.productPriceLabel.translatesAutoresizingMaskIntoConstraints = YES;
    
    self.paymentContainerView.layer.borderColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0].CGColor;
    self.paymentContainerView.layer.borderWidth = 1.5f;
    self.paymentContainerView.frame = CGRectMake(8, self.paymentContainerView.frame.origin.y, rect.size.width-15, 20*(count+1)+30);
    
    self.productNameLabel.frame = CGRectMake(self.productNameLabel.frame.origin.x, self.productNameLabel.frame.origin.y, self.productNameLabel.frame.size.width, 0);
    self.productPriceLabel.frame = CGRectMake(self.paymentContainerView.frame.size.width-70, self.productPriceLabel.frame.origin.y, self.productPriceLabel.frame.size.width, self.productPriceLabel.frame.size.height);
}
//(self.productNameLabel.frame.size.height+10)*4
-(void)layoutView4 :(CGRect)rect
{
    self.amountContainerView.translatesAutoresizingMaskIntoConstraints = YES;
    self.cartImage.translatesAutoresizingMaskIntoConstraints = YES;
    self.totalPayableLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.amountLabel.translatesAutoresizingMaskIntoConstraints = YES;
    
    self.amountContainerView.layer.borderColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0].CGColor;
    self.amountContainerView.layer.borderWidth = 1.5f;
    //totalPayableLabel.backgroundColor = [UIColor redColor];
    self.amountContainerView.frame = CGRectMake(self.amountContainerView.frame.origin.x, self.amountContainerView.frame.origin.y, rect.size.width-80, self.amountContainerView.frame.size.height);
    self.totalPayableLabel.frame = CGRectMake(self.totalPayableLabel.frame.origin.x, self.totalPayableLabel.frame.origin.y, self.totalPayableLabel.frame.size.width, self.totalPayableLabel.frame.size.height);
    
    self.amountLabel.frame = CGRectMake(self.totalPayableLabel.frame.origin.x+self.totalPayableLabel.frame.size.width+40, self.amountLabel.frame.origin.y, self.amountContainerView.frame.size.width-140, self.amountLabel.frame.size.height);
    
    
}
@end
