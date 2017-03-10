//
//  UITextField+Border.m
//  PipaBella
//
//  Created by Ranosys on 21/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "UITextField+Border.h"

@implementation UITextField (Border)
-(void)addBorder: (UITextField *)textfield
{
    textfield.layer.borderColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0].CGColor;
    textfield.layer.borderWidth = 1.5f;
    
//    UIView *leftBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, textfield.frame.size.height)];
//    leftBorder.backgroundColor = [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0f];
//    
//    UIView *topBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textfield.frame.size.width, 1)];
//    topBorder.backgroundColor = [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0f];
//
//    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, textfield.frame.size.height - 1.0f, textfield.frame.size.width, 1)];
//    bottomBorder.backgroundColor = [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0f];
//    
//    UIView *rightBorder = [[UIView alloc] initWithFrame:CGRectMake(textfield.frame.size.width-1.0f, 0, 1, textfield.frame.size.height)];
//    rightBorder.backgroundColor = [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0f];
//    
//    [textfield addSubview:leftBorder];
//    [textfield addSubview:topBorder];
//    [textfield addSubview:bottomBorder];
//    [textfield addSubview:rightBorder];
}


@end
