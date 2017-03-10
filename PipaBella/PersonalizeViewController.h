//
//  PersonalizeViewController.h
//  PipaBella
//
//  Created by Sumit on 14/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetailViewController.h"
@interface PersonalizeViewController : UIViewController

@property(nonatomic,retain)NSMutableArray * personalizeArray;
@property(nonatomic,retain)ProductDetailViewController * objProductDetail;
@property(nonatomic,retain)NSString * productName;
@end
