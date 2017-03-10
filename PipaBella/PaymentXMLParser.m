//
//  PaymentXMLParser.m
//  PipaBella
//
//  Created by Ranosys on 12/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "PaymentXMLParser.h"
#import "PaymentModel.h"

@implementation PaymentXMLParser
{
    NSMutableDictionary *dataDic;
    NSMutableArray *paymentArray;
    PaymentModel  *paymentDataModel;
    NSString * tag;
}
@synthesize currentNodeContent;
@synthesize responseString,status;

//Shared instance init
+ (id)sharedManager
{
    static PaymentXMLParser *sharedMyManager = nil;
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
    NSLog(@"entered in loadxmlByData productXMLParser");

    status=nil;
    parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    return dataDic;
}


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
    if ([myDelegate.methodName isEqualToString: @"generalApiPayAndShipMethodListRequestParam"])
    {
        if ([elementname isEqualToString:@"shipping"])
        {
            paymentArray=[[NSMutableArray alloc]init];
            tag = @"shipping";
        }
        else if ([elementname isEqualToString:@"payment"])
        {
            //paymentDataModel =[[PaymentModel alloc]init];
            tag = @"payment";
            
        }
        else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
            paymentDataModel =[[PaymentModel alloc]init];
            
        }
    }
    
    
}
- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    /************************** Get shipping and payment method list *******************************************/
    if ([myDelegate.methodName isEqualToString: @"generalApiPayAndShipMethodListRequestParam"])
    {
        
        if ([elementname isEqualToString:@"code"])
        {
            if ([tag isEqualToString:@"shipping"])
            {
                paymentDataModel.shippingCode = currentNodeContent;
                
            }
            else if ([tag isEqualToString:@"payment"])
            {
                paymentDataModel.paymentCode = currentNodeContent;
                
            }
        }
        else if ([elementname isEqualToString:@"method"])
        {
            paymentDataModel.method=currentNodeContent;
        }
        else if ([elementname isEqualToString:@"price"])
        {
            paymentDataModel.price=currentNodeContent;
        }
        
        else if ([elementname isEqualToString:@"title"])
        {
            paymentDataModel.title=currentNodeContent;
        }
        else if ([elementname isEqualToString:@"error_message"])
        {
            paymentDataModel.errorMessage=currentNodeContent;
        }
        
        else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
            [paymentArray addObject:paymentDataModel];
            //[dataDic setObject:paymentArray forKey:@"SOAP-ENC:Struct"];
            
        }
        
        if ([elementname isEqualToString:@"result"])
        {
            [dataDic setObject:paymentArray forKey:@"result"];
        }

    }
    /************************** Set shipping method *******************************************/

    if ([myDelegate.methodName isEqualToString: @"shoppingCartShippingMethodRequestParam"])
    {
        if ([elementname isEqualToString:@"result"])
        {
            [dataDic setObject:currentNodeContent forKey:@"result"];
        }
    }
    /************************** Set payment method *******************************************/
    if ([myDelegate.methodName isEqualToString: @"shoppingCartPaymentMethodRequestParam"])
    {
        if ([elementname isEqualToString:@"result"])
        {
            [dataDic setObject:currentNodeContent forKey:@"result"];
        }
    }
    /************************** Set payment method *******************************************/
    if ([myDelegate.methodName isEqualToString: @"shoppingCartOrderRequestParam"])
    {
        if ([elementname isEqualToString:@"result"])
        {
            [dataDic setObject:currentNodeContent forKey:@"result"];
        }
    }
    /************************** Set payment method *******************************************/
    if ([myDelegate.methodName isEqualToString: @"generalApiNewQuoteRequestParam"])
    {
        NSLog(@"entered in generalApiNewQuoteRequestParam");

        if ([elementname isEqualToString:@"newQuoteId"])
        {
            NSLog(@"entered in newQuoteId");

            [dataDic setObject:currentNodeContent forKey:@"newQuoteId"];
        }
    }

    
    /************************** Message *******************************************/
    
    if ([elementname isEqualToString:@"status"])
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
    }    currentNodeContent=nil;
    
    
    
    
    
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
