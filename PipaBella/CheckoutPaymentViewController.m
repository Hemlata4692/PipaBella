//
//  CheckoutPaymentViewController.m
//  PipaBella
//
//  Created by Ranosys on 05/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "CheckoutPaymentViewController.h"
#import <Razorpay/RazorpayCheckout.h>
#import "PaymentService.h"
#import "PaymentModel.h"
#import "ThankYouViewController.h"
#import "CurrencyConverter.h"
#import "LoadCMSPagesViewController.h"
@interface CheckoutPaymentViewController (){
    BOOL maintainExpand;
    NSMutableArray *returnDataArray;
    PaymentModel *dataModel;
    
    NSString *paymentMethod;
    NSString *orderId;
    int checkShipping;
    
    int isOnline;
    
}


@property (weak, nonatomic) IBOutlet UIButton *reviewButton;
@property (weak, nonatomic) IBOutlet UIButton *deliverToButton;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (weak, nonatomic) IBOutlet UIButton *placeOrderButton;

//COD View
@property (weak, nonatomic) IBOutlet UIView *codView;
@property (weak, nonatomic) IBOutlet UILabel *codLabel;
@property (weak, nonatomic) IBOutlet UIImageView *paymentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIButton *codButton;
@property (weak, nonatomic) IBOutlet UILabel *separatorLabel;
@property (weak, nonatomic) IBOutlet UIView *codContainerView;
@property (weak, nonatomic) IBOutlet UILabel *totalPayableLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

//Online payment view
@property (weak, nonatomic) IBOutlet UIView *onlinePaymentView;
@property (weak, nonatomic) IBOutlet UIButton *onlinePaymentButton;
@property (weak, nonatomic) IBOutlet UIImageView *paymentIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *onlinePaymentLabel;
@property (weak, nonatomic) IBOutlet UIView *termsConditionsView;
@property (weak, nonatomic) IBOutlet UIButton *termsButton;
@property (weak, nonatomic) IBOutlet UIButton *returnPolicyButton;

@end

@implementation CheckoutPaymentViewController
@synthesize reviewButton,deliverToButton,payButton,placeOrderButton;
@synthesize codView,paymentImageView,arrowImageView,codLabel,codButton,separatorLabel,codContainerView,totalPayableLabel,amountLabel,termsConditionsView,termsButton,returnPolicyButton;
@synthesize onlinePaymentView,onlinePaymentButton,onlinePaymentLabel,paymentIconImageView,totalPrice;


