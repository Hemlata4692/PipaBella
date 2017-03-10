//
//  AppDelegate.m
//  PipaBella
//
//  Created by Ranosys on 16/10/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "AppDelegate.h"
#import "GAI.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MMMaterialDesignSpinner.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "LandingViewController.h"
#import "AppVirality.h"


@interface AppDelegate ()
{
    UIImageView *logoImage;
    UIView *loaderView;
}
@property (nonatomic, strong) MMMaterialDesignSpinner *spinnerView;
@property (nonatomic, strong) UIView *spinView;
@end

@implementation AppDelegate
static NSString *AppVirality_AppKey = @"b00032e5a2c74f1bb6f7a5b80075eb4e";

id<GAITracker> tracker;
@synthesize navigationController,isSessionId,quizCompleted,methodName,spinView,isRegistered,tabId,istoast,toastMessage,wishlistItems,isBuildGift,counter,giftMessage;

#pragma mark - Global indicator view

- (void)ShowIndicator
{
    self.spinView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.window.screen.bounds.size.width, self.window.screen.bounds.size.height)];
    self.spinView.backgroundColor = [UIColor clearColor];
    UIView *fadedView=[[UIView alloc]initWithFrame:self.spinView.bounds];
    [fadedView setBackgroundColor:[UIColor blackColor]];
    [fadedView setAlpha:0.1];
    [self.spinView addSubview:fadedView];
    [self.spinView sendSubviewToBack:fadedView];
    UIImageView *imgVw = [[UIImageView alloc]initWithFrame:CGRectMake(self.window.screen.bounds.size.width/2-25, self.spinView.frame.size.height/2-25, 50, 50)];
    imgVw.image = [UIImage imageNamed:@"dimond.png"];
    [self runSpinAnimationOnView:imgVw duration:1.5 rotations:M_PI_4 repeat:1000000000000000000];
    [self.spinView addSubview:imgVw];
    [self.window addSubview:self.spinView];
}
- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
- (void)StopIndicator
{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
             [self.spinView removeFromSuperview];
    
                   });
}
#pragma mark - end


static void onUncaughtException(NSException * exception)
{
    NSLog(@"uncaught exception: %@", exception.description);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 5;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-70253865-1"];
    
    
    
    
     //NSLog(@"Login through appDelegate ...................");
    
    //Push notifications
    UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    //Localytics integration
    [Localytics autoIntegrate:@"8650e94c469fcf389a61d51-ab8a5198-dc5b-11e5-0ebc-00cef1388a40" launchOptions:launchOptions];
   
    NSSetUncaughtExceptionHandler(&onUncaughtException);
    //AppVirality Integration
    [AppVirality attributeUserBasedonCookie:AppVirality_AppKey OnCompletion:^(BOOL success, NSError *error) {
        
        NSDictionary * userDetails = nil;
        //if your App has login/logout and would like to allow multiple users to use single device, uncomment below lines
        //[AppVirality enableInitWithEmail];
        //userDetails = @{@"EmailId":@"USER-EMAIL-ID",@"ReferrerCode":@"REFERRER-CODE",@"isExistingUser":@"false"};
        // Init AppVirality SDK
        [AppVirality initWithApiKey:AppVirality_AppKey WithParams:userDetails OnCompletion:^(NSDictionary *referrerDetails,NSError*error) {
            
//            NSLog(@"user key %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userkey"]);
//            NSLog(@"User has Referrer %@", referrerDetails);
        }];
    }];
    [AppVirality registerAsDebugDevice:^(BOOL success, NSError *error) {
        NSLog(@"Register Test Device Response: %d ", success);
    }];
    [self registerForRemoteNotifications];
    
    //giftMessage = [[NSString alloc]init];
    giftMessage = @"";
    NSMutableDictionary * currencyDict = [NSMutableDictionary new];
    [currencyDict setObject:@"₹" forKey:@"symbol"];
    [currencyDict setObject:@"INR" forKey:@"code"];
    [currencyDict setObject:@"1.0" forKey:@"price"];
    [UserDefaultManager setValue:currencyDict key:@"selectedCurrency"];
    counter=0;
    istoast = false;
    //toastMessage = [NSString stringWithFormat:@"You need to login first        X"];
    
//
    //set navigation title color
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:81.0/255.0 green:82.0/255.0 blue:82.0/255.0 alpha:1.0], NSForegroundColorAttributeName, [UIFont systemFontOfSize:22 weight:UIFontWeightRegular], NSFontAttributeName, nil]];
    
    isSessionId=1;
  [UserDefaultManager removeValue:@"sessionId"];
    
    //View navigation
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
   // NSLog(@"customerId sessionId %@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"customer_id"],[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionId"]);
    
    if (([[NSUserDefaults standardUserDefaults] objectForKey:@"customer_id"]!=nil) && ([[[NSUserDefaults standardUserDefaults] objectForKey:@"QuizCompleted"]isEqualToString:@"true"]))
    {
        [Localytics setCustomerId:[UserDefaultManager getValue:@"customer_id"]];
        [Localytics setCustomerEmail:[UserDefaultManager getValue:@"userEmail"]];
        [Localytics setCustomerFullName:[UserDefaultManager getValue:@"customer_name"]];
        
        HomeViewController * objView=[storyboard instantiateViewControllerWithIdentifier:@"tabbar"];
           self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
          [self.window setRootViewController:objView];
         [self.window makeKeyAndVisible];
    }
    else
    {
        //NSLog(@"enterd after login with fb ...................");

        LandingViewController * infoView = [storyboard instantiateViewControllerWithIdentifier:@"LandingViewController"];
        [self.navigationController setViewControllers: [NSArray arrayWithObject: infoView]
                                             animated: YES];
    }

      return YES;
}
- (void)registerForRemoteNotifications{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
#endif
}


-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    // Prepare the Device Token for Registration (remove spaces and < >)
    NSString *devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    [AppVirality setUserDetails:@{@"pushDeviceToken":devToken} Oncompletion:^(BOOL success, NSError *error) {
        
    }];
    //NSLog(@"My token is: %@", devToken);
}

-(void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error

{
    //NSLog(@"Failed to get token, error: %@", error);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // [FBAppEvents activateApp];
    if ([FBSession activeSession].state == FBSessionStateCreatedTokenLoaded) {
        [self openActiveSessionWithPermissions:nil allowLoginUI:NO];
    }
    
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

-(void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI
{
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:allowLoginUI
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                      // Create a NSDictionary object and set the parameter values.
                                      NSDictionary *sessionStateInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                        session, @"session",
                                                                        [NSNumber numberWithInteger:status], @"state",
                                                                        error, @"error",
                                                                        nil];
                                      
                                      // Create a new notification, add the sessionStateInfo dictionary to it and post it.
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"SessionStateChangeNotification"
                                                                                          object:nil
                                                                                        userInfo:sessionStateInfo];
                                      
                                  }];
    
}

@end
