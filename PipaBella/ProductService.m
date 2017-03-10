//
//  ProductService.m
//  PipaBella
//
//  Created by Ranosys on 18/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "ProductService.h"
#import "ProductXMLParser.h"
#import "ProductListingDataModel.h"
#import "BuildGiftModel.h"
#define kUrlProductListing                @"generalApiProductListingRequestParam"
#define kUrlSearchProductListing          @"generalApiProductSearchRequestParam"
#define kUrlAddToWishlist                 @"generalApiAddToWishlistRequestParam"
#define kUrlRemoveFromWishlist            @"generalApiRemoveFromWishlistRequestParam"
#define kUrlColorListing                  @"generalApiColorFilterRequestParam"
#define kUrlCategory                      @"generalApiCategoryListingRequestParam"
#define kUrlWishlist                      @"generalApiCustomerWishlistRequestParam"
#define kUrlProductDetail                 @"catalogProductInfoRequestParam"
#define kUrlProductImage                  @"catalogProductAttributeMediaListRequestParam"
#define kUrlAddToCart                     @"shoppingCartProductAddRequestParam"
#define kUrlCartList                      @"generalApiCustomcartInfoRequestParam"
#define kUrlBuildGift                     @"generalApiCustomProductDetailsRequestParam"
#define kUrlgiftMessage                   @"generalApiAddGiftMessageRequestParam"
#define kUrlRemoveMessage                 @"generalApiRemoveGiftMessageRequestParam"

#define kUrlWaitlist                      @"generalApiWaitListRequestParam"
#define kUrlsizeGuide                     @"generalApiSizeGuideRequestParam"
#define kUrlremoveFromCart                @"generalApiCustomproductRemoveRequestParam"
#define kUrlshoppingCartProductUpdateRequestParam       @"generalApiCustomproductUpdateRequestParam"
#define kUrlgeneralApiMyWaitListRequestParam            @"generalApiMyWaitListRequestParam"

@implementation ProductService
{
    
}
@synthesize webserviceData;
#pragma mark - Singleton instance
+ (id)sharedManager
{
    static ProductService *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      sharedMyManager = [[self alloc] init];
                  });
    return sharedMyManager;
}
- (id)init
{
    
    if (self = [super init])
    {
        webserviceData = [NSMutableDictionary new];
        
    }
    return self;
}
#pragma mark - end

#pragma mark - Product Listing

-(void)productListing:(NSString *)categoryId pageNumber:(NSString *)pageNumber color:(NSString *)color price:(NSString *)price whatsNew:(NSString *)whatsNew inStock:(NSString *)inStock success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [webserviceData removeAllObjects];
    myDelegate.methodName=@"generalApiProductListingRequestParam";
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"categoryId":categoryId,@"color":color,@"price":price,@"whatsNew":whatsNew,@"inStock":inStock,@"pageNumber":pageNumber,@"perPage":@"20",@"storeId":@""};
    
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlProductListing success:^(id data)
     {
         //Handle fault cases
         webserviceData = [[ProductXMLParser sharedManager]loadxmlByDataArray:data];
         if (webserviceData.count<1)
         {
             success(webserviceData);
             [myDelegate StopIndicator];
         }
         else
         {
             success(webserviceData);
         }
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
}

-(void)addTowaitList:(NSString *)productId name:(NSString *)name email:(NSString *)email success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [webserviceData removeAllObjects];
    myDelegate.methodName=@"generalApiWaitListRequestParam";
    NSString  *userId;
    if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
    {
        
        userId = @"";
    }
    else
    {
        userId = [UserDefaultManager getValue:@"customer_id"];
    
    }
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"email":email,@"fullname":name,@"customerId":userId,@"productId":productId,@"storeId":@""};
    
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlWaitlist success:^(id data)
     {
         //Handle fault cases
         webserviceData = [[ProductXMLParser sharedManager]loadxmlByData:data];
         if (webserviceData.count<1)
         {
             [myDelegate StopIndicator];
             success(webserviceData);
         }
         else
         {
             success(webserviceData);
         }
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }];

}

