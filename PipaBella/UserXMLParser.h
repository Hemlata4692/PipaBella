//
//  XMLParser.h
//  SleepApp
//
//  Created by Isolpc32 on 04/03/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserXMLParser : NSObject<NSXMLParserDelegate>
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