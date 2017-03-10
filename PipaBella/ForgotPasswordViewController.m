//
//  ForgotPasswordViewController.m
//  PipaBella
//
//  Created by Ranosys on 19/10/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "UIImage+deviceSpecificMedia.h"
#import "LoginViewController.h"
#import "UserService.h"
#import "LandingViewController.h"
@interface ForgotPasswordViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;


@end

@implementation ForgotPasswordViewController
@synthesize scrollView,mainContainerView,emailField,submitButton;
@synthesize backgroundImage;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [submitButton addBorder:submitButton];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Textfield delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end

#pragma mark - Validations
- (BOOL)performValidationsForChangePassword
{
    
    if ([emailField isEmpty])
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        });
         [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter your email address" parentView:self.view];
        //[self.view makeToast:@"Please enter your email address" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        return NO;
    }
    else
    {
        
        if (![emailField isValidEmail])
        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter a valid email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//            });
             [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter a valid email address" parentView:self.view];
           // [self.view makeToast:@"Please enter a valid email address" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];

            return NO;
        }
        else
        {
            return YES;
        }
}

}
#pragma mark - end

#pragma mark - Button Actions
- (IBAction)submitButtonAction:(id)sender
{
    [emailField resignFirstResponder];
    if([self performValidationsForChangePassword])
    {
    [myDelegate ShowIndicator];
    [self performSelector:@selector(forgotPassword) withObject:nil afterDelay:.1];
    }
}
- (IBAction)backToSignIn:(id)sender
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
- (IBAction)closeAction:(id)sender
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

#pragma mark - end

#pragma mark - Webservice
-(void)forgotPassword
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
        
        [[UserService sharedManager] forgotPassword:emailField.text  success:^(id data)
         {
             //Handle fault cases
             dispatch_async(dispatch_get_main_queue(), ^{
                 // code here
                 [myDelegate StopIndicator];
                 UIAlertView *alert;
                 if ([data objectForKey:@"status"] != nil || [data objectForKey:@"status"] != NULL) {
                     if ([[data objectForKey:@"status"] intValue] == 1)
                     {
                         alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:[data objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                         alert.tag=1;
                         [alert show];
                         
                     }

                 }
               });
             
         }
                                            failure:^(NSError *error)
         {
             //Handle if response is nil
             
         }] ;
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1)
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
    
}

#pragma mark - end
@end