#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    checkShipping=0;
    self.navigationItem.title=@"CHECKOUT";
    
    maintainExpand = YES;
    
    placeOrderButton.hidden = YES;
    termsConditionsView.hidden = YES;
    
    [reviewButton addBorder:reviewButton color:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0]];
    [reviewButton setTitleColor:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    
    [deliverToButton addBorder:deliverToButton color:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0]];
    [deliverToButton setTitleColor:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    
    [payButton addBorder:payButton color:[UIColor colorWithRed:241.0/255.0 green:0.0/255.0 blue:136.0/255.0 alpha:1.0]];
    [payButton setTitleColor:[UIColor colorWithRed:241.0/255.0 green:0.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    
    [self setCODViewFrame];
    [self setOnlineViewFrame];
    
    //    amountLabel.text=[CurrencyConverter converCurrency:totalPrice];
    amountLabel.text=[NSString stringWithFormat:@"(%@)",[CurrencyConverter converCurrency:totalPrice]];
    
    [myDelegate ShowIndicator];
    [self performSelector:@selector(getReturnOrderData) withObject:nil afterDelay:.1];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
//    NSLog(@"Tab Id = %d, SELECTED INDEX = %u",myDelegate.tabId,self.tabBarController.selectedIndex);
    if (myDelegate.tabId != self.tabBarController.selectedIndex)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - end

#pragma mark - Object framing
- (void)setCODViewFrame{
    
    //COD view framing
    codView.translatesAutoresizingMaskIntoConstraints = YES;
    codLabel.translatesAutoresizingMaskIntoConstraints = YES;
    paymentImageView.translatesAutoresizingMaskIntoConstraints = YES;
    arrowImageView.translatesAutoresizingMaskIntoConstraints = YES;
    codButton.translatesAutoresizingMaskIntoConstraints = YES;
    separatorLabel.translatesAutoresizingMaskIntoConstraints = YES;
    codContainerView.translatesAutoresizingMaskIntoConstraints = YES;
    totalPayableLabel.translatesAutoresizingMaskIntoConstraints = YES;
    amountLabel.translatesAutoresizingMaskIntoConstraints = YES;
    
    separatorLabel.hidden = YES;
    codContainerView.hidden = YES;
    
    codView.layer.borderColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0].CGColor;
    codView.layer.borderWidth = 1.5f;
    
    codContainerView.layer.borderColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0].CGColor;
    codContainerView.layer.borderWidth = 1.5f;
    
    [codView setFrame:CGRectMake(self.codView.frame.origin.x, self.codView.frame.origin.y, self.view.frame.size.width - 40, 45)];
    [codButton setFrame:CGRectMake(self.codButton.frame.origin.x, self.codButton.frame.origin.y, self.view.frame.size.width - 40, 45)];
    [paymentImageView setFrame:CGRectMake(self.paymentImageView.frame.origin.x, self.paymentImageView.frame.origin.y, self.paymentImageView.frame.size.width, self.paymentImageView.frame.size.height)];
    [codLabel setFrame:CGRectMake(self.paymentImageView.frame.origin.x+self.paymentImageView.frame.size.width+20, self.codLabel.frame.origin.y, self.codLabel.frame.size.width, self.codLabel.frame.size.height)];
    [arrowImageView setFrame:CGRectMake(self.codView.frame.size.width-self.arrowImageView.frame.size.width-8, self.arrowImageView.frame.origin.y, self.arrowImageView.frame.size.width, self.arrowImageView.frame.size.height)];
    [separatorLabel setFrame:CGRectMake(self.separatorLabel.frame.origin.x, self.separatorLabel.frame.origin.y, self.codView.frame.size.width - 20, 1)];
    [codContainerView setFrame:CGRectMake(40, self.codContainerView.frame.origin.y, self.codView.frame.size.width-80 , self.codContainerView.frame.size.height)];
    [totalPayableLabel setFrame:CGRectMake((self.codContainerView.frame.size.width/2)-self.totalPayableLabel.frame.size.width , self.totalPayableLabel.frame.origin.y, self.totalPayableLabel.frame.size.width , self.totalPayableLabel.frame.size.height)];
    [amountLabel setFrame:CGRectMake(self.codContainerView.frame.size.width/2, self.amountLabel.frame.origin.y, self.amountLabel.frame.size.width+20, self.amountLabel.frame.size.height)];
    
}

- (void)setOnlineViewFrame{
    onlinePaymentView.translatesAutoresizingMaskIntoConstraints = YES;
    onlinePaymentButton.translatesAutoresizingMaskIntoConstraints = YES;
    onlinePaymentLabel.translatesAutoresizingMaskIntoConstraints = YES;
    paymentIconImageView.translatesAutoresizingMaskIntoConstraints = YES;
    
    onlinePaymentView.layer.borderColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0].CGColor;
    onlinePaymentView.layer.borderWidth = 1.5f;
    
    [onlinePaymentView setFrame:CGRectMake(self.onlinePaymentView.frame.origin.x, self.onlinePaymentView.frame.origin.y, self.view.frame.size.width - 40, 45)];
    [onlinePaymentButton setFrame:CGRectMake(self.onlinePaymentButton.frame.origin.x, self.onlinePaymentButton.frame.origin.y, self.view.frame.size.width - 40, 45)];
    [paymentIconImageView setFrame:CGRectMake(self.paymentIconImageView.frame.origin.x, self.paymentIconImageView.frame.origin.y, self.paymentIconImageView.frame.size.width, self.paymentIconImageView.frame.size.height)];
    [onlinePaymentLabel setFrame:CGRectMake(self.paymentImageView.frame.origin.x+self.paymentImageView.frame.size.width+20, self.onlinePaymentLabel.frame.origin.y, self.onlinePaymentLabel.frame.size.width, self.onlinePaymentLabel.frame.size.height)];
    
}
#pragma mark - end

