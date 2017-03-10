//
//  BackViewController.m
//  PipaBella
//
//  Created by Hema on 28/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "GlobalViewController.h"

@interface GlobalViewController ()
{
    UIBarButtonItem *barButton;
}

@end

@implementation GlobalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self addLeftBarButtonWithImage:[UIImage imageNamed:@"back_icon"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Add back button
- (void)addLeftBarButtonWithImage:(UIImage *)backButton
{
    CGRect framing = CGRectMake(0, 0, backButton.size.width, backButton.size.height);
    UIButton *button = [[UIButton alloc] initWithFrame:framing];
    [button setBackgroundImage:backButton forState:UIControlStateNormal];
    barButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems=[NSArray arrayWithObjects:barButton, nil];
    
}
//back button action
-(void)backButtonAction :(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - end

@end
