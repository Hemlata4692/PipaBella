//
//  ReturnOrderTwoViewController.h
//  PipaBella
//
//  Created by Ranosys on 06/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReturnOrderTwoViewController : GlobalViewController
@property(nonatomic,retain)NSString * orderIdData;
@property(nonatomic,retain)NSString * policyString;
@property(nonatomic,retain)NSString * addressString;
@property(nonatomic,retain)NSMutableArray * packingArray;
@property(nonatomic,retain)NSMutableArray * reasonArray;
@property(nonatomic,retain)NSMutableArray * typeArray;
@property(nonatomic,retain)NSMutableDictionary * pickerDataDictionary;
@property(nonatomic,retain)NSMutableDictionary * itemDetailDataDictionary;
@end
