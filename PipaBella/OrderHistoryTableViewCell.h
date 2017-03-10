//
//  OrderHistoryTableViewCell.h
//  PipaBella
//
//  Created by Ranosys on 09/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderHistoryModel.h"
@interface OrderHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *shipToLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTotal;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *returnOrderButton;
@property (weak, nonatomic) IBOutlet UITextView *orderId;
@property (weak, nonatomic) IBOutlet UIButton *trackOrderBtn;


-(void)layoutView : (CGRect )rect index:(int)index;

-(void)displayData:(OrderHistoryModel*)orderHistoryData;

@end
