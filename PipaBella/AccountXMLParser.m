//
//  AccountXMLParser.m
//  PipaBella
//
//  Created by Ranosys on 02/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "AccountXMLParser.h"
#import "ManageAddressDataModel.h"

@implementation AccountXMLParser
{
    NSMutableDictionary *dataDic;
    ManageAddressDataModel *myAddressDataModel;
    NSMutableArray *myAddressArray;
    NSString* key;
    
}
@synthesize currentNodeContent;
@synthesize responseString,status;
//Shared instance init
+ (id)sharedManager
{
    static AccountXMLParser *sharedMyManager = nil;
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
    myAddressArray=[[NSMutableArray alloc]init];
    [dataDic removeAllObjects];
    parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    return dataDic;
    
}

-(id) loadxmlByDataArray:(NSData *)data
{
    //NSLog(@"entered in loadxmlByData");
    status=nil;
    myAddressArray=[[NSMutableArray alloc]init];
    parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    return myAddressArray;
    
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
    if ([elementname isEqualToString:@"complexObjectArray"])
    {
        myAddressDataModel=[[ManageAddressDataModel alloc]init];
    }

}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
        /************************** My address list *******************************************/
    if ([elementname isEqualToString:@"result"] )
    {
        if (![currentNodeContent isEqualToString:@""] && ![currentNodeContent isEqualToString:@"\n"] && currentNodeContent != nil) {
           [dataDic setObject:currentNodeContent forKey:@"result"];
        }
    }
    else if ([elementname isEqualToString:@"customer_address_id"]) {
        myAddressDataModel.customerAddressId = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"city"]) {
        myAddressDataModel.city = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"country_id"]) {
        myAddressDataModel.countryId = currentNodeContent;
        key = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"region_id"]) {
        myAddressDataModel.regionId = currentNodeContent;
        key = currentNodeContent;
    }
        else if ([elementname isEqualToString:@"code"]) {
        myAddressDataModel.regionCode = currentNodeContent;
        [dataDic setObject:currentNodeContent forKey:key];
    }
    else if ([elementname isEqualToString:@"name"]) {
       
        if (![currentNodeContent isEqualToString:@""] && ![currentNodeContent isEqualToString:@"\n"] && currentNodeContent != nil) {
             myAddressDataModel.countryName = currentNodeContent;
            [dataDic setObject:currentNodeContent forKey:key];
        }
        
    }
      else if ([elementname isEqualToString:@"firstname"]) {
            myAddressDataModel.firstname = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"lastname"]) {
        myAddressDataModel.lastname = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"street"]) {
        myAddressDataModel.street = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"telephone"]) {
        myAddressDataModel.telephone = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"region_id"]) {
        myAddressDataModel.regionId = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"region"]) {
        myAddressDataModel.stateName = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"postcode"]) {
        myAddressDataModel.postcode = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"is_default_billing"]) {
        myAddressDataModel.isDefaultBilling = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"is_default_shipping"]) {
        myAddressDataModel.isDefaultShipping = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"complexObjectArray"])
    {
            [myAddressArray addObject:myAddressDataModel];
          //NSLog(@"MainCatArray : %lu", (unsigned long) myAddressArray.count);
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
        //NSLog(@"status **** %@",status );
        
        if (![status isEqual:@"1"] && status!=nil)
        {
            //NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
             [self showAlertMessage:responseString];
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
