//
//  ProductDetailCell.m
//  PipaBella
//
//  Created by Rohit Kumar Modi on 26/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "ProductDetailCell.h"

@implementation ProductDetailCell
@synthesize titleLabel;
@synthesize detailLabel;
@synthesize borderView;
@synthesize downArrow;
- (void)awakeFromNib {
    // Initialization code
}
-(void)layouutView :(CGRect)rect
{

    self.borderView.translatesAutoresizingMaskIntoConstraints = YES;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.detailLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.downArrow.translatesAutoresizingMaskIntoConstraints = YES;
    self.borderView.frame = CGRectMake(self.borderView.frame.origin.x, self.borderView.frame.origin.y, rect.size.width, self.borderView.frame.size.height);
    self.detailLabel.frame = CGRectMake(self.detailLabel.frame.origin.x, self.detailLabel.frame.origin.y, self.borderView.frame.size.width-30, self.detailLabel.frame.size.height);
    self.downArrow.frame = CGRectMake(borderView.frame.size.width-35, self.downArrow.frame.origin.y, self.downArrow.frame.size.width, self.downArrow.frame.size.height);
    [self.contentView sendSubviewToBack:self.borderView];
    UIColor *color = [UIColor colorWithRed:201.0/255.0 green:201.0/255.0 blue:201.0/255.0 alpha:1.0];
    self.borderView.layer.shadowColor = [color CGColor];
    self.borderView.layer.shadowRadius = 2.0f;
    self.borderView.layer.shadowOpacity = 1;
    self.borderView.layer.shadowOffset = CGSizeZero;
    self.borderView.layer.masksToBounds = NO;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
