//
//  OrderDetailViewController.m
//  PipaBella
//
//  Created by Ranosys on 09/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailTableViewCell.h"
#import "OrderService.h"
@interface OrderDetailViewController ()
{
    NSMutableArray *orderDetailArray;
    NSMutableDictionary *shippingAddress;
    NSMutableDictionary *billingAddress;
    
    //Price
    NSString *baseGrandTotal;
    NSString *baseShippingAmount;
    NSString *baseTaxAmount;
    NSString *grandTotal;
    NSString *taxpercent;
    
    //Reward points
    NSString *pointGathered;
    NSString *pointUsed;
}
@property (weak, nonatomic) IBOutlet UITextView *orderIdTview;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITableView *orderDetailTableView;
@property (strong, nonatomic) IBOutlet UILabel *orderIdLbl;
@property (strong, nonatomic) IBOutlet UILabel *orderDateLbl;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *paymentMethodLbl;
@property (strong, nonatomic) IBOutlet UILabel *instructionLabel;
@property (strong, nonatomic) IBOutlet UITextView *shippingAddressTextView;
@property (strong, nonatomic) IBOutlet UITextView *billingAddressTextView;
@property (strong, nonatomic) IBOutlet UILabel *instructionTextView;
@property (strong, nonatomic) IBOutlet UILabel *itemsOrderedLabel;
@property (strong, nonatomic) IBOutlet UIView *addressView;


@end

@implementation OrderDetailViewController
@synthesize orderDetailTableView,orderId,price,date;
@synthesize orderDateLbl,orderIdLbl,totalPriceLabel,paymentMethodLbl,shippingAddressTextView,billingAddressTextView,instructionTextView,instructionLabel,itemsOrderedLabel,addressView,scrollView,mainView,orderIdTview;
#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=@"ORDER DETAILS";
    orderDetailArray=[[NSMutableArray alloc]init];
    shippingAddress=[[NSMutableDictionary alloc]init];
    billingAddress=[[NSMutableDictionary alloc]init];
    
    orderIdTview.text=[NSString stringWithFormat:@"# %@",orderId];
    orderIdTview.contentInset = UIEdgeInsetsMake(-5.0,0.0,5.0,0.0);
    totalPriceLabel.text=price;
    orderDateLbl.text=date;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [myDelegate ShowIndicator];
    [self performSelector:@selector(getOrderDetail) withObject:nil afterDelay:.1];
    [self setViewFrames:@""];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Localytics tagScreen:@"Order Detail View"];
}