#pragma mark - end

#pragma mark - Search product Listing

-(void)searchProductListing:(NSString *)searchKeyword pageNumber:(NSString *)pageNumber color:(NSString *)color price:(NSString *)price whatsNew:(NSString *)whatsNew inStock:(NSString *)inStock success:(void (^)(id data))success failure:(void (^)(NSError *error))failure{
    
    [webserviceData removeAllObjects];
    myDelegate.methodName=@"generalApiProductSearchRequestParam";
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"search_keyword":searchKeyword,@"color":color,@"price":price,@"whatsNew":whatsNew,@"inStock":inStock,@"pageNumber":pageNumber,@"perPage":@"20",@"storeId":@""};
    
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlSearchProductListing success:^(id data)
     {
         //Handle fault cases
         webserviceData = [[ProductXMLParser sharedManager]loadxmlByDataArray:data];
         if (webserviceData.count<1)
         {
             
             [myDelegate StopIndicator];
         }
         else
         {
             success(webserviceData);
         }
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
}
#pragma mark - end


#pragma mark - Add to wish list
-(void)addToWishlist:(NSString *)productId success:(void (^)(id data))success failure:(void (^)(NSError *error))failur
{
    [webserviceData removeAllObjects];
    myDelegate.methodName=@"generalApiAddToWishlistRequestParam";
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"customer_id":[UserDefaultManager getValue:@"customer_id"],@"product_id":productId,@"store_id":@""};
    
     [Localytics tagEvent:@"Product added to wishlist" attributes:@{@"product_id" : productId}];
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlAddToWishlist success:^(id data)
     {
         //Handle fault cases
         
         webserviceData = [[ProductXMLParser sharedManager]loadxmlByData:data];
         NSLog(@"data for add to wishlist is ------------------------------- %@ and webserviceData is %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],webserviceData);
         if (webserviceData.count<1)
         {
             success(nil);
         }
         else
         {
             success(webserviceData);
         }
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
    
}
#pragma mark - end

#pragma mark - Remove from wish list
-(void)removeFromWishlist:(NSString *)productId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [webserviceData removeAllObjects];
    myDelegate.methodName=@"generalApiRemoveFromWishlistRequestParam";
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"customer_id":[UserDefaultManager getValue:@"customer_id"],@"product_id":productId};
    
    
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlRemoveFromWishlist success:^(id data)
     {
         //Handle fault cases
         webserviceData = [[ProductXMLParser sharedManager]loadxmlByData:data];
         if (webserviceData.count<1)
         {
             success(nil);
         }
         else
         {
             success(webserviceData);
         }
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
    
}
#pragma mark - end


#pragma mark - Color Listing

-(void)colorListing:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    
    [webserviceData removeAllObjects];
    myDelegate.methodName=@"generalApiColorFilterRequestParam";
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"storeId":@""};
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlColorListing success:^(id data)
     {
         //Handle fault cases
         [[ProductXMLParser sharedManager]loadxmlByData:data];
         success([[ProductXMLParser sharedManager]colorArray]);
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
}
#pragma mark - end
#pragma mark - Category listing service
-(void)getCategoryList:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    myDelegate.methodName = @"generalApiCategoryListingRequestParam";
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"]};
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlCategory success:^(id data)
     {
         //Handle fault cases
         NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"string is %@",string);
         [[ProductXMLParser sharedManager]loadxmlByData:data];
         success([[ProductXMLParser sharedManager]catArray]);
         
     }
                                       failure:^(NSError *error)
     {
         
     }] ;
    
}
#pragma mark - end

#pragma mark - My wishlist service
-(void)getWishlist:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
{
    myDelegate.methodName = @"generalApiCustomerWishlistRequestParam";
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"customer_id":[UserDefaultManager getValue:@"customer_id"]};
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlWishlist success:^(id data)
     {
         //Handle fault cases
         NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"string is %@",string);
         [[ProductXMLParser sharedManager]loadxmlByData:data];
         success(data);
         
     }
      failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }];
}
#pragma mark - end

