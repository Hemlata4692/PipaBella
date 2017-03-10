//
//  TrackEmailViewController.m
//  PipaBella
//
//  Created by Monika on 2/4/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "TrackEmailViewController.h"
#import "WaitListProductViewController.h"
@interface TrackEmailViewController ()
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)submitBtnAction:(id)sender;

@end

@implementation TrackEmailViewController
@synthesize emailField;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"WAITLIST";
    [self addBorder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addBorder
{
    [emailField addBorder:emailField];
    [self addPadding];
}

-(void)addPadding
{
    [emailField addTextFieldPaddingWithoutImages:emailField];
}

-(void)viewWillDisappear:(BOOL)animated
{
    emailField.text=@"";
    [super viewWillDisappear:animated];
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

#pragma mark - Check validations
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //    [UIView animateWithDuration:0.3 animations:^{
    //        if([[UIScreen mainScreen] bounds].size.height<=568)
    //        {
    //            //         self.view.frame=CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width, self.view.frame.size.height);
    //        }
    //
    //        //        self.view.frame=CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    //    }];
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)performValidationsToContinue
{
    
    if ([emailField isEmpty] )
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"All fields are required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        });
        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"All fields are required" parentView:self.view];
        //[self.view makeToast:@"All fields are required" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        return NO;
    }
    else if (![emailField isValidEmail])
    {
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter a valid email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        });
        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter a valid email address" parentView:self.view];
     //   [self.view makeToast:@"Please enter a valid email address" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        
        
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
    if([self performValidationsToContinue])
    {
       
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WaitListProductViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"WaitListProductViewController"];
        view.mailId = emailField.text;
        [self.navigationController pushViewController:view animated:YES];
    }
}
@end
