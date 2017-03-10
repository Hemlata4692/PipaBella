//
//  ProductXMLParser.m
//  PipaBella
//
//  Created by Ranosys on 18/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "ProductXMLParser.h"
#import "ProductListingDataModel.h"
#import "SearchProductModel.h"
#import "CategoryListingModel.h"
#import "SubCategoryModel.h"
#import "ColorModel.h"
#import "BuildGiftModel.h"
@implementation ProductXMLParser
{
    
    NSMutableArray *productListArray;
    ProductListingDataModel *productListData;
    SearchProductModel *searchProductListData;
    NSString *categoryImage;
    NSString *totalProducts;
    CategoryListingModel * catModel;
    SubCategoryModel *subCatModel;
    BuildGiftModel *buildGiftModel;
    ColorModel * objColorModel;
    NSMutableDictionary * colorDict;
    NSMutableArray * wishListArray;
    NSMutableDictionary *wishListDict;
    
    NSMutableDictionary * cartDict;
    NSMutableArray * cartArray;
    
    NSMutableDictionary * giftDict;
    NSString *position;
    
    NSString * productType;
    
    NSMutableDictionary *waitListDict;
    
    
    //data structure for personalize product.
    NSMutableArray * mainPersonalizeArray;
    NSMutableDictionary * personalizeTypeDict;
    NSMutableArray * additionalFiendsArray;
    NSMutableDictionary * additionalFiendsDict;
    //end
    NSMutableDictionary * sizeGuideDict;
    int depth;
    bool category_listing;
    
    
    
    bool isPrice;
    bool isSku;
    
}
@synthesize currentNodeContent;
@synthesize responseString,status;
@synthesize catArray;
@synthesize colorArray;
@synthesize dataDic;
@synthesize productDetailDict;
@synthesize imageArary;
@synthesize subGiftArray;
@synthesize mainGiftArray;
@synthesize sizeGuideArray;
//Shared instance init
+ (id)sharedManager
{
    static ProductXMLParser *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}
