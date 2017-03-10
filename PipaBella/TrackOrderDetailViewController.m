//
//  TrackOrderDetailViewController.m
//  PipaBella
//
//  Created by Hema on 10/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "TrackOrderDetailViewController.h"
#import "ItemCollectionViewCell.h"
#import "OrderService.h"

#define kCellsPerRow 2

@interface TrackOrderDetailViewController (){
    BOOL checkToggleState;
    
    NSMutableArray *orderDetailArray;
    NSMutableDictionary *shippingAddress;
    NSMutableDictionary *billingAddress;
    NSString *status;
    NSString *dateTime, *shippingCharges;
    
    
    //Price
    NSString *baseGrandTotal;
   // NSString *grandTotal;
}
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UITextField *orderIdField;
@property (weak, nonatomic) IBOutlet UITextField *emailIdField;
@property (weak, nonatomic) IBOutlet UILabel *firstSeparatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *showStatusButtonBottomLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatedDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *showStatusButton;

@property (weak, nonatomic) IBOutlet UIView *statusDetailContainerView;
@property (weak, nonatomic) IBOutlet UILabel *viewSeparatorLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *itemCollectionView;

@property (weak, nonatomic) IBOutlet UIView *shippingView;
@property (weak, nonatomic) IBOutlet UILabel *shippingToLabel;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;
@property (weak, nonatomic) IBOutlet UILabel *baseAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingChargesLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTotalLabel;

@end

@implementation TrackOrderDetailViewController
@synthesize mainScrollView,mainContainerView,orderIdField,emailIdField,firstSeparatorLabel,showStatusButtonBottomLabel,currentStatusLabel,updatedDateLabel,showStatusButton,statusDetailContainerView,viewSeparatorLabel,itemCollectionView,shippingView,shippingToLabel,addressTextView,paymentLabel,baseAmountLabel,shippingChargesLabel,orderTotalLabel;
@synthesize orderIdData,emailAddress;


#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"TRACK YOUR ORDER";
    
    [self addborder];
    
    statusDetailContainerView.hidden = YES;
    
    orderIdField.text = [NSString stringWithFormat:@"  %@", orderIdData];
    emailIdField.text = [NSString stringWithFormat:@"  %@", emailAddress];
    
    [self removeAutolayouts];
    
     [self setFrameTop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [myDelegate ShowIndicator];
    [self performSelector:@selector(getOrderDetail) withObject:nil afterDelay:.1];
   
}

-(void)addborder
{
    [orderIdField addBorder:orderIdField];
    [emailIdField addBorder:emailIdField];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Localytics tagScreen:@"Track Order Detail View"];
}

#pragma mark - end

#pragma mark - Object framing
-(void)removeAutolayouts{
    self.mainScrollView.translatesAutoresizingMaskIntoConstraints = YES;
    self.mainContainerView.translatesAutoresizingMaskIntoConstraints = YES;
    self.orderIdField.translatesAutoresizingMaskIntoConstraints = YES;
    self.emailIdField.translatesAutoresizingMaskIntoConstraints = YES;
    self.firstSeparatorLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.currentStatusLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.updatedDateLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.showStatusButton.translatesAutoresizingMaskIntoConstraints = YES;
    self.showStatusButtonBottomLabel.translatesAutoresizingMaskIntoConstraints = YES;
    
    
    self.statusDetailContainerView.translatesAutoresizingMaskIntoConstraints = YES;
    self.viewSeparatorLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.itemCollectionView.translatesAutoresizingMaskIntoConstraints = YES;
    
    self.shippingView.translatesAutoresizingMaskIntoConstraints = YES;
    self.shippingToLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.addressTextView.translatesAutoresizingMaskIntoConstraints = YES;
    self.paymentLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.baseAmountLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.shippingChargesLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.orderTotalLabel.translatesAutoresizingMaskIntoConstraints = YES;
}