#pragma mark - RazorPay integration
- (void) showPayment { // called by your app
    
    int totalPri=[totalPrice intValue];
    totalPri=totalPri*100;
    NSString *totalAmount=[NSString stringWithFormat:@"%d",totalPri];
    
    RazorpayCheckout * checkout = [[RazorpayCheckout alloc] initWithKey:@"rzp_live_TAPE4GblO2CrTF"];
    
    NSDictionary * options = @{
                               @"amount":totalAmount, // mandatory, in paise
                               // all optional other than amount.
                               @"image": @"",
                               @"name": @"Razorpay Online Payment",
                               @"description": @"",
                               @"prefill" : @{
                                       @"email": @"",
                                       @"contact": @""
                                       },
                               @"theme": @{
                                       @"color": @"#EB008A"
                                       }
                               };
    
    
    [checkout setDelegate:self];
    [checkout open: options];
}



- (void)onPaymentSuccess:(nonnull NSString*) payment_id{
    
    [self performSelector:@selector(payuOrderUpdate:) withObject:payment_id afterDelay:.1];
    
    
    //  [[[UIAlertView alloc] initWithTitle:@"Payment Successful" message:payment_id delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    //    UIAlertController *alertController = [UIAlertController
    //                                          alertControllerWithTitle:@"Payment Successful"
    //                                          message:payment_id
    //                                          preferredStyle:UIAlertControllerStyleAlert];
    //
    //
    //
    //    UIAlertAction *cancelAction = [UIAlertAction
    //                                   actionWithTitle:@"OK"
    //                                   style:UIAlertActionStyleCancel
    //                                   handler:^(UIAlertAction *action)
    //                                   {
    //
    //                                       [alertController dismissViewControllerAnimated:YES completion:nil];
    //                                   }];
    //
    //    [alertController addAction:cancelAction];
    //
    //    [self presentViewController:alertController animated:YES completion:nil];
    //
    
};

- (void)onPaymentError:(nonnull NSString *) code description:(nonnull NSString *) str{
   
    [self cancelOrder];
    
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Error"
                                          message:str
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                       [alertController dismissViewControllerAnimated:YES completion:nil];
                                   }];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
};
#pragma mark - end

