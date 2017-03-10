//
//  MyAccountViewController.m
//  PipaBella
//
//  Created by Ranosys on 16/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "MyAccountViewController.h"
#import "MyAccountTableViewCell.h"
#import "LandingViewController.h"
#import "TrackOrderViewController.h"
#import "MyLoyalityPointsViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CartViewController.h"
#import "TrackEmailViewController.h"
#import "RateAppViewController.h"
#import "AppViralityUI.h"

@interface MyAccountViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>{
    NSArray *myAccountListArray, *exploreMyAccountListArray;
    UIView *mainView;
}
@property (weak, nonatomic) IBOutlet UITableView *myAccountTableView;
@property (weak, nonatomic) IBOutlet UIView *userInfoContainerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shortNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginOrSignupButton;
@property (weak, nonatomic) IBOutlet UIButton *cartIcon;

@end

@implementation MyAccountViewController
@synthesize myAccountTableView,userInfoContainerView,userImageView,nameLabel,emailLabel,shortNameLabel,loginOrSignupButton,cartIcon;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=@"MY ACCOUNT";
    //    [AppViralityUI showWelcomeScreenFromController:self];
    //    // Add observer for Signup button click on Welcome page & Register Signup Conversion event
    //    [[NSNotificationCenter defaultCenter] addObserverForName:@"SignUpClicked" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
    //        NSLog(@"Sign up clicked");
    //        [AppVirality saveConversionEvent:@{@"eventName":@"Signup"} completion:^(NSDictionary *conversionResult,NSError* error) {
    //            if (conversionResult&&[conversionResult objectForKey:@"success"]&&![[conversionResult valueForKeyPath:@"friend.rewardid"] isEqual:[NSNull null]]) {
    //                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[[conversionResult valueForKey:@"success"] boolValue]?@"Hurray..! you will receive your reward shortly":@"Reward is on for first time users, but you can still earn by referring your friends" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //                [alert show];
    //
    //            }
    //        }];
    //    }];
    //
    //    //App-level Reward notifications (or) Add Observer to get notified on any Successful conversion
    //    [[NSNotificationCenter defaultCenter] addObserverForName:@"conversionResult" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
    //        NSLog(@"conversion Event result %@",[note valueForKeyPath:@"userInfo.result"]);
    //    }];
    //    [self registerForRemoteNotifications];
    
    myAccountListArray = [[NSArray alloc]initWithObjects:
                          @"WAITLIST",@"MY ORDERS",@"TRACK ORDER",
                          @"CURRENCY",@"MANAGE ADDRESSES",@"GENERAL INFO",
                          @"MY LOYALTY POINTS",@"REFER AND EARN",@"CHANGE PASSWORD",@"RATE OUR APP",@"LOGOUT",
                          nil];
    
    exploreMyAccountListArray = [[NSArray alloc]initWithObjects:
                                 @"WAITLIST",@"MY ORDERS",@"TRACK ORDER",
                                 @"CURRENCY",@"MANAGE ADDRESSES",@"GENERAL INFO",
                                 @"MY LOYALTY POINTS",@"REFER AND EARN",@"RATE OUR APP",
                                 nil];
    
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2;
    self.userImageView.clipsToBounds = YES;
    NSString *profileUrl = [UserDefaultManager getValue:@"profiePicture"];
    if ([UserDefaultManager getValue:@"profiePicture"] == nil ) {
        shortNameLabel.hidden = NO;
    }
    else
    {
        shortNameLabel.hidden = YES;
        [userImageView sd_setImageWithURL:[NSURL URLWithString:profileUrl] placeholderImage:[UIImage imageNamed:@""]];
    }
    
    [self setViewFrame];
    mainView.hidden = YES;
    
    nameLabel.text=[UserDefaultManager getValue:@"customer_name"];
    emailLabel.text=[UserDefaultManager getValue:@"userEmail"];
    
    if (nameLabel.text.length<=2) {
        shortNameLabel.text=nameLabel.text;
    }
    else
    {
        NSString *shortname = nameLabel.text;
        shortNameLabel.text = [shortname substringToIndex:2];
    }
    // NSLog(@"customer id is %@",[UserDefaultManager getValue:@"customer_id"]);
    
    if ([UserDefaultManager getValue:@"customer_id"] == nil)
    {
        if ( [UserDefaultManager getValue:@"customer_name"]==nil) {
            loginOrSignupButton.hidden = NO;
        }
        loginOrSignupButton.hidden = NO;
        
    }
    else
    {
        loginOrSignupButton.hidden = YES;
    }
}
//- (void)registerForRemoteNotifications{
//
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
//    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    }
//    else{
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
//    }
//#else
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
//#endif
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [UIView animateWithDuration:0.6f animations:^{
        
        mainView.hidden = YES;
        
    }];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    myDelegate.tabId = (int)self.tabBarController.selectedIndex;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if ([[UserDefaultManager getValue:@"cartData"] count]>0)
    {
        NSMutableArray *tmpArray =[UserDefaultManager getValue:@"cartData"];
        NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)[tmpArray count]];
        cartIcon.badgeValue = count;
        cartIcon.badgeBGColor = [UIColor colorWithRed:237.0/255.0 green:0.0/255.0 blue:140.0/255.0 alpha:1.0];
        
        
    }
    else
    {
        cartIcon.badgeBGColor = [UIColor clearColor];
    }
    
    
}



