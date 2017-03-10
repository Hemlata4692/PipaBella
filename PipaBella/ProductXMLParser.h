//
//  ProductXMLParser.h
//  PipaBella
//
//  Created by Ranosys on 18/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductXMLParser : NSObject
<NSXMLParserDelegate>
{
    
    NSXMLParser	*parser;
    
}
@property(nonatomic,retain) NSMutableString	*currentNodeContent;
@property(nonatomic,retain) NSString	*responseString;
@property(nonatomic,retain) NSString	*status;
@property(nonatomic,retain)NSMutableArray * catArray;
@property(nonatomic,retain)NSMutableArray * colorArray;
@property(nonatomic,retain)NSMutableDictionary *dataDic;
@property(nonatomic,retain)NSMutableDictionary *productDetailDict;
@property(nonatomic,retain)NSMutableArray *imageArary;
@property(nonatomic,retain)NSMutableArray *subGiftArray;
@property(nonatomic,retain)NSMutableArray *mainGiftArray;

@property(nonatomic,retain)NSMutableArray *sizeGuideArray;
//Shared instance init
+ (id)sharedManager;
//end

-(id) loadxmlByData:(NSData *)data;
-(id) loadxmlByDataArray:(NSData *)data;
@end
