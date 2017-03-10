//
//  CurrencyDataModel.h
//  PipaBella
//
//  Created by Hema on 10/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrencyDataModel : NSObject

@property(nonatomic,retain)NSString * currencyCode;
@property(nonatomic,retain)NSString * currencySymbol;
@property(nonatomic,retain)NSString * currencyFlag;
@property(nonatomic,retain)NSString * convertingPrice;
@end