-(void)setFrameTop{
    self.orderIdField.frame = CGRectMake(10, self.orderIdField.frame.origin.y, self.view.frame.size.width-20, self.orderIdField.frame.size.height);
    self.emailIdField.frame = CGRectMake(10, self.orderIdField.frame.origin.y+self.orderIdField.frame.size.height+10, self.view.frame.size.width-20, self.emailIdField.frame.size.height);
    self.firstSeparatorLabel.frame = CGRectMake(20, self.emailIdField.frame.origin.y+self.emailIdField.frame.size.height+30, self.view.frame.size.width-40, 1);
    self.currentStatusLabel.frame = CGRectMake(0, self.firstSeparatorLabel.frame.origin.y+self.firstSeparatorLabel.frame.size.height+10, self.view.frame.size.width, self.currentStatusLabel.frame.size.height);
    self.updatedDateLabel.frame = CGRectMake(20, self.currentStatusLabel.frame.origin.y+self.currentStatusLabel.frame.size.height, self.view.frame.size.width-40, self.updatedDateLabel.frame.size.height);
    self.showStatusButton.frame = CGRectMake(20, self.updatedDateLabel.frame.origin.y+self.updatedDateLabel.frame.size.height, self.showStatusButton.frame.size.width, self.showStatusButton.frame.size.height);
    self.showStatusButtonBottomLabel.frame = CGRectMake(20, self.showStatusButton.frame.origin.y+self.showStatusButton.frame.size.height, self.showStatusButtonBottomLabel.frame.size.width, 1);
    
    
    self.mainContainerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.mainScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
   // self.mainScrollView.contentSize=CGSizeMake(self.view.frame.size.width,self.mainContainerView.frame.size.height);
  
}

-(void)setFrameBottom{
    self.statusDetailContainerView.frame = CGRectMake(0, self.showStatusButtonBottomLabel.frame.origin.y+self.showStatusButtonBottomLabel.frame.size.height+10, self.view.frame.size.width, 460);
    
    self.viewSeparatorLabel.frame = CGRectMake(10, 0, self.view.frame.size.width-20, 1);
    int c;
    if (orderDetailArray.count == 1)
    {
        c = 1;
    }
    else if (orderDetailArray.count%2 == 0)
    {
        c = (int)(orderDetailArray.count/2);
    }
    else
    {
         c = (int)((orderDetailArray.count+1)/2);
    }
    self.itemCollectionView.frame = CGRectMake(4, 10, self.statusDetailContainerView.frame.size.width-8, 192*c);
    
    
    self.shippingView.frame = CGRectMake(0, self.itemCollectionView.frame.origin.y+self.itemCollectionView.frame.size.height+10, self.statusDetailContainerView.frame.size.width, 200+100);
    
    self.shippingToLabel.frame = CGRectMake(0, 0, self.shippingView.frame.size.width, self.shippingToLabel.frame.size.height);
    self.addressTextView.frame = CGRectMake(10, self.shippingToLabel.frame.size.height+10, self.shippingView.frame.size.width-20, self.addressTextView.frame.size.height);
    
    self.paymentLabel.frame = CGRectMake(0, self.addressTextView.frame.origin.y+self.addressTextView.frame.size.height+10, self.shippingView.frame.size.width, self.paymentLabel.frame.size.height);
    self.baseAmountLabel.frame = CGRectMake(10, self.paymentLabel.frame.origin.y+self.paymentLabel.frame.size.height+10, self.shippingView.frame.size.width-20, self.baseAmountLabel.frame.size.height);
    self.shippingChargesLabel.frame = CGRectMake(10, self.baseAmountLabel.frame.origin.y+self.baseAmountLabel.frame.size.height, self.shippingView.frame.size.width-20, self.shippingChargesLabel.frame.size.height);
    self.orderTotalLabel.frame = CGRectMake(10, self.shippingChargesLabel.frame.origin.y+self.shippingChargesLabel.frame.size.height, self.shippingView.frame.size.width-20, self.orderTotalLabel.frame.size.height);
    
    self.statusDetailContainerView.frame = CGRectMake(0, self.statusDetailContainerView.frame.origin.y, self.view.frame.size.width, self.shippingView.frame.origin.y+self.shippingView.frame.size.height+20);
    
    self.mainContainerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.statusDetailContainerView.frame.origin.y+self.statusDetailContainerView.frame.size.height+20);
    self.mainScrollView.contentSize=CGSizeMake(self.view.frame.size.width,self.mainContainerView.frame.size.height+100);
    
    NSLog(@"%f",self.mainScrollView.contentSize.height);
    


    
}
#pragma mark - end


