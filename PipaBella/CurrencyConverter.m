//
//  CurrencyConverter.m
//  PipaBella
//
//  Created by Sumit on 15/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "CurrencyConverter.h"

@implementation CurrencyConverter


+(NSString *)converCurrency : (NSString *)price
{
    
    NSMutableDictionary * currencyDict = [UserDefaultManager getValue:@"selectedCurrency"];
    NSString *convertedPrice;
    if (currencyDict!=nil)
    {
        double newPrice = [[currencyDict objectForKey:@"price"]doubleValue]* [price doubleValue];
        //NSLog(@"newPrice is %f",newPrice);
        convertedPrice = [NSString stringWithFormat:@"%@ %.2f",[currencyDict objectForKey:@"symbol"],newPrice];
        return convertedPrice;
        
    }
    else
    {
        return price;
    
    }
   
    
    


}
@end
