//
//  LoginViewController.m
//  PipaBella
//
//  Created by Ranosys on 19/10/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "LoginViewController.h"
#import "UIImage+deviceSpecificMedia.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UserService.h"
#import "HomeViewController.h"
#import "ProductService.h"
#import "LandingViewController.h"
@interface LoginViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate,AlertControllerDelegate,FBLoginViewDelegate>
{
    NSArray *textFields;
}

-(void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *loginWithFacebookButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (strong, nonatomic) NSString *userEmailFb;
@property (strong, nonatomic) NSString *userFirstNameFb;
@property (strong, nonatomic) NSString *userLastNameFb;
@property (strong, nonatomic) NSString *fbAccessToken;
@property (strong, nonatomic) NSString *fbId;
@end

@implementation LoginViewController
@synthesize scrollView,mainContainerView;
@synthesize backgroundImage,emailField,passwordField,userEmailFb,fbAccessToken,userLastNameFb,userFirstNameFb,fbId;
@synthesize loginButton,loginWithFacebookButton,forgotPasswordButton,createAccountButton;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    emailField.delegate=self;
    passwordField.delegate=self;
    
    //Keyboard toolbar action to display toolbar with keyboard to move next,previous
    textFields = @[emailField,passwordField];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFields]];
    [self.keyboardControls setDelegate:self];
    
    [loginButton addBorder:loginButton];
    
    
    //facebook
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Observe for the custom notification regarding the session state change.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFBSessionStateChangeWithNotification:)
                                                 name:@"SessionStateChangeNotification"
                                               object:nil];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
     myDelegate.istoast= false;
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Localytics tagScreen:@"Login View"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [Localytics tagEvent:@"User logged_in"];
    if (myDelegate.istoast)
    {
        [MozTopAlertView showWithType:MozAlertTypeInfo text:myDelegate.toastMessage parentView:self.view];
//        if([[UIScreen mainScreen] bounds].size.height>480)
//        {
//            //  [self.view makeToast:@"SIGN IN to add products to your cart                          X" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
//            [MozTopAlertView showWithType:MozAlertTypeInfo text:myDelegate.toastMessage parentView:self.view];
//           // [self.view makeToast:myDelegate.toastMessage image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
//        }
//        else
//        {
//            //[self.view makeToast:@"SIGN IN to add products to your cart                   X" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
//            
//            [self.view makeToast:myDelegate.toastMessage image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
//        }
    }
    
    [super viewWillAppear:animated];
    // hide navigation bar
    [[self navigationController] setNavigationBarHidden:YES];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)statusHide
{
    [UIView animateWithDuration:0.1 animations:^() {
        [self setNeedsStatusBarAppearanceUpdate];
    }completion:^(BOOL finished){}];
}

#pragma mark - end

#pragma mark - Keyboard controls delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    UIView *view;
    view = field.superview.superview.superview;
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [keyboardControls.activeField resignFirstResponder];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - end

#pragma mark - Textfield delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [self.keyboardControls setActiveField:textField];
    if (textField!=emailField) {
        [scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-( textField.frame.size.height+70)) animated:YES];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - end

#pragma mark - Button actions
- (IBAction)loginButtonClickAction:(id)sender
{
    
    //     [self.view makeToast:@"Discount successfully applied to your shopping bag!" image:[UIImage imageNamed:@"sign.png"] color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
    
    [self.keyboardControls.activeField resignFirstResponder];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    if([self performValidationsForLogin])
    {
        // [UserDefaultManager removeValue:@"currencyCode"];
        [myDelegate ShowIndicator];
        [self performSelector:@selector(loginUser) withObject:nil afterDelay:.1];
    }
    
}

