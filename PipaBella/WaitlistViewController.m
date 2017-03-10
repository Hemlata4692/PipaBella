//
//  WaitlistViewController.m
//  PipaBella
//
//  Created by Sumit on 29/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "WaitlistViewController.h"
#import "ProductService.h"
@interface WaitlistViewController ()
{

    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *mailField;

}

@end

@implementation WaitlistViewController
@synthesize productId;
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"WAITLIST";
    [nameField addTextFieldPaddingWithoutImages:nameField];
    [mailField addTextFieldPaddingWithoutImages:mailField];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end
#pragma mark - Webservice
-(void)addtoWaitlistService
{
    
    [[ProductService sharedManager] addTowaitList:productId name:nameField.text email:mailField.text success:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            if (data != nil)
                            {
                                [myDelegate StopIndicator];
                                nameField.text =@"";
                                mailField.text=@"";
                                
                                if ([[data objectForKey:@"status"] isEqualToString:@"1"])
                                {
                                    MozTopAlertView *alertView = [MozTopAlertView showWithType:MozAlertTypeSuccess text:[data objectForKey:@"message"] parentView:self.view];
                                    alertView.dismissBlock = ^(){
                                        NSLog(@"dismissBlock");
                                    };
                                  //  [self.view makeToast:[data objectForKey:@"message"] image:[UIImage imageNamed:@"sign.png"] color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
                                }
                                else
                                {
                                    [MozTopAlertView showWithType:MozAlertTypeWarning text:[data objectForKey:@"message"] doText:nil doBlock:^{
                                        
                                    } parentView:self.view];
                                   // [self.view makeToast:[data objectForKey:@"message"] image:[UIImage imageNamed:@"excl.png"] color:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]];
                                }

//
//                                    [self.view makeToast:@"You have subscribed to be on the waitlist for this product successfully." image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
//                                
                                
                                
                                
                            }
                            else
                            {
                                [myDelegate StopIndicator];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                    [alert show];
                                });
                            }
                            
                            
                        });
         
         
     }
       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }];
    
    
    
    
}
#pragma mark - end
#pragma mark - Button actions
- (IBAction)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)submit:(id)sender
{
    nameField.text = [nameField.text stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceCharacterSet]];
    mailField.text = [mailField.text stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceCharacterSet]];
    
    if ([nameField.text isEqualToString:@""])
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        });
        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter your name" parentView:self.view];
      //  [self.view makeToast:@"Please enter your name" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        return;
    }
    else if ([mailField.text isEqualToString:@""])
    {

        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter your email address" parentView:self.view];
       // [self.view makeToast:@"Please enter your email address" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        return;
    }
    else if (![mailField isValidEmail])
    {

        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter a valid email address" parentView:self.view];
      //  [self.view makeToast:@"Please enter a valid email address" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        return;
    
    }
    [nameField resignFirstResponder];
    [mailField resignFirstResponder];
    [myDelegate ShowIndicator];
    [self performSelector:@selector(addtoWaitlistService) withObject:nil afterDelay:.2];
}
#pragma mark - end
#pragma mark - Textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if(textField==nameField)
    {
        textField.returnKeyType = UIReturnKeyNext;
        return  YES;
        
    }
    else
    {
        
        textField.returnKeyType = UIReturnKeyDone;
        return  YES;
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if(textField==nameField)
    {
        [nameField resignFirstResponder];
        [mailField becomeFirstResponder];
        return  YES;
        
    }
    else
    {
        [mailField resignFirstResponder];
        return  YES;
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
