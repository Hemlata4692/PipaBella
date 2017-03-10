//
//  UIButton+ButtonBorder.h
//  PipaBella
//
//  Created by Hema on 28/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ButtonBorder)

-(void)addBorder: (UIButton *)button;

-(void)addBorder: (UIButton *)button color:(UIColor *)color;

-(void)addShadow: (UIButton *)button color:(UIColor *)color radius:(int)radius;
@end
