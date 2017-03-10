//
//  XMLParser.m
//  SleepApp
//
//  Created by Isolpc32 on 04/03/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "UserXMLParser.h"


@implementation UserXMLParser
{
    NSMutableDictionary *dataDic;
    NSString *signUpCustomerId;
    int CartProducts;
    NSMutableDictionary * wishListDict;
    NSMutableArray * wishListArray;
    
    NSMutableDictionary * cartDict;
    NSMutableArray * cartArray;
    
}
@synthesize currentNodeContent;
@synthesize responseString,status;
//Shared instance init
#pragma mark - Singleton instance init
+ (id)sharedManager
{
    static UserXMLParser *sharedMyManager = nil;
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
#pragma mark - end

#pragma mark - Load xml
-(NSMutableDictionary *) loadxmlByData:(NSData *)data
{
    //NSLog(@"entered in loadxmlByData");
    status=nil;
    [dataDic removeAllObjects];
    cartArray = [[NSMutableArray alloc]init];
    wishListArray = [[NSMutableArray alloc]init];
    parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    
    return dataDic;
    
}
#pragma mark - end

#pragma mark - XML parser delegate methods
- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (currentNodeContent==nil)
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
    if ([myDelegate.methodName isEqualToString: @"generalApiCustomerLoginRequestParam"])
    {
        if ([elementname isEqualToString:@"wishlist_products"])
        {
            CartProducts = 1;
        }
        else if ([elementname isEqualToString:@"cart_products"])
        {
            CartProducts = 2;
        }
        else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
            if (CartProducts==2)
            {
                cartDict = [NSMutableDictionary new];
            }
            else if (CartProducts==1)
            {
                wishListDict = [NSMutableDictionary new];
                
            }
        }
    }
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    
    /************************** SessionId *******************************************/
    
    if ([myDelegate.methodName isEqualToString: @"loginParam"])
    {
        if ([elementname isEqualToString:@"result"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            
            [dataDic setObject:currentNodeContent forKey:@"result"];
            
            
            if (myDelegate.isSessionId ==1)
            {
                [UserDefaultManager setValue:responseString key:@"sessionId"];
                NSLog(@"%@",[UserDefaultManager getValue:@"sessionId"]);
                myDelegate.isSessionId=0;
            }
        }
        
        
    }
    /************************** Login *******************************************/
    else if ([myDelegate.methodName isEqualToString: @"generalApiCustomerLoginRequestParam"])
    {
        if ([elementname isEqualToString:@"result"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            [dataDic setObject:currentNodeContent forKey:@"result"];
        }
        else if ([elementname isEqualToString:@"customer_id"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            [dataDic setObject:currentNodeContent forKey:@"customer_id"];
            
        }
        else if ([elementname isEqualToString:@"customer_name"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            [dataDic setObject:currentNodeContent forKey:@"customer_name"];
            
            [UserDefaultManager setValue:currentNodeContent key:@"customer_name"];
        }
        else if ([elementname isEqualToString:@"status"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            
            responseString = currentNodeContent;
            responseString = [responseString stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            status=responseString;
            [dataDic setObject:currentNodeContent forKey:@"status"];
            
        }
        else if ([elementname isEqualToString:@"message"])
        {
            NSLog(@"status **** %@",status );
            
            if (![status isEqual:@"1"] && status!=nil)
            {
                NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
                responseString = currentNodeContent;
                [dataDic setObject:currentNodeContent forKey:@"message"];

//                [self showAlertMessage:responseString];
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
            else{
                [self showAlertMessage:responseString];
            }
        }
        //code for same tag of cart and wishlist
        else if ([elementname isEqualToString:@"product_id"])
        {
            if (CartProducts==2)
            {
                [cartDict setObject:currentNodeContent forKey:@"product_id"];
            }
            else if (CartProducts==1)
            {
                
                [wishListDict setObject:currentNodeContent forKey:@"product_id"];
                
            }
        }
        else if ([elementname isEqualToString:@"product_quantity"])
        {
            [cartDict setObject:currentNodeContent forKey:@"product_quantity"];
        }
        else if ([elementname isEqualToString:@"product_name"])
        {
            [wishListDict setObject:currentNodeContent forKey:@"product_name"];
        }
        else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
            if ([status isEqualToString:@"1"])
            {
                if (CartProducts==2)
                {
                    [cartArray addObject:cartDict];
                }
                else if (CartProducts==1)
                {
                    [wishListArray addObject:wishListDict];
                    
                }
            }
        }
        else if ([elementname isEqualToString:@"wishlist_products"])
        {
            [UserDefaultManager setValue:wishListArray key:@"wishListData"];
            NSLog(@"session is %@ and wishListArray is %@",[UserDefaultManager getValue:@"sessionId"],[UserDefaultManager getValue:@"wishListData"]);
        }
        else if ([elementname isEqualToString:@"cart_products"])
        {
            CartProducts=0;
            [UserDefaultManager setValue:cartArray key:@"cartData"];
            NSLog(@"session is %@ and wishListArray is %@",[UserDefaultManager getValue:@"sessionId"],[UserDefaultManager getValue:@"cartData"]);
        }
        //end
        else if ([elementname isEqualToString:@"quoteId"])
        {
            [UserDefaultManager setValue:currentNodeContent key:@"quoteId"];
        }
        else if ([elementname isEqualToString:@"total_cart_item"])
        {
            [UserDefaultManager setValue:currentNodeContent key:@"total_cart_item"];
        }
    }
    
    else if ([myDelegate.methodName isEqualToString: @"customerCustomerCreateRequestParam"])
    {
        if ([elementname isEqualToString:@"result"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            
            [dataDic setObject:currentNodeContent forKey:@"result"];
            
        }
        
        else if ([elementname isEqualToString:@"customer_id"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            [dataDic setObject:currentNodeContent forKey:@"customer_id"];
            [UserDefaultManager setValue:currentNodeContent key:@"customer_id"];
            
            NSLog(@"[UserDefaultManager getValue:customer_id] %@",[UserDefaultManager getValue:@"customer_id"]);

            
        }

        else if ([elementname isEqualToString:@"status"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            
            responseString = currentNodeContent;
            responseString = [responseString stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            status=responseString;
            [dataDic setObject:currentNodeContent forKey:@"status"];
            
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
        else if ([elementname isEqualToString:@"quoteId"])
        {
            [UserDefaultManager setValue:currentNodeContent key:@"quoteId"];
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
    else if ([myDelegate.methodName isEqualToString: @"generalApiForgetPasswordRequestParam"])
    {
        if ([elementname isEqualToString:@"result"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            
            [dataDic setObject:currentNodeContent forKey:@"result"];
            
        }
        else if ([elementname isEqualToString:@"status"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            
            responseString = currentNodeContent;
            responseString = [responseString stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            status=responseString;
            [dataDic setObject:currentNodeContent forKey:@"status"];
            
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
            else{
                [self showAlertMessage:responseString];
            }
        }
    }
    else if ([myDelegate.methodName isEqualToString: @"generalApiAppViralityRequestParam"])
    {
        if ([elementname isEqualToString:@"result"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            
            [dataDic setObject:currentNodeContent forKey:@"result"];
            
        }
        else if ([elementname isEqualToString:@"status"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            
            responseString = currentNodeContent;
            responseString = [responseString stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            status=responseString;
            [dataDic setObject:currentNodeContent forKey:@"status"];
            
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
            else{
                [self showAlertMessage:responseString];
            }
        }
    }

    currentNodeContent=nil;
    
}
#pragma mark - end

#pragma mark - Show alert message
-(void)showAlertMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    });
}
#pragma mark - end

#pragma mark - Memory deallocation
-(void)dealloc
{
    parser = nil;
    currentNodeContent =nil;
}
#pragma mark - end

@end
