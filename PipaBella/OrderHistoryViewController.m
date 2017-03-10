//
//  OrderHistoryViewController.m
//  PipaBella
//
//  Created by Ranosys on 09/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "OrderHistoryViewController.h"
#import "OrderHistoryTableViewCell.h"
#import "OrderService.h"
#import "ReturnOrderOneViewController.h"
#import "OrderDetailViewController.h"
#import "CheckoutPaymentViewController.h"
#import "CurrencyConverter.h"
#import "TrackOrderDetailViewController.h"
@interface OrderHistoryViewController ()
{
    NSMutableArray *orderHistoryArray;
}
@property (weak, nonatomic) IBOutlet UITableView *orderListTableView;
@property (strong, nonatomic) IBOutlet UILabel *noDataLabel;

@end

@implementation OrderHistoryViewController
@synthesize orderListTableView,noDataLabel;
@synthesize shouldNotReturn,message;
#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=@"MY ORDERS";
    orderHistoryArray=[[NSMutableArray alloc]init];
    
    [myDelegate ShowIndicator];
    [self performSelector:@selector(getOrderHistory) withObject:nil afterDelay:.1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    if (shouldNotReturn)
    {
         [MozTopAlertView showWithType:MozAlertTypeInfo text:message parentView:self.view];
       // [self.view makeToast:message image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        shouldNotReturn=false;
    }
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Localytics tagScreen:@"Order History View"];
}

#pragma mark - end


#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return orderHistoryArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"orderHistoryCell";
    OrderHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[OrderHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.containerView.layer.borderColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0f].CGColor;
    cell.containerView.layer.borderWidth = 2.0f;
    [cell displayData:[orderHistoryArray objectAtIndex:indexPath.row]];
    
    cell.returnOrderButton.tag=indexPath.row;
    cell.trackOrderBtn.tag=indexPath.row;
    [cell.returnOrderButton addTarget:self action:@selector(returnOrderClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.trackOrderBtn addTarget:self action:@selector(trackOrderClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderHistoryModel *orderHistDataModel = [orderHistoryArray objectAtIndex:indexPath.row];
    
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OrderDetailViewController *nextView =[storyboard instantiateViewControllerWithIdentifier:@"OrderDetailViewController"];
    nextView.orderId=orderHistDataModel.OrderId;
    nextView.date=orderHistDataModel.date;
    
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    nextView.price =  [CurrencyConverter converCurrency:orderHistDataModel.grandTotal];
    [self.navigationController pushViewController:nextView animated:YES];
}
-(void)trackOrderClicked : (id)sender
{
    long Tag=[sender tag];
    
    OrderHistoryModel *dataModel=[orderHistoryArray objectAtIndex:Tag];
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TrackOrderDetailViewController *searchView =[storyboard instantiateViewControllerWithIdentifier:@"TrackOrderDetailViewController"];
    searchView.orderIdData=dataModel.OrderId;
    searchView.emailAddress = [UserDefaultManager getValue:@"userEmail"];
    [self.navigationController pushViewController:searchView animated:YES];
}
-(void)returnOrderClicked:(UIButton *)sender
{
    long Tag=[sender tag];
    
    OrderHistoryModel *dataModel=[orderHistoryArray objectAtIndex:Tag];
    
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ReturnOrderOneViewController *searchView =[storyboard instantiateViewControllerWithIdentifier:@"ReturnOrderOneViewController"];
    searchView.orderIdForReturn=dataModel.orderIdForReturnOrder;
    searchView.objOrderHistory = self;
    [self.navigationController pushViewController:searchView animated:YES];
}

#pragma mark - end
#pragma mark - Webservice
-(void)getOrderHistory
{
    
    [[OrderService sharedManager] salesOrderListRequestParam:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(),^
                        {
                            [myDelegate StopIndicator];
                            if (data!=nil)
                            {
                                orderHistoryArray=[data objectForKey:@"orderHistory"];
                                
                                orderHistoryArray=[[[orderHistoryArray reverseObjectEnumerator] allObjects] mutableCopy];
                                
                                if ([data objectForKey:@"result"] != nil || [data objectForKey:@"result"] != NULL)
                                {
                                    if (orderHistoryArray.count>0)
                                    {
                                        noDataLabel.hidden=YES;
                                        [orderListTableView reloadData];
                                    }
                                    else
                                    {
                                        noDataLabel.hidden=NO;
                                        [orderListTableView reloadData];
                                    }
                                }
                                else
                                {
                                    [orderListTableView reloadData];
                                }
                            }
                            else
                            {
                                UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                [alert1 show];
                            }
                            
                        });
     }
                                                     failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
