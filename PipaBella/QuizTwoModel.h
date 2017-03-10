//
//  QuizTwoModel.h
//  PipaBella
//
//  Created by Ranosys on 24/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuizTwoModel : NSObject
@property(nonatomic,retain)NSString * quizId;
@property(nonatomic,retain)NSString * question;
@property(nonatomic,retain)NSString * answer;
@property(nonatomic,retain)NSMutableArray * answerArray;

@end
