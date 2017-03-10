//
//  QuizXMLParser.h
//  PipaBella
//
//  Created by Ranosys on 24/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuizXMLParser : NSObject

<NSXMLParserDelegate>
{
    
    NSXMLParser	*parser;
    
}
@property(nonatomic,retain) NSMutableString	*currentNodeContent;
@property(nonatomic,retain) NSString	*responseString;
@property(nonatomic,retain) NSString	*status;
@property(nonatomic,retain)NSMutableArray * array;

//Shared instance init
+ (id)sharedManager;
//end

-(id) loadxmlByDataArray:(NSData *)data;


@end
