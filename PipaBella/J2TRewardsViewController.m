//
//  J2TRewardsViewController.m
//  PipaBella
//
//  Created by Ranosys on 15/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "J2TRewardsViewController.h"
#import "MyAccountViewController.h"
#import "OrderService.h"
#import "CartViewController.h"
#import "MyLoyalityPointsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CurrencyConverter.h"
@interface J2TRewardsViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>{
    NSString *minSecondBase, *minFirstBaseSpent, *minFirstBaseEarn, *minFirstBase, *minFirstBaseBonus, *secondBaseBonus, *minThirdBase, *thirdBaseBonus, *registerPoints, *referPoints;
    UIView *mainView;
    
}
@property (strong, nonatomic) IBOutlet UIView *globalContainerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UILabel *secondBaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondBaseBonusLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdBaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdBaseBonusLabel;
@property (weak, nonatomic) IBOutlet UILabel *registerPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *referPointsLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinNowButton;
@property (weak, nonatomic) IBOutlet UIButton *bagButton;
@property (weak, nonatomic) IBOutlet UILabel *firstBasePointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstBaseRedeemLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstBaseRedeemPointLabelOnImage;

//Set view frames
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UILabel *sepLabelBanner;
@property (weak, nonatomic) IBOutlet UIImageView *heartIcon;
@property (weak, nonatomic) IBOutlet UILabel *rightSeparatorBaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottpmSeparatorBaseLbl;
@property (weak, nonatomic) IBOutlet UIImageView *secondHeartIcon;
@property (weak, nonatomic) IBOutlet UILabel *plusLabel;
@property (weak, nonatomic) IBOutlet UILabel *bonusPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *separatorBonusPoints;
@property (weak, nonatomic) IBOutlet UIImageView *thirdHeartIcon;
@property (weak, nonatomic) IBOutlet UILabel *secondPlusLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdBonusPoints;
@property (weak, nonatomic) IBOutlet UILabel *thirdSeparatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *homerunLabel;

@property (weak, nonatomic) IBOutlet UIView *registerAndEarnView;
@property (weak, nonatomic) IBOutlet UIImageView *registerIcon;
@property (weak, nonatomic) IBOutlet UIImageView *referIcon;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabelFirst;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabelSecond;
@property (weak, nonatomic) IBOutlet UILabel *registerAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *referFriendLabel;
@property (weak, nonatomic) IBOutlet UILabel *startEarningLabel;
@property (weak, nonatomic) IBOutlet UILabel *earnWhenShopLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstBaseIcon;

@end

