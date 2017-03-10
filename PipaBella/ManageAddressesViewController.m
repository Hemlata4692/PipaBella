//
//  ManageAddressesViewController.m
//  PipaBella
//
//  Created by Ranosys on 21/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "ManageAddressesViewController.h"
#import "AddressTableViewCell.h"
#import "AccountService.h"
#import "AddAddressViewController.h"
#import "ManageAddressDataModel.h"

@interface ManageAddressesViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *getAddressList;
    int buttonTag;
     ManageAddressDataModel *addressData;
}
@property (weak, nonatomic) IBOutlet UIView *noAddressFoundView;
@property (weak, nonatomic) IBOutlet UITableView *addressTableView;
@property (weak, nonatomic) IBOutlet UIButton *addAnotherAddressButton;
@property(strong,nonatomic)NSString *customerAddressId;
@end

@implementation ManageAddressesViewController
@synthesize noAddressFoundView,addressTableView,addAnotherAddressButton,customerAddressId;
@synthesize checkVC,isReturnScreen;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"ADDRESS";
    
    [self setCornerRadius];
    [self setBorder];
    // Do any additional setup after loading the view.
    addAnotherAddressButton.hidden=YES;
    getAddressList=[[NSMutableArray alloc]init];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [myDelegate ShowIndicator];
    [self performSelector:@selector(getAddressListWebservice) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                 getAddressList=[data mutableCopy];
                 if (getAddressList.count==0) {
                     noAddressFoundView.hidden=NO;
                     addAnotherAddressButton.hidden=YES;
                     addressTableView.hidden=YES;
                 }
                 else
                 {
                     noAddressFoundView.hidden=YES;
                     addAnotherAddressButton.hidden=NO;
                     addressTableView.hidden=NO;
                     [addressTableView reloadData];
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
                     if (getAddressList.count==0) {
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
    if (indexPath.section==0)
    {
        
        NSString *simpleTableIdentifier = @"AddressCell";
        AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            cell = [[AddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        [cell.editButton addTarget:self action:@selector(editAddress:) forControlEvents:UIControlEventTouchDown];
        [cell.deleteButton addTarget:self action:@selector(deleteAddress:) forControlEvents:UIControlEventTouchDown];
        cell.editButton.tag=indexPath.row;
        cell.deleteButton.tag=indexPath.row;
        cell.addressTextView.tag = indexPath.row;
        [cell.addressTextView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didReceiveGestureOnText:)]];
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
        return cell;
    }
    
}
-(void)didReceiveGestureOnText:(UITapGestureRecognizer*)recognizer
{
    UITextView *tView = (UITextView *)recognizer.view;
    if (isReturnScreen) {
        addressData=[getAddressList objectAtIndex:tView.tag];
        NSString *address=[NSString stringWithFormat:@" %@ \n %@, \n %@, \n %@, \n %@ \n",addressData.firstname,addressData.street,addressData.city,addressData.postcode, addressData.telephone];
        
        checkVC.address = address;
        [self.navigationController popViewControllerAnimated:YES];
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
        return 60;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isReturnScreen) {
        addressData=[getAddressList objectAtIndex:indexPath.row];
        NSString *address=[NSString stringWithFormat:@" %@ \n %@, \n %@, \n %@, \n %@ \n",addressData.firstname,addressData.street,addressData.city,addressData.postcode, addressData.telephone];
        
        checkVC.address = address;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
 
    
}
#pragma mark - end


#pragma mark - Button actions
-(IBAction)addAnotherAddressAction:(id)sender
{

    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddAddressViewController *editAddresss =[storyboard instantiateViewControllerWithIdentifier:@"AddAddressViewController"];
    [self.navigationController pushViewController:editAddresss animated:YES];

}
- (IBAction)editAddress:(UIButton*)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddAddressViewController *editAddresss =[storyboard instantiateViewControllerWithIdentifier:@"AddAddressViewController"];
    editAddresss.isEditScreen=true;
    editAddresss.addressId=[[getAddressList objectAtIndex:[sender tag]] customerAddressId];
    editAddresss.firstName=[[getAddressList objectAtIndex:[sender tag]] firstname];
    editAddresss.lastName=[[getAddressList objectAtIndex:[sender tag]] lastname];
    
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
    editAddresss.city=[[getAddressList objectAtIndex:[sender tag]] city];
    editAddresss.phoneNumber=[[getAddressList objectAtIndex:[sender tag]] telephone];
    editAddresss.country=[[getAddressList objectAtIndex:[sender tag]] countryId];
    editAddresss.state=[[getAddressList objectAtIndex:[sender tag]] stateName];
    editAddresss.postalCode=[[getAddressList objectAtIndex:[sender tag]] postcode];
    
    [self.navigationController pushViewController:editAddresss animated:YES];
    
}
- (IBAction)deleteAddress:(UIButton*)sender
{
    buttonTag = (int)[sender tag];
    customerAddressId=[[getAddressList objectAtIndex:buttonTag] customerAddressId];
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
            [self performSelector:@selector(deleteAddressWebservice:) withObject:[NSNumber numberWithInt:buttonTag] afterDelay:.1];
            
        }
    }
}


- (IBAction)addAddressButtonAction:(id)sender {
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"AddAddressViewController"];
    [self.navigationController pushViewController:view animated:YES];
    
}

- (IBAction)addAnotherAddressButtonAction:(id)sender {
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"AddAddressViewController"];
    [self.navigationController pushViewController:view animated:YES];
}
#pragma mark - end

@end