#pragma mark - Button actions
- (IBAction)codButtonClicked:(id)sender {
    
    isOnline=0;
    if (maintainExpand) {
        [codButton setSelected:YES];
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             
                             
                             [codView setFrame:CGRectMake(self.codView.frame.origin.x, self.codView.frame.origin.y, self.view.frame.size.width - 40, 120)];
                             codView.layer.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0].CGColor;
                             arrowImageView.image = [UIImage imageNamed:@"up_arrow_payment.png"];
                             [onlinePaymentView setFrame:CGRectMake(self.onlinePaymentView.frame.origin.x, 250, self.view.frame.size.width - 40, 45)];
                              [onlinePaymentButton setFrame:CGRectMake(self.onlinePaymentButton.frame.origin.x, 250, self.view.frame.size.width - 40, 45)];
                             placeOrderButton.hidden = NO;
                             termsConditionsView.hidden = NO;
                             
                         }
                         completion:^(BOOL finished) {
                             separatorLabel.hidden = NO;
                             codContainerView.hidden = NO;
                             
                             
                         }];
        
        
    }
    else
    {
        [codButton setSelected:NO];
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             
                             
                             [codView setFrame:CGRectMake(self.codView.frame.origin.x, self.codView.frame.origin.y, self.view.frame.size.width - 40, 45)];
                             codView.layer.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
                             arrowImageView.image = [UIImage imageNamed:@"down_arrow_payment.png"];
                             [onlinePaymentView setFrame:CGRectMake(self.onlinePaymentView.frame.origin.x, 175, self.view.frame.size.width - 40, 45)];
                             [onlinePaymentButton setFrame:CGRectMake(self.onlinePaymentButton.frame.origin.x, 175, self.view.frame.size.width - 40, 45)];
                             separatorLabel.hidden = YES;
                             codContainerView.hidden = YES;
                             placeOrderButton.hidden = YES;
                             termsConditionsView.hidden = YES;
                             
                             
                         }
                         completion:^(BOOL finished) {
                             
                             
                         }];
        
    }
    for (int i=0; i<returnDataArray.count; i++)
    {
        dataModel=[returnDataArray objectAtIndex:i];
        if ([dataModel.paymentCode isEqualToString:@"cashondelivery"])
        {
            
            paymentMethod=dataModel.paymentCode;
            //NSLog(@"paymentMethod is it may be null resulting crash.................>>>>>>%@",paymentMethod);
        }
    }
    if ([paymentMethod isEqualToString:@"(null)"] ||[paymentMethod isEqualToString:@""]||paymentMethod==nil) {
        
        paymentMethod = @"cashondelivery";
    }
    maintainExpand =! maintainExpand;
    
}
- (IBAction)onlinePaymentButtonClicked:(id)sender {
    isOnline=1;

    [codButton setSelected:NO];
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         
                         maintainExpand=YES;
                         [codView setFrame:CGRectMake(self.codView.frame.origin.x, self.codView.frame.origin.y, self.view.frame.size.width - 40, 45)];
                         codView.layer.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
                         arrowImageView.image = [UIImage imageNamed:@"down_arrow_payment.png"];
                         [onlinePaymentView setFrame:CGRectMake(self.onlinePaymentView.frame.origin.x, 175, self.view.frame.size.width - 40, 45)];
                         [onlinePaymentButton setFrame:CGRectMake(self.onlinePaymentButton.frame.origin.x, 175, self.view.frame.size.width - 40, 45)];
                         separatorLabel.hidden = YES;
                         codContainerView.hidden = YES;
                         placeOrderButton.hidden = YES;
                         termsConditionsView.hidden = YES;
                         
                         
                     }
                     completion:^(BOOL finished) {
                         
                         
                     }];

    
    //    [self showPayment];
    
    for (int i=0; i<returnDataArray.count; i++)
    {
        dataModel=[returnDataArray objectAtIndex:i];
        if ([dataModel.paymentCode isEqualToString:@"razorpay"])
        {
            paymentMethod=dataModel.paymentCode;
            if ([paymentMethod isEqualToString:@"(null)"] ||[paymentMethod isEqualToString:@""]||paymentMethod==nil) {
                
                paymentMethod = @"razorpay";
            }
            [myDelegate ShowIndicator];
            [self performSelector:@selector(setShippingMethod) withObject:nil afterDelay:.1];
        }
    }
}
- (BOOL)performValidationsForPlaceorder
{
    if ((![codButton isSelected]) && (![onlinePaymentButton isSelected]))
    {
         [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Kindly select payment mode" parentView:self.view];
        //[self.view makeToast:@"Kindly select payment mode" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];

        return NO;
    }
    else
    {
        return YES;
        
    }
    
}
- (IBAction)placeOrderButtonClicked:(id)sender
{
    if([self performValidationsForPlaceorder])
    {
        [myDelegate ShowIndicator];
        [self performSelector:@selector(setShippingMethod) withObject:nil afterDelay:.1];
    }
}
- (IBAction)termsCondtionsButtonClicked:(id)sender {
    
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoadCMSPagesViewController *contactView =[storyboard instantiateViewControllerWithIdentifier:@"LoadCMSPagesViewController"];
    contactView.navigationTitle=@"TERMS AND CONDTIONS";
    [self.navigationController pushViewController:contactView animated:YES];
}
- (IBAction)returnPolicyButtonClicked:(id)sender {
    
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoadCMSPagesViewController *contactView =[storyboard instantiateViewControllerWithIdentifier:@"LoadCMSPagesViewController"];
    contactView.navigationTitle=@"RETURN POLICY";
    [self.navigationController pushViewController:contactView animated:YES];
}

#pragma mark - end
#pragma mark - Webservice
-(void)cancelOrder
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //NSLog(@"!!!!!!!!!!!!!!!!!!");
            [myDelegate StopIndicator];
            
        });
    }
    [Localytics tagEvent:@"Cancel order request submitted" attributes:@{@"order_id" : orderId}];
    [[PaymentService sharedManager] cancelOrder:orderId success:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(),^
                        {
                            
                            
                        });
         
     }
       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }];
}
-(void)getReturnOrderData
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
            
        });
    }

    
    [[PaymentService sharedManager] generalApiPayAndShipMethodListRequestParam:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(),^
                        {
                            if (data!=nil)
                            {
                                
                                //                                policy = [data objectForKey:@"policy"];
                                //                                address = [data objectForKey:@"address"];
                                //                                [pickerDataDic setObject:[data objectForKey:@"packing"] forKey:@"packing"];
                                //                                [pickerDataDic setObject:[data objectForKey:@"reason"] forKey:@"reason"];
                                //                                [pickerDataDic setObject:[data objectForKey:@"type"] forKey:@"type"];
                                
                                returnDataArray=[data objectForKey:@"result"];
                                
                                
                                
                                //[returnOrderTableView reloadData];
                                //                                if (returnDataArray.count>0)
                                //                                {
                                //                                    // noProductsLbl.hidden = YES;
                                //                                }
                                //                                else
                                //                                {
                                //                                    // noProductsLbl.hidden = NO;
                                //                                }
                            }
                            else
                            {
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
-(void)setShippingMethod
{
    NSString *errorMsg;
    for (int i=0; i<returnDataArray.count; i++)
    {
        dataModel=[returnDataArray objectAtIndex:i];
        if ([dataModel.shippingCode isEqualToString:@"tablerate_bestway"])
        {
            checkShipping=1;
            [[PaymentService sharedManager] shoppingCartShippingMethodRequestParam:dataModel.shippingCode success:^(id data)
             {
                 //Handle fault cases
                 dispatch_async(dispatch_get_main_queue(),^
                                {
                                    if (data!=nil)
                                    {
                                        if ([[data objectForKey:@"result"] isEqualToString:@"true"])
                                        {
                                            [self performSelector:@selector(setPaymentMethod:) withObject:paymentMethod afterDelay:.1];
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
        else if((dataModel.errorMessage!=nil) && (![dataModel.errorMessage isEqualToString:@"\n"]))
        {
            checkShipping=0;
            errorMsg=dataModel.errorMessage;
        }
    }
    if (checkShipping==0)
    {
        [myDelegate StopIndicator];
        UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your selected address is not valid.Please select an valid address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alert1.tag=1;
        [alert1 show];
    }
}
-(void)setPaymentMethod:(NSString *)method
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
            
        });
    }

    
    [[PaymentService sharedManager] shoppingCartPaymentMethodRequestParam:method  success:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(),^
                        {
                            if (data!=nil)
                            {
                                if ([[data objectForKey:@"result"] isEqualToString:@"true"])
                                {
                                    
                                    [self performSelector:@selector(placeOrderWebservice) withObject:nil afterDelay:.1];
//                                    [self placeOrderWebservice];
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
-(void)placeOrderWebservice
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
            
        });
    }

    
    [[PaymentService sharedManager] shoppingCartOrderRequestParam:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(),^
                        {
                             [myDelegate StopIndicator];
                            if (data!=nil)
                            {
                                if ([data objectForKey:@"result"]!=nil)
                                {
                                    orderId=[data objectForKey:@"result"];
                                    
                                    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                    
                                    if (isOnline == 1)
                                    {
                                        [self showPayment];
                                    }
                                    else
                                    {
                                        ThankYouViewController * objView=[sb instantiateViewControllerWithIdentifier:@"ThankYouViewController"];
                                        objView.orderId=orderId;
                                        [self.navigationController pushViewController:objView animated:YES];
                                        
                                    }
                                    
                                }
                            }
                            else
                            {
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
-(void)payuOrderUpdate:(NSString *)rozarPayId
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
            
        });
    }

    
    [[PaymentService sharedManager] generalApiPayumoneyUpdateRequestParam:orderId price:totalPrice transactionId:rozarPayId success:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(),^
                        {
                            [myDelegate StopIndicator];
                            UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            
                            if (data!=nil)
                            {
                                if ([[data objectForKey:@"status"] isEqualToString:@"1"])
                                {
                                    ThankYouViewController * objView=[sb instantiateViewControllerWithIdentifier:@"ThankYouViewController"];
                                    objView.orderId=orderId;
                                    [self.navigationController pushViewController:objView animated:YES];
                                    
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1)
    {
        if (buttonIndex==0)
        {
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
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
