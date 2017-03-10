//
//  RateAppViewController.m
//  PipaBella
//
//  Created by Ranosys on 19/02/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "RateAppViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface RateAppViewController ()<MFMailComposeViewControllerDelegate>{
    UIBarButtonItem *barButton;
    __weak IBOutlet UIView *bgView;
    __weak IBOutlet UIView *rateUsView;
}
@property (weak, nonatomic) IBOutlet UIButton *rateNowButton;
@property (weak, nonatomic) IBOutlet UIButton *leaveAMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation RateAppViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationItem.title=@"RATE OUR APP";
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    bgView.userInteractionEnabled = YES;
    [bgView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rateNowButtonClicked:)];
    singleTap.numberOfTapsRequired = 1;
    rateUsView.userInteractionEnabled = YES;
    [rateUsView addGestureRecognizer:tapGesture];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}
-(void)tapDetected
{
     [self cancelButtonClicked:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}
- (void)addLeftBarButtonWithImage:(UIImage *)backButton
{
    CGRect framing = CGRectMake(0, 0, 0, 0);
    UIButton *button = [[UIButton alloc] initWithFrame:framing];
    [button setBackgroundImage:backButton forState:UIControlStateNormal];
    barButton =[[UIBarButtonItem alloc] initWithCustomView:button];
   // [button addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
   // self.navigationItem.leftBarButtonItems=[NSArray arrayWithObjects:barButton, nil];
    
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //Actions for composing the email
    switch (result)
    {
        case MFMailComposeResultCancelled:
            
            break;
        case MFMailComposeResultSaved:
            
            break;
        case MFMailComposeResultSent:
            
            break;
        case MFMailComposeResultFailed:
            
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - end

#pragma mark - Button actions

- (IBAction)leaveAMessageButtonClicked:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        // Email Subject
        NSString *emailTitle = @"My feedback for Pipa+Bella's IOS app";
        NSArray *toRecipents = [NSArray arrayWithObject:@"support@pipabella.com"];
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        // [mc setMessageBody:[NSString stringWithFormat:@"%@ %@",@"Download Pipa Bella app at",[NSURL URLWithString: @"http://www.google.com/"]] isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        [self presentViewController:mc animated:YES completion:NULL];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Alert"
                                      message:@"Email account is not configured in your device."
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        });
    }

}
- (IBAction)rateNowButtonClicked:(id)sender
{
    NSString *iTunesLink = @"https://itunes.apple.com/us/app/google-official-search-app/id284815942?mt=8";
    //NSString *iTunesLink = @"itms://itunes.apple.com/in/app/google-official-search-app/id284815942?mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}
- (IBAction)cancelButtonClicked:(id)sender
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    [self.view removeFromSuperview];
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