- (IBAction)closeLoginScreen:(id)sender
{
    
    if (myDelegate.istoast)
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {
        for (UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[LandingViewController class]])
            {
                [self.navigationController popToViewController:controller animated:NO];
                
                break;
            }
        }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (IBAction)loginWithFBClickAction:(id)sender
{
    // [UserDefaultManager removeValue:@"currencyCode"];
    
    [[FBSession activeSession] closeAndClearTokenInformation];
    if ([FBSession activeSession].state != FBSessionStateOpen && [FBSession activeSession].state != FBSessionStateOpenTokenExtended)
    {
        
        [myDelegate openActiveSessionWithPermissions:@[@"public_profile", @"email"] allowLoginUI:YES];
        [[FBSession activeSession] closeAndClearTokenInformation];
        
    }
    else
    {
        // Close an existing session.
        [[FBSession activeSession] closeAndClearTokenInformation];
    }
    
}

- (IBAction)forgotPasswordClickAction:(id)sender
{
    UIViewController *nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [self.navigationController pushViewController:nextView animated:YES];
}

- (IBAction)createAccountClickAction:(id)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *registerView =[storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self.navigationController pushViewController:registerView animated:YES];
}

#pragma mark - end

-(void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification{
    
    
    
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    NSDictionary *userInfo = [notification userInfo];
    
    FBSessionState sessionState = (int)[[userInfo objectForKey:@"state"] integerValue];
    fbAccessToken = [FBSession activeSession].accessTokenData.accessToken;
    NSError *error = [userInfo objectForKey:@"error"];
    
    if (!error) {
        if (sessionState == FBSessionStateOpen)
        {
            [myDelegate ShowIndicator];
            [FBRequestConnection startWithGraphPath:@"me"
                                         parameters:@{@"fields": @"first_name, last_name, picture.type(normal), email"}
                                         HTTPMethod:@"GET"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      if (!error)
                                      {
                                          
                                          userEmailFb=[result objectForKey:@"email"];
                                          userFirstNameFb=[result objectForKey:@"first_name"];
                                          userLastNameFb=[result objectForKey:@"last_name"];
                                          [UserDefaultManager setValue:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"] key:@"profiePicture"];
                                          fbId=[result objectForKey:@"id"];
                                          
                                          [self performSelector:@selector(userLoginFb) withObject:nil afterDelay:.1];
                                          
                                      }
                                      
                                  }];
        }
        else if (sessionState == FBSessionStateClosed || sessionState == FBSessionStateClosedLoginFailed)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate StopIndicator];
            });
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
        });
        
    }
}

#pragma mark - Webservice

-(void)getMyCartList
{
    
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
            return ;
            
        });
    }
    [[ProductService sharedManager] cartListing:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [myDelegate StopIndicator];
                            [myDelegate StopIndicator];
                            if(data==nil)
                            {
                                [myDelegate StopIndicator];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                    [alert1 show];
                                });
                                
                            }
                            else
                            {
                                
                                [myDelegate StopIndicator];
                                NSMutableArray *tempArray=[UserDefaultManager getValue:@"cartData"];
                                NSMutableArray * cartArray = [tempArray mutableCopy];
                                NSMutableArray * tmpAry = [tempArray mutableCopy];
                                for (int i =0; i<tempArray.count; i++) {
                                    NSMutableDictionary * cartDict1 = [tempArray objectAtIndex:i];
                                    if (![[cartDict1 objectForKey:@"parent_item_id"] isEqualToString:@"\n"])
                                    {
                                        [tmpAry removeObject:cartDict1];
                                        
                                    }
                                }
                                [cartArray removeAllObjects];
                                cartArray = [tmpAry mutableCopy];
                                [UserDefaultManager setValue:cartArray key:@"cartData"];
                                
                                UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                //                                        HomeViewController *homeView =[storyboard instantiateViewControllerWithIdentifier:@"tabbar"];
                                ////                                        myDelegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                                //                                        [myDelegate.window setRootViewController:homeView];
                                //                                        [myDelegate.window makeKeyAndVisible];
                                
                                
                                if ([[UserDefaultManager getValue:@"QuizCompleted"] isEqualToString:@"true"])
                                {
                                    
                                    HomeViewController *homeView =[storyboard instantiateViewControllerWithIdentifier:@"tabbar"];
                                    //                                        myDelegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                                    [myDelegate.window setRootViewController:homeView];
                                    [myDelegate.window makeKeyAndVisible];
                                    
                                }
                                else
                                {
                                    UIViewController *quizView =[storyboard instantiateViewControllerWithIdentifier:@"QuizViewController"];
                                    [self.navigationController pushViewController:quizView animated:YES];
                                }
                                
                                
                                
                            }
                        });
         
     }
                                        failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
    
}



