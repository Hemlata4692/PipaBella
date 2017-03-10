//
//  GeneralInfoXMLParser.m
//  PipaBella
//
//  Created by Hema on 10/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "GeneralInfoXMLParser.h"
#import "CurrencyDataModel.h"

@implementation GeneralInfoXMLParser
{
    NSMutableDictionary *dataDic;
    CurrencyDataModel *currencyData;
    NSMutableArray *currencyDataArray;
}
@synthesize currentNodeContent;
@synthesize responseString,status;
//Shared instance init
+ (id)sharedManager
{
    static GeneralInfoXMLParser *sharedMyManager = nil;
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
    //NSLog(@"entered in loadxmlByData");
    status=nil;
    [dataDic removeAllObjects];
    parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    return dataDic;
    
}

-(id) loadxmlArrayByData:(NSData *)data
{
    //NSLog(@"entered in loadxmlByData");
    status=nil;
    currencyDataArray=[[NSMutableArray alloc]init];
    parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    return currencyDataArray;
    
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
    if ([elementname isEqualToString:@"currency"])
    {
        currencyData=[[CurrencyDataModel alloc]init];
    }

}


- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
 
    /************************** General Info *******************************************/
    
    if ([elementname isEqualToString:@"content"])
    {
        //NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        responseString = currentNodeContent;
        [dataDic setObject:currentNodeContent forKey:@"content"];
        
    }
    
     /************************** Currency *******************************************/
    
   else if ([elementname isEqualToString:@"currency_code"])
   {
        currencyData.currencyCode = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"currency_flag"])
    {
        currencyData.currencyFlag = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"currency_rates"])
    {
        currencyData.convertingPrice = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"currency_symbol"])
    {
        currencyData.currencySymbol = currentNodeContent;
    }

    else if ([elementname isEqualToString:@"currency"])
    {
        [currencyDataArray addObject:currencyData];
        //NSLog(@"MainCatArray : %lu", (unsigned long) currencyDataArray.count);
        
    }

    else if ([elementname isEqualToString:@"status"])
    {
        //NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        
        responseString = currentNodeContent;
        responseString = [responseString stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        status=responseString;
         [dataDic setObject:currentNodeContent forKey:@"status"];
    }
    else if ([elementname isEqualToString:@"message"])
    {
       // NSLog(@"status **** %@",status );
        
        if (![status isEqual:@"1"] && status!=nil)
        {
            //NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            
        }
    }
    else if ([elementname isEqualToString:@"faultstring"])
    {
        {
            
            //NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
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