@implementation J2TRewardsViewController
@synthesize scrollView,mainContainerView,firstBasePointsLabel,firstBaseRedeemLabel,secondBaseLabel,secondBaseBonusLabel,thirdBaseLabel,thirdBaseBonusLabel,registerPointsLabel,referPointsLabel,joinNowButton,bagButton,firstBaseRedeemPointLabelOnImage;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    if([[UIScreen mainScreen] bounds].size.height>568)
    //    {
    //        scrollView.scrollEnabled = NO;
    //    }
    
    [self setViewFrame];
    mainView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.title=@"LOYALTY PROGRAM";
    
    if ([[UserDefaultManager getValue:@"cartData"] count]>0)
    {
        NSMutableArray *tmpArray =[UserDefaultManager getValue:@"cartData"];
        NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)[tmpArray count]];
        bagButton.badgeValue = count;
        bagButton.badgeBGColor = [UIColor colorWithRed:237.0/255.0 green:0.0/255.0 blue:140.0/255.0 alpha:1.0];
        
        
    }
    else
    {
       bagButton.badgeBGColor = [UIColor clearColor];
    }
    if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL)) {
        
        [joinNowButton setTitle:@"JOIN NOW" forState:UIControlStateNormal];
        joinNowButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [joinNowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        [joinNowButton setTitle:@"SEE MY LOYALTY POINTS" forState:UIControlStateNormal];
        joinNowButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [joinNowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    [myDelegate ShowIndicator];
    [self performSelector:@selector(getRewardsDetail) withObject:nil afterDelay:.1];
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [UIView animateWithDuration:0.6f animations:^{
        
        mainView.hidden = YES;
        
    }];
    
}
#pragma mark - end

#pragma mark - Object framing
-(void)setViewFrame
{
    
    
    if([[UIScreen mainScreen] bounds].size.height <= 568)
    {
        self.view.translatesAutoresizingMaskIntoConstraints=YES;
        self.globalContainerView.translatesAutoresizingMaskIntoConstraints=YES;
        //self.scrollView.translatesAutoresizingMaskIntoConstraints=YES;
        self.mainContainerView.translatesAutoresizingMaskIntoConstraints=YES;
        scrollView.delegate = self;
        self.bannerImage.translatesAutoresizingMaskIntoConstraints=YES;
        self.sepLabelBanner.translatesAutoresizingMaskIntoConstraints=YES;
        self.heartIcon.translatesAutoresizingMaskIntoConstraints=YES;
        self.rightSeparatorBaseLabel.translatesAutoresizingMaskIntoConstraints=YES;
        self.bottpmSeparatorBaseLbl.translatesAutoresizingMaskIntoConstraints=YES;
        self.secondHeartIcon.translatesAutoresizingMaskIntoConstraints=YES;
        self.plusLabel.translatesAutoresizingMaskIntoConstraints=YES;
        self.bonusPointsLabel.translatesAutoresizingMaskIntoConstraints=YES;
        self.separatorBonusPoints.translatesAutoresizingMaskIntoConstraints=YES;
        self.thirdHeartIcon.translatesAutoresizingMaskIntoConstraints=YES;
        self.secondPlusLabel.translatesAutoresizingMaskIntoConstraints=YES;
        self.thirdBonusPoints.translatesAutoresizingMaskIntoConstraints=YES;
        self.thirdSeparatorLabel.translatesAutoresizingMaskIntoConstraints=YES;
        self.homerunLabel.translatesAutoresizingMaskIntoConstraints=YES;
        self.registerAndEarnView.translatesAutoresizingMaskIntoConstraints=YES;
        self.registerIcon.translatesAutoresizingMaskIntoConstraints=YES;
        self.referIcon.translatesAutoresizingMaskIntoConstraints=YES;
        self.pointsLabelFirst.translatesAutoresizingMaskIntoConstraints=YES;
        self.pointsLabelSecond.translatesAutoresizingMaskIntoConstraints=YES;
        self.registerAccountLabel.translatesAutoresizingMaskIntoConstraints=YES;
        self.referFriendLabel.translatesAutoresizingMaskIntoConstraints=YES;
        self.startEarningLabel.translatesAutoresizingMaskIntoConstraints=YES;
        self.earnWhenShopLabel.translatesAutoresizingMaskIntoConstraints=YES;
        self.firstBaseIcon.translatesAutoresizingMaskIntoConstraints=YES;
        
        self.secondBaseLabel.translatesAutoresizingMaskIntoConstraints=YES;
        self.secondBaseBonusLabel.translatesAutoresizingMaskIntoConstraints=YES;
        self.thirdBaseLabel.translatesAutoresizingMaskIntoConstraints=YES;
        self.thirdBaseBonusLabel.translatesAutoresizingMaskIntoConstraints=YES;
        self.registerPointsLabel.translatesAutoresizingMaskIntoConstraints=YES;
        self.referPointsLabel.translatesAutoresizingMaskIntoConstraints=YES;
//        self.joinNowButton.translatesAutoresizingMaskIntoConstraints=YES;
        self.bagButton.translatesAutoresizingMaskIntoConstraints=YES;
        self.firstBasePointsLabel.translatesAutoresizingMaskIntoConstraints=YES;
        self.firstBaseRedeemLabel.translatesAutoresizingMaskIntoConstraints=YES;
        self.firstBaseRedeemPointLabelOnImage.translatesAutoresizingMaskIntoConstraints=YES;
        
        

    }
    
    mainView = [[UIView alloc] initWithFrame:
                CGRectMake(0,0,
                           [[UIScreen mainScreen] applicationFrame].size.width,
                           [[UIScreen mainScreen] applicationFrame].size.height)];
    mainView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.8];
    
    mainView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.8];
    
    UITapGestureRecognizer *menuItemTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideCartPopup:)];
    menuItemTapGestureRecognizer.numberOfTapsRequired    = 1;
    menuItemTapGestureRecognizer.delegate                = self;
    [mainView addGestureRecognizer:menuItemTapGestureRecognizer];
    
    
    UIView *emptyBagView = [[UIView alloc] initWithFrame:
                            CGRectMake(120,20,mainView.frame.size.width-120,120)];
    emptyBagView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0, 0, emptyBagView.frame.size.width, 1.5);
    topBorder.backgroundColor = [UIColor colorWithRed:133.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1.0].CGColor;
    [emptyBagView.layer addSublayer:topBorder];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, emptyBagView.frame.size.height-1.5, emptyBagView.frame.size.width, 1.5);
    bottomBorder.backgroundColor = [UIColor colorWithRed:133.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1.0].CGColor;
    [emptyBagView.layer addSublayer:bottomBorder];
    
    CALayer *leftBorder = [CALayer layer];
    leftBorder.frame = CGRectMake(0, 0, 1.5, emptyBagView.frame.size.height);
    leftBorder.backgroundColor = [UIColor colorWithRed:133.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1.0].CGColor;
    [emptyBagView.layer addSublayer:leftBorder];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0,0,40,40)];
    [closeButton setTitle:@"X" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UILabel *shoppingLabel = [[UILabel alloc] initWithFrame:
                              CGRectMake(30,22,emptyBagView.frame.size.width-80,30)];
    shoppingLabel.text = @"MY SHOPPING BAG";
    shoppingLabel.backgroundColor = [UIColor clearColor];
    shoppingLabel.textColor = [UIColor colorWithRed:60.0/255.0 green:60.0/255.0 blue:60.0/255.0 alpha:1.0];
    if (self.view.frame.size.width<=320) {
        shoppingLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    }
    else
    {
        shoppingLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    }
    
    // shoppingLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    shoppingLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UIButton *emptyBagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [emptyBagButton setFrame:CGRectMake(shoppingLabel.frame.origin.x+shoppingLabel.frame.size.width+10,22,25,25)];
    [emptyBagButton setImage:[UIImage imageNamed:@"cart.png"] forState:UIControlStateNormal];
    
    
    UILabel *bagLabel = [[UILabel alloc] initWithFrame:
                         CGRectMake(30,54,emptyBagView.frame.size.width-80,20)];
    bagLabel.text = @"YOUR BAG IS EMPTY";
    bagLabel.backgroundColor = [UIColor clearColor];
    bagLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    bagLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UILabel *keepShoppingLabel = [[UILabel alloc] initWithFrame:
                                  CGRectMake(30,74,emptyBagView.frame.size.width-80,30)];
    keepShoppingLabel.text = @"Life's too short. Keep shopping";
    keepShoppingLabel.backgroundColor = [UIColor clearColor];
    keepShoppingLabel.textColor = [UIColor colorWithRed:138.0/255.0 green:138.0/255.0 blue:138.0/255.0 alpha:1.0];
    keepShoppingLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
    keepShoppingLabel.textAlignment = NSTextAlignmentCenter;
    
    [emptyBagView addSubview:emptyBagButton];
    [emptyBagView addSubview:closeButton];
    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [emptyBagView addSubview:keepShoppingLabel];
    [emptyBagView addSubview:shoppingLabel];
    [emptyBagView addSubview:bagLabel];
    [mainView addSubview:emptyBagView];
    [self.navigationController.view addSubview:mainView];
    
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    scrollView.contentSize=CGSizeMake(320,self.mainContainerView.frame.size.height+110);
    // Your code
    
}
-(void)hideCartPopup:(UITapGestureRecognizer *)gestureRecognizer
{
    [self closeAction:nil];
}
#pragma mark - end

