//
//  ReturnPolicyViewController.m
//  PipaBella
//
//  Created by Ranosys on 08/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "ReturnPolicyViewController.h"

@interface ReturnPolicyViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *policyWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ReturnPolicyViewController
@synthesize policyWebView,activityIndicator;
@synthesize policyStringText;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"RETURN POLICY";
    
    
   // [activityIndicator startAnimating];
    NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html> \n"
                                   "<head> \n"
                                   "<style type=\"text/css\"> \n"
                                   "body {font-family: \"-apple-system\";color:#000000}\n"
                                   "</style> \n"
                                   "</head> \n"
                                   "<body>%@</body> \n"
                                   "</html>", policyStringText];
    
    NSLog(@"webDataStr is %@",myDescriptionHTML);
    [policyWebView loadHTMLString:myDescriptionHTML baseURL:nil];
   // [activityIndicator stopAnimating];
    
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Localytics tagScreen:@"Return Policy View"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
