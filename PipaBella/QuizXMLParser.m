//
//  QuizXMLParser.m
//  PipaBella
//
//  Created by Ranosys on 24/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "QuizXMLParser.h"
#import "QuizTwoModel.h"


@implementation QuizXMLParser
{
     NSMutableDictionary *dataDic;
    NSMutableDictionary *answerDic;
     NSMutableArray *quizListArray;
     QuizTwoModel *quizListData;
    NSString *quizId;
    NSString *question;
}
@synthesize currentNodeContent;
@synthesize responseString,status;
@synthesize array;



//Shared instance init
+ (id)sharedManager
{
    static QuizXMLParser *sharedMyManager = nil;
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
-(id) loadxmlByDataArray:(NSData *)data
{
    status=nil;
    // [dataDic removeAllObjects];
   // quizListArray = [[NSMutableArray alloc]init];
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
    if ([myDelegate.methodName isEqualToString: @"generalApiQuizQuestionGetRequestParam"])
    {
        
        if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
            quizListData=[[QuizTwoModel alloc]init];
        }
        else if([elementname isEqualToString:@"answer"]){
            quizListData.answerArray = [NSMutableArray new];
        }
        else if([elementname isEqualToString:@"BOGUS"]){
            answerDic = [NSMutableDictionary new];
        }
        
    }

}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([myDelegate.methodName isEqualToString: @"generalApiQuizQuestionGetRequestParam"])
    {
        if ([elementname isEqualToString:@"quizid"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            quizId = currentNodeContent;
            
            
        }
        
        else if ([elementname isEqualToString:@"question"])
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            quizListData.question = currentNodeContent;
            
            
        }
        else if ([elementname isEqualToString:@"BOGUS"])
        {
            [quizListData.answerArray addObject:answerDic];
            
        }
        else if ([elementname isEqualToString:@"text"])
        {
            [answerDic setObject:currentNodeContent forKey:@"text"];
            
            
        }
        else if ([elementname isEqualToString:@"image"])
        {
            [answerDic setObject:currentNodeContent forKey:@"image"];
            
        }
        else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
            [dataDic setObject:quizListData forKey:quizId];
           
            
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
