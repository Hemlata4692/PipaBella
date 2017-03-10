//
//  RegisterViewController.m
//  PipaBella
//
//  Created by Ranosys on 19/10/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserService.h"
#import "UIImage+deviceSpecificMedia.h"
#import "LoginViewController.h"
#import "AppViralityUI.h"
#import "LandingViewController.h"
@interface RegisterViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate>{
    NSArray *textFields;
    AlertController *alertController;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (nonatomic, strong) NSString *rewardPoints;
@property (weak, nonatomic) IBOutlet UITextField *referField;
@end

@implementation RegisterViewController
@synthesize scrollView,mainContainerView,nameField,emailField,passwordField,confirmPasswordField,signUpButton,referField,rewardPoints;
@synthesize backgroundImage;
#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    myDelegate.isRegistered = true;
    //Adding textfield to array
    textFields = @[nameField,emailField,passwordField,confirmPasswordField,referField];
    //Keyboard toolbar action to display toolbar with keyboard to move next,previous
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFields]];
    [self.keyboardControls setDelegate:self];
    
    [signUpButton addBorder:signUpButton];
    
        
    //  Show Welcome screen
//    [AppViralityUI showWelcomeScreenFromController:self];
//    
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
    
    //App-level Reward notifications (or) Add Observer to get notified on any Successful conversion
    [[NSNotificationCenter defaultCenter] addObserverForName:@"conversionResult" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSLog(@"conversion Event result %@",[note valueForKeyPath:@"userInfo.result"]);
    }];
  //  [self registerForRemoteNotifications];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [Localytics tagEvent:@"User registered"];
    // hide navigation bar
    [[self navigationController] setNavigationBarHidden:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Localytics tagScreen:@"Register View"];
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
    scrollView.scrollEnabled = YES;
    [self.keyboardControls setActiveField:textField];
    if (textField!=nameField) {
        [scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-( textField.frame.size.height+90)) animated:YES];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.keyboardControls.activeField resignFirstResponder];
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end

#pragma mark - Register view methods
- (BOOL)performValidationsForRegister
{
    
    if (([nameField isEmpty])||([emailField isEmpty])||([passwordField isEmpty])||([confirmPasswordField isEmpty]))
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//        UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"All fields are required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//            });
        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"All fields are required" parentView:self.view];
        //[self.view makeToast:@"All fields are required" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        return NO;
    }
    else
    {
        
        if ([emailField.text hasPrefix:@"."])
        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please entre a valid email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//                });
            [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter a valid email address" parentView:self.view];
          //  [self.view makeToast:@"Please enter a valid email address" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
            return NO;
        }
        if ([emailField isValidEmail])
        {
            if ([passwordField isEmpty])
            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//                      });
                [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter password" parentView:self.view];
              //  [self.view makeToast:@"Please enter the password" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
                return NO;
            }
            else if (passwordField.text.length<6)
            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your password must be atleast 6 characters long." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//                     });
                [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Your password must be atleast 6 characters long" parentView:self.view];
             //   [self.view makeToast:@"Your password must be atleast 6 characters long" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
                return NO;
            }
            else if (!([passwordField.text isEqualToString:confirmPasswordField.text]))
            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Passwords do not match." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//                    });
                [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Passwords do not match" parentView:self.view];
               // [self.view makeToast:@"Passwords do not match" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
                return NO;
            }
            
            else
            {
                return YES;
            }
        }
        else
        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter a valid email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//                });
            [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter a valid email address" parentView:self.view];
           // [self.view makeToast:@"Please enter a valid email address" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
            return NO;
        }
    }
}
#pragma mark - end

#pragma mark - Webservice
-(void)registerUser
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
        
        
        [[UserService sharedManager] registerUser:nameField.text email:emailField.text password:passwordField.text success:^(NSMutableDictionary * data)
         {
             //Handle fault cases
             dispatch_async(dispatch_get_main_queue(), ^{
                 // code here
                [myDelegate StopIndicator];
                 
                 if (data !=nil && data.count!=0)
                 {
                  //  [[NSNotificationCenter defaultCenter] postNotificationName:@"SignUpClicked" object:nil];
                     //  Show Welcome screen
                       //  [AppViralityUI showWelcomeScreenFromController:self];
                     
                     [AppVirality saveConversionEvent:@{@"eventName":@"Signup"} completion:^(NSDictionary *conversionResult,NSError* error)
                     {
                         if (conversionResult&&[conversionResult objectForKey:@"success"]&&![[conversionResult valueForKeyPath:@"friend.rewardid"] isEqual:[NSNull null]]) {
                             rewardPoints=[conversionResult valueForKeyPath:@"friend.amount"];
//                             UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[[conversionResult valueForKey:@"success"] boolValue]?@"Hurray..! you will receive your reward shortly":@"Reward is on for first time users, but you can still earn by referring your friends" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                             [alert show];
                             [[UserService sharedManager]earnRewards:[UserDefaultManager getValue:@"customer_id"] points:rewardPoints success:^(NSMutableDictionary * data)
                              {
                                  
                              }failure:^(NSError *error){
                                  
                              }];
                             
                         }
                     }];

                     if ([[data objectForKey:@"status"] isEqualToString:@"1"]) {
                         
                         [UserDefaultManager setValue:emailField.text key:@"userEmail"];
                         [UserDefaultManager setValue:nameField.text key:@"customer_name"];
                         //                      [UserDefaultManager setValue:[data objectForKey:@"result"] key:@"customer_id"];
                         
                         
                         UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                         //                     UIViewController *searchView =[storyboard instantiateViewControllerWithIdentifier:@"tabbar"];
                         //                     [self.navigationController pushViewController:searchView animated:YES];
                         
                         if ([[UserDefaultManager getValue:@"QuizCompleted"] isEqualToString:@"true"])
                         {
                             [myDelegate StopIndicator];
                             UIViewController *searchView =[storyboard instantiateViewControllerWithIdentifier:@"tabbar"];
                             [self.navigationController pushViewController:searchView animated:YES];
                         }
                         else
                         {
                             [myDelegate StopIndicator];
                             UIViewController *quizView =[storyboard instantiateViewControllerWithIdentifier:@"QuizViewController"];
                             [self.navigationController pushViewController:quizView animated:YES];
                         }
                     }
                 }
                 else{
                 dispatch_async(dispatch_get_main_queue(), ^{
                     UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     [alert1 show];
                 });
                 }
                 
             });
             
         }
         
                                          failure:^(NSError *error)
         {
             //Handle if response is nil
             
         }] ;
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

#pragma mark - end

- (IBAction)signUpButtonAction:(id)sender
{
    [self.keyboardControls.activeField resignFirstResponder];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
   
//    [AppVirality submitReferralCode:referField.text completion:^(BOOL success, NSError *error) {
//        
//        if (success) {
//            NSLog(@"Referral Code applied Successfully");
//        }
//        else{
//            NSLog(@"Invalid Referral Code");
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"SignUpClicked" object:nil];
//    }];
    
    

    if([self performValidationsForRegister])
    {
        [myDelegate ShowIndicator];
        [self performSelector:@selector(registerUser) withObject:nil afterDelay:.1];
    }
    
}
- (IBAction)backToSIgnIn:(id)sender
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[LoginViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            
            break;
        }
    }
}

- (IBAction)cancelSignUpView:(id)sender
{
    
    if (myDelegate.istoast)
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
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


@end