#pragma mark - Webservice
-(void)getRewardsDetail
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
        });
        return;
    }
    
    [[OrderService sharedManager] generalApiLoyalityPageRequestParam:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [myDelegate StopIndicator];
                            if(data==nil || [data count]==0)
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                    [alert1 show];
                                });
                                
                                
                            }
                            else
                            {
                                minFirstBaseSpent = [data objectForKey:@"min_first_base_spent"];
                                minFirstBaseEarn = [data objectForKey:@"min_first_base_earn"];
                                minFirstBase  = [data objectForKey:@"min_first_base"];
                                minFirstBaseBonus = [data objectForKey:@"min_first_base_bonus"];
                                
                                minSecondBase=[data objectForKey:@"min_second_base"];
                                secondBaseBonus=[data objectForKey:@"second_base_bonus"];
                                minThirdBase=[data objectForKey:@"min_third_base"];
                                thirdBaseBonus=[data objectForKey:@"third_base_bonus"];
                                registerPoints=[data objectForKey:@"register_points"];
                                referPoints=[data objectForKey:@"refer_points"];
//                                NSString * price1 = [CurrencyConverter converCurrency:minFirstBaseSpent];
//                                int x = [NSString stringWithFormat:@"%@",price1];
                                
                                UIFont *fnt = [UIFont systemFontOfSize:8 weight:UIFontWeightSemibold];
                                
                                NSMutableAttributedString *attributedStringFirst = [[NSMutableAttributedString alloc] initWithString:@"1ST BASE : " attributes:@{NSFontAttributeName: [fnt fontWithSize:10]}];
                                [attributedStringFirst setAttributes:@{NSFontAttributeName : [fnt fontWithSize:8] , NSBaselineOffsetAttributeName : @2} range:NSMakeRange(1, 2)];
                                NSString *testFirst = [NSString stringWithFormat:@"Spend %@, Earn %@ Point",[CurrencyConverter converCurrency:minFirstBaseSpent],minFirstBaseEarn];
                                NSMutableAttributedString * stringFirst = [[NSMutableAttributedString alloc] initWithString:testFirst];
                                
                                [stringFirst addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10 weight:UIFontWeightRegular] range:(NSMakeRange(0, testFirst.length))];
                                NSMutableAttributedString *resultFirst = [attributedStringFirst mutableCopy];
                                [resultFirst appendAttributedString:stringFirst];
                                firstBasePointsLabel.attributedText = resultFirst;
                                
                                
                                
                                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"2ND BASE : " attributes:@{NSFontAttributeName: [fnt fontWithSize:10]}];
                                [attributedString setAttributes:@{NSFontAttributeName : [fnt fontWithSize:8] , NSBaselineOffsetAttributeName : @2} range:NSMakeRange(1, 2)];
                                NSString *test = [NSString stringWithFormat:@"Order Value Above %@, Earn %@ Bonus",[CurrencyConverter converCurrency:minSecondBase],secondBaseBonus];
                                NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:test];
                                
                                [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10 weight:UIFontWeightRegular] range:(NSMakeRange(0, test.length))];
                                NSMutableAttributedString *result = [attributedString mutableCopy];
                                [result appendAttributedString:string];
                                secondBaseLabel.attributedText = result;
                                
                                NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:@"3RD BASE : " attributes:@{NSFontAttributeName: [fnt fontWithSize:10]}];
                                [attributedString1 setAttributes:@{NSFontAttributeName : [fnt fontWithSize:8] , NSBaselineOffsetAttributeName : @2} range:NSMakeRange(1, 2)];
                                NSString *test1 = [NSString stringWithFormat:@"Order Value Above %@, Earn %@ Bonus",[CurrencyConverter converCurrency:minThirdBase],thirdBaseBonus];
                                NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc] initWithString:test1];
                                [string1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10 weight:UIFontWeightRegular] range:(NSMakeRange(0, test1.length))];
                                NSMutableAttributedString *result1 = [attributedString1 mutableCopy];
                                [result1 appendAttributedString:string1];
                                thirdBaseLabel.attributedText = result1;
                                
                                UIFont *fntFirst = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
                                firstBaseRedeemLabel.font = fntFirst;
                                firstBaseRedeemLabel.text = [NSString stringWithFormat:@"Earn %@ points, Redeem %@",minFirstBase,[CurrencyConverter converCurrency:minFirstBaseBonus]];
                                secondBaseBonusLabel.text = secondBaseBonus;
                                thirdBaseBonusLabel.text = thirdBaseBonus;
                                firstBaseRedeemPointLabelOnImage.text = [NSString stringWithFormat:@"x %@",minFirstBase];
                                registerPointsLabel.text = [NSString stringWithFormat:@"+ %@",registerPoints];
                                referPointsLabel.text = [NSString stringWithFormat:@"+ %@",referPoints];
                                
                            }
                        });
         
     }
                                                             failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
    
}

