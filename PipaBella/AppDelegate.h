//
//  AppDelegate.h
//  PipaBella
//
//  Created by Ranosys on 16/10/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain) UINavigationController *navigationController;
//Indicator
- (void)ShowIndicator;
- (void)StopIndicator;

//Facebook
-(void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI;

//Session ID
@property(nonatomic) int isSessionId;
@property(nonatomic,retain) NSString* quizCompleted;
@property(nonatomic,retain) NSString* methodName;
@property(nonatomic,retain) NSString* toastMessage;
@property(nonatomic,retain) NSString* giftMessage;
@property(nonatomic,assign)bool isRegistered;
@property(nonatomic,assign)bool istoast;
@property(nonatomic,assign)int tabId;
@property(nonatomic,assign)int wishlistItems;
@property(nonatomic,assign)bool isBuildGift;
@property(nonatomic,assign)int counter;
@end