#pragma mark- Product detail service
-(void)productDetailService:(NSString *)productId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    
    NSLog(@"push to remote");
    myDelegate.methodName = @"generalApiCustomProductDetailsRequestParam";
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"storeId":@"",@"productId":productId};
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlBuildGift success:^(id data)
     {
         //Handle fault cases
         [[ProductXMLParser sharedManager]loadxmlByData:data];
         success([[ProductXMLParser sharedManager] productDetailDict]);
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }];
}
-(void)sizeGuide:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    NSLog(@"push to remote");
    myDelegate.methodName = @"generalApiSizeGuideRequestParam";
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"]};
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlsizeGuide success:^(id data)
     {
         //Handle fault cases
         [[ProductXMLParser sharedManager]loadxmlByData:data];
         success([[ProductXMLParser sharedManager] sizeGuideArray]);
     }
      failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }];

}
//-(NSString *)getSoapForProductDetail :(NSString *)productId
//{
//    NSString *soapStr = [NSString stringWithFormat:@"<sessionId>%@</sessionId><productId>%@</productId><store>1</store><attributes><attributes><complexObjectArray>name</complexObjectArray><complexObjectArray>sku</complexObjectArray><complexObjectArray>description</complexObjectArray><complexObjectArray>price</complexObjectArray><complexObjectArray>color</complexObjectArray></attributes><additional_attributes><complexObjectArray>delivery</complexObjectArray></additional_attributes></attributes><identifierType>image_label</identifierType>",[UserDefaultManager getValue:@"sessionId"],productId];
//    return soapStr;
//}
-(void)productImageService:(NSString *)productId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    myDelegate.methodName = @"catalogProductAttributeMediaListRequestParam";
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"productId":productId,@"identifierType":@"",@"store":@""};
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlProductImage success:^(id data)
     {
         //Handle fault cases
         NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"string is %@",string);
         [[ProductXMLParser sharedManager]loadxmlByData:data];
         //         NSMutableArray *tmpAry = [[ProductXMLParser sharedManager]catArray];
         //         NSLog(@"tmpAry count is %lu",(unsigned long)tmpAry.count);
         success([[ProductXMLParser sharedManager]imageArary]);
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }];
}
#pragma mark - end
#pragma mark - Cart services
-(void)addToCart:(NSString *)productId qty:(NSString *)qty success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    NSLog(@"push to remote");
    NSString * soapStr;
    myDelegate.methodName = @"shoppingCartProductAddRequestParam";
    if (myDelegate.isBuildGift)
    {
        soapStr = [self getSoapForAddtoCartBuildGift:productId qty:qty];
        myDelegate.isBuildGift = false;
    }
    else
    {
        soapStr = [self getSoapForAddtoCart:productId qty:qty];
    }
     [Localytics tagEvent:@"Product added to cart" attributes:@{@"product_id" : productId}];
    [[Webservice sharedManager] fireWebserviceForArray:soapStr methodName:kUrlAddToCart success:^(id data)
     {
         //Handle fault cases
         NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"string is %@",string);
         [[ProductXMLParser sharedManager]loadxmlByData:data];
         success([[ProductXMLParser sharedManager] status]);
         
     }
         failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }];
    
}

-(NSString *)getSoapForAddtoCartBuildGift :(NSString *)productId qty:(NSString *)qty
{
    NSString *soapStr = [NSString stringWithFormat:@"<sessionId>%@</sessionId><quoteId>%@</quoteId><productsData><complexObjectArray><product_id>%@</product_id><sku></sku><qty>%@</qty><options><complexObjectArray><key></key><value></value></complexObjectArray></options>%@%@<links><complexObjectArray></complexObjectArray></links></complexObjectArray></productsData><store >1</store>",[UserDefaultManager getValue:@"sessionId"],[UserDefaultManager getValue:@"quoteId"],productId,qty,[UserDefaultManager getValue:@"buildGiftSoapOption"],[UserDefaultManager getValue:@"buildGiftSoapQty"]];
    return soapStr;
}

