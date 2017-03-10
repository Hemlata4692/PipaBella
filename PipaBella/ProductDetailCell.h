//
//  ProductDetailCell.h
//  PipaBella
//
//  Created by Rohit Kumar Modi on 26/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *downArrow;

-(void)layouutView :(CGRect)rect;
@end
