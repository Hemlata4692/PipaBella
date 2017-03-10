//
//  HomeXMLParser.h
//  PipaBella
//
//  Created by Ranosys on 07/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeXMLParser : NSObject<NSXMLParserDelegate>
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
