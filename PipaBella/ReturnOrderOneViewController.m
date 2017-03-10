//
//  ReturnOrderOneViewController.m
//  PipaBella
//
//  Created by Ranosys on 06/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "ReturnOrderOneViewController.h"
#import "ReturnOrderTableViewCell.h"
#import "ReturnOrderTwoViewController.h"
#import "ReturnOrderModel.h"
#import "ReturnOrderService.h"

@interface ReturnOrderOneViewController (){
    NSMutableArray *returnDataArray, *packing, *reason, *type;
    ReturnOrderModel *returnOrderDataModel;
     int buttonTag;
    NSString *policy, *address, *orderIdData;
    NSMutableDictionary *pickerDataDic;
    NSMutableDictionary *orderDetailDictMut;
}
@property (weak, nonatomic) IBOutlet UITableView *returnOrderTableView;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIImageView *stepOneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *stepTwoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *stepThreeImageView;

@end

@implementation ReturnOrderOneViewController
@synthesize returnOrderTableView,continueButton,stepOneImageView,stepTwoImageView,stepThreeImageView;
@synthesize orderIdForReturn,objOrderHistory;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=@"RETURN ORDER";
    
    //continueButton.enabled = NO;
    
    self.stepOneImageView.layer.cornerRadius = self.stepOneImageView.frame.size.width / 2;
    self.stepOneImageView.clipsToBounds = YES;
    
    self.stepTwoImageView.layer.cornerRadius = self.stepTwoImageView.frame.size.width / 2;
    self.stepTwoImageView.clipsToBounds = YES;

    self.stepThreeImageView.layer.cornerRadius = self.stepThreeImageView.frame.size.width / 2;
    self.stepThreeImageView.clipsToBounds = YES;
    
    returnDataArray=[[NSMutableArray alloc]init];
    packing=[[NSMutableArray alloc]init];
    reason=[[NSMutableArray alloc]init];
    type=[[NSMutableArray alloc]init];
    
    pickerDataDic=[[NSMutableDictionary alloc]init];
    
    orderDetailDictMut=[[NSMutableDictionary alloc]init];

    
   

    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Localytics tagScreen:@"Return Order Step1"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [myDelegate ShowIndicator];
    [self performSelector:@selector(getReturnOrderData) withObject:nil afterDelay:.1];}


#pragma mark - end

#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
   return returnDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"returnCell";
    ReturnOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[ReturnOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.containerView.layer.borderColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0f].CGColor;
    cell.containerView.layer.borderWidth = 2.0f;
    
    [cell displayData:[returnDataArray objectAtIndex:indexPath.row]];
    
    orderIdData = cell.orderIdLabel.text ;
    
    cell.checkButton.tag=indexPath.row;
    [cell.checkButton addTarget:self action:@selector(checklist:) forControlEvents:UIControlEventTouchDown];
    
    

    return cell;
}
- (IBAction)checklist:(UIButton*)sender
{
    buttonTag = (int)[sender tag];
    returnOrderDataModel=[returnDataArray objectAtIndex:buttonTag];
    
    if ([sender isSelected]) {
        [orderDetailDictMut removeObjectForKey:[returnOrderDataModel itemId]];
         returnOrderDataModel.checker=NO;
        [sender setSelected:NO];
        //continueButton.enabled = NO;
    }
    else
    {
         returnOrderDataModel.checker=YES;
        [sender setSelected:YES];
        [orderDetailDictMut setObject:[returnOrderDataModel qty] forKey:[returnOrderDataModel itemId]];
        //continueButton.enabled = YES;

    }
      [returnOrderTableView reloadData];
}
#pragma mark - end


#pragma mark - Button actions
- (IBAction)continueButtonAction:(id)sender {
    bool canReturn = true;
    for (int i =0; i<returnDataArray.count; i++)
    {
        ReturnOrderModel * objModel = [returnDataArray objectAtIndex:i];
        if ([objModel.isVisible isEqualToString:@"No"])
        {
            canReturn = false;
        }
        else
        {
            canReturn =true;
        }
    }
    if (!canReturn)
    {
        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"No item(s) to return" parentView:self.view];
        //[self.view makeToast:@"No item(s) to return." image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
    }
   else if (orderDetailDictMut.count == 0 )
    {
         [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please select an item to return" parentView:self.view];
       // [self.view makeToast:@"Please select an item to return" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
    }
    else
    {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ReturnOrderTwoViewController *returnView =[storyboard instantiateViewControllerWithIdentifier:@"ReturnOrderTwoViewController"];
        returnView.policyString = policy;
        returnView.addressString = address;
        returnView.pickerDataDictionary = pickerDataDic;
        returnView.orderIdData = orderIdData;
        returnView.itemDetailDataDictionary = orderDetailDictMut;
        [self.navigationController pushViewController:returnView animated:YES];
    }


}
#pragma mark - end


#pragma mark - Webservice
-(void)getReturnOrderData
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
            return ;
        });
    }
   
    
    [[ReturnOrderService sharedManager] returnOrder:orderIdForReturn success:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(),^
                        {
                            [myDelegate StopIndicator];
                            if(data==nil)
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                    [alert1 show];
                                });
                            }
                            else if ([[data objectForKey:@"status"] isEqualToString:@"0"])
                            {
                                objOrderHistory.shouldNotReturn = true;
                                objOrderHistory.message = [data objectForKey:@"message"];
                                [self.navigationController popViewControllerAnimated:NO];
                            }
                            else
                            {
                                policy = [data objectForKey:@"policy"];
                                address = [data objectForKey:@"address"];
                                [pickerDataDic setObject:[data objectForKey:@"packing"] forKey:@"packing"];
                                [pickerDataDic setObject:[data objectForKey:@"reason"] forKey:@"reason"];
                                [pickerDataDic setObject:[data objectForKey:@"type"] forKey:@"type"];
                                returnDataArray=[data objectForKey:@"rmastepdetails"];
                                
                                [returnOrderTableView reloadData];
                                if (returnDataArray.count>0)
                                {
                                    // noProductsLbl.hidden = YES;
                                }
                                else
                                {
                                    // noProductsLbl.hidden = NO;
                                }
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
