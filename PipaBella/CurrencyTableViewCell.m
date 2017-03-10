//
//  CurrencyTableViewCell.m
//  PipaBella
//
//  Created by Ranosys on 20/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "CurrencyTableViewCell.h"


@implementation CurrencyTableViewCell
@synthesize countryFlagImageView,currencyNameLabel,radioButton,borderView;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    return self;
}

#pragma mark - Radiobutton action

-(void) checkRadio
{
    [radioButton setSelected:YES];
}

-(void) unCheckRadio
{
    [radioButton setSelected:NO];
}

-(void) radioButtonTouched :(NSString *)currencyCode
{
    if(radioButton.isSelected == YES)
    {
        
        return;
    }
    else
    {
        [UserDefaultManager setValue:currencyCode key:@"currencyCode"];
        //NSLog(@"Currency %@",[UserDefaultManager getValue:@"currencyCode"]);
        [self checkRadio];
        [_delegate myRadioCellDelegateDidCheckRadioButton:self];
    }
}

#pragma mark - end
#pragma mark - Data display of objects
-(void)displayData:(CurrencyDataModel*)currencyData
{
    currencyNameLabel.text = currencyData.currencyCode;
    [countryFlagImageView sd_setImageWithURL:[NSURL URLWithString:currencyData.currencyFlag] placeholderImage:[UIImage imageNamed:@""]];
  
    
}
#pragma mark - end

@end
