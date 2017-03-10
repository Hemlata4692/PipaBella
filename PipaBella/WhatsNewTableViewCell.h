//
//  WhatsNewTableViewCell.h
//  PipaBella
//
//  Created by Ranosys on 19/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverDataModel.h"

@interface WhatsNewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property(nonatomic,strong) NSString *productId;
@property(nonatomic,strong) NSString *type;

-(void)displayData:(DiscoverDataModel*)categoryData;
@end