#pragma mark - end

#pragma mark - Object framing
-(void)setViewFrame{
    mainView = [[UIView alloc] initWithFrame:
                CGRectMake(0,0,
                           [[UIScreen mainScreen] applicationFrame].size.width,
                           [[UIScreen mainScreen] applicationFrame].size.height)];
    mainView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.8];
    
    UITapGestureRecognizer *menuItemTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideCartPopup:)];
    menuItemTapGestureRecognizer.numberOfTapsRequired    = 1;
    menuItemTapGestureRecognizer.delegate                = self;
    [mainView addGestureRecognizer:menuItemTapGestureRecognizer];
    
    UIView *emptyBagView = [[UIView alloc] initWithFrame:
                            CGRectMake(120,20,mainView.frame.size.width-120,120)];
    emptyBagView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0, 0, emptyBagView.frame.size.width, 1.5);
    topBorder.backgroundColor = [UIColor colorWithRed:133.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1.0].CGColor;
    [emptyBagView.layer addSublayer:topBorder];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, emptyBagView.frame.size.height-1.5, emptyBagView.frame.size.width, 1.5);
    bottomBorder.backgroundColor = [UIColor colorWithRed:133.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1.0].CGColor;
    [emptyBagView.layer addSublayer:bottomBorder];
    
    CALayer *leftBorder = [CALayer layer];
    leftBorder.frame = CGRectMake(0, 0, 1.5, emptyBagView.frame.size.height);
    leftBorder.backgroundColor = [UIColor colorWithRed:133.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1.0].CGColor;
    [emptyBagView.layer addSublayer:leftBorder];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0,0,40,40)];
    [closeButton setTitle:@"X" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UILabel *shoppingLabel = [[UILabel alloc] initWithFrame:
                              CGRectMake(30,22,emptyBagView.frame.size.width-80,30)];
    shoppingLabel.text = @"MY SHOPPING BAG";
    shoppingLabel.backgroundColor = [UIColor clearColor];
    shoppingLabel.textColor = [UIColor colorWithRed:60.0/255.0 green:60.0/255.0 blue:60.0/255.0 alpha:1.0];
    if (self.view.frame.size.width<=320) {
        shoppingLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    }
    else
    {
        shoppingLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    }
    
    // shoppingLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    shoppingLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UIButton *emptyBagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [emptyBagButton setFrame:CGRectMake(shoppingLabel.frame.origin.x+shoppingLabel.frame.size.width+10,22,25,25)];
    [emptyBagButton setImage:[UIImage imageNamed:@"cart.png"] forState:UIControlStateNormal];
    
    
    UILabel *bagLabel = [[UILabel alloc] initWithFrame:
                         CGRectMake(25,54,emptyBagView.frame.size.width-60,20)];
    bagLabel.text = @"YOUR BAG IS EMPTY";
    bagLabel.backgroundColor = [UIColor clearColor];
    bagLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    bagLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UILabel *keepShoppingLabel = [[UILabel alloc] initWithFrame:
                                  CGRectMake(25,74,emptyBagView.frame.size.width-45,30)];
    keepShoppingLabel.text = @"Life's too short. Keep shopping";
    keepShoppingLabel.backgroundColor = [UIColor clearColor];
    keepShoppingLabel.textColor = [UIColor colorWithRed:138.0/255.0 green:138.0/255.0 blue:138.0/255.0 alpha:1.0];
    keepShoppingLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
    keepShoppingLabel.textAlignment = NSTextAlignmentCenter;
    
    [emptyBagView addSubview:emptyBagButton];
    [emptyBagView addSubview:closeButton];
    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [emptyBagView addSubview:keepShoppingLabel];
    [emptyBagView addSubview:shoppingLabel];
    [emptyBagView addSubview:bagLabel];
    [mainView addSubview:emptyBagView];
    [self.navigationController.view addSubview:mainView];
    
}
-(void)hideCartPopup:(UITapGestureRecognizer *)gestureRecognizer
{
    [self closeAction:nil];
}
-(void)closeAction :(id)sender
{
    [UIView animateWithDuration:0.6f animations:^{
        
        mainView.hidden = YES;
        
    }];
    
}
#pragma mark - end

