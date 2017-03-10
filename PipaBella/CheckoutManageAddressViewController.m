//
//  CheckoutManageAddressViewController.m
//  PipaBella
//
//  Created by Ranosys on 05/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "CheckoutManageAddressViewController.h"
#import "AccountService.h"
#import "ManageAddressDataModel.h"
#import "AddressTableViewCell.h"
#import "CheckoutAddAddressViewController.h"
#import "OrderService.h"
#import "CheckoutPaymentViewController.h"
@interface CheckoutManageAddressViewController ()
{
    NSMutableArray *getAddressList;
    long buttonTag;
    ManageAddressDataModel *addressData;
    int checkSelAddress;
    UILabel* deliveryLabel;
    long deletedBtnTag;
}
@property (weak, nonatomic) IBOutlet UIButton *reviewButton;
@property (weak, nonatomic) IBOutlet UIButton *deliverToButton;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIView *noAddressFoundView;
@property (weak, nonatomic) IBOutlet UITableView *addressTableView;
@property (weak, nonatomic) IBOutlet UIButton *addAnotherAddressButton;
@property(strong,nonatomic)NSString *customerAddressId;
@property (weak, nonatomic) IBOutlet UIButton *addNewAddressButton;

@end

@implementation CheckoutManageAddressViewController
@synthesize reviewButton,deliverToButton,payButton,noAddressFoundView,addAnotherAddressButton,addressTableView,customerAddressId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    checkSelAddress=0;
    self.navigationItem.title=@"CHECKOUT";
    
    [reviewButton addBorder:reviewButton color:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0]];
    [reviewButton setTitleColor:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [deliverToButton addBorder:deliverToButton color:[UIColor colorWithRed:241.0/255.0 green:0.0/255.0 blue:136.0/255.0 alpha:1.0]];
    [deliverToButton setTitleColor:[UIColor colorWithRed:241.0/255.0 green:0.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [payButton addBorder:payButton color:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0]];
    [payButton setTitleColor:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [self setCornerRadius];
    [self setBorder];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [myDelegate ShowIndicator];
    [self performSelector:@selector(getAddressListWebservice) withObject:nil afterDelay:.1];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //NSLog(@"Tab Id = %d, SELECTED INDEX = %lu",myDelegate.tabId,self.tabBarController.selectedIndex);
    if (myDelegate.tabId != self.tabBarController.selectedIndex)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(void) setCornerRadius
{
    [noAddressFoundView setCornerRadius:2.0f];
}
-(void)setBorder
{
    [noAddressFoundView setViewBorder:noAddressFoundView color:[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0] ];
    [addAnotherAddressButton addBorder:addAnotherAddressButton color:[UIColor colorWithRed:154.0/255.0 green:153.0/255.0 blue:154.0/255.0 alpha:1.0]];
    
}
#pragma mark - end
#pragma mark - Webservices

-(void)getAddressListWebservice
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
        });
    }
    else
    {
        
        [[AccountService sharedManager] addressList:^(id data)
         {
             //Handle fault cases
             dispatch_async(dispatch_get_main_queue(), ^{
                 // code here
                 [myDelegate StopIndicator];
                 if (data!=nil)
                 {
                     getAddressList=[data mutableCopy];
                     
                     getAddressList=[[[getAddressList reverseObjectEnumerator] allObjects] mutableCopy];
                     
                     //NSLog(@"count %lu",(unsigned long)getAddressList.count);
                     if (getAddressList.count > 0)
                     {
                         
                         noAddressFoundView.hidden=YES;
                         addAnotherAddressButton.hidden=NO;
                         addressTableView.hidden=NO;
                         [addressTableView reloadData];
                         
                     }
                     else
                     {
                         noAddressFoundView.hidden=NO;
                         addAnotherAddressButton.hidden=YES;
                         addressTableView.hidden=YES;
                         
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
    
}

-(void)deleteAddressWebservice:(NSNumber *)tag
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
        });
    }
    else
    {
        
        [[AccountService sharedManager] deleteAddress:customerAddressId success:^(id data)
         {
             //Handle fault cases
             dispatch_async(dispatch_get_main_queue(), ^{
                 // code here
                 [myDelegate StopIndicator];
                 if ([[data objectForKey:@"result"] isEqualToString:@"true"]) {
                     [getAddressList removeObjectAtIndex:[tag intValue]];
                     if (getAddressList.count > 0)
                     {
                         _indexPathPosition=0;
                         noAddressFoundView.hidden=YES;
                         addAnotherAddressButton.hidden=NO;
                         addressTableView.hidden=NO;
                         [addressTableView reloadData];
                         
                     }
                     else
                     {
                         noAddressFoundView.hidden=NO;
                         addAnotherAddressButton.hidden=YES;
                         addressTableView.hidden=YES;
                         
                     }
                     [addressTableView reloadData];
                 }
                 else
                 {
                     
                 }
                 
             });
             
         }
                                              failure:^(NSError *error)
         {
             //Handle if response is nil
             
         }];
    }
    
}


#pragma mark - end
#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section==0)
    {
        return getAddressList.count;
    }
    else
    {
        return 1;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        NSString *simpleTableIdentifier = @"AddressCell";
        AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            cell = [[AddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        [cell.editButton addTarget:self action:@selector(editAddress:) forControlEvents:UIControlEventTouchDown];
        [cell.deleteButton addTarget:self action:@selector(deleteAddress:) forControlEvents:UIControlEventTouchDown];
        [cell.selectAddressBtn addTarget:self action:@selector(selectAddressButtonClick:) forControlEvents:UIControlEventTouchDown];
        
        cell.selectAddressBtn.tag=indexPath.row;
        cell.editButton.tag=indexPath.row;
        cell.deleteButton.tag=indexPath.row;
        
        if (_isAddScreen)
        {
            for (int i=0; i<getAddressList.count; i++)
            {
                if (indexPath.row == _indexPathPosition)
                {
                    checkSelAddress=1;
                    ManageAddressDataModel *  addressDataModel=[getAddressList objectAtIndex:_indexPathPosition];
                    addressDataModel.checkSelectionState=1;
                    [getAddressList replaceObjectAtIndex:_indexPathPosition withObject:addressDataModel];
                    
                }
                else
                {
                    ManageAddressDataModel *  addressDataModel=[getAddressList objectAtIndex:_indexPathPosition];
                    addressDataModel.checkSelectionState=0;
                    [getAddressList replaceObjectAtIndex:_indexPathPosition withObject:addressDataModel];
                    
                }
            }
        }
        
        
        [cell displayData:[getAddressList objectAtIndex:indexPath.row]];
        
        
        return cell;
    }
    else
    {
        static NSString *simpleTableIdentifier = @"AddressButtonCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        UIButton *addAddressBtn =(UIButton *)[cell.contentView viewWithTag:1];
        [addAddressBtn addBorder:addAddressBtn color:[UIColor colorWithRed:154.0/255.0 green:153.0/255.0 blue:154.0/255.0 alpha:1.0]];
        [addAddressBtn addTarget:self action:@selector(addAnotherAddressAction:) forControlEvents:UIControlEventTouchUpInside];
        
      UILabel *  deliveryTimeLabel =(UILabel *)[cell viewWithTag:10];
        
        
        UIFont *fnt = [UIFont systemFontOfSize:8 weight:UIFontWeightBold];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"ESTIMATED DELIVERY TIME: " attributes:@{NSFontAttributeName: [fnt fontWithSize:8]}];
        //        [attributedString setAttributes:@{NSFontAttributeName : [fnt fontWithSize:8] , NSBaselineOffsetAttributeName : @2} range:NSMakeRange(1, 2)];
        NSString *test = [NSString stringWithFormat:@"1-2 WORKING DAYS AFTER ORDER"];
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:test];
        
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:8 weight:UIFontWeightRegular] range:(NSMakeRange(0, test.length))];
        NSMutableAttributedString *result = [attributedString mutableCopy];
        [result appendAttributedString:string];
        deliveryTimeLabel.attributedText = result;
        deliveryLabel = deliveryTimeLabel;
//        deliveryTimeLabel.hidden=YES;
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 150;
    }
    else
    {
        return 100;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
#pragma mark - end


#pragma mark - Button actions

- (IBAction)addNewAddressButtonClicked:(id)sender {
    
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CheckoutAddAddressViewController *editAddresss =[storyboard instantiateViewControllerWithIdentifier:@"CheckoutAddAddressViewController"];
    //    editAddresss.checkVC=self;
    //    editAddresss.indexPathPosition=0;
    
    [self.navigationController pushViewController:editAddresss animated:YES];
    
}



-(IBAction)addAnotherAddressAction:(id)sender
{
    
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CheckoutAddAddressViewController *editAddresss =[storyboard instantiateViewControllerWithIdentifier:@"CheckoutAddAddressViewController"];
    editAddresss.checkVC=self;
    editAddresss.indexPathPosition=0;
    
    [self.navigationController pushViewController:editAddresss animated:YES];
    
}
- (IBAction)editAddress:(UIButton*)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CheckoutAddAddressViewController *editAddresss =[storyboard instantiateViewControllerWithIdentifier:@"CheckoutAddAddressViewController"];
    editAddresss.isEditScreen=true;
    editAddresss.addressId=[[getAddressList objectAtIndex:[sender tag]] customerAddressId];
    editAddresss.firstNameStr=[[getAddressList objectAtIndex:[sender tag]] firstname];
    editAddresss.lastNameStr=[[getAddressList objectAtIndex:[sender tag]] lastname];
    
    NSArray *streetArray = [[[getAddressList objectAtIndex:[sender tag]] street] componentsSeparatedByString:@"\n"];
    if (streetArray.count==2) {
        editAddresss.address1=[streetArray objectAtIndex:0];
        editAddresss.address2 = [streetArray objectAtIndex:1];
    }
    else if(streetArray.count==1) {
        editAddresss.address1=[streetArray objectAtIndex:0];
        editAddresss.address1 = @"";
    }
    else{
        editAddresss.address1=@"";
        editAddresss.address1 = @"";
    }
    editAddresss.regionId=[[getAddressList objectAtIndex:[sender tag]] regionId];
    editAddresss.cityStr=[[getAddressList objectAtIndex:[sender tag]] city];
    editAddresss.phoneNumberStr=[[getAddressList objectAtIndex:[sender tag]] telephone];
    editAddresss.countryStr=[[getAddressList objectAtIndex:[sender tag]] countryId];
    editAddresss.stateStr=[[getAddressList objectAtIndex:[sender tag]] stateName];
    editAddresss.postalCodeStr=[[getAddressList objectAtIndex:[sender tag]] postcode];
    editAddresss.checkVC=self;
    editAddresss.indexPathPosition=[sender tag];
    
    [self.navigationController pushViewController:editAddresss animated:YES];
    
}
- (IBAction)deleteAddress:(UIButton*)sender
{
    deletedBtnTag = (int)[sender tag];
    customerAddressId=[[getAddressList objectAtIndex:deletedBtnTag] customerAddressId];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Are you sure you want to delete this address?"
                                                   delegate:self
                                          cancelButtonTitle:@"Yes"
                                          otherButtonTitles:@"No", nil];
    alert.tag=1;
    [alert show];
    
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1)
    {
        if (buttonIndex==0)
        {
            [myDelegate ShowIndicator];
            [self performSelector:@selector(deleteAddressWebservice:) withObject:[NSNumber numberWithLong:deletedBtnTag] afterDelay:.1];
        }
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)setCheckoutAddress:(id)sender
{
    for (int i=0; i<getAddressList.count; i++)
    {
        addressData=[getAddressList objectAtIndex:i];
        if (addressData.checkSelectionState==1)
        {
            buttonTag=i;

            checkSelAddress=1;
        }
        else
        {
            
        }
    }
    
    if (checkSelAddress==1)
    {
        [myDelegate ShowIndicator];
        [self performSelector:@selector(setCartAddress:) withObject:[NSNumber numberWithLong:buttonTag] afterDelay:.1];
    }
    else
    {
         [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please select address" parentView:self.view];
       // [self.view makeToast:@"Please select address" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        
//        UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert1 show];
    }
    
    
    
}
-(void)setCartAddress:(NSNumber *)tag
{
    //    editAddresss.addressId=[[getAddressList objectAtIndex:[sender tag]] customerAddressId];
    //    editAddresss.firstNameStr=[[getAddressList objectAtIndex:[sender tag]] firstname];
    //    editAddresss.lastNameStr=[[getAddressList objectAtIndex:[sender tag]] lastname];
    
    NSString *address1;
    NSString *address2;
    
    NSArray *streetArray = [[[getAddressList objectAtIndex:buttonTag] street] componentsSeparatedByString:@"\n"];
    if (streetArray.count==2) {
        address1=[streetArray objectAtIndex:0];
        address2 = [streetArray objectAtIndex:1];
    }
    else if(streetArray.count==1) {
        address1=[streetArray objectAtIndex:0];
        address2 = @"";
    }
    else
    {
        address1=@"";
        address2 = @"";
    }
    //    editAddresss.regionId=[[getAddressList objectAtIndex:[sender tag]] regionId];
    //    editAddresss.cityStr=[[getAddressList objectAtIndex:[sender tag]] city];
    //    editAddresss.phoneNumberStr=[[getAddressList objectAtIndex:[sender tag]] telephone];
    //    editAddresss.countryStr=[[getAddressList objectAtIndex:[sender tag]] countryId];
    //    editAddresss.stateStr=[[getAddressList objectAtIndex:[sender tag]] stateName];
    //    editAddresss.postalCodeStr=[[getAddressList objectAtIndex:[sender tag]] postcode];
    
    
    
    
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
            
        });
    }
    else
    {
        
        [[OrderService sharedManager]shoppingCartCustomerAddressesRequestParam:[[getAddressList objectAtIndex:buttonTag] firstname] lastname:[[getAddressList objectAtIndex:buttonTag] lastname] shippingMode:@"" addressId:[[getAddressList objectAtIndex:buttonTag] customerAddressId] streetAddress1:address1 city:[[getAddressList objectAtIndex:buttonTag] city] mobile:[[getAddressList objectAtIndex:buttonTag] telephone] countryCode:[[getAddressList objectAtIndex:buttonTag] countryId] postcode:[[getAddressList objectAtIndex:buttonTag] postcode] streetAddress2:address2 state:[[getAddressList objectAtIndex:buttonTag] stateName] regionId:[[getAddressList objectAtIndex:buttonTag] regionId]  success:^(id data)
         {
             //Handle fault cases
             dispatch_async(dispatch_get_main_queue(), ^{
                 // code here
                 [myDelegate StopIndicator];
                 
                 if (data != nil)
                 {
                     
                     if ([data objectForKey:@"result"] != nil || [data objectForKey:@"result"] != NULL)
                     {
                         UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                         CheckoutPaymentViewController *editAddresss =[storyboard instantiateViewControllerWithIdentifier:@"CheckoutPaymentViewController"];
                         editAddresss.totalPrice=_totalPrice;
                         [self.navigationController pushViewController:editAddresss animated:YES];                     }
                     else
                     {
                         UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                         [alert1 show];
                     }
                 }
             });
         }
                                                                       failure:^(NSError *error)
         {
             //Handle if response is nil
         }];
    }
}
- (IBAction)selectAddressButtonClick:(UIButton*)sender
{
    buttonTag=[sender tag];
    deliveryLabel.hidden= NO;
    for (int i=0; i<getAddressList.count; i++)
    {
        if (buttonTag == i)
        {
            ManageAddressDataModel *  addressDataModel=[getAddressList objectAtIndex:i];
            addressDataModel.checkSelectionState=1;
            [getAddressList replaceObjectAtIndex:i withObject:addressDataModel];
            
        }
        else
        {
            ManageAddressDataModel *  addressDataModel=[getAddressList objectAtIndex:i];
            addressDataModel.checkSelectionState=0;
            [getAddressList replaceObjectAtIndex:i withObject:addressDataModel];
            
        }
        _indexPathPosition=[sender tag];

    }
    [addressTableView reloadData];
    
}
@end
