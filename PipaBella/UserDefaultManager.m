//
//  UserDefaultManager.m
//  Digibi_ecommerce
//
//  Created by Sumit on 08/09/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import "UserDefaultManager.h"
#import "ProductListingDataModel.h"
#import "BuildGiftModel.h"
@implementation UserDefaultManager
#pragma mark - User default methods
+(void)setValue : (id)value key :(NSString *)key
{

    [[NSUserDefaults standardUserDefaults]setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];

}

+(id)getValue : (NSString *)key
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:key];
}

+(void)removeValue : (NSString *)key
{

    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];

}
#pragma mark - end

#pragma mark - Wishlist comparision method
+(NSMutableArray *)wishListcomparision:(NSMutableArray *)productArray;
{
    NSMutableArray *wishlistArray = [UserDefaultManager getValue:@"wishListData"];
    
    for (int i =0; i<productArray.count; i++)
    {
        ProductListingDataModel * productModel = [productArray objectAtIndex:i];
        if (wishlistArray.count>0)
        {
            for (int j =0; j<wishlistArray.count; j++)
            {
                NSMutableDictionary *wishListDict = [wishlistArray objectAtIndex:j];
                if ([productModel.productId isEqualToString:[wishListDict objectForKey:@"product_id"]])
                {
                    productModel.isAddedToWishlist = true;
                    [productArray replaceObjectAtIndex:i withObject:productModel];
                    break;
                }
                else
                {
                    productModel.isAddedToWishlist = false;
                    [productArray replaceObjectAtIndex:i withObject:productModel];
                }
            }
        }
        else
        {
            productModel.isAddedToWishlist = false;
            [productArray replaceObjectAtIndex:i withObject:productModel];
        }
        
    }
    return productArray;
}
#pragma mark - end
#pragma mark - Wishlist comparision method for gift module
+(NSMutableArray *)wishListcomparisionForGiftModule:(NSMutableArray *)productArray;
{
    NSMutableArray *wishlistArray = [UserDefaultManager getValue:@"wishListData"];
    
    for (int i =0; i<productArray.count-1; i++)
    {
        BuildGiftModel * giftModel = [productArray objectAtIndex:i];
        if (wishlistArray.count>0)
        {
            for (int j =0; j<wishlistArray.count; j++)
            {
                NSMutableDictionary *wishListDict = [wishlistArray objectAtIndex:j];
                if ([[giftModel.giftDict objectForKey:@"id"] isEqualToString:[wishListDict objectForKey:@"product_id"]])
                {
                    [giftModel.giftDict setObject:@"Yes" forKey:@"isWishlist"];
                    [productArray replaceObjectAtIndex:i withObject:giftModel];
                    break;
                }
                else
                {
                    [giftModel.giftDict setObject:@"No" forKey:@"isWishlist"];
                    [productArray replaceObjectAtIndex:i withObject:giftModel];
                }
            }
        }
        else
        {
            [giftModel.giftDict setObject:@"No" forKey:@"isWishlist"];
            [productArray replaceObjectAtIndex:i withObject:giftModel];
        }
        
    }
    return productArray;
}
#pragma mark - end

@end
