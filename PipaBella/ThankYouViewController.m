//
//  ThankYouViewController.m
//  PipaBella
//
//  Created by Ranosys on 03/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "ThankYouViewController.h"
#import "PaymentService.h"
@interface ThankYouViewController (){
     UIBarButtonItem *barButton;
}
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UIButton *continuShoppingButton;

@end

@implementation ThankYouViewController
@synthesize orderIdLabel,orderId;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [myDelegate StopIndicator];
    self.title = @"THANK YOU";
    // Do any additional setup after loading the view.
    orderIdLabel.text=[NSString stringWithFormat:@"Your order has been successfully placed with Order Number #%@",orderId];
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [NSTimer scheduledTimerWithTimeInterval:.1
                                     target:self
                                   selector:@selector(showLoader)
                                   userInfo:nil
                                    repeats:NO];
  
}
-(void)showLoader
{
   [myDelegate ShowIndicator];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(clearCartWebservice) withObject:nil afterDelay:.5];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    
//    NSLog(@"Tab Id = %d, SELECTED INDEX = %lu",myDelegate.tabId,self.tabBarController.selectedIndex);
//    if (myDelegate.tabId != self.tabBarController.selectedIndex)
//    {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//}

- (void)addLeftBarButtonWithImage:(UIImage *)backButton
{
    
   // if (self.tabBarController.selectedIndex == 4) {
        CGRect framing = CGRectMake(0, 0, 0, 0);
        UIButton *button = [[UIButton alloc] initWithFrame:framing];
        [button setBackgroundImage:backButton forState:UIControlStateNormal];
        barButton =[[UIBarButtonItem alloc] initWithCustomView:button];
       // [button addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItems=[NSArray arrayWithObjects:barButton, nil];
        
   // }
    
    
}
//-(void)backButtonAction :(id)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}


- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}
#pragma mark - end

#pragma mark - Button action
- (IBAction)continueShoppingButtonAction:(id)sender {
    [UserDefaultManager removeValue:@"total_cart_item"];
    [UserDefaultManager removeValue:@"cartData"];
    if (self.tabBarController.selectedIndex==0)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.tabBarController setSelectedIndex:0];

        [self.navigationController popToRootViewControllerAnimated:YES];
    }

}
#pragma mark - end

#pragma mark - Webservice
-(void)clearCartWebservice
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"!!!!!!!!!!!!!!!!!!");
            [myDelegate StopIndicator];
            
        });
    }

    [[PaymentService sharedManager] generalApiNewQuoteRequestParam:orderId success:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(),^
                        {
                            [myDelegate StopIndicator];
                            if (data!=nil)
                            {
                                NSLog(@"************************************************");
                                
                               
                                NSLog(@"DATA = %@",data);

                                if ([[data objectForKey:@"status"] intValue] == 1)
                                {
 
                                    
                                    NSString *newQuote=[data objectForKey:@"newQuoteId"];
                                    [UserDefaultManager setValue:newQuote key:@"quoteId"];
                                    
                                    [UserDefaultManager removeValue:@"total_cart_item"];
                                    [UserDefaultManager removeValue:@"cartData"];

                                    
                                    NSLog(@"[UserDefaultManager setValue:nil key:@total_cart_item] %@",[UserDefaultManager getValue:@"total_cart_item"]);
                                    NSLog(@"[UserDefaultManager setValue:nil key:@total_cart_item] %@",[UserDefaultManager getValue:@"cartData"]);

                                }
                                
                            }
                            else
                            {
                                [myDelegate StopIndicator];

                                UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                [alert1 show];
                            }
                            
                        });
         
     }
                                                           failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }];
    
}
#pragma mark - end
@end
