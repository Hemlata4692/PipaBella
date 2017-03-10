//
//  GeneralInfoXMLParser.h
//  PipaBella
//
//  Created by Hema on 10/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneralInfoXMLParser : NSObject<NSXMLParserDelegate>
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
-(id) loadxmlArrayByData:(NSData *)data;

@end