-(NSString *)getSoapForAddtoCart :(NSString *)productId qty:(NSString *)qty
{
    NSString *soapStr = [NSString stringWithFormat:@"<sessionId>%@</sessionId><quoteId>%@</quoteId><productsData><complexObjectArray><product_id>%@</product_id><sku></sku><qty>%@</qty><options><complexObjectArray><key></key><value></value></complexObjectArray></options><bundle_option/><bundle_option_qty/><links><complexObjectArray></complexObjectArray></links></complexObjectArray></productsData><store >1</store>",[UserDefaultManager getValue:@"sessionId"],[UserDefaultManager getValue:@"quoteId"],productId,qty];
    return soapStr;
}

-(void)addToCartPersonalize:(NSString *)productId qty:(NSString *)qty dataArray:(NSMutableDictionary *)dataDict success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{

    NSLog(@"push to remote");
    myDelegate.methodName = @"shoppingCartProductAddRequestParam";
     [Localytics tagEvent:@"Personalized product added to cart" attributes:@{@"product_id" : productId}];
    [[Webservice sharedManager] fireWebserviceForArray:[self getSoapForAddtoCartPersonalize:productId qty:qty dataArray:dataDict] methodName:kUrlAddToCart success:^(id data)
     {
         //Handle fault cases
         NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"string is %@",string);
         [[ProductXMLParser sharedManager]loadxmlByData:data];
         success([[ProductXMLParser sharedManager] status]);
         
     }
                                               failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }];



}
-(NSString *)getSoapForAddtoCartPersonalize :(NSString *)productId qty:(NSString *)qty dataArray:(NSMutableDictionary *)dataDict
{
//    [sendingDataDict setObject:@"" forKey:@"selectedRadioId"];
//    [sendingDataDict setObject:@"" forKey:@"RadioId"];
//    [sendingDataDict setObject:@"" forKey:@"fieldId"];
//    [sendingDataDict setObject:@"" forKey:@"fieldValue"];
    NSString *soapStr = [NSString stringWithFormat:@"<sessionId xmlns=\"\">%@</sessionId><quoteId xmlns=\"\">%@</quoteId><productsData xmlns=\"\"><complexObjectArray><product_id>%@</product_id><sku></sku><qty>%@</qty><options><complexObjectArray><key>%@</key><value>%@</value></complexObjectArray><complexObjectArray><key>%@</key><value>%@</value></complexObjectArray></options><bundle_option/><bundle_option_qty/><links><complexObjectArray>[string?]</complexObjectArray></links></complexObjectArray></productsData><store xmlns=\"\">1</store>",[UserDefaultManager getValue:@"sessionId"],[UserDefaultManager getValue:@"quoteId"],productId,qty,[dataDict objectForKey:@"fieldId"],[dataDict objectForKey:@"fieldValue"],[dataDict objectForKey:@"RadioId"],[dataDict objectForKey:@"selectedRadioId"]];
    return soapStr;
}

