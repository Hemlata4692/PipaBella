//
//  ReturnOrderThreeViewController.m
//  PipaBella
//
//  Created by Ranosys on 06/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "ReturnOrderThreeViewController.h"
#import "ReturnOrderService.h"
#import "ManageAddressesViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface ReturnOrderThreeViewController (){
    NSMutableArray *confirmReturnArray;
    int pickUpId;
    NSString *addressValue;
}
@property (weak, nonatomic) IBOutlet UIImageView *stepOneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *stepTwoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *stepThreeImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIPickerView *returnPickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *returnPickerToolbar;

@property (weak, nonatomic) IBOutlet UITextField *pickupInformationTextfield;
@property (weak, nonatomic) IBOutlet UIButton *pickupInformationButton;
@property (weak, nonatomic) IBOutlet UILabel *confirmLabel;
@property (weak, nonatomic) IBOutlet UITextView *confirmAddressTextView;
@property (weak, nonatomic) IBOutlet UIButton *addAddressButton;
@property (weak, nonatomic) IBOutlet UITextView *addressView;

@end

@implementation ReturnOrderThreeViewController
@synthesize stepOneImageView,stepTwoImageView,stepThreeImageView;
@synthesize scrollView,containerView,submitButton;
@synthesize returnPickerToolbar,returnPickerView;
@synthesize pickupInformationTextfield,pickupInformationButton,confirmLabel,confirmAddressTextView,addAddressButton,addressView;
@synthesize orderIdData,addressStringText,typeId,reasonId,packingId,itemDetailDataDictionary,additionalInfo;


@synthesize address;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=@"RETURN ORDER";
    
    
    self.stepOneImageView.layer.cornerRadius = self.stepOneImageView.frame.size.width / 2;
    self.stepOneImageView.clipsToBounds = YES;
    
    self.stepTwoImageView.layer.cornerRadius = self.stepTwoImageView.frame.size.width / 2;
    self.stepTwoImageView.clipsToBounds = YES;
    
    self.stepThreeImageView.layer.cornerRadius = self.stepThreeImageView.frame.size.width / 2;
    self.stepThreeImageView.clipsToBounds = YES;
    
    [self addborder];
    
    confirmLabel.hidden = YES;
    confirmAddressTextView.hidden = YES;
    addAddressButton.hidden = YES;
     addressView.hidden = YES;
    
    addAddressButton.layer.borderColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0].CGColor;
    addAddressButton.layer.borderWidth = 1.0f;
    
    [[self.addressView layer] setBorderColor:[[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0] CGColor]];
    [[self.addressView layer] setBorderWidth:1.5];
    
    [[self.confirmAddressTextView layer] setBorderColor:[[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0] CGColor]];
    [[self.confirmAddressTextView layer] setBorderWidth:1.5];
    
    
    confirmReturnArray=[[NSMutableArray alloc] initWithObjects:
              @"YES",
              @"NO",
              nil];
    
    returnPickerView.translatesAutoresizingMaskIntoConstraints=YES;
    returnPickerToolbar.translatesAutoresizingMaskIntoConstraints=YES;
    
    address = @"";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addborder
{
    [pickupInformationButton addBorder:pickupInformationButton];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    // Dispose of any resources that can be recreated.
    
    addressView.text = [NSString stringWithFormat:@"%@", address];
    addressValue = addressView.text;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Localytics tagScreen:@"Return Order Step3"];
}

#pragma mark - end


#pragma mark - Picker

-(void)pickerShow
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [returnPickerView setNeedsLayout];
    
   // [returnPickerView selectRow:[confirmReturnArray indexOfObject:confirmTextfield.text] inComponent:0 animated:YES];
    
    [returnPickerView reloadAllComponents];
    returnPickerView.frame = CGRectMake(returnPickerView.frame.origin.x, self.view.bounds.size.height-returnPickerView.frame.size.height , self.view.bounds.size.width, returnPickerView.frame.size.height);
    returnPickerToolbar.frame = CGRectMake(returnPickerToolbar.frame.origin.x, returnPickerView.frame.origin.y-44, self.view.bounds.size.width, returnPickerToolbar.frame.size.height);
    [UIView commitAnimations];
}



- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,600,20)];
        pickerLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        pickerLabel.textAlignment=NSTextAlignmentCenter;
    }
    
        if (confirmReturnArray.count>row)
        {
            NSString *str=[confirmReturnArray objectAtIndex:row];
            pickerLabel.text=str;
        }
        
   
    return pickerLabel;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return confirmReturnArray.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // [_keyboardControls.activeField resignFirstResponder];
    
   
        NSString *str=[confirmReturnArray objectAtIndex:row];
        return str;
}

- (IBAction)pickerToolBar:(id)sender
{
    NSInteger index = [returnPickerView selectedRowInComponent:0];
    pickupInformationTextfield.text=[confirmReturnArray objectAtIndex:index];
    [self hidePickerWithAnimation];
    
    if ([pickupInformationTextfield.text isEqualToString:@"YES"]) {
        pickUpId = 1;
        confirmLabel.hidden = NO;
        confirmAddressTextView.hidden = NO;
        confirmAddressTextView.text = [NSString stringWithFormat:@"%@", addressStringText];
        addressValue = confirmAddressTextView.text;
        addAddressButton.hidden = YES;
        addressView.hidden = YES;
    }
    else if ([pickupInformationTextfield.text isEqualToString:@"NO"]){
        pickUpId = 2;
        addAddressButton.hidden = NO;
        addressView.hidden = NO;
        confirmLabel.hidden = YES;
        confirmAddressTextView.hidden = YES;
        
    }
}

-(void)hidePickerWithAnimation
{
    // scrollView.scrollEnabled = YES;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    returnPickerView.frame = CGRectMake(returnPickerView.frame.origin.x, 1000, self.view.bounds.size.width, returnPickerView.frame.size.height);
    returnPickerToolbar.frame = CGRectMake(returnPickerToolbar.frame.origin.x, 1000, self.view.bounds.size.width, returnPickerToolbar.frame.size.height);
    [UIView commitAnimations];
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

#pragma mark - Webservice
-(void)submitReturnOrderData
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
            return ;
            
        });
    }

    [Localytics tagEvent:@"Return order request submitted" attributes:@{@"order_id" : orderIdData}];
    [[ReturnOrderService sharedManager] submitReturnOrder:[NSString stringWithFormat:@"%d",reasonId] orderIncrementId:orderIdData additionalinfo:additionalInfo orderData:itemDetailDataDictionary requesttype:[NSString stringWithFormat:@"%d",typeId] packageopened:[NSString stringWithFormat:@"%d",packingId] pick_from:[NSString stringWithFormat:@"%d",pickUpId] address:addressValue success:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(),^
                        {
                            [myDelegate StopIndicator];
                            if (data!=nil)
                            {
                                UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"New RMA request has been successfully added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                alert1.tag=1;
                                [alert1 show];
                           
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1)
    {
        if (buttonIndex==0)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

#pragma mark - end


#pragma mark - Button actions
- (IBAction)cancel:(id)sender
{
    [self hidePickerWithAnimation];
}

- (IBAction)submitButtonClicked:(id)sender {
    
    if ([addressView.text isEqualToString:@""] && [pickupInformationTextfield.text isEqualToString:@"NO"]) {
//        UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert1 show];
        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter the address" parentView:self.view];
       // [self.view makeToast:@"Please enter the address" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
    }
    else{
        [myDelegate ShowIndicator];
        [self performSelector:@selector(submitReturnOrderData) withObject:nil afterDelay:.1];
    }
    
}
- (IBAction)addAddressButtonClicked:(id)sender {
    
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ManageAddressesViewController *returnView =[storyboard instantiateViewControllerWithIdentifier:@"ManageAddressesViewController"];
    returnView.isReturnScreen = YES;
    returnView.checkVC = self;
    [self.navigationController pushViewController:returnView animated:YES];

}
- (IBAction)pickupInformationButtonClicked:(id)sender {
    [self pickerShow];
}

#pragma mark - end
@end
