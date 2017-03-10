//
//  TrackOrderViewController.m
//  PipaBella
//
//  Created by Hema on 09/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "TrackOrderViewController.h"
#import "TrackOrderDetailViewController.h"

@interface TrackOrderViewController ()<BSKeyboardControlsDelegate>
{
    NSArray *textFields;
}
@property (weak, nonatomic) IBOutlet UITextField *orderIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@end

@implementation TrackOrderViewController
@synthesize orderIdTextField,emailAddressTextField;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"TRACK YOUR ORDER";
    
    //Adding textfield to array
    textFields = @[orderIdTextField,emailAddressTextField];
    //Keyboard toolbar action to display toolbar with keyboard to move next,previous
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFields]];
    [self.keyboardControls setDelegate:self];
    if(!([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
    {
        emailAddressTextField.text = [UserDefaultManager getValue:@"userEmail"];
    }
    [self addBorder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Localytics tagScreen:@"Track Order View"];
}

-(void)addBorder
{
    [orderIdTextField addBorder:orderIdTextField];
    [emailAddressTextField addBorder:emailAddressTextField];
    [self addPadding];
}

-(void)addPadding
{
    [emailAddressTextField addTextFieldPaddingWithoutImages:emailAddressTextField];
    [orderIdTextField addTextFieldPaddingWithoutImages:orderIdTextField];
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
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame=CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

#pragma mark - end

#pragma mark - Textfield delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];
    if([[UIScreen mainScreen] bounds].size.height<=568)
    {
        if (textField==orderIdTextField)
        {
            self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-64, self.view.frame.size.width, self.view.frame.size.height);
        }
        else if (textField==emailAddressTextField)
        {
            self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-120, self.view.frame.size.width, self.view.frame.size.height);
        }
    }
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if([[UIScreen mainScreen] bounds].size.height<=568)
    {
        //         self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-64, self.view.frame.size.width, self.view.frame.size.height);
        if (textField==orderIdTextField)
        {
            self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+64, self.view.frame.size.width, self.view.frame.size.height);
        }
        else if (textField==emailAddressTextField)
        {
            self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+120, self.view.frame.size.width, self.view.frame.size.height);
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        if([[UIScreen mainScreen] bounds].size.height<=568)
        {
            //         self.view.frame=CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width, self.view.frame.size.height);
        }
        
        //        self.view.frame=CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end

#pragma mark - Check validations
- (BOOL)performValidationsToContinue
{
    
    if ([orderIdTextField isEmpty] || [emailAddressTextField isEmpty] )
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"All fields are required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        });
        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"All fields are required" parentView:self.view];
       // [self.view makeToast:@"All fields are required" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        return NO;
    }
    else if (![emailAddressTextField isValidEmail])
    {
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter a valid email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        });
        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter a valid email address" parentView:self.view];
       // [self.view makeToast:@"Please enter a valid email address" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        
        
        return NO;
    }
    else
    {
        return YES;
    }
}
#pragma mark - end

#pragma mark - Button actions
- (IBAction)submitBtnAction:(id)sender
{
    [_keyboardControls.activeField resignFirstResponder];
    
    if([self performValidationsToContinue])
    {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TrackOrderDetailViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"TrackOrderDetailViewController"];
        view.orderIdData = orderIdTextField.text;
        view.emailAddress = emailAddressTextField.text;
        [self.navigationController pushViewController:view animated:YES];
    }
}
#pragma mark - end

@end
