//
//  HomeXMLParser.m
//  PipaBella
//
//  Created by Ranosys on 07/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "HomeXMLParser.h"
#import "DiscoverDataModel.h"

@implementation HomeXMLParser
{
    NSMutableDictionary *dataDic;
    DiscoverDataModel *whatsNewData;
    NSMutableArray *whatsNewArray;
}
@synthesize currentNodeContent;
@synthesize responseString,status;
//Shared instance init
+ (id)sharedManager
{
    static HomeXMLParser *sharedMyManager = nil;
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
    whatsNewArray=[[NSMutableArray alloc]init];
    parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    return whatsNewArray;
    
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
    if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
    {
        whatsNewData=[[DiscoverDataModel alloc]init];
    }

}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    /************************** What's New *******************************************/
    
    if ([elementname isEqualToString:@"title"]) {
        whatsNewData.title = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"image_url"]) {
        whatsNewData.imageUrl = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"id"]) {
        whatsNewData.productId = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"type"]) {
        whatsNewData.type = currentNodeContent;
    }

    
    else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
    {
        
        [whatsNewArray addObject:whatsNewData];
        NSLog(@"MainCatArray : %lu", (unsigned long) whatsNewArray.count);
       
    }
   
    else if ([elementname isEqualToString:@"status"])
    {
        NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        
        responseString = currentNodeContent;
        responseString = [responseString stringByTrimmingCharactersInSet:
                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        status=responseString;
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