#pragma mark - end

#pragma mark - Button actions
- (IBAction)joinNowButtonClicked:(id)sender {
    
    if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL)) {
        myDelegate.istoast = true;
        if([[UIScreen mainScreen] bounds].size.height>480)
        {
            myDelegate.toastMessage = @"             You need to login first";
        }else{
            myDelegate.toastMessage = @"    You need to login first";
        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
        myDelegate.window.rootViewController = myDelegate.navigationController;
    }
    else
    {
        //   [self.tabBarController setSelectedIndex:4];
        
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MyLoyalityPointsViewController *cartView =[storyboard instantiateViewControllerWithIdentifier:@"MyLoyalityPointsViewController"];
        [self.navigationController pushViewController:cartView animated:YES];
        
    }
    
    
}
- (IBAction)bagButtonClicked:(id)sender {
    
    if ([[UserDefaultManager getValue:@"cartData"] count]<1) {
        [UIView animateWithDuration:0.6f animations:^{
            mainView.hidden = NO;
            
        }];
    }
    else
    {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CartViewController *cartView =[storyboard instantiateViewControllerWithIdentifier:@"CartViewController"];
        [self.navigationController pushViewController:cartView animated:YES];
        
    }
}

-(void)closeAction :(id)sender
{
    [UIView animateWithDuration:0.4f animations:^{
        
        mainView.hidden = YES;
        
    }];
    
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