-(void)cartListing:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [webserviceData removeAllObjects];
    myDelegate.methodName=@"generalApiCustomcartInfoRequestParam";
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"storeId":@"1",@"quoteId":[UserDefaultManager getValue:@"quoteId"]};
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlCartList success:^(id data)
     {
         //Handle fault cases
         [[ProductXMLParser sharedManager]loadxmlByData:data];
         success(data);
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }];
    
    
}
-(void)removeFromCart:(NSString *)productId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [webserviceData removeAllObjects];
    myDelegate.methodName=@"generalApiCustomproductRemoveRequestParam";
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"storeId":@"1",@"quoteId":[UserDefaultManager getValue:@"quoteId"],@"itemId":productId};
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlremoveFromCart success:^(id data)
     {
         //Handle fault cases
         [[ProductXMLParser sharedManager]loadxmlByData:data];
         success([[ProductXMLParser sharedManager]status]);
         
     }
       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }];

}
-(NSString * )removeFromCartXmlForBuildGift :(NSString *)productId
{
    //    <bundle_option><complexObjectArray><key>38</key><value>483</value></complexObjectArray><complexObjectArray><key>39</key><value>767</value></complexObjectArray><complexObjectArray><key>44</key><value>784</value></complexObjectArray><complexObjectArray><key>45</key><value>552</value></complexObjectArray></bundle_option>
    NSLog(@"1st soap is %@ and 2nd soap is %@",[UserDefaultManager getValue:@"buildGiftSoapOption"],[UserDefaultManager getValue:@"buildGiftSoapQty"]);
    
    
    NSString *soapStr = [NSString stringWithFormat:@"<sessionId xmlns=\"\">%@</sessionId><quoteId xmlns=\"\">%@</quoteId><productsData xmlns=\"\"><complexObjectArray><product_id>%@</product_id><sku></sku><qty></qty><options><complexObjectArray><key></key><value></value></complexObjectArray></options>%@%@><links><complexObjectArray></complexObjectArray></links></complexObjectArray></productsData><store xmlns=\"\">1</store>",[UserDefaultManager getValue:@"sessionId"],[UserDefaultManager getValue:@"quoteId"],productId,[UserDefaultManager getValue:@"buildGiftSoapOption"],[UserDefaultManager getValue:@"buildGiftSoapQty"]];
    return soapStr;
    
}
-(NSString * )removeFromCartXml :(NSString *)productId
{
//    <bundle_option><complexObjectArray><key>38</key><value>483</value></complexObjectArray><complexObjectArray><key>39</key><value>767</value></complexObjectArray><complexObjectArray><key>44</key><value>784</value></complexObjectArray><complexObjectArray><key>45</key><value>552</value></complexObjectArray></bundle_option>
    
    
    
    NSString *soapStr = [NSString stringWithFormat:@"<sessionId xmlns=\"\">%@</sessionId><quoteId xmlns=\"\">%@</quoteId><productsData xmlns=\"\"><complexObjectArray><product_id>%@</product_id><sku></sku><qty></qty><options><complexObjectArray><key></key><value></value></complexObjectArray></options><bundle_option/><bundle_option_qty/><links><complexObjectArray></complexObjectArray></links></complexObjectArray></productsData><store xmlns=\"\">1</store>",[UserDefaultManager getValue:@"sessionId"],[UserDefaultManager getValue:@"quoteId"],productId];
    return soapStr;

}
#pragma mark - Update product from cart

-(NSDictionary *)createSoapForUpdateCart :(NSString *)quoteId productData:(NSMutableArray *)productData

