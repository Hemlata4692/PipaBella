//
//  SearchViewController.m
//  PipaBella
//
//  Created by Ranosys on 16/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchProductViewController.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation SearchViewController
@synthesize searchTextField,cancelBtn;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [searchTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - end

#pragma mark - Button actions
- (IBAction)cancelButtonAction:(id)sender
{
    NSLog(@"myDelegate.tabId is %d",myDelegate.tabId);
    [self.tabBarController setSelectedIndex:myDelegate.tabId];
    [searchTextField resignFirstResponder];
}
#pragma mark - end

#pragma mark - Textfield delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSString *textData =  [searchTextField.text stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([textData isEqualToString:@""])
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please enter any keyword to search." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter any keyword to search" parentView:self.view];
//        if([[UIScreen mainScreen] bounds].size.height>480)
//        {
//            [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter any keyword to search" parentView:self.view];
//            [self.view makeToast:@"Please enter any keyword to search" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
//        }else{
//            [self.view makeToast:@"Please enter any keyword to search" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
//        }
        
    }
    else
    {
        [textField resignFirstResponder];
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchProductViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"SearchProductViewController"];
        view.searchKeyword = textData;
        [self.navigationController pushViewController:view animated:YES];
    }
    
    return YES;
}

#pragma mark - end

#pragma mark - Webservice

#pragma mark - end
@end
