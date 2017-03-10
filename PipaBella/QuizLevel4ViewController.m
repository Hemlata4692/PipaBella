//
//  QuizLevel4ViewController.m
//  PipaBella
//
//  Created by Hema on 30/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "QuizLevel4ViewController.h"
#import "QuizLevel3ViewController.h"
#import "QuizLevel5ViewController.h"
#import "QuizTwoModel.h"

@interface QuizLevel4ViewController ()
{
    NSArray *separatedPrice;
}
@property (weak, nonatomic) IBOutlet UIScrollView *quizLevel4ScrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIButton *nopeButton;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *priceButtonOne;
@property (weak, nonatomic) IBOutlet UILabel *priceButtonOneRange1;
@property (weak, nonatomic) IBOutlet UILabel *priceButtonOneRange2;
@property (weak, nonatomic) IBOutlet UIButton *priceButtonThree;
@property (weak, nonatomic) IBOutlet UILabel *priceButtonThreeRange1;
@property (weak, nonatomic) IBOutlet UILabel *priceButtonThreeRange2;
@property (weak, nonatomic) IBOutlet UIButton *priceButtonTwo;
@property (weak, nonatomic) IBOutlet UILabel *priceButtonTwoRange1;
@property (weak, nonatomic) IBOutlet UILabel *priceButtonTwoRange2;
@property (weak, nonatomic) IBOutlet UIButton *priceButtonFour;
@property (weak, nonatomic) IBOutlet UILabel *priceButtonFourRange1;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation QuizLevel4ViewController
@synthesize priceButtonFour,priceButtonOne,priceButtonThree,priceButtonTwo;
@synthesize quizLevel4ScrollView,mainContainerView;
@synthesize questionLabel,nopeButton,yesButton,priceButtonOneRange1,priceButtonOneRange2,priceButtonThreeRange1,priceButtonThreeRange2,priceButtonTwoRange1,priceButtonTwoRange2,priceButtonFourRange1;
@synthesize userInfoDic,quiz3Information;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //hide status bar
    [self prefersStatusBarHidden];
    [self addShadow];
    
    questionLabel.text = [[quiz3Information objectForKey:@"3"] question];
    
    separatedPrice = [[[[[quiz3Information objectForKey:@"3"] answerArray] objectAtIndex:0] objectForKey:@"text"] componentsSeparatedByString:@"to"];
    priceButtonOneRange1.text = [separatedPrice objectAtIndex:0];
    priceButtonOneRange2.text = [separatedPrice objectAtIndex:1];
    
    separatedPrice = [[[[[quiz3Information objectForKey:@"3"] answerArray] objectAtIndex:1] objectForKey:@"text"] componentsSeparatedByString:@"to"];
    priceButtonTwoRange1.text = [separatedPrice objectAtIndex:0];
    priceButtonTwoRange2.text = [separatedPrice objectAtIndex:1];
    
    separatedPrice = [[[[[quiz3Information objectForKey:@"3"] answerArray] objectAtIndex:2] objectForKey:@"text"] componentsSeparatedByString:@"to"];
    priceButtonThreeRange1.text = [separatedPrice objectAtIndex:0];
    priceButtonThreeRange2.text = [separatedPrice objectAtIndex:1];
    
    priceButtonFourRange1.text = [[[[quiz3Information objectForKey:@"3"] answerArray] objectAtIndex:3] objectForKey:@"text"];
   
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

-(void)addShadow
{
    [questionLabel setTextBorder:questionLabel color:[UIColor colorWithRed:227.0/255 green:0.0/255 blue:117.0/255 alpha:1]];
    [yesButton addShadow:yesButton color:[UIColor colorWithRed:163.0/255 green:0.0/255 blue:74.0/255 alpha:1] radius:7.0f];
    [nopeButton addShadow:nopeButton color:[UIColor colorWithRed:163.0/255 green:0.0/255 blue:74.0/255 alpha:1] radius:7.0f];
}


#pragma mark - end


#pragma mark - Button actions
- (IBAction)nopeButtonAction:(id)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    QuizLevel5ViewController *quiz4View =[storyboard instantiateViewControllerWithIdentifier:@"QuizLevel5ViewController"];
     quiz4View.quiz4Information = [quiz3Information mutableCopy];
    [self.navigationController pushViewController:quiz4View animated:YES];

}

- (IBAction)backButtonAction:(id)sender
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[QuizLevel3ViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            
            break;
        }
    }

}

- (IBAction)priceButtonFourAction:(id)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    QuizLevel5ViewController *quiz4View =[storyboard instantiateViewControllerWithIdentifier:@"QuizLevel5ViewController"];
    quiz4View.quiz4Information = [quiz3Information mutableCopy];
    [self.navigationController pushViewController:quiz4View animated:YES];

}
- (IBAction)priceButtonTwoAction:(id)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    QuizLevel5ViewController *quiz4View =[storyboard instantiateViewControllerWithIdentifier:@"QuizLevel5ViewController"];
    quiz4View.quiz4Information = [quiz3Information mutableCopy];
    [self.navigationController pushViewController:quiz4View animated:YES];

}
- (IBAction)priceButtonThreeAction:(id)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    QuizLevel5ViewController *quiz4View =[storyboard instantiateViewControllerWithIdentifier:@"QuizLevel5ViewController"];
    quiz4View.quiz4Information = [quiz3Information mutableCopy];
    [self.navigationController pushViewController:quiz4View animated:YES];

}
- (IBAction)priceButtonOneAction:(id)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    QuizLevel5ViewController *quiz4View =[storyboard instantiateViewControllerWithIdentifier:@"QuizLevel5ViewController"];
    quiz4View.quiz4Information = [quiz3Information mutableCopy];
    [self.navigationController pushViewController:quiz4View animated:YES];

}
#pragma mark - end

@end
