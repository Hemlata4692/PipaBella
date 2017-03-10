//
//  ReturnOrderXMLParser.m
//  PipaBella
//
//  Created by Ranosys on 07/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "ReturnOrderXMLParser.h"
#import "ReturnOrderModel.h"

@implementation ReturnOrderXMLParser

{
    NSMutableDictionary *dataDic;
    
    ReturnOrderModel *returnOrderDataModel;
    NSMutableArray *itemDetailArray;
    NSMutableArray *reasonArray;
    NSMutableArray *packingArray;
    NSMutableArray *typeArray;
    
    NSString * reasonTag;
    BOOL isFaultString;
    
}
@synthesize currentNodeContent;
@synthesize responseString,status;

//Shared instance init
+ (id)sharedManager
{
    static ReturnOrderXMLParser *sharedMyManager = nil;
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
    isFaultString = NO;
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
    //     if ([elementname isEqualToString:@"rmastepdetails"])
    //    {
    //        itemDetailArray=[[NSMutableArray alloc]init];
    //
    //    }
    
    if ([elementname isEqualToString:@"items_details"])
    {
        reasonTag=@"items_details";
        
        itemDetailArray=[[NSMutableArray alloc]init];
        returnOrderDataModel.checker = NO;
    }
    
    else if ([elementname isEqualToString:@"reason"])
    {
        reasonArray=[[NSMutableArray alloc]init];
        reasonTag=@"reason";
    }
    else if ([elementname isEqualToString:@"packing"])
    {
        packingArray=[[NSMutableArray alloc]init];
        reasonTag=@"packing";
    }
    else if ([elementname isEqualToString:@"type"])
    {
        typeArray=[[NSMutableArray alloc]init];
        reasonTag=@"type";
    }
    
    
    else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
    {
        returnOrderDataModel=[[ReturnOrderModel alloc]init];
    }
    
    else if ([elementname isEqualToString:@"BOGUS"])
    {
        returnOrderDataModel=[[ReturnOrderModel alloc]init];
    }
    
    
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    /************************** Return order *******************************************/
    
    if ([myDelegate.methodName isEqualToString: @"generalApiRmaRequestParam"])
    {
        if ([elementname isEqualToString:@"faultcode"])
        {
            status = currentNodeContent;
        }
        
        if ([elementname isEqualToString:@"order_id"])
        {
            returnOrderDataModel.OrderId = currentNodeContent;
        }
        
        else if ([elementname isEqualToString:@"name"])
        {
            if ([reasonTag isEqualToString:@"reason"])
            {
                returnOrderDataModel.reasonName = currentNodeContent;
                
            }
            else if ([reasonTag isEqualToString:@"type"])
            {
                returnOrderDataModel.typeName = currentNodeContent;
                
            }
            else if ([reasonTag isEqualToString:@"items_details"])
            {
                returnOrderDataModel.name = currentNodeContent;
            }
            else
            {
                returnOrderDataModel.packingName = currentNodeContent;
            }
        }
        else if ([elementname isEqualToString:@"id"])
        {
            if ([reasonTag isEqualToString:@"reason"])
            {
                returnOrderDataModel.reasonId = currentNodeContent;
                
            }
            else if ([reasonTag isEqualToString:@"packing"])
            {
                returnOrderDataModel.packingId = currentNodeContent;
            }
            else if ([reasonTag isEqualToString:@"type"])
            {
                returnOrderDataModel.typeId = currentNodeContent;
            }
        }
        else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
            if ([reasonTag isEqualToString:@"reason"])
            {
                [reasonArray addObject:returnOrderDataModel];
                
            }
            else if ([reasonTag isEqualToString:@"packing"])
            {
                [packingArray addObject:returnOrderDataModel];
            }
            else if ([reasonTag isEqualToString:@"type"])
            {
                [typeArray addObject:returnOrderDataModel];
            }
        }
        else if ([elementname isEqualToString:@"sku"])
        {
            returnOrderDataModel.sku = currentNodeContent;
        }
        else if ([elementname isEqualToString:@"item_id"])
        {
            returnOrderDataModel.itemId = currentNodeContent;
        }
        else if ([elementname isEqualToString:@"qty"]) {
            returnOrderDataModel.qty = currentNodeContent;
        }
        else if ([elementname isEqualToString:@"isvisible"]) {
            returnOrderDataModel.isVisible = currentNodeContent;
        }
        else if ([elementname isEqualToString:@"image"]) {
            returnOrderDataModel.image = currentNodeContent;
        }
        else if ([elementname isEqualToString:@"BOGUS"] )
        {
            [itemDetailArray addObject:returnOrderDataModel];
            NSLog(@"MainCatArray : %lu", (unsigned long) itemDetailArray.count);
        }
        else if ([elementname isEqualToString:@"shipping_address"] )
        {
            
            [dataDic setObject:currentNodeContent forKey:@"address"];
            
        }
        else if ([elementname isEqualToString:@"policy"] )
        {
            
            [dataDic setObject:currentNodeContent forKey:@"policy"];
            
        }
        else if ([elementname isEqualToString:@"rmastepdetails"] )
        {
            if (!isFaultString)
            {
                NSLog(@"itemDetailArray.count = %lu",(unsigned long)itemDetailArray.count);
                if (itemDetailArray.count >= 1)
                {
                    [dataDic setObject:itemDetailArray forKey:@"rmastepdetails"];
                    [dataDic setObject:reasonArray forKey:@"reason"];
                    [dataDic setObject:packingArray forKey:@"packing"];
                    [dataDic setObject:typeArray forKey:@"type"];
                    
                }
                
            }
            
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
               // [self showAlertMessage:responseString];
                //isFaultString = YES;
            }
        }
        else if ([elementname isEqualToString:@"faultstring"])
        {
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