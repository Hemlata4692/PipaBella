//
//  QuizLevel6ViewController.m
//  PipaBella
//
//  Created by Hema on 30/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "QuizLevel6ViewController.h"
#import "QuizLevel5ViewController.h"
#import "QuizLevel7ViewController.h"
#import "QuizTwoModel.h"

@interface QuizLevel6ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *quizLevel6ScrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *tellUsLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;

@end

@implementation QuizLevel6ViewController
@synthesize quizLevel6ScrollView,mainContainerView,backButton,tellUsLabel,questionLabel,categoryTableView;
@synthesize userInfoDic,quiz5Information;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //hide status bar
    [self prefersStatusBarHidden];
    [self addShadow];
    
     questionLabel.text = [[quiz5Information objectForKey:@"5"] question];
}

-(void)viewWillAppear:(BOOL)animated
{
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        quizLevel6ScrollView.scrollEnabled=NO;
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

#pragma mark - Button action
- (IBAction)backButtonAction:(id)sender
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[QuizLevel5ViewController class]])
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
    NSLog(@"%d",[[[quiz5Information objectForKey:@"5"] answerArray] count] );
    return [[[quiz5Information objectForKey:@"5"] answerArray] count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UIImageView *categoryImage = (UIImageView *)[cell viewWithTag:1];
    [categoryImage sd_setImageWithURL:[NSURL URLWithString:[[[[quiz5Information objectForKey:@"5"] answerArray] objectAtIndex:indexPath.row] objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    QuizLevel7ViewController *quiz5View =[storyboard instantiateViewControllerWithIdentifier:@"QuizLevel7ViewController"];
    quiz5View.quiz6Information = [quiz5Information mutableCopy];
    [self.navigationController pushViewController:quiz5View animated:YES];

}

#pragma mark - end


@end
