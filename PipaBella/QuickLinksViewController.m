//
//  QuickLinksViewController.m
//  PipaBella
//
//  Created by Ranosys on 17/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "QuickLinksViewController.h"
#import "LoadCMSPagesViewController.h"

@interface QuickLinksViewController ()
{
    NSMutableArray *quickLinkArray;
}

@property (weak, nonatomic) IBOutlet UITableView *quickLinksTableView;
@end

@implementation QuickLinksViewController

@synthesize quickLinksTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    quickLinkArray=[[NSMutableArray alloc]initWithObjects:@"ABOUT US",@"CONTACT US",@"PRIVACY POLICIES",@"RETURN POLICY",@"FAQ's", nil];
   
    quickLinksTableView.layer.borderWidth=1.0;
    quickLinksTableView.layer.borderColor=[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0].CGColor;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.title=@"GENERAL INFO";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Localytics tagScreen:@"General Info View"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   return quickLinkArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"QucikLinks";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    UILabel *linksLabel=(UILabel *)[cell viewWithTag:1];
    linksLabel.text=[quickLinkArray objectAtIndex:indexPath.row];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row==0)
    {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoadCMSPagesViewController *aboutView =[storyboard instantiateViewControllerWithIdentifier:@"LoadCMSPagesViewController"];
        aboutView.navigationTitle=@"ABOUT US";
        [self.navigationController pushViewController:aboutView animated:YES];
    }
    else if (indexPath.row==1)
    {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoadCMSPagesViewController *contactView =[storyboard instantiateViewControllerWithIdentifier:@"LoadCMSPagesViewController"];
         contactView.navigationTitle=@"CONTACT US";
        [self.navigationController pushViewController:contactView animated:YES];
    
    }
    else if (indexPath.row==2)
    {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoadCMSPagesViewController *policyView =[storyboard instantiateViewControllerWithIdentifier:@"LoadCMSPagesViewController"];
        policyView.navigationTitle=@"PRIVACY POLICY";
        [self.navigationController pushViewController:policyView animated:YES];
    }
    else if (indexPath.row==3)
    {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoadCMSPagesViewController *policyView =[storyboard instantiateViewControllerWithIdentifier:@"LoadCMSPagesViewController"];
        policyView.navigationTitle=@"RETURN POLICY";
        [self.navigationController pushViewController:policyView animated:YES];
    }
    else
    {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoadCMSPagesViewController *faqView =[storyboard instantiateViewControllerWithIdentifier:@"LoadCMSPagesViewController"];
        faqView.navigationTitle=@"FAQ's";
        [self.navigationController pushViewController:faqView animated:YES];
    }
    
}

@end