-(void)userLoginFb
{
    
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
        });
    }
    else
    {
        
        NSDictionary *fbParameters=@{@"first_name":userFirstNameFb,@"last_name":userLastNameFb,@"email":userEmailFb,@"id":fbId,@"token":fbAccessToken};
        
        [[UserService sharedManager] userLogin:@"" password:@"" facebook:@"1" fbparams:fbParameters success:^(id data)
         {
             //Handle fault cases
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                // code here
                                
                                
                                if ([data objectForKey:@"result"] != nil || [data objectForKey:@"result"] != NULL)
                                {
                                    if ([[data objectForKey:@"status"] intValue] == 1)
                                    {
                                        [UserDefaultManager setValue:userEmailFb key:@"userEmail"];
                                        [UserDefaultManager setValue:[data objectForKey:@"customer_id"] key:@"customer_id"];
                                        [[FBSession activeSession] closeAndClearTokenInformation];
                                        [self getMyCartList];
                                        
                                    }
                                }
                            });
             
             
         }
         
                                       failure:^(NSError *error)
         {
             //Handle if response is nil
             [myDelegate StopIndicator];
             [[FBSession activeSession] closeAndClearTokenInformation];
             
         }] ;
    }
    
    
    
    
}



-(void)loginUser
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
        });
    }
    else
    {
        NSDictionary *fbParameters=@{};
        [[UserService sharedManager] userLogin:emailField.text password:passwordField.text facebook:@"0" fbparams:fbParameters success:^(id data)
         {
             //Handle fault cases
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                // code here
                                
                                if ([data objectForKey:@"result"] != nil || [data objectForKey:@"result"] != NULL) {
                                    if ([[data objectForKey:@"status"] intValue] == 1)
                                    {
                                        
                                        [UserDefaultManager setValue:emailField.text key:@"userEmail"];
                                        [UserDefaultManager setValue:[data objectForKey:@"customer_id"] key:@"customer_id"];
                                        NSLog(@"emailField.text is %@ and default value is %@",emailField.text,[UserDefaultManager getValue:@"userEmail"]);
                                        
                                        [self getMyCartList];
                                        
                                        
                                    }
                                    else
                                    {
                                        [myDelegate StopIndicator];
                                        [MozTopAlertView showWithType:MozAlertTypeInfo text:[data objectForKey:@"message"] parentView:self.view];
                                     //   [self.view makeToast:[data objectForKey:@"message"] image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
                                        
                                    }
                                    
                                }
                                else
                                {
                                    [myDelegate StopIndicator];
                                }
                            });
             
             
         }
         
                                       failure:^(NSError *error)
         {
             //Handle if response is nil
             
         }] ;
    }
}

#pragma mark - end

#pragma mark - Check validations
- (BOOL)performValidationsForLogin
{
    
    if ([emailField isEmpty] || [passwordField isEmpty])
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//        UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"All fields are required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//            });
        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"All fields are required" parentView:self.view];
       // [self.view makeToast:@"All fields are required" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        return NO;
    }
    else
    {
        
        if ([emailField isValidEmail])
        {
            if (passwordField.text.length<6 )
            {
                
//                 UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your password must be atleast 6 characters long." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
                
                [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Your password must be atleast 6 characters long" parentView:self.view];
               // [self.view makeToast:@"Your password must be atleast 6 characters long" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
                return NO;
                
            }
            
            else
            {
                return YES;
            }
        }
        else
        {
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter a valid email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
            [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter a valid email address" parentView:self.view];
          //  [self.view makeToast:@"Please enter a valid email address" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
            return NO;
        }
    }
}
#pragma mark - end
@end