#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (([UserDefaultManager getValue:@"customer_id"]  == nil)) {
        return 3;
    }
    else
    {
        return 3;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if (section == 0) {
        return 3;
    }
    else if (section == 1)
    {
        return 5;
    }
    else
    {
        if (([UserDefaultManager getValue:@"customer_id"]  == nil))
        {
            return 1;
        }
        else{
            return 3;
        }
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"myAccountCell";
    MyAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[MyAccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.contentView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0f];
    
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, cell.frame.size.height)];
    left.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0];
    if((indexPath.section == 0 && indexPath.row == 2) || (indexPath.section == 1 && indexPath.row == 3) || (indexPath.section==2 && indexPath.row == 1) ){
        cell.separatorLabel.hidden = NO;
    }
    
    if(indexPath.section == 0 )
    {
        if (([UserDefaultManager getValue:@"customer_id"] == nil)) {
            [cell.nameLabel setText:[exploreMyAccountListArray objectAtIndex:indexPath.row]];
        }
        else{
            [cell.nameLabel setText:[myAccountListArray objectAtIndex:indexPath.row]];
        }
    }
    else if(indexPath.section == 1 )
    {
        if (([UserDefaultManager getValue:@"customer_id"] == nil)){
            [cell.nameLabel setText:[exploreMyAccountListArray objectAtIndex:indexPath.row+3]];
        }
        else{
            [cell.nameLabel setText:[myAccountListArray objectAtIndex:indexPath.row+3]];
        }
    }
    else if(indexPath.section == 2 )
    {
        
        // [cell.nameLabel setText:[myAccountListArray objectAtIndex:indexPath.row+8]];
        
        
        if (([UserDefaultManager getValue:@"customer_id"] == nil))
        {
            [cell.nameLabel setText:[exploreMyAccountListArray objectAtIndex:indexPath.row+8]];
        }
        else{
            [cell.nameLabel setText:[myAccountListArray objectAtIndex:indexPath.row+8]];
        }
        
        
    }
    [cell.contentView addSubview:left];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 7;
    }
    else
        return 15;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0 && indexPath.row==0)
    {
        if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL)) {
            
            UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TrackEmailViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"TrackEmailViewController"];
            [self.navigationController pushViewController:view animated:YES];
            
            //            myDelegate.istoast = true;
            
            //            if([[UIScreen mainScreen] bounds].size.height>480)
            //            {
            //                myDelegate.toastMessage = @"SIGN IN to add products to your wishlist          X";
            //            }
            //            else{
            //                myDelegate.toastMessage = @"SIGN IN to add products to your wishlist    X";
            //            }
            //
            //            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            //            myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
            //            myDelegate.window.rootViewController = myDelegate.navigationController;
            //
            
        }
        else
        {
            UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"WaitListProductViewController"];
            [self.navigationController pushViewController:view animated:YES];
            
        }
    }
    
    else if (indexPath.section == 0 && indexPath.row==1)
    {
        if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL)) {
            myDelegate.istoast = true;
            if([[UIScreen mainScreen] bounds].size.height>480)
            {
                myDelegate.toastMessage = @"You need to login first";
            }
            else{
                myDelegate.toastMessage = @"You need to login first";
            }
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
            myDelegate.window.rootViewController = myDelegate.navigationController;
        }
        else
        {
            UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryViewController"];
            [self.navigationController pushViewController:view animated:YES];
        }
    }
    
    else if (indexPath.section == 0 && indexPath.row==2)
    {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TrackOrderViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"TrackOrderViewController"];
        [self.navigationController pushViewController:view animated:YES];
    }
    
    else if (indexPath.section == 1 && indexPath.row==0)
    {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"CurrencyViewController"];
        [self.navigationController pushViewController:view animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row==1)
    {
        if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL)) {
            myDelegate.istoast = true;
            if([[UIScreen mainScreen] bounds].size.height>480)
            {
                myDelegate.toastMessage = @"You need to login first";
            }else{
                myDelegate.toastMessage = @"You need to login first";
            }
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
            myDelegate.window.rootViewController = myDelegate.navigationController;
        }
        else
        {
            UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"ManageAddressesViewController"];
            [self.navigationController pushViewController:view animated:YES];
        }
    }
    else if (indexPath.section == 1 && indexPath.row==2) {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"QuickLinksViewController"];
        [self.navigationController pushViewController:view animated:YES];
    }
    
    else if (indexPath.section == 1 && indexPath.row==3)
    {
        if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
        {
            myDelegate.istoast = true;
            if([[UIScreen mainScreen] bounds].size.height>480)
            {
                myDelegate.toastMessage = @"You need to login first";
            }else{
                myDelegate.toastMessage = @"You need to login first";
            }
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
            myDelegate.window.rootViewController = myDelegate.navigationController;
        }
        else
        {
            UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MyLoyalityPointsViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"MyLoyalityPointsViewController"];
            [self.navigationController pushViewController:view animated:YES];
        }
    }
    else if (indexPath.section == 1 && indexPath.row==4)
    {
        if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
        {
            myDelegate.istoast = true;
            if([[UIScreen mainScreen] bounds].size.height>480)
            {
                myDelegate.toastMessage = @"You need to login first";
            }else{
                myDelegate.toastMessage = @"You need to login first";
            }
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
            myDelegate.window.rootViewController = myDelegate.navigationController;
        }
        else
        {
            
            [AppViralityUI showGrowthHack:GrowthHackTypeWordOfMouth FromController:self];
        }
    }
    else if (indexPath.section == 2 && indexPath.row==0)
    {
        
        
        if (([UserDefaultManager getValue:@"customer_id"] == nil))
        {
            UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            RateAppViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"RateAppViewController"];
            view.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1f];
            [view setModalPresentationStyle:UIModalPresentationOverCurrentContext];
            //[self presentViewController:view animated: YES completion:nil];
            
            
            CATransition* transition = [CATransition animation];
            transition.duration = 0.3f;
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFromTop;
            [self.navigationController.view.layer addAnimation:transition
                                                        forKey:kCATransition];
            [self addChildViewController:view];
            [self.view addSubview:view.view];
            
        }
        else
        {
            if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL)) {
                myDelegate.istoast = true;
                if([[UIScreen mainScreen] bounds].size.height>480)
                {
                    myDelegate.toastMessage = @"You need to login first";
                }else{
                    myDelegate.toastMessage = @"You need to login first";
                }
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
                myDelegate.window.rootViewController = myDelegate.navigationController;
            }
            else{
                
                UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
                [self.navigationController pushViewController:view animated:YES];
            }
        }
        
    }
    
    else if (indexPath.section == 2 && indexPath.row==1) {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RateAppViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"RateAppViewController"];
        view.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1f];
        [view setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        //[self presentViewController:view animated: YES completion:nil];
        
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
        [self.navigationController.view.layer addAnimation:transition
                                                    forKey:kCATransition];
        [self addChildViewController:view];
        [self.view addSubview:view.view];
    }
    
    else if (indexPath.section == 2 && indexPath.row==2) {
        
        //Facebook logout
        if (!([FBSession activeSession].state != FBSessionStateOpen &&
              [FBSession activeSession].state != FBSessionStateOpenTokenExtended))
        {
            [[FBSession activeSession] closeAndClearTokenInformation];
        }
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
        
        myDelegate.window.rootViewController = myDelegate.navigationController;
        [UserDefaultManager removeValue:@"customer_id"];
        [UserDefaultManager removeValue:@"customer_name"];
        [UserDefaultManager removeValue:@"userEmail"];
        [UserDefaultManager removeValue:@"profiePicture"];
        [UserDefaultManager removeValue:@"quoteId"];
        [UserDefaultManager removeValue:@"sessionId"];
        [UserDefaultManager removeValue:@"total_cart_item"];
        [UserDefaultManager removeValue:@"cartData"];
        [UserDefaultManager removeValue:@"wishListData"];
        userImageView.image = [UIImage imageNamed:@""];
    }
    
    
}
#pragma mark - end

#pragma mark - Button action
- (IBAction)loginOrSignupButtonAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [UserDefaultManager setValue:nil key:@"wishListData"];
    [UserDefaultManager removeValue:@"userEmail"];
    myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
    
    myDelegate.window.rootViewController = myDelegate.navigationController;
    
    
}
- (IBAction)cartIconClickedAction:(id)sender {
    if ([[UserDefaultManager getValue:@"cartData"] count]<1) {
        [UIView animateWithDuration:0.6f animations:^{
            mainView.hidden = NO;
            
        }];
    }
    else
    {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CartViewController *cartView =[storyboard instantiateViewControllerWithIdentifier:@"CartViewController"];
        [self.navigationController pushViewController:cartView animated:YES];
        
    }
    
}
#pragma mark - end

@end