-(void)setViewFrames:(NSString *)giftMessage
{
    instructionLabel.translatesAutoresizingMaskIntoConstraints=YES;
    instructionTextView.translatesAutoresizingMaskIntoConstraints=YES;
    orderDetailTableView.translatesAutoresizingMaskIntoConstraints=YES;
    itemsOrderedLabel.translatesAutoresizingMaskIntoConstraints=YES;
    mainView.translatesAutoresizingMaskIntoConstraints=YES;
    
    if (giftMessage != nil)
    {
        instructionLabel.hidden=NO;
        instructionTextView.hidden=NO;
        
        instructionLabel.frame=CGRectMake(20,addressView.frame.origin.y+addressView.frame.size.height+20, self.view.frame.size.width-40,20);
        
        CGSize size = CGSizeMake(self.view.frame.size.width-80,240);
        
        CGRect textRect=[giftMessage
                         boundingRectWithSize:size
                         options:NSStringDrawingUsesLineFragmentOrigin
                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"SF UI Display" size:12]}
                         context:nil];
        instructionTextView.numberOfLines = 0;
        instructionTextView.text=giftMessage;
        
        instructionTextView.frame=CGRectMake(20,instructionLabel.frame.origin.y+instructionLabel.frame.size.height+10, self.view.frame.size.width-40,textRect.size.height+5);
        
        itemsOrderedLabel.frame=CGRectMake(20,instructionTextView.frame.origin.y+instructionTextView.frame.size.height+10, self.view.frame.size.width-40,itemsOrderedLabel.frame.size.height);
        
        orderDetailTableView.frame=CGRectMake(10,itemsOrderedLabel.frame.origin.y+itemsOrderedLabel.frame.size.height+10, self.view.frame.size.width-20,  120+110+(104 * orderDetailArray.count)+10);
        
        mainView.frame=CGRectMake(0,0, self.view.frame.size.width,orderDetailTableView.frame.size.height+orderDetailTableView.frame.origin.y+20);
        
        
        scrollView.contentSize=CGSizeMake(self.view.frame.size.width,mainView.frame.size.height);
    }
    else
    {
        instructionLabel.hidden=YES;
        instructionTextView.hidden=YES;
        
        itemsOrderedLabel.frame=CGRectMake(20,addressView.frame.origin.y+addressView.frame.size.height+10, self.view.frame.size.width-40,itemsOrderedLabel.frame.size.height);
        
        orderDetailTableView.frame=CGRectMake(10,itemsOrderedLabel.frame.origin.y+itemsOrderedLabel.frame.size.height+10, self.view.frame.size.width-20,  120+110+(104 * orderDetailArray.count )+10);
        
        mainView.frame=CGRectMake(0,0, self.view.frame.size.width,orderDetailTableView.frame.size.height+orderDetailTableView.frame.origin.y+20);
        
        
        scrollView.contentSize=CGSizeMake(self.view.frame.size.width,mainView.frame.size.height);
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if (section == 0)
    {
        return  orderDetailArray.count;
    }
    else if (section == 1)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 104;
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        return 120;
    }
    else{
        return 110;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2 && indexPath.row == 0) {
        OrderDetailTableViewCell *cell ;
        NSString *simpleTableIdentifier = @"rewardPoints";
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            cell = [[OrderDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        [cell displayData:pointGathered pointUsed:pointUsed];
        return cell;
    }
    else if (indexPath.section==1 && indexPath.row == 0){
        
        OrderDetailTableViewCell *cell1 ;
        NSString *simpleTableIdentifier = @"subTotal";
        cell1 = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell1 == nil)
        {
            cell1 = [[OrderDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        [cell1 displayData:baseGrandTotal shippingCharge:baseShippingAmount vatPercent:taxpercent vatAmount:baseTaxAmount grandTotal:grandTotal];
        return cell1;
        
    }
    else
    {
        OrderDetailTableViewCell *cell2 ;
        NSString *simpleTableIdentifier = @"items";
        cell2 = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell2 == nil)
        {
            cell2 = [[OrderDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        cell2.itemsContainerView.layer.borderColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0f].CGColor;
        cell2.itemsContainerView.layer.borderWidth = 2.0f;
        
        if (orderDetailArray!=nil) {
            [cell2 displayData:[orderDetailArray objectAtIndex:indexPath.row]];
            
        }
        
        return cell2;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    UIViewController *searchView =[storyboard instantiateViewControllerWithIdentifier:@"OrderDetailViewController"];
    //    [self.navigationController pushViewController:searchView animated:YES];
    
}
#pragma mark - end
#pragma mark - Webservice
-(void)getOrderDetail
{
    NSLog(@"order id %@",orderId);
    [[OrderService sharedManager] generalApiTrackOrderRequestParam:orderId email:[UserDefaultManager getValue:@"userEmail"] success:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(),^
                        {
                            [myDelegate StopIndicator];
                            
                            if (data!=nil) {
                                
                                
                            orderDetailArray=[data objectForKey:@"ProductDetails"];
                                NSMutableArray *tmpAry = [orderDetailArray mutableCopy];
                                for (int i = 0; i<orderDetailArray.count; i++)
                                {
                                    OrderDetailModel * model = [orderDetailArray objectAtIndex:i];
                                    
                                    if (![model.parentId isEqualToString:@"\n"])
                                    {
                                        [tmpAry removeObject:model];
                                    }
                                }
                                [orderDetailArray removeAllObjects];
                                orderDetailArray = [tmpAry mutableCopy];
                                
                                
                            shippingAddress=[data objectForKey:@"shipping_address"];
                            billingAddress=[data objectForKey:@"billing_address"];
                            orderDetailArray=[[[orderDetailArray reverseObjectEnumerator] allObjects] mutableCopy];
                            
                            if ([[data objectForKey:@"PaymentMethod"] isEqualToString:@"cashondelivery"])
                            {
                                paymentMethodLbl.text=@"Cash on Delivery";
                            }
                            else
                            {
                                paymentMethodLbl.text=@"ONLINE";
                            }
                            
                            baseGrandTotal=[data objectForKey:@"base_grand_total"];
                            
                                
                                
                                
                            baseShippingAmount=[data objectForKey:@"base_shipping_amount"];
                            baseTaxAmount=[data objectForKey:@"base_tax_amount"];
                            grandTotal=[data objectForKey:@"grand_total"];
                            taxpercent=[data objectForKey:@"tax_percent"];
                            
                            if ([data objectForKey:@"pointGathered"]!=nil)
                            {
                                pointGathered=[data objectForKey:@"pointGathered"];
                            }
                            else
                            {
                                pointGathered=@"0";
                            }
                            
                            if (([data objectForKey:@"pointUsed"]!=nil) && (![[data objectForKey:@"pointUsed"] isEqualToString:@"\n"]))
                            {
                                NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
                                [fmt setPositiveFormat:@"0.##"];
                                
                               pointUsed =  [fmt stringFromNumber:[NSNumber numberWithFloat:[[data objectForKey:@"pointUsed"]floatValue]]];

                                
//                                pointUsed=[data objectForKey:@"pointUsed"];
                            }
                            else
                            {
                                pointUsed=@"0";
                            }
                            
                            
                            NSString * giftMessage=[data objectForKey:@"giftMessage"];
                            
                            if (shippingAddress!=nil)
                            {
                                  shippingAddressTextView.text=[NSString stringWithFormat:@"%@ %@\n%@ %@ %@\n%@",[shippingAddress objectForKey:@"sfirstname"],[shippingAddress objectForKey:@"slastname"],[shippingAddress objectForKey:@"sstreet"],[shippingAddress objectForKey:@"scity"],[shippingAddress objectForKey:@"spostcode"],[shippingAddress objectForKey:@"stelephone"]];
                            }
                          
                            if (billingAddress!=nil)
                            {

                            billingAddressTextView.text=[NSString stringWithFormat:@"%@ %@\n%@ %@ %@\n%@",[billingAddress objectForKey:@"bfirstname"],[billingAddress objectForKey:@"blastname"],[billingAddress objectForKey:@"bstreet"],[billingAddress objectForKey:@"bcity"],[billingAddress objectForKey:@"bpostcode"],[billingAddress objectForKey:@"btelephone"]];
                            }
                            
                            [self setViewFrames:giftMessage];
                            
                            if ([data objectForKey:@"result"] != nil || [data objectForKey:@"result"] != NULL)
                            {
                                [orderDetailTableView reloadData];
                                
                            }
                            else
                            {
                                [orderDetailTableView reloadData];
                            }
                            [orderDetailTableView reloadData];
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
