//
//  MyLoyalityPointsViewController.m
//  PipaBella
//
//  Created by Hema on 28/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "MyLoyalityPointsViewController.h"
#import "OrderService.h"
#import "CurrencyConverter.h"

@interface MyLoyalityPointsViewController (){
   // NSMutableArray *loyaltyPointsArray;
    
    NSString *loyaltyPoints, *loyaltyPointsAmount;
}
@property (weak, nonatomic) IBOutlet UIView *loyalityPointView;
@property (weak, nonatomic) IBOutlet UILabel *loyalityPointLabel;
@property (weak, nonatomic) IBOutlet UILabel *worthRupeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *loyalityLabel;
@property (weak, nonatomic) IBOutlet UIButton *retryButton;
@property (weak, nonatomic) IBOutlet UIImageView *circularImageView;

@end

@implementation MyLoyalityPointsViewController
@synthesize loyalityLabel,loyalityPointLabel,loyalityPointView,worthRupeeLabel,retryButton,circularImageView;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.circularImageView.layer.cornerRadius = self.circularImageView.frame.size.width / 2;
    self.circularImageView.clipsToBounds = YES;
    
    loyalityPointView.layer.borderColor = [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0].CGColor;
    loyalityPointView.layer.borderWidth = 1.5f;
    
    [self setCornerRadius];
    
    retryButton.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.title=@"MY LOYALTY POINTS";
    
    [myDelegate ShowIndicator];
    [self performSelector:@selector(getLoyaltyDetail) withObject:nil afterDelay:.1];
}
-(void) setCornerRadius
{
    [loyalityPointView setCornerRadius:2.0f];
}
#pragma mark - end

#pragma mark - Webservice
-(void)getLoyaltyDetail
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        retryButton.hidden=NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
        });
        return;
    }
    
    [[OrderService sharedManager] generalApiUserLoyaltiPointsRequestParam:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            //categoryArray = (NSMutableArray *)data;
                            [myDelegate StopIndicator];
                            if(data==nil || [data count]==0)
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                    [alert1 show];
                                });
                                retryButton.hidden=NO;
                                loyalityPointView.hidden = YES;
                            }
                            else
                            {
                                retryButton.hidden=YES;
                                loyalityPointView.hidden = NO;
                                
                                loyaltyPoints=[data objectForKey:@"loyaly_points"];
                                loyaltyPointsAmount=[data objectForKey:@"loyaly_points_amout"];
                                
                                
                                loyalityPointLabel.text = loyaltyPoints;
                                worthRupeeLabel.text = [NSString stringWithFormat:@"Worth %@",[CurrencyConverter converCurrency:loyaltyPointsAmount]];
                                
                            }
                        });
         
     }
                                            failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;

 }

#pragma mark - end

#pragma mark - Button action
- (IBAction)retryButtonClicked:(id)sender {
    
    [myDelegate ShowIndicator];
    [self performSelector:@selector(getLoyaltyDetail) withObject:nil afterDelay:.1];
}
#pragma mark - end

@end
