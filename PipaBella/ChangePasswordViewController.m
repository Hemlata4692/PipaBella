//
//  ChangePasswordViewController.m
//  PipaBella
//
//  Created by Ranosys on 21/10/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "AccountService.h"
#import "MyAccountViewController.h"
@interface ChangePasswordViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate,AlertControllerDelegate>
{
    NSArray *textFields;
    // UIAlertView *alert;
    AlertController *alertController;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *changePasswordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassField;
@property (weak, nonatomic) IBOutlet UIButton *changePasswordButton;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@end

@implementation ChangePasswordViewController
@synthesize scrollView,mainContainerView,oldPasswordField,changePasswordField,confirmPassField,changePasswordButton;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"CHANGE PASSWORD";
    
    //Adding textfield to array
    textFields = @[oldPasswordField,changePasswordField,confirmPassField];
    //Keyboard toolbar action to display toolbar with keyboard to move next,previous
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFields]];
    [self.keyboardControls setDelegate:self];
    
    // Corner radius and border
    [self setCornerRadius];
    [self addborder];
    [self setBorder];
    [self addPadding];
    
    // [[AlertController sharedManager] setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated

{
    [super viewWillDisappear:animated];
    [self.keyboardControls resignFirstResponder];
}

-(void) setCornerRadius
{
    [oldPasswordField setCornerRadius:2.0f];
    [changePasswordField setCornerRadius:2.0f];
    [confirmPassField setCornerRadius:2.0f];
    [changePasswordButton setCornerRadius:2.0f];
    
}

-(void)addborder
{
    [oldPasswordField addBorder:oldPasswordField];
    [changePasswordField addBorder:changePasswordField];
    [confirmPassField addBorder:confirmPassField];
}

-(void)setBorder
{
    [changePasswordButton addBorder:changePasswordButton color:[UIColor colorWithRed:154.0/255.0 green:153.0/255.0 blue:154.0/255.0 alpha:1.0]];
    
}
-(void)addPadding
{
    [oldPasswordField addTextFieldPaddingWithoutImages:oldPasswordField];
    [changePasswordField addTextFieldPaddingWithoutImages:changePasswordField];
    [confirmPassField addTextFieldPaddingWithoutImages:confirmPassField];
}


#pragma mark - end

#pragma mark - Keyboard controls delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    UIView *view;
    
    if ([[UIDevice currentDevice].systemVersion floatValue]< 7.0) {
        view = field.superview.superview;
    } else {
        view = field.superview.superview.superview;
    }
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
    scrollView.scrollEnabled = NO;
    [self.keyboardControls setActiveField:textField];
    if([[UIScreen mainScreen] bounds].size.height<=480)
    {
        [scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-15) animated:YES];
    }
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    scrollView.scrollEnabled = YES;
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end

#pragma mark - Validations
- (BOOL)performValidationsForChangePassword
{
    
    if ([oldPasswordField isEmpty] || [changePasswordField isEmpty]|| [confirmPassField isEmpty])
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"All fields are required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        });
        
        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"All fields are required" parentView:self.view];
      //  [self.view makeToast:@"All fields are required" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        
        return NO;
        
        
    }
    else{
        if ([oldPasswordField.text isEqualToString:changePasswordField.text]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Old password and new password are same. Please try a different one." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//            });
            [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Old password and new password are same. Please try a different one" parentView:self.view];
            //[self.view makeToast:@"Old password and new password are same. Please try a different one" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
            return NO;
        }
        
        //Password confirmation for new password entered
        else if (![changePasswordField.text isEqualToString:confirmPassField.text]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Passwords do not match." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//            });
             [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Passwords do not match" parentView:self.view];
          //  [self.view makeToast:@"Passwords do not match" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
            return NO;
        }
        else
        {
            if (changePasswordField.text.length<6 )
            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your password must be atleast 6 characters long." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                    [alert show];
//                });
                [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Your password must be atleast 6 characters long" parentView:self.view];
              //  [self.view makeToast:@"Your password must be atleast 6 characters long" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
                return NO;
            }
            else
            {
                return YES;
            }
        }
    }
}
#pragma mark - end
#pragma mark - Webservice
-(void)changePassword
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
        
        [[AccountService sharedManager] changePassword:oldPasswordField.text newPassword:changePasswordField.text success:^(id data)
         {
             //Handle fault cases
             dispatch_async(dispatch_get_main_queue(), ^{
                 // code here
                 [myDelegate StopIndicator];
                 if ([data objectForKey:@"status"] != nil || [data objectForKey:@"status"] != NULL) {
                     if ([[data objectForKey:@"status"] intValue] == 1)
                     {
                         UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your password has been changed successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
    if(alertView.tag==1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Button action
- (IBAction)changePasswordBtnAction:(id)sender {
    [oldPasswordField resignFirstResponder];
    [changePasswordField resignFirstResponder];
    [confirmPassField resignFirstResponder];
    
    if([self performValidationsForChangePassword])
    {
        [myDelegate ShowIndicator];
        [self performSelector:@selector(changePassword) withObject:nil afterDelay:.1];
    }
    
}
#pragma mark - end
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
