//
//  LoadCMSPagesViewController.m
//  PipaBella
//
//  Created by Hema on 28/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "LoadCMSPagesViewController.h"
#import <Social/Social.h>
#import "GeneralInfoService.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface LoadCMSPagesViewController ()<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *loadCMSPagesView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *contactUsView;
@property(strong,nonatomic) NSString *urlKey;

@end

@implementation LoadCMSPagesViewController
@synthesize loadCMSPagesView,activityIndicator,navigationTitle,contactUsView,urlKey;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=navigationTitle;
    if ([navigationTitle isEqualToString:@"CONTACT US" ]) {
        contactUsView.hidden = NO;
        loadCMSPagesView.hidden = YES;
    }
    else{
        contactUsView.hidden = YES;
        loadCMSPagesView.hidden = NO;
        if ([navigationTitle isEqualToString:@"ABOUT US"]) {
            urlKey=@"mobileapp-about-us";
        }
        else if ([navigationTitle isEqualToString:@"PRIVACY POLICY"]) {
            urlKey=@"mobileapp-policies";
        }
        else if ([navigationTitle isEqualToString:@"FAQ's"]) {
            urlKey=@"mobileapp-faq";
        }
        else if ([navigationTitle isEqualToString:@"TERMS AND CONDTIONS"]) {
            urlKey=@"terms-conditions";
        }
        else if ([navigationTitle isEqualToString:@"RETURN POLICY"]) {
            urlKey=@"return-policy";
        }
        
        [myDelegate ShowIndicator];
        [self performSelector:@selector(loadCMSPages) withObject:nil afterDelay:.1];
    }
   
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
    if ([navigationTitle isEqualToString:@"ABOUT US"]) {
        urlKey=@"mobileapp-about-us";
         [Localytics tagScreen:@"General Info:About Us"];
    }
    else if ([navigationTitle isEqualToString:@"PRIVACY POLICY"]) {
        urlKey=@"mobileapp-policies";
        [Localytics tagScreen:@"General Info:Privacy Policy"];
    }
    else if ([navigationTitle isEqualToString:@"FAQ's"]) {
        urlKey=@"mobileapp-faq";
        [Localytics tagScreen:@"General Info:FAQ's"];
    }
    else if ([navigationTitle isEqualToString:@"TERMS AND CONDTIONS"]) {
        urlKey=@"terms-conditions";
        [Localytics tagScreen:@"General Info:Terms and Conditions"];
    }
    else if ([navigationTitle isEqualToString:@"RETURN POLICY"]) {
        urlKey=@"return-policy";
        [Localytics tagScreen:@"General Info:Return Policy"];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadCMSPages
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
        [[GeneralInfoService sharedManager] customerapiCmsPageInfoRequestParam:urlKey success:^(id data)
         {
             //Handle fault cases
             dispatch_async(dispatch_get_main_queue(), ^{
                 // code here
                 [myDelegate StopIndicator];
                 
                     if (data == nil) {
                         UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                         [alert show];
                     }
                     else
                     {
                            if ([data objectForKey:@"status"] != nil || [data objectForKey:@"status"] != NULL)
                         {
                             if ([[data objectForKey:@"status"] intValue] == 1)
                             {
                                
                                 NSString *webDataStr=[data objectForKey:@"content"];
                                 NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html> \n"
                                                                "<head> \n"
                                                                "<style type=\"text/css\"> \n"
                                                                "body {font-family: \"-apple-system\";color:#000000}\n"
                                                                "</style> \n"
                                                                "</head> \n"
                                                                "<body>%@</body> \n"
                                                                "</html>", webDataStr];
                                 
                                 NSLog(@"webDataStr is %@",myDescriptionHTML);
                                 [loadCMSPagesView loadHTMLString:myDescriptionHTML baseURL:nil];
                                 [activityIndicator stopAnimating];
                             }
                             else
                             {
                                 UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                 [alert1 show];
                             }
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

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [myDelegate StopIndicator];
    });

}


#pragma mark - end

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
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1)
    {
        if (buttonIndex == 0)
        {
           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"+919022614455"]]];
        }
    }
}
#pragma mark - Button actions

- (IBAction)callUsButton:(id)sender {
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:9799963190"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Feel free to call us: +919004642600"
                                                   delegate:self
                                          cancelButtonTitle:@"Call"
                                          otherButtonTitles:@"Cancel", nil];
    alert.tag=1;
    [alert show];
}

- (IBAction)mailUsButton:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        // Email Subject
        NSString *emailTitle = @"Pipa Bella";
        NSArray *toRecipents = [NSArray arrayWithObject:@"hello@pipabella.com"];
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
- (IBAction)contactUsIconClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Feel free to call us: +919004642600"
                                                   delegate:self
                                          cancelButtonTitle:@"Call"
                                          otherButtonTitles:@"Cancel", nil];
    alert.tag=1;
    [alert show];

}
- (IBAction)emailIconClicked:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        // Email Subject
        NSString *emailTitle = @"Pipa Bella";
        NSArray *toRecipents = [NSArray arrayWithObject:@"hello@pipabella.com"];
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
#pragma mark - end
@end
