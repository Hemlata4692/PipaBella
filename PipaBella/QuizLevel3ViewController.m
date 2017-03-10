//
//  QuizLevel3ViewController.m
//  PipaBella
//
//  Created by Hema on 30/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "QuizLevel3ViewController.h"
#import "QuizLevel4ViewController.h"
#import "QuizLevel2ViewController.h"
#import "QuizTwoModel.h"
#include "QuizLevel3ViewCell.h"

@interface QuizLevel3ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableDictionary *dataDic;
}

@property (weak, nonatomic) IBOutlet UIScrollView *quizLevel3ScrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIButton *nopeButton;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UILabel *selectPriceLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *categoryCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation QuizLevel3ViewController
@synthesize mainContainerView,quizLevel3ScrollView,categoryLabel,nopeButton,yesButton,selectPriceLabel,categoryCollectionView;
@synthesize quiz2Information,userInfoDic;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //hide status bar
    [self prefersStatusBarHidden];
    [self addShadow];
    
    NSLog(@"%d", quiz2Information.count);
   // dataDic =[NSMutableDictionary new];
    categoryLabel.text = [[quiz2Information objectForKey:@"2"] question];
}

-(void)viewWillAppear:(BOOL)animated
{
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        quizLevel3ScrollView.scrollEnabled=NO;
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
    [categoryLabel setTextBorder:categoryLabel color:[UIColor colorWithRed:0.0/255 green:182.0/255 blue:107.0/255 alpha:1]];
   
    [yesButton addShadow:yesButton color:[UIColor colorWithRed:0.0/255 green:127.0/255 blue:40.0/255 alpha:1] radius:7.0f];
    [nopeButton addShadow:nopeButton color:[UIColor colorWithRed:0.0/255 green:127.0/255 blue:40.0/255 alpha:1] radius:7.0f];
}
#pragma mark - end

#pragma mark - Button actions

- (IBAction)backButtonAction:(id)sender
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[QuizLevel2ViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            
            break;
        }
    }

}
- (IBAction)nopeButtonAction:(id)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    QuizLevel4ViewController *quiz3View =[storyboard instantiateViewControllerWithIdentifier:@"QuizLevel4ViewController"];
    quiz3View.quiz3Information = [quiz2Information mutableCopy];
    [self.navigationController pushViewController:quiz3View animated:YES];
}
#pragma mark - end

#pragma mark - UICollectionView methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%d",[[[quiz2Information objectForKey:@"2"] answerArray] count] );
    return [[[quiz2Information objectForKey:@"2"] answerArray] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QuizLevel3ViewCell *myCell = [self.categoryCollectionView
                                      dequeueReusableCellWithReuseIdentifier:@"categoryCell"
                                      forIndexPath:indexPath];

    UIButton *cellButton=(UIButton *)[myCell viewWithTag:1];
    myCell.categoryNameLabel.text = [[[[quiz2Information objectForKey:@"2"] answerArray] objectAtIndex:indexPath.row] objectForKey:@"text"];
    [myCell.categoryImageView sd_setImageWithURL:[NSURL URLWithString:[[[[quiz2Information objectForKey:@"2"] answerArray] objectAtIndex:indexPath.row] objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [cellButton addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
    
    return myCell;
}

-(void)selectCategory:(UIButton *)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    QuizLevel4ViewController *quiz3View =[storyboard instantiateViewControllerWithIdentifier:@"QuizLevel4ViewController"];
   // quiz3View.userInfoDic = [userInfoDic mutableCopy];
    
    quiz3View.quiz3Information = [quiz2Information mutableCopy];
    [self.navigationController pushViewController:quiz3View animated:YES];

}

//- (void)collectionView:(UICollectionViewCell *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    
//    UIViewController *searchView =[storyboard instantiateViewControllerWithIdentifier:@"QuizLevel4ViewController"];
//        [self.navigationController pushViewController:searchView animated:YES];
//}
#pragma mark - end




@end