{
    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    myDelegate.methodName = @"shoppingCartProductUpdateRequestParam";
    
    NSMutableArray* productDatas = [NSMutableArray new];
    for (int i = 0; i < productData.count; i++)
    {
        NSMutableDictionary * productDict =[productData objectAtIndex:i];
        NSDictionary *dataDic = @{@"complexObjectArray":
                                      @{@"product_id":[productDict objectForKey:@"product_id"], @"sku":[productDict objectForKey:@"sku"], @"qty":[productDict objectForKey:@"product_quantity"], @"options":
                                            @{@"complexObjectArray":
                                                  @{@"key":@"", @"value":@""}},
                                        @"links":
                                            @{@"complexObjectArray":@""},@"bundle_option":@"",@"bundle_option_qty":@""
                                        }
                                  };
        [productDatas addObject:dataDic];
    }
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":quoteId, @"productsData":
                                      productDatas
                                  ,@"store":@"1"
                                  };

    return parameters;

}
-(NSString *)getSoapForUpdateCart : (NSMutableArray *)productData quoteId :(NSString *)quoteId
{
    NSString *soapStr = [NSString stringWithFormat:@"<sessionId>%@</sessionId><quoteId>%@</quoteId><itemId>%@</itemId>",[UserDefaultManager getValue:@"sessionId"],quoteId,[self createSoapForCustomUpdateCart:productData]];
    return soapStr;

}
-(NSString *)createSoapForCustomUpdateCart : (NSMutableArray *)productData
{
    NSString  *updateCartXml = [[NSString alloc] init];
    
    for (int i=0; i<productData.count; i++)
    {
        NSMutableDictionary * productDict =[productData objectAtIndex:i];
        updateCartXml=[updateCartXml stringByAppendingString:[NSString stringWithFormat:@"<complexObjectArray>"]];
        updateCartXml=[updateCartXml stringByAppendingString:[NSString stringWithFormat:@"<key>%@</key>",[productDict objectForKey:@"item_id"]]];
        updateCartXml=[updateCartXml stringByAppendingString:[NSString stringWithFormat:@"<value>%@</value>",[productDict objectForKey:@"product_quantity"]]];
        updateCartXml=[updateCartXml stringByAppendingString:[NSString stringWithFormat:@"</complexObjectArray>"]];
    }
    NSLog(@"updateCartXml is %@",updateCartXml);
    return updateCartXml;
    
}

-(void)shoppingCartProductUpdateRequestParam:(NSString*)quoteId productData:(NSMutableArray*)productData success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    NSLog(@"push to remote");
    myDelegate.methodName = @"generalApiCustomproductUpdateRequestParam";
    [[Webservice sharedManager] fireWebserviceForArray:[self getSoapForUpdateCart:productData quoteId:quoteId] methodName:kUrlshoppingCartProductUpdateRequestParam success:^(id data)
     {
         //Handle fault cases
         NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"string is %@",string);
         [[ProductXMLParser sharedManager]loadxmlByData:data];
         success([[ProductXMLParser sharedManager] status]);
     }
                                               failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }];
}

#pragma mark - end
#pragma mark - end

#pragma mark - Build a gift service
-(void)buildGiftService:(NSString *)productId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    myDelegate.methodName = @"generalApiCustomProductDetailsRequestParam";
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"storeId":@"",@"productId":productId};
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlBuildGift success:^(id data)
     {
         //Handle fault cases
         [[ProductXMLParser sharedManager]loadxmlByData:data];
         success([[ProductXMLParser sharedManager] mainGiftArray]);
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }];
}

