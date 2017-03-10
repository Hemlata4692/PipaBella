//
//  PaymentXMLParser.h
//  PipaBella
//
//  Created by Ranosys on 12/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentXMLParser : NSObject<NSXMLParserDelegate>
{
    
    NSXMLParser	*parser;
    
}
@property(nonatomic,retain) NSMutableString	*currentNodeContent;
@property(nonatomic,retain) NSString	*responseString;
@property(nonatomic,retain) NSString	*status;
//Shared instance init
+ (id)sharedManager;
//end

-(NSMutableDictionary *) loadxmlByData:(NSData *)data;



@end
