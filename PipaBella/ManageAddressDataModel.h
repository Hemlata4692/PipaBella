//
//  ManageAddressDataModel.h
//  PipaBella
//
//  Created by Ranosys on 10/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManageAddressDataModel : NSObject

@property(nonatomic,retain)NSString * customerAddressId;
@property(nonatomic,retain)NSString * city;
@property(nonatomic,retain)NSString * countryId;
@property(nonatomic,retain)NSString * firstname;
@property(nonatomic,retain)NSString * lastname;
@property(nonatomic,retain)NSString * postcode;
@property(nonatomic,retain)NSString * street;
@property(nonatomic,retain)NSString * telephone;
@property(nonatomic,retain)NSString * isDefaultBilling;
@property(nonatomic,retain)NSString * isDefaultShipping;
@property(nonatomic,retain)NSString * regionId;
@property(nonatomic,retain)NSString * regionCode;
@property(nonatomic,retain)NSString * stateName;
@property(nonatomic,retain)NSString * message;
@property(nonatomic,retain)NSString * countryName;

@property(nonatomic,assign)int checkSelectionState;

@end
