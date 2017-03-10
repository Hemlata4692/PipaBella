//
//  AccountXMLParser.h
//  PipaBella
//
//  Created by Ranosys on 02/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountXMLParser : NSObject<NSXMLParserDelegate>
{
    
    NSXMLParser	*parser;
    
}
@property(nonatomic,retain) NSMutableString	*currentNodeContent;
@property(nonatomic,retain) NSString	*responseString;
@property(nonatomic,retain) NSString	*status;
//Shared instance init
+ (id)sharedManager;
//end

-(id) loadxmlByData:(NSData *)data;
-(id) loadxmlByDataArray:(NSData *)data;
@end
