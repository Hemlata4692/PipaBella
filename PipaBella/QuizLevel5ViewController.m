//
//  QuizLevel5ViewController.m
//  PipaBella
//
//  Created by Hema on 30/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "QuizLevel5ViewController.h"
#import "QuizLevel4ViewController.h"
#import "QuizLevel6ViewController.h"
#import "QuizTwoModel.h"

@interface QuizLevel5ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *quizLevel5ScrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *tellUsLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITableView *categoryTabelView;
@end

@implementation QuizLevel5ViewController
@synthesize questionLabel,quizLevel5ScrollView,mainContainerView,backButton,tellUsLabel,categoryTabelView;
@synthesize userInfoDic,quiz4Information;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //hide status bar
    [self prefersStatusBarHidden];
    [self addShadow];
    
     questionLabel.text = [[quiz4Information objectForKey:@"4"] question];
}

-(void)viewWillAppear:(BOOL)animated
{
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        quizLevel5ScrollView.scrollEnabled=NO;
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
- (IBAction)backButtonAction:(id)sender
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[QuizLevel4ViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            
            break;
        }
    }

}

-(void)addShadow
{
    [questionLabel setTextBorder:questionLabel color:[UIColor colorWithRed:0.0/255 green:173.0/255 blue:181.0/255 alpha:1]];
    [tellUsLabel setTextBorder:tellUsLabel color:[UIColor colorWithRed:147.0/255 green:227.0/255 blue:232.0/255 alpha:1]];
}
#pragma mark - end

#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
     NSLog(@"%d",[[[quiz4Information objectForKey:@"4"] answerArray] count] );
    return [[[quiz4Information objectForKey:@"4"] answerArray] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"necklacesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UIImageView *categoryImage = (UIImageView *)[cell viewWithTag:1];
   [categoryImage sd_setImageWithURL:[NSURL URLWithString:[[[[quiz4Information objectForKey:@"4"] answerArray] objectAtIndex:indexPath.row] objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    QuizLevel6ViewController *quiz5View =[storyboard instantiateViewControllerWithIdentifier:@"QuizLevel6ViewController"];
    quiz5View.quiz5Information = [quiz4Information mutableCopy];
    [self.navigationController pushViewController:quiz5View animated:YES];

}


#pragma mark - end
@end
