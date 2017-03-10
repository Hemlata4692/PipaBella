//
//  ReturnOrderThreeViewController.h
//  PipaBella
//
//  Created by Ranosys on 06/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReturnOrderThreeViewController : GlobalViewController
@property(nonatomic,retain)NSString * addressStringText;
@property(nonatomic,retain)NSString * additionalInfo;
@property(nonatomic,assign)int reasonId;
@property(nonatomic,assign)int typeId;
@property(nonatomic,assign)int packingId;
@property(nonatomic,retain)NSString * orderIdData;
@property(nonatomic,retain)NSMutableDictionary * itemDetailDataDictionary;





@property (strong, nonatomic)NSString *address;


@end