#pragma mark - UICollectionView methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
     //[itemCollectionView.collectionViewLayout invalidateLayout];
        return orderDetailArray.count;
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCollectionViewCell *cell=(ItemCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"itemCell" forIndexPath:indexPath];
    //setting collection view cell size according to iPhone screens
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.itemCollectionView.collectionViewLayout;
    CGFloat availableWidthForCells = CGRectGetWidth(self.view.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow -1) - 4;
    CGFloat cellWidth = (availableWidthForCells / kCellsPerRow)-4;
    flowLayout.itemSize = CGSizeMake(cellWidth, flowLayout.itemSize.height);

    
    cell.layer.borderColor= [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0].CGColor;
    cell.layer.borderWidth= 1.0f;
    
    
    [cell layoutView:flowLayout.itemSize index:(int)indexPath.row];
    NSLog(@"--------------%f--------------",cell.frame.size.width);
    //cell.itemImageView.frame = CGRectMake(18, cell.itemImageView.frame.origin.y,flowLayout.itemSize.width-36, cell.itemImageView.frame.size.height);
    [cell displayData:[orderDetailArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - end


#pragma mark - Button actions
- (IBAction)showStatusButtonClicked:(id)sender {
    
    if(!checkToggleState)
    {
        [showStatusButton setSelected:YES];
        [showStatusButton setTitleColor:[UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0] forState:UIControlStateSelected];
        statusDetailContainerView.hidden = NO;
        [self setFrameBottom];
        
        
    }
    else
    {
        [showStatusButton setSelected:NO];
        statusDetailContainerView.hidden = YES;
        self.mainContainerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.mainScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.mainScrollView.contentSize=CGSizeMake(self.view.frame.size.width,self.mainContainerView.frame.size.height);
    }
    checkToggleState = !checkToggleState;

}

#pragma mark - end

#pragma mark - Webservice
-(void)getOrderDetail
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
            return ;
        });
    }

    
    
    NSLog(@"order id %@",orderIdData);
    [[OrderService sharedManager] generalApiTrackOrderRequestParam:orderIdData email:emailAddress success:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(),^
                        {
                            [myDelegate StopIndicator];
                            if (data!=nil)
                            {
                          
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
                            status=[data objectForKey:@"state"];
                                if ([[data objectForKey:@"status"] isEqualToString:@"0"]) {
                                    UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No record found." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                    alert1.tag = 1;
                                    [alert1 show];
                                }
                                else
                                {
                                
                            dateTime=[data objectForKey:@"formated_time"];
                            shippingAddress=[data objectForKey:@"shipping_address"];
                            shippingCharges=[data objectForKey:@"base_shipping_incl_tax"];
                            baseGrandTotal=[data objectForKey:@"base_grand_total"];
                             // grandTotal=[data objectForKey:@"grand_total"];
                            
                            currentStatusLabel.text = [NSString stringWithFormat:@"Current Status : %@", status];
                            updatedDateLabel.text = [NSString stringWithFormat:@"Updated : %@", dateTime];
                            addressTextView.text=[NSString stringWithFormat:@"%@ %@\n%@ %@ %@\n%@",[shippingAddress objectForKey:@"sfirstname"],[shippingAddress objectForKey:@"slastname"],[shippingAddress objectForKey:@"sstreet"],[shippingAddress objectForKey:@"scity"],[shippingAddress objectForKey:@"spostcode"],[shippingAddress objectForKey:@"stelephone"]];
                            
                            baseAmountLabel.text = [NSString stringWithFormat:@"Base amount : %@", baseGrandTotal];
                            shippingChargesLabel.text = [NSString stringWithFormat:@"Shipping charges : %@", shippingCharges];
                            orderTotalLabel.text = [NSString stringWithFormat:@"Order total charges : %@", baseGrandTotal];
                            
                            
                            
//                            
//                            if ([data objectForKey:@"result"] != nil || [data objectForKey:@"result"] != NULL)
//                            {
//                                [itemCollectionView reloadData];
//                                
//                            }
//                            else
//                            {
//                                [itemCollectionView reloadData];
//                            }
                            [itemCollectionView reloadData];
                                }
                            }
                            else{
                                [myDelegate StopIndicator];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1)
    {
        if (buttonIndex==0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - end


@end
