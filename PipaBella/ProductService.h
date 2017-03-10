//
//  ProductService.h
//  PipaBella
//
//  Created by Ranosys on 18/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductService : NSObject
@property(nonatomic,retain)NSMutableDictionary *webserviceData;
//Singleton instance
+ (id)sharedManager;
//end


//Product listing
-(void)productListing:(NSString *)categoryId pageNumber:(NSString *)pageNumber color:(NSString *)color price:(NSString *)price whatsNew:(NSString *)whatsNew inStock:(NSString *)inStock success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Search product listing
-(void)searchProductListing:(NSString *)searchKeyword pageNumber:(NSString *)pageNumber color:(NSString *)color price:(NSString *)price whatsNew:(NSString *)whatsNew inStock:(NSString *)inStock success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Color listing
-(void)colorListing:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Add to wish list
-(void)addToWishlist:(NSString *)productId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Remove from wish list
-(void)removeFromWishlist:(NSString *)productId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Category listing service
-(void)getCategoryList:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//My wishlist service
-(void)getWishlist:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end
//Product detail service
-(void)productDetailService:(NSString *)productId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end
//Product image service
-(void)productImageService:(NSString *)productId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//add to cart service
-(void)addToCart:(NSString *)productId qty:(NSString *)qty success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Cart listing
-(void)cartListing:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Build gift service
-(void)buildGiftService:(NSString *)productId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end
//Build gift add to cart
-(void)buildGiftAddToCart:(NSString *)productId dataArray:(NSMutableArray *)dataArray success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end
//My add gift message service
-(void)addGiftMessage:(NSString *)giftMessage success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//My remove gift message service
-(void)removeGiftMessage:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end


//Add to waitlist
-(void)addTowaitList:(NSString *)productId name:(NSString *)name email:(NSString *)email success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//add to cart service for personalize
-(void)addToCartPersonalize:(NSString *)productId qty:(NSString *)qty dataArray:(NSMutableDictionary *)dataDict success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Size guideg
-(void)sizeGuide:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Remove from cart
-(void)removeFromCart:(NSString *)productId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end
//Update cart
-(void)shoppingCartProductUpdateRequestParam:(NSString *)quoteId productData:(NSMutableArray *)productData success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Waitlist
-(void)generalApiMyWaitListRequestParam:(NSString *)mailId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end
@end
