//
//  CurrencyTableViewCell.h
//  PipaBella
//
//  Created by Ranosys on 20/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButton.h"
#import "CurrencyDataModel.h"

@class CurrencyTableViewCell;
@protocol RadioCellDelegate <NSObject>
-(void) myRadioCellDelegateDidCheckRadioButton:(CurrencyTableViewCell *)checkedCell;
@end

@interface CurrencyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (weak, nonatomic) IBOutlet UIImageView *countryFlagImageView;
@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *radioButton;
-(void) unCheckRadio;
-(void) radioButtonTouched :(NSString *)currencyCode;
@property (nonatomic, weak) id <RadioCellDelegate> delegate;

-(void)displayData:(CurrencyDataModel*)currencyData;
@end
