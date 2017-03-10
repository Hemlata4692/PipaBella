//
//  QuizLevel7ViewController.m
//  PipaBella
//
//  Created by Hema on 30/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "QuizLevel7ViewController.h"
#import "QuizLevel6ViewController.h"
#import "HomeViewController.h"
#import "QuizTwoModel.h"

@interface QuizLevel7ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *quizLevel7ScrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *tellUsLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;

@end

@implementation QuizLevel7ViewController
@synthesize quizLevel7ScrollView,mainContainerView,backButton,tellUsLabel,questionLabel,categoryTableView;
@synthesize userInfoDic,quiz6Information;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //hide status bar
    [self prefersStatusBarHidden];
    [self addShadow];
    
     questionLabel.text = [[quiz6Information objectForKey:@"6"] question];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        quizLevel7ScrollView.scrollEnabled=NO;
    }
    
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
    [questionLabel setTextBorder:questionLabel color:[UIColor colorWithRed:0.0/255 green:173.0/255 blue:181.0/255 alpha:1]];
    [tellUsLabel setTextBorder:tellUsLabel color:[UIColor colorWithRed:147.0/255 green:227.0/255 blue:232.0/255 alpha:1]];
}
#pragma mark - end

#pragma mark -Button action
- (IBAction)backButtonAction:(id)sender
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[QuizLevel6ViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            
            break;
        }
    }

}
#pragma mark - end

#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"%d",[[[quiz6Information objectForKey:@"6"] answerArray] count] );
    return [[[quiz6Information objectForKey:@"6"] answerArray] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UIImageView *categoryImage = (UIImageView *)[cell viewWithTag:1];
    [categoryImage sd_setImageWithURL:[NSURL URLWithString:[[[[quiz6Information objectForKey:@"6"] answerArray] objectAtIndex:indexPath.row] objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    
//    UIViewController *searchView =[storyboard instantiateViewControllerWithIdentifier:@"tabbar"];
//    [self.navigationController pushViewController:searchView animated:YES];
    
    HomeViewController *homeView =[storyboard instantiateViewControllerWithIdentifier:@"tabbar"];
    //                                        myDelegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [myDelegate.window setRootViewController:homeView];
    [myDelegate.window makeKeyAndVisible];


}
#pragma mark - end
@end