- (id)init
{
    if (self = [super init])
    {
        dataDic = [NSMutableDictionary new];
        
    }
    return self;
}
//end
-(id) loadxmlByData:(NSData *)data
{
    status=nil;
    depth = 0;
    isSku=false;
    isPrice=false;
    mainPersonalizeArray = [[NSMutableArray alloc]init];
    imageArary = [[NSMutableArray alloc]init];
    catArray = [[NSMutableArray alloc]init];
    wishListArray = [[NSMutableArray alloc]init];
    colorArray = [[NSMutableArray alloc]init];
    productDetailDict = [NSMutableDictionary new];
    cartArray = [[NSMutableArray alloc]init];
    
    mainGiftArray = [[NSMutableArray alloc]init];
    [dataDic removeAllObjects];
    parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    return dataDic;
}
-(id) loadxmlByDataArray:(NSData *)data
{
    status=nil;
    // [dataDic removeAllObjects];
    productListArray = [[NSMutableArray alloc]init];
    parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    
    return productListArray;
    
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //NSLog(@"currentNodeContent is ...............................%@",currentNodeContent);
    if (currentNodeContent==nil ||[currentNodeContent isEqualToString:@"(null)"]||[currentNodeContent isEqualToString:@"\n"]||[currentNodeContent isEqualToString:@""])
    {
        currentNodeContent = [[NSMutableString alloc] initWithString:string];
        
    }
    else
    {
        NSString *trimString= [currentNodeContent stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        currentNodeContent = [trimString mutableCopy];
        [currentNodeContent appendString:string];
    }
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([myDelegate.methodName isEqualToString: @"generalApiProductListingRequestParam"])
    {
        
        if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
            productListData=[[ProductListingDataModel alloc]init];
        }
        
    }
    else   if ([myDelegate.methodName isEqualToString: @"generalApiMyWaitListRequestParam"])
    {
        if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
            productListData=[[ProductListingDataModel alloc]init];
        }
    }
    else if ([myDelegate.methodName isEqualToString: @"generalApiCategoryListingRequestParam"])
    {
        if ([elementname isEqualToString:@"level1"])
        {
            depth = 0;
        }
        else if ([elementname isEqualToString:@"level2"])
        {
            
            depth++;
            
        }
        else if([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
            if (depth==0)
            {
                
                catModel = [[CategoryListingModel alloc]init];
                catModel.subCatArray = [[NSMutableArray alloc]init];
            }
            else if (depth==1)
            {
                subCatModel = [[SubCategoryModel alloc]init];
            }
        }
        else if ([elementname isEqualToString:@"category_listing"])
        {
            category_listing = true;
        }
        
    }
    else if ([myDelegate.methodName isEqualToString: @"generalApiColorFilterRequestParam"])
    {
        if([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
            colorDict =[NSMutableDictionary new];
            
        }
    }
    else if ([myDelegate.methodName isEqualToString: @"generalApiCustomerWishlistRequestParam"])
    {
        
        if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
            
            wishListDict = [NSMutableDictionary new];
            
            
        }
        
    }
    
    else if ([myDelegate.methodName isEqualToString: @"generalApiProductSearchRequestParam"])
    {
        
        if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
            searchProductListData=[[SearchProductModel alloc]init];
        }
        
    }
    else if ([myDelegate.methodName isEqualToString: @"catalogProductInfoRequestParam"])
    {
        
        
        
    }
    else if ([myDelegate.methodName isEqualToString: @"generalApiCustomcartInfoRequestParam"])
    {
        if ([elementname isEqualToString:@"raw_data"])
        {
            cartDict = [NSMutableDictionary new];
        }
        else if ([elementname isEqualToString:@"custom_options"])
        {
            depth =0;
        }
        
    }
    else if ([myDelegate.methodName isEqualToString: @"generalApiCustomProductDetailsRequestParam"])
    {
        if ([elementname isEqualToString:@"BOGUS"])
        {
            depth++;
            if (depth==1)
            {
                subGiftArray = [[NSMutableArray alloc]init];
                giftDict = [NSMutableDictionary new];
                personalizeTypeDict= [NSMutableDictionary new];
                
                
                
            }
            else if (depth==2)
            {
                buildGiftModel = [[BuildGiftModel alloc]init];
                buildGiftModel.giftDict = [NSMutableDictionary new];
                additionalFiendsDict= [NSMutableDictionary new];
                
            }
            
        }
        else if ([elementname isEqualToString:@"additional_fields"])
        {
            
                additionalFiendsArray = [[NSMutableArray alloc]init];
            
        }
        
        
    }
    else if ([myDelegate.methodName isEqualToString: @"generalApiSizeGuideRequestParam"])
    {
        if ([elementname isEqualToString:@"data"])
        {
            sizeGuideArray = [[NSMutableArray alloc]init];
        }
        else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
        sizeGuideDict = [NSMutableDictionary new];
        
        }
        
    }
    
    else if ([myDelegate.methodName isEqualToString: @"generalApiWaitListRequestParam"])
    {
        if ([elementname isEqualToString:@"result"])
        {
            waitListDict = [[NSMutableDictionary alloc]init];
        }
        
    }

    
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    /************************** Product Listing *******************************************/
    if ([myDelegate.methodName isEqualToString: @"generalApiProductListingRequestParam"])
    {
        if ([elementname isEqualToString:@"category_image"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            categoryImage = currentNodeContent;
            
            
        }
        
        else if ([elementname isEqualToString:@"total_products"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            totalProducts = currentNodeContent;
            
            
        }
        else if ([elementname isEqualToString:@"product_id"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            productListData.productId = currentNodeContent;
            productListData.isAddedToWishlist = false;
            
        }
        else if ([elementname isEqualToString:@"sku"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            productListData.skuNumber = currentNodeContent;
            
            
            
        }
        else if ([elementname isEqualToString:@"name"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            productListData.productName = currentNodeContent;
            
            
            
        }
        else if ([elementname isEqualToString:@"price"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            productListData.productPrice = currentNodeContent;
            
        }
        
        else if ([elementname isEqualToString:@"currency_symbol"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            productListData.productPriceSymbol = currentNodeContent;
            
            
        }
        else if ([elementname isEqualToString:@"special_price"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            productListData.specialPrice = currentNodeContent;
            
            
        }
        else if ([elementname isEqualToString:@"is_in_stock"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            productListData.isInStock = currentNodeContent;
            
            
        }
        else if ([elementname isEqualToString:@"stock_quantity"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            productListData.stockQuantity = currentNodeContent;
            
            
        }
        
        else if ([elementname isEqualToString:@"image"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            productListData.productImage = currentNodeContent;
            
            
        }
        else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
            productListData.categoryImage = categoryImage;
            productListData.totalProducts = totalProducts;
            
            [productListArray addObject:productListData];
            
            
            // [productListArray addObject:productListData.categoryImage];
            NSLog(@"MainCatArray : %lu", (unsigned long) productListArray.count);
            
        }
        
        else if ([elementname isEqualToString:@"status"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            
            responseString = currentNodeContent;
            responseString = [responseString stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            status=responseString;
            //            [dataDic setObject:currentNodeContent forKey:@"status"];
            
        }
        else if ([elementname isEqualToString:@"message"])
        {
            NSLog(@"status **** %@",status );
            
            if (![status isEqual:@"1"] && status!=nil)
            {
                NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
                responseString = currentNodeContent;
                
                //[self showAlertMessage:responseString];
            }
            else
            {
                [dataDic setObject:currentNodeContent forKey:@"message"];
            }
        }
        else if ([elementname isEqualToString:@"faultstring"])
        {
            
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            if ([currentNodeContent isEqualToString:@"Session expired. Try to relogin."]) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                
                myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
                
                myDelegate.window.rootViewController = myDelegate.navigationController;
                [UserDefaultManager removeValue:@"customer_id"];
                [UserDefaultManager removeValue:@"customer_name"];
                [UserDefaultManager removeValue:@"userEmail"];
                [UserDefaultManager removeValue:@"profiePicture"];
            }
            else
            {
                //[self showAlertMessage:responseString];
            }
        }
        else if ([elementname isEqualToString:@"is_success"])
        {
            status = currentNodeContent;
            
        }
    }
    else if ([myDelegate.methodName isEqualToString:@"generalApiAddToWishlistRequestParam"])
    {
        if ([elementname isEqualToString:@"result"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            [dataDic setObject:currentNodeContent forKey:@"result"];
            
            
        }
        else if ([elementname isEqualToString:@"status"])
        {
            status = currentNodeContent;
            if (![status isEqual:@"1"] && status!=nil)
            {
                NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
                
                
                [self showAlertMessage:responseString];
            }
            else
            {
                if (responseString!= nil)
                {
                    [dataDic setObject:responseString forKey:@"message"];
                }
                
                
            }
        }
        else if ([elementname isEqualToString:@"message"])
        {
            NSLog(@"status **** %@",status );
            responseString = currentNodeContent;
            
        }
        else if ([elementname isEqualToString:@"faultstring"])
        {
            
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            if ([currentNodeContent isEqualToString:@"Session expired. Try to relogin."]) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                
                myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
                
                myDelegate.window.rootViewController = myDelegate.navigationController;
                [UserDefaultManager removeValue:@"customer_id"];
                [UserDefaultManager removeValue:@"customer_name"];
                [UserDefaultManager removeValue:@"userEmail"];
                [UserDefaultManager removeValue:@"profiePicture"];
            }
            else{
                [self showAlertMessage:responseString];
            }
        }
        
        
    }
    else if ([myDelegate.methodName isEqualToString:@"generalApiRemoveFromWishlistRequestParam"])
    {
        if ([elementname isEqualToString:@"result"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            [dataDic setObject:currentNodeContent forKey:@"result"];
            
            
        }
        else if ([elementname isEqualToString:@"message"])
        {
            NSLog(@"status **** %@",status );
            
            if (![status isEqual:@"1"] && status!=nil)
            {
                NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
                responseString = currentNodeContent;
                
                [self showAlertMessage:responseString];
            }
            else
            {
                [dataDic setObject:currentNodeContent forKey:@"message"];
            }
        }
        else if ([elementname isEqualToString:@"faultstring"])
        {
            
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            if ([currentNodeContent isEqualToString:@"Session expired. Try to relogin."])
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
                myDelegate.window.rootViewController = myDelegate.navigationController;
                [UserDefaultManager removeValue:@"customer_id"];
                [UserDefaultManager removeValue:@"customer_name"];
                [UserDefaultManager removeValue:@"userEmail"];
                [UserDefaultManager removeValue:@"profiePicture"];
            }
            else
            {
                [self showAlertMessage:responseString];
            }
        }
        
    }
    
    else if ([myDelegate.methodName isEqualToString: @"generalApiCategoryListingRequestParam"])
    {
        if ([elementname isEqualToString:@"level2"])
        {
            depth--;
            [catArray addObject:catModel];
        }
        if (depth==0)
        {
            if ([elementname isEqualToString:@"entity_id"])
            {
                catModel.catId = currentNodeContent;
            }
            else if ([elementname isEqualToString:@"name"])
            {
                catModel.catName = currentNodeContent;
            }
            else if ([elementname isEqualToString:@"caticon"])
            {
                catModel.catIcon = currentNodeContent;
            }
            else if ([elementname isEqualToString:@"type"])
            {
                catModel.type = currentNodeContent;
            }
            else if ([elementname isEqualToString:@"is_instock"])
            {
                catModel.isInstock = currentNodeContent;
            }
            else if ([elementname isEqualToString:@"product_type"])
            {
                catModel.productType = currentNodeContent;
            }
            else if ([elementname isEqualToString:@"mob_product_id"])
            {
                if (category_listing)
                {
                    catModel.productId = currentNodeContent;
                }
                
            }
            else if ([elementname isEqualToString:@"category_listing"])
            {
                category_listing = false;
            }
            
        }
        else if (depth==1)
        {
            if ([elementname isEqualToString:@"entity_id"])
            {
                subCatModel.subCatId = currentNodeContent;
            }
            else if ([elementname isEqualToString:@"name"])
            {
                subCatModel.subCatName = currentNodeContent;
            }
            else if ([elementname isEqualToString:@"caticon"])
            {
                subCatModel.subCatIcon = currentNodeContent;
            }
            else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
            {
                [catModel.subCatArray addObject:subCatModel];
            }
        }
        
        
    }
    
    else if ([myDelegate.methodName isEqualToString: @"generalApiColorFilterRequestParam"])
    {
        
        if ([elementname isEqualToString:@"value"])
        {
            [colorDict setObject:currentNodeContent forKey:@"value"];
        }
        else if ([elementname isEqualToString:@"label"])
        {
            [colorDict setObject:currentNodeContent forKey:@"label"];
        }
        else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
            [colorArray addObject:colorDict];
        }
        
    }
    else if ([myDelegate.methodName isEqualToString: @"generalApiCustomerWishlistRequestParam"])
    {
        
        if ([elementname isEqualToString:@"product_id"])
        {
            [wishListDict setObject:currentNodeContent forKey:@"product_id"];
            
        }
        else if ([elementname isEqualToString:@"name"])
        {
            [wishListDict setObject:currentNodeContent forKey:@"name"];
        }
        else if ([elementname isEqualToString:@"sku"])
        {
            [wishListDict setObject:currentNodeContent forKey:@"sku"];
        }
        else if ([elementname isEqualToString:@"image"])
        {
            [wishListDict setObject:currentNodeContent forKey:@"image"];
        }
        else if ([elementname isEqualToString:@"product_price"])
        {
            [wishListDict setObject:currentNodeContent forKey:@"product_price"];
        }
        else if ([elementname isEqualToString:@"Isinstock"])
        {
            [wishListDict setObject:currentNodeContent forKey:@"Isinstock"];
        }
        else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
            
            [wishListArray addObject:wishListDict];
            
        }
        else if ([elementname isEqualToString:@"products"])
        {
            [UserDefaultManager setValue:wishListArray key:@"wishListData"];
            NSLog(@"session is %@ and wishListArray is %@",[UserDefaultManager getValue:@"sessionId"],[UserDefaultManager getValue:@"wishListData"]);
        }
        else if ([elementname isEqualToString:@"status"])
        {
            status = currentNodeContent;
            if ([status isEqualToString:@"0"])
            {
                [UserDefaultManager setValue:nil key:@"wishListData"];
                NSLog(@"session is %@ and wishListArray is %@",[UserDefaultManager getValue:@"sessionId"],[UserDefaultManager getValue:@"wishListData"]);
            }
        }
        
    }
    else if ([myDelegate.methodName isEqualToString: @"generalApiProductSearchRequestParam"])
    {
        if ([elementname isEqualToString:@"category_image"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            categoryImage = currentNodeContent;
            
            
        }
        
        else if ([elementname isEqualToString:@"total_products"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            totalProducts = currentNodeContent;
            
            
        }
        else if ([elementname isEqualToString:@"product_id"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            searchProductListData.productId = currentNodeContent;
            searchProductListData.isAddedToWishlist = false;
            
        }
        else if ([elementname isEqualToString:@"sku"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            searchProductListData.skuNumber = currentNodeContent;
            
            
            
        }
        else if ([elementname isEqualToString:@"name"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            searchProductListData.productName = currentNodeContent;
            
            
            
        }
        else if ([elementname isEqualToString:@"price"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            searchProductListData.productPrice = currentNodeContent;
            
        }
        
        else if ([elementname isEqualToString:@"currency_symbol"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            searchProductListData.productPriceSymbol = currentNodeContent;
            
            
        }
        else if ([elementname isEqualToString:@"special_price"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            searchProductListData.specialPrice = currentNodeContent;
            
            
        }
        else if ([elementname isEqualToString:@"is_in_stock"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            searchProductListData.isInStock = currentNodeContent;
            
            
        }
        else if ([elementname isEqualToString:@"stock_quantity"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            searchProductListData.stockQuantity = currentNodeContent;
            
        }
        
        else if ([elementname isEqualToString:@"image"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            searchProductListData.productImage = currentNodeContent;
            
        }
        else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
            searchProductListData.categoryImage = categoryImage;
            searchProductListData.totalProducts = totalProducts;
            [productListArray addObject:searchProductListData];
            // [productListArray addObject:productListData.categoryImage];
            NSLog(@"MainCatArray : %lu", (unsigned long) productListArray.count);
            
        }
        
        else if ([elementname isEqualToString:@"status"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            
            responseString = currentNodeContent;
            responseString = [responseString stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            status=responseString;
            //            [dataDic setObject:currentNodeContent forKey:@"status"];
            
        }
        else if ([elementname isEqualToString:@"message"])
        {
            NSLog(@"status **** %@",status );
            
            if (![status isEqual:@"1"] && status!=nil)
            {
                NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
                responseString = currentNodeContent;
                
                //[self showAlertMessage:responseString];
            }
            else
            {
                [dataDic setObject:currentNodeContent forKey:@"message"];
            }
        }
        else if ([elementname isEqualToString:@"faultstring"])
        {
            
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            if ([currentNodeContent isEqualToString:@"Session expired. Try to relogin."]) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                
                myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
                
                myDelegate.window.rootViewController = myDelegate.navigationController;
                [UserDefaultManager removeValue:@"customer_id"];
                [UserDefaultManager removeValue:@"customer_name"];
                [UserDefaultManager removeValue:@"userEmail"];
                [UserDefaultManager removeValue:@"profiePicture"];
            }
            else
            {
                //[self showAlertMessage:responseString];
            }
        }
        else if ([elementname isEqualToString:@"is_success"])
        {
            status = currentNodeContent;
            
        }
    }
    else if ([myDelegate.methodName isEqualToString: @"catalogProductInfoRequestParam"])
    {
        if ([elementname isEqualToString:@"sku"])
        {
            [productDetailDict setObject:currentNodeContent forKey:@"sku"];
            
        }
        else if ([elementname isEqualToString:@"type"])
        {
            [productDetailDict setObject:currentNodeContent forKey:@"type"];
            
        }
        else if ([elementname isEqualToString:@"name"])
        {
            [productDetailDict setObject:currentNodeContent forKey:@"name"];
            
        }
        else if ([elementname isEqualToString:@"description"])
        {
            [productDetailDict setObject:currentNodeContent forKey:@"Details"];
            
        }
        else if ([elementname isEqualToString:@"price"])
        {
            [productDetailDict setObject:currentNodeContent forKey:@"price"];
            
        }
        else if ([elementname isEqualToString:@"value"])
        {
            if (!([currentNodeContent isEqualToString:@""] ||[currentNodeContent isEqualToString:@"\n"]))
            {
                [productDetailDict setObject:currentNodeContent forKey:@"Delivery"];
            }
            
            
        }
        
        
        
    }
    else if ([myDelegate.methodName isEqualToString: @"catalogProductAttributeMediaListRequestParam"])
    {
        if ([elementname isEqualToString:@"exclude"])
        {
            status = currentNodeContent;
            
        }
        else if ([elementname isEqualToString:@"url"])
        {
            if ([status isEqualToString:@"0"])
            {
                [imageArary addObject:currentNodeContent];
            }
        }
    }
    else if ([myDelegate.methodName isEqualToString: @"shoppingCartProductAddRequestParam"])
    {
        if ([elementname isEqualToString:@"result"])
        {
            status = currentNodeContent;
            
        }
        
    }
    else if ([myDelegate.methodName isEqualToString: @"generalApiCustomcartInfoRequestParam"])
    {
        if ([elementname isEqualToString:@"status"])
        {
            [UserDefaultManager setValue:currentNodeContent key:@"status"];
            if ([currentNodeContent intValue]==0)
            {
                [UserDefaultManager setValue:nil key:@"cartData"];
            }
        }
        else if ([elementname isEqualToString:@"parent_item_id"])
        {
            [cartDict setObject:currentNodeContent forKey:@"parent_item_id"];
        }
        else if ([elementname isEqualToString:@"item_id"])
        {
            [cartDict setObject:currentNodeContent forKey:@"item_id"];
        }
        else if ([elementname isEqualToString:@"product_id"])
        {
            [cartDict setObject:currentNodeContent forKey:@"product_id"];
        }
        else if ([elementname isEqualToString:@"product_type"])
        {
            [cartDict setObject:currentNodeContent forKey:@"product_type"];
        }
        else if ([elementname isEqualToString:@"scalar"])
        {
            [cartDict setObject:currentNodeContent forKey:@"inStock"];
        }
        else if ([elementname isEqualToString:@"qty"])
        {
            [cartDict setObject:currentNodeContent forKey:@"product_quantity"];
        }
        else if ([elementname isEqualToString:@"sku"])
        {
            [cartDict setObject:currentNodeContent forKey:@"sku"];
        }
        else if ([elementname isEqualToString:@"name"])
        {
            [cartDict setObject:currentNodeContent forKey:@"product_name"];
        }
        else if ([elementname isEqualToString:@"price"])
        {
            [cartDict setObject:currentNodeContent forKey:@"price"];
        }
        else if ([elementname isEqualToString:@"tax_amount"])
        {
            [cartDict setObject:currentNodeContent forKey:@"tax_amount"];
        }
        else if ([elementname isEqualToString:@"tax_amount"])
        {
            [cartDict setObject:currentNodeContent forKey:@"tax_amount"];
        }
        else if ([elementname isEqualToString:@"value"] && depth==0)
        {
            depth=1;
            [cartDict setObject:currentNodeContent forKey:@"value"];
        }
        else if ([elementname isEqualToString:@"custom_options"])
        {
            depth=0;
            
        }
        else if ([elementname isEqualToString:@"ssn"])
        {
            myDelegate.giftMessage = currentNodeContent;
        }
//        else if ([elementname isEqualToString:@"row_total"])
//        {
//            [cartDict setObject:currentNodeContent forKey:@"price"];
//        }
        else if ([elementname isEqualToString:@"position"])
        {
            position= currentNodeContent;
        }
        else if ([elementname isEqualToString:@"url"])
        {
            if ([position isEqualToString:@"1"])
            {
                [cartDict setObject:currentNodeContent forKey:@"url"];
            }
        }
        else if ([elementname isEqualToString:@"raw_data"])
        {
            position = @"";
            [cartDict setObject:@"N" forKey:@"isWishlist"];
            [cartArray addObject:cartDict];
        }
        else if([elementname isEqualToString:@"items"])
        {
            [UserDefaultManager setValue:cartArray key:@"cartData"];
            [UserDefaultManager setValue:[NSString stringWithFormat:@"%lu",(unsigned long)cartArray.count] key:@"total_cart_item"];
            NSLog(@"session is %@ and wishListArray is %@",[UserDefaultManager getValue:@"sessionId"],[UserDefaultManager getValue:@"cartData"]);
        }
        else if([elementname isEqualToString:@"subtotal"])
        {
            [UserDefaultManager setValue:currentNodeContent key:@"cart_total"];
            //NSLog(@"session is %@ and wishListArray is %@",[UserDefaultManager getValue:@"sessionId"],[UserDefaultManager getValue:@"cartData"]);
        }
        else if([elementname isEqualToString:@"cart_total"])
        {
            [UserDefaultManager setValue:currentNodeContent key:@"total_cart_total"];
            //NSLog(@"session is %@ and wishListArray is %@",[UserDefaultManager getValue:@"sessionId"],[UserDefaultManager getValue:@"cartData"]);
        }
        else if([elementname isEqualToString:@"total_tax_amount"])
        {
            [UserDefaultManager setValue:currentNodeContent key:@"total_tax_amount"];
            //NSLog(@"session is %@ and wishListArray is %@",[UserDefaultManager getValue:@"sessionId"],[UserDefaultManager getValue:@"cartData"]);
        }
        
    }
    else if ([myDelegate.methodName isEqualToString: @"generalApiCustomProductDetailsRequestParam"])
    {
        //parsing for build a gift product.
        if ([elementname isEqualToString:@"product_type"])
        {
            productType = currentNodeContent;
            
        }
        else if ([productType isEqualToString:@"bundle"])
        {
            if ([elementname isEqualToString:@"BOGUS"])
            {
                
                if (depth==2)
                {
                    [buildGiftModel.giftDict setObject:@"No" forKey:@"isWishlist"];
                    [buildGiftModel.giftDict setObject:@"No" forKey:@"isSelected"];
                    [subGiftArray addObject:buildGiftModel];
                }
                else if (depth==1)
                {
                    
                }
                depth--;
            }
            else if ([elementname isEqualToString:@"all_bundle_prouducts"])
            {
                
                [subGiftArray addObject:giftDict];
                [mainGiftArray addObject:subGiftArray];
                
                
            }
            else if (depth==1)
            {
                if ([elementname isEqualToString:@"required"])
                {
                    [giftDict setObject:currentNodeContent forKey:@"required"];
                }
                else if ([elementname isEqualToString:@"type"])
                {
                    [giftDict setObject:currentNodeContent forKey:@"type"];
                }
                else if ([elementname isEqualToString:@"default_title"])
                {
                    [giftDict setObject:currentNodeContent forKey:@"default_title"];
                }
            }
            else if (depth==2)
            {
                if ([elementname isEqualToString:@"name"])
                {
                    [buildGiftModel.giftDict setObject:currentNodeContent forKey:@"name"];
                }
                else if ([elementname isEqualToString:@"id"])
                {
                    [buildGiftModel.giftDict setObject:currentNodeContent forKey:@"id"];
                }
                else if ([elementname isEqualToString:@"bundle_pro_sku"])
                {
                    [buildGiftModel.giftDict setObject:currentNodeContent forKey:@"bundle_pro_sku"];
                }
                if ([elementname isEqualToString:@"price"])
                {
                    [buildGiftModel.giftDict setObject:currentNodeContent forKey:@"price"];
                }
                else if ([elementname isEqualToString:@"selection_id"])
                {
                    [buildGiftModel.giftDict setObject:currentNodeContent forKey:@"selection_id"];
                }
                else if ([elementname isEqualToString:@"product_option_id"])
                {
                    [buildGiftModel.giftDict setObject:currentNodeContent forKey:@"product_option_id"];
                }
                else if ([elementname isEqualToString:@"image"])
                {
                    [buildGiftModel.giftDict setObject:currentNodeContent forKey:@"url"];
                }
                
            }
            else if (depth==3)
            {
                
                if ([elementname isEqualToString:@"url"])
                {
                    [buildGiftModel.giftDict setObject:currentNodeContent forKey:@"url"];
                }
                
            }
        }
        //end.
        else if([productType isEqualToString:@"simple"])
        {
            if ([elementname isEqualToString:@"BOGUS"])
            {
                
                depth--;
                if (depth==1)
                {
                    [additionalFiendsArray addObject:additionalFiendsDict];
                }
                
            }
            else if ([elementname isEqualToString:@"sku"])
            {
                if (!isSku) {
                    isSku = true;
                    [productDetailDict setObject:currentNodeContent forKey:@"sku"];
                }
//                else
//                {
//                   // isSku = false;
//                    [productDetailDict setObject:currentNodeContent forKey:@"sku"];
//
//                }
                
                
            }
            else if ([elementname isEqualToString:@"name"])
            {
                [productDetailDict setObject:currentNodeContent forKey:@"name"];
                
            }
            else if ([elementname isEqualToString:@"is_in_stock"])
            {
                [productDetailDict setObject:currentNodeContent forKey:@"is_in_stock"];
                
            }
            else if ([elementname isEqualToString:@"product_url"])
            {
                [productDetailDict setObject:currentNodeContent forKey:@"product_url"];
                
            }
            else if ([elementname isEqualToString:@"description"])
            {
                [productDetailDict setObject:currentNodeContent forKey:@"Details"];
                
            }
            else if ([elementname isEqualToString:@"price"])
            {
                if (!isPrice)
                {
                    isPrice = true;
                    [productDetailDict setObject:currentNodeContent forKey:@"price"];
                }
//                else
//                {
//                   // isPrice = false;
//                    [productDetailDict setObject:currentNodeContent forKey:@"price"];
//                    
//                }

                
                
            }
            else if ([elementname isEqualToString:@"has_options"])
            {
                [productDetailDict setObject:currentNodeContent forKey:@"has_options"];
                
            }
            else if ([elementname isEqualToString:@"value"])
            {
                if (!([currentNodeContent isEqualToString:@""] ||[currentNodeContent isEqualToString:@"\n"]))
                {
                    [productDetailDict setObject:currentNodeContent forKey:@"Delivery"];
                }
                
            }
            else if ([elementname isEqualToString:@"url"])
            {
                [imageArary addObject:currentNodeContent];
            }
            else if ([elementname isEqualToString:@"images"])
            {
                [productDetailDict setObject:imageArary forKey:@"url"];
            }
            else if ([[productDetailDict objectForKey:@"has_options"] boolValue])
            {
                if (depth==1)
                {
                    if ([elementname isEqualToString:@"option_id"])
                    {
                        [personalizeTypeDict setObject:currentNodeContent forKey:@"option_id"];
                    }
                    else if ([elementname isEqualToString:@"title"])
                    {
                        [personalizeTypeDict setObject:currentNodeContent forKey:@"title"];
                    }
                    else if ([elementname isEqualToString:@"is_require"])
                    {
                        [personalizeTypeDict setObject:currentNodeContent forKey:@"is_require"];
                    }
                    else if ([elementname isEqualToString:@"type"])
                    {
                        [personalizeTypeDict setObject:currentNodeContent forKey:@"type"];
                    }
                    else if ([elementname isEqualToString:@"additional_fields"])
                    {
                        [personalizeTypeDict setObject:additionalFiendsArray forKey:@"personalizeType"];
                        [mainPersonalizeArray addObject:personalizeTypeDict];
                    }
                    
                }
                else if (depth==2)
                {
                    if ([elementname isEqualToString:@"value_id"])
                    {
                        [additionalFiendsDict setObject:currentNodeContent forKey:@"value_id"];
                    }
                    else if ([elementname isEqualToString:@"title"])
                    {
                        [additionalFiendsDict setObject:currentNodeContent forKey:@"title"];
                    }
                    else if ([elementname isEqualToString:@"sku"])
                    {
                        [additionalFiendsDict setObject:currentNodeContent forKey:@"sku"];
                    }
                    else if ([elementname isEqualToString:@"price_type"])
                    {
                        [additionalFiendsDict setObject:currentNodeContent forKey:@"price_type"];
                    }
                }
                
                else if ([elementname isEqualToString:@"product_options"])
                {
                    [productDetailDict setObject:mainPersonalizeArray forKey:@"Personalize"];
                }
                
            }
            else if ([elementname isEqualToString:@"type"])
            {
                [productDetailDict setObject:currentNodeContent forKey:@"type"];
                
            }
            
        }
    }
    else if ([myDelegate.methodName isEqualToString: @"generalApiSizeGuideRequestParam"])
    {
        if ([elementname isEqualToString:@"sid"])
        {
            [sizeGuideDict setObject:currentNodeContent forKey:@"sid"];
        }
        else if ([elementname isEqualToString:@"title"])
        {
            [sizeGuideDict setObject:currentNodeContent forKey:@"title"];
        }
        else if ([elementname isEqualToString:@"subtitle"])
        {
            [sizeGuideDict setObject:currentNodeContent forKey:@"subtitle"];
        }
        else if ([elementname isEqualToString:@"image"])
        {
            [sizeGuideDict setObject:currentNodeContent forKey:@"image"];
        }
        else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
            [sizeGuideArray addObject:sizeGuideDict];
        }
        
        
    }
    else if ([myDelegate.methodName isEqualToString: @"generalApiCustomproductRemoveRequestParam"])
    {
        if ([elementname isEqualToString:@"status"])
        {
            status = currentNodeContent;
        }
    
    }
    else if ([myDelegate.methodName isEqualToString: @"generalApiCustomproductUpdateRequestParam"])
    {
        if ([elementname isEqualToString:@"result"])
        {
            status = currentNodeContent;
        }
        
    }
    
    else if ([myDelegate.methodName isEqualToString: @"generalApiWaitListRequestParam"])
    {
        if ([elementname isEqualToString:@"status"])
        {
            [dataDic setObject:currentNodeContent forKey:@"status"];

        }
        else if ([elementname isEqualToString:@"message"])
        {
            [dataDic setObject:currentNodeContent forKey:@"message"];
            
        }
        
    }
    else if ([myDelegate.methodName isEqualToString: @"generalApiMyWaitListRequestParam"])
    {
        if ([elementname isEqualToString:@"product_id"])
        {
            productListData.productId = currentNodeContent;
        }
        else if ([elementname isEqualToString:@"product_name"])
        {
            productListData.productName = currentNodeContent;
        }
        else if ([elementname isEqualToString:@"product_price"])
        {
            productListData.productPrice = currentNodeContent;
        }
        else if ([elementname isEqualToString:@"position"])
        {
            position= currentNodeContent;
        }
        else if ([elementname isEqualToString:@"url"])
        {
            if ([position isEqualToString:@"1"])
            {
                productListData.productImage = currentNodeContent;
            }
        }
        else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
             [productListArray addObject:productListData];
            NSLog(@"MainCatArray : %lu", (unsigned long) productListArray.count);
        }
        
        else if ([elementname isEqualToString:@"status"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            
            responseString = currentNodeContent;
            responseString = [responseString stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            status=responseString;
            //            [dataDic setObject:currentNodeContent forKey:@"status"];
            
        }
        else if ([elementname isEqualToString:@"message"])
        {
            NSLog(@"status **** %@",status );
            
            if (![status isEqual:@"1"] && status!=nil)
            {
                NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
                responseString = currentNodeContent;
                
                [self showAlertMessage:responseString];
            }
            else
            {
                [dataDic setObject:currentNodeContent forKey:@"message"];
            }
        }
        else if ([elementname isEqualToString:@"faultstring"])
        {
            
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            if ([currentNodeContent isEqualToString:@"Session expired. Try to relogin."]) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                
                myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
                
                myDelegate.window.rootViewController = myDelegate.navigationController;
                [UserDefaultManager removeValue:@"customer_id"];
                [UserDefaultManager removeValue:@"customer_name"];
                [UserDefaultManager removeValue:@"userEmail"];
                [UserDefaultManager removeValue:@"profiePicture"];
            }
            else
            {
                [self showAlertMessage:responseString];
            }
        }
        else if ([elementname isEqualToString:@"is_success"])
        {
            status = currentNodeContent;
            
        }
    }

    
    
    currentNodeContent=nil;
    
}


-(void)showAlertMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    });
}

-(void)dealloc
{
    parser = nil;
    currentNodeContent =nil;
    
}

@end