-(void)buildGiftAddToCart:(NSString *)productId dataArray:(NSMutableArray *)dataArray success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    NSLog(@"push to remote");
    myDelegate.methodName = @"shoppingCartProductAddRequestParam";
    [[Webservice sharedManager] fireWebserviceForArray:[self getSoapForBuildGiftAddtoCart:productId dataArray:dataArray] methodName:kUrlAddToCart success:^(id data)
     {
         //Handle fault cases
         NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"string is %@",string);
         [[ProductXMLParser sharedManager]loadxmlByData:data];
         success([[ProductXMLParser sharedManager] status]);
         
     }
                                               failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }];
    
}
-(NSString *)getSoapForBuildGiftAddtoCart :(NSString *)productId dataArray:(NSMutableArray *)dataArray
{
    NSString *soapStr = [NSString stringWithFormat:@"<sessionId>%@</sessionId><quoteId>%@</quoteId><productsData><complexObjectArray><product_id>%@</product_id><sku></sku><qty></qty><options><complexObjectArray><key></key><value></value></complexObjectArray></options>%@%@<links><complexObjectArray></complexObjectArray></links></complexObjectArray></productsData><store>1</store>",[UserDefaultManager getValue:@"sessionId"],[UserDefaultManager getValue:@"quoteId"],productId,[self getComplexObjectArrayForBuildGiftAddtoCart:@"bundle_option" dataArray:dataArray],[self getComplexObjectArrayForBuildGiftAddtoCart:@"bundle_option_qty" dataArray:dataArray]];
    NSLog(@"soapStr is %@",soapStr);
    return soapStr;
}
-(NSString *)getComplexObjectArrayForBuildGiftAddtoCart :(NSString *)tag dataArray:(NSMutableArray *)dataArray
{
    NSString * tagString=[[NSString alloc] init];
    tagString = [tagString stringByAppendingString:[NSString stringWithFormat:@"<%@>",tag]];
    for (int i= 0; i<dataArray.count; i++)
    {
        tagString = [tagString stringByAppendingString:[NSString stringWithFormat:@"<complexObjectArray>"]];
        NSMutableArray * tempArray = [dataArray objectAtIndex:i];
        for (int j=0; j<tempArray.count; j++)
        {
            NSMutableDictionary *model = [tempArray objectAtIndex:j];
            if ([tag isEqualToString:@"bundle_option"])
            {
                if (j==0)
                {
                    tagString = [tagString stringByAppendingString:[NSString stringWithFormat:@"<key>%@</key>",[model objectForKey:@"selection_id"]]];
                }
                tagString = [tagString stringByAppendingString:[NSString stringWithFormat:@"<value>%@</value>",[model objectForKey:@"product_option_id"]]];
            }
            else
            {
                tagString = [tagString stringByAppendingString:[NSString stringWithFormat:@"<key>%@</key>",[model objectForKey:@"product_option_id"]]];
                tagString = [tagString stringByAppendingString:[NSString stringWithFormat:@"<value>1</value>"]];
            }
            
        }
        tagString = [tagString stringByAppendingString:[NSString stringWithFormat:@"</complexObjectArray>"]];
    }
    tagString = [tagString stringByAppendingString:[NSString stringWithFormat:@"</%@>",tag]];
    NSLog(@"tagString is %@",tagString);
    
    if ([tag isEqualToString:@"bundle_option"])
    {
    
        [UserDefaultManager setValue:tagString key:@"buildGiftSoapOption"];
    
    }
    else
    {
        [UserDefaultManager setValue:tagString key:@"buildGiftSoapQty"];
    }
    
    
    return tagString;
}
-(void)addGiftMessage:(NSString *)giftMessage success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    
    [webserviceData removeAllObjects];
    myDelegate.methodName=@"generalApiAddGiftMessageRequestParam";
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"storeId":@"1",@"quoteId":[UserDefaultManager getValue:@"quoteId"],@"giftMessage":giftMessage};
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlgiftMessage success:^(id data)
     {
         //Handle fault cases
         [[ProductXMLParser sharedManager]loadxmlByData:data];
         success(data);
     }
     failure:^(NSError *error)
     {
         
     }];
    
}
#pragma mark - end
#pragma mark - remove gift message service
-(void)removeGiftMessage:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [webserviceData removeAllObjects];
    myDelegate.methodName=@"generalApiRemoveGiftMessageRequestParam";
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"quoteId":[UserDefaultManager getValue:@"quoteId"]};
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlRemoveMessage success:^(id data)
     {
         //Handle fault cases
         [[ProductXMLParser sharedManager]loadxmlByData:data];
         success(data);
     }
                                       failure:^(NSError *error)
     {
         
     }];

}
#pragma mark - end
#pragma mark - Waitlist
-(void)generalApiMyWaitListRequestParam:(NSString *)mailId success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [webserviceData removeAllObjects];
    myDelegate.methodName=@"generalApiMyWaitListRequestParam";
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"email":mailId};
    
      
    [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlgeneralApiMyWaitListRequestParam success:^(id data)
     {
         //Handle fault cases
         webserviceData = [[ProductXMLParser sharedManager]loadxmlByDataArray:data];
         if (webserviceData.count<1)
         {
             success(webserviceData);
             [myDelegate StopIndicator];
         }
         else
         {
             success(webserviceData);
         }
         
     }
                                       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;

}
#pragma mark - end

@end

