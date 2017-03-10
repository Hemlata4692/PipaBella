//
//  UIButton+ButtonBorder.m
//  PipaBella
//
//  Created by Hema on 28/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "UIButton+ButtonBorder.h"

@implementation UIButton (ButtonBorder)

-(void)addBorder: (UIButton *)button
{
    button.layer.borderColor = [UIColor colorWithRed:196.0/255.0 green:196.0/255.0 blue:196.0/255.0 alpha:1.0].CGColor;
    button.layer.borderWidth = 1.5f;
    
}


-(void)addBorder: (UIButton *)button color:(UIColor *)color
{
    button.layer.borderColor = color.CGColor;
    button.layer.borderWidth = 1.5f;
}

-(void)addShadow: (UIButton *)button color:(UIColor *)color radius:(int)radius
{
    button.layer.shadowColor=color.CGColor;
    button.layer.shadowOffset = CGSizeMake(3, 3);
    button.layer.shadowOpacity = 1;
    button.layer.shadowRadius = 1.0;
    [button.layer setCornerRadius:radius];
}
@end
