//
//  LandingViewController.m
//  PipaBella
//
//  Created by Ranosys on 06/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "LandingViewController.h"
#import "UIImage+deviceSpecificMedia.h"
#import "UserService.h"
#import "AppVirality.h"


@interface LandingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *exploreButton;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end

@implementation LandingViewController
@synthesize exploreButton,joinButton;
@synthesize backgroundImage;
#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //hide status bar
    [self prefersStatusBarHidden];
    
    //get image according to device
    backgroundImage.translatesAutoresizingMaskIntoConstraints = YES;
    backgroundImage.frame = CGRectMake(self.view.frame.origin.x,0, self.view.bounds.size.width, self.view.bounds.size.height);
    UIImage * tempImg =[UIImage imageNamed:@"bg1"];
    backgroundImage.image = [UIImage imageNamed:[tempImg imageForDeviceWithName:@"bg1"]];
    
    [self addButtonBorder];
    [self getSessionID];
     

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (myDelegate.istoast)
    {
        
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *loginView =[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:loginView animated:NO];
        
    }
    else if ([UserDefaultManager getValue:@"CurrentView"]!=nil || [[UserDefaultManager getValue:@"isGift"] isEqualToString:@"buildGift"])
    {
        [UserDefaultManager setValue:nil key:@"isGift"];
        [self exploreBtnAction:nil];
    }
    
   // }
    
    // hide navigation bar
    [[self navigationController] setNavigationBarHidden:YES];
}

-(void)addButtonBorder
{
    [exploreButton addBorder:exploreButton];
    [joinButton addBorder:joinButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 //hide status bar
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark - end

#pragma mark - Button Actions
- (IBAction)exploreBtnAction:(id)sender
{
    [UserDefaultManager removeValue:@"CurrentView"];
    [UserDefaultManager removeValue:@"Tab"];
    [UserDefaultManager removeValue:@"productDetailDict"];
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([[UserDefaultManager getValue:@"QuizCompleted"] isEqualToString:@"true"])
    {
        
        UIViewController *searchView =[storyboard instantiateViewControllerWithIdentifier:@"tabbar"];
        [self.navigationController pushViewController:searchView animated:NO];
    }
    else
    {
        UIViewController *quizView =[storyboard instantiateViewControllerWithIdentifier:@"QuizViewController"];
        [self.navigationController pushViewController:quizView animated:YES];
    }
}
- (IBAction)joinBtnAction:(id)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginView =[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:loginView];
    [self.navigationController presentViewController:navBar animated: YES completion: ^ {
        
    }];
    
}
#pragma mark - end

#pragma mark - Webservice Methods
//get sessionid webservice calling
-(void)getSessionID
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
        
        if (([UserDefaultManager getValue:@"sessionId"] == nil) || [[UserDefaultManager getValue:@"sessionId"] isEqualToString:@""])
        {
            myDelegate.isSessionId=1;
            [myDelegate ShowIndicator];
            [[UserService sharedManager] getSessionId:^(id data)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                  [myDelegate StopIndicator];
                 });
                 NSLog(@"getSessionID method called");
             }
                failure:^(NSError *error)
             {
                 NSLog(@"Failure check");
                 dispatch_async(dispatch_get_main_queue(), ^{
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, please try again." delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:nil, nil];
                 alert.tag=1;
                 [alert show];
                      });
                 
             }] ;
            
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1)
    {
        [self getSessionID];
    }
    
}
#pragma mark - end
@end
