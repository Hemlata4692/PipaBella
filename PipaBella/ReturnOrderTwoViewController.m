//
//  ReturnOrderTwoViewController.m
//  PipaBella
//
//  Created by Ranosys on 06/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "ReturnOrderTwoViewController.h"
#import "ReturnOrderThreeViewController.h"
#import "ReturnPolicyViewController.h"
#import "ReturnOrderModel.h"

@interface ReturnOrderTwoViewController ()<UITextFieldDelegate>{
    BOOL checkToggleState;
    NSMutableArray *tagArray,*requestTypeArray,*reasonOfReturnArray;
    int managePicker;
    ReturnOrderModel *dataModel;
    int reasonId,typeId,packingId;
    int tagChecker,requestChecker,reasonChecker;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *stepOneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *stepTwoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *stepThreeImageView;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextField *additionalInfoField;



@property (weak, nonatomic) IBOutlet UIButton *termsCheckButton;
@property (weak, nonatomic) IBOutlet UIButton *returnPolicyButton;
@property (weak, nonatomic) IBOutlet UIPickerView *returnProductPickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *returnPickerToolbar;

@property (weak, nonatomic) IBOutlet UITextField *tagTextField;
@property (weak, nonatomic) IBOutlet UIButton *tagButton;
@property (weak, nonatomic) IBOutlet UITextField *requestTypeTextField;
@property (weak, nonatomic) IBOutlet UIButton *requestTypeButton;
@property (weak, nonatomic) IBOutlet UITextField *reasonTextField;
@property (weak, nonatomic) IBOutlet UIButton *reasonButton;


@end

@implementation ReturnOrderTwoViewController
@synthesize stepOneImageView,stepTwoImageView,stepThreeImageView;
@synthesize scrollView,continueButton,termsCheckButton,returnPolicyButton;
@synthesize tagTextField,tagButton,reasonTextField,reasonButton,requestTypeButton,requestTypeTextField,additionalInfoField;
@synthesize returnPickerToolbar,returnProductPickerView;
@synthesize orderIdData,policyString,addressString,packingArray,reasonArray,typeArray,pickerDataDictionary,itemDetailDataDictionary;


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
    
    packingArray = [[NSMutableArray alloc]init];
    reasonArray = [[NSMutableArray alloc]init];
    typeArray = [[NSMutableArray alloc]init];
    tagArray=[[NSMutableArray alloc] initWithObjects:
                @"YES",
                @"NO",
                nil];

    packingArray = [pickerDataDictionary objectForKey:@"packing"];
     reasonArray = [pickerDataDictionary objectForKey:@"reason"];
     typeArray = [pickerDataDictionary objectForKey:@"type"];
    
    returnProductPickerView.translatesAutoresizingMaskIntoConstraints=YES;
    returnPickerToolbar.translatesAutoresizingMaskIntoConstraints=YES;

    
    tagChecker = 0;
    requestChecker = 0;
    reasonChecker = 0;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
   
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Localytics tagScreen:@"Return Order Step2"];
}


-(void)addborder
{
    [tagButton addBorder:tagButton];
    [requestTypeButton addBorder:requestTypeButton];
    [reasonButton addBorder:reasonButton];
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


#pragma mark - Picker

-(void)pickerShow
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [returnProductPickerView setNeedsLayout];
    
    if (managePicker==0) {
        
         [returnProductPickerView selectRow:tagChecker inComponent:0 animated:YES];
     }
    else if (managePicker==1){
        [returnProductPickerView selectRow:requestChecker inComponent:0 animated:YES];
    }
    else if (managePicker==2){
        [returnProductPickerView selectRow:reasonChecker inComponent:0 animated:YES];
    }
    
    [returnProductPickerView reloadAllComponents];
    returnProductPickerView.frame = CGRectMake(returnProductPickerView.frame.origin.x, self.view.bounds.size.height-returnProductPickerView.frame.size.height , self.view.bounds.size.width, returnProductPickerView.frame.size.height);
    returnPickerToolbar.frame = CGRectMake(returnPickerToolbar.frame.origin.x, returnProductPickerView.frame.origin.y-44, self.view.bounds.size.width, returnPickerToolbar.frame.size.height);
    [returnProductPickerView setNeedsLayout];
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
    if (managePicker==0) {
    if (packingArray.count>row)
    {
        dataModel=[packingArray objectAtIndex:row];
        NSString *str=dataModel.packingName;
        pickerLabel.text=str;
    }
    }
    else if (managePicker==1){
        if (typeArray.count>row)
        {
            dataModel=[typeArray objectAtIndex:row];
            NSString *str=dataModel.typeName;
            pickerLabel.text=str;
        }

    }
    else if (managePicker==2){
        if (reasonArray.count>row)
        {
            dataModel=[reasonArray objectAtIndex:row];
            NSString *str=dataModel.reasonName;
            pickerLabel.text=str;
        }
        
    }
    
    return pickerLabel;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (managePicker==0) {
    return packingArray.count;
    }
    else if (managePicker==1){
         return typeArray.count;
    }
    else{
         return reasonArray.count;
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // [_keyboardControls.activeField resignFirstResponder];
    
    if (managePicker==0) {
    dataModel=[packingArray objectAtIndex:row];
    NSString *str=dataModel.packingName;
    return str;
    }
    else if (managePicker==1){
        dataModel=[typeArray objectAtIndex:row];
        NSString *str=dataModel.typeName;
        return str;
    }
    else{
         dataModel=[reasonArray objectAtIndex:row];
        NSString *str=dataModel.reasonName;
        return str;
    }
}
- (IBAction)cancel:(id)sender
{
    [self hidePickerWithAnimation];
}

- (IBAction)pickerToolBar:(id)sender
{
    NSInteger index = [returnProductPickerView selectedRowInComponent:0];
    
    
    if (managePicker==0)
    {
        tagChecker = (int)index;
    dataModel=[packingArray objectAtIndex:index];
    tagTextField.text=dataModel.packingName;
    packingId = [dataModel.packingId intValue];
    }
    else if (managePicker==1)
    {
        requestChecker = (int)index;
        dataModel = [typeArray objectAtIndex:index];
       requestTypeTextField.text=dataModel.typeName;
        typeId = [dataModel.typeId intValue];
    }
    else
    {
        reasonChecker = (int)index;
        dataModel = [reasonArray objectAtIndex:index];
        reasonTextField.text= dataModel.reasonName;
        reasonId = [dataModel.reasonId intValue];
    }
    
    
    
    [self hidePickerWithAnimation];
    
}

-(void)hidePickerWithAnimation
{
    // scrollView.scrollEnabled = YES;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    returnProductPickerView.frame = CGRectMake(returnProductPickerView.frame.origin.x, 1000, self.view.bounds.size.width, returnProductPickerView.frame.size.height);
    returnPickerToolbar.frame = CGRectMake(returnPickerToolbar.frame.origin.x, 1000, self.view.bounds.size.width, returnPickerToolbar.frame.size.height);
    [returnProductPickerView setNeedsLayout];
    [UIView commitAnimations];
}


#pragma mark - end

#pragma mark - Textfield delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    scrollView.scrollEnabled = NO;
    [self hidePickerWithAnimation];
   
    [scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-15) animated:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    scrollView.scrollEnabled = YES;
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end


#pragma mark - Check validations
- (BOOL)performValidationsToContinue
{
    
    if ([tagTextField isEmpty] || [requestTypeTextField isEmpty]  || [reasonTextField isEmpty] || [additionalInfoField isEmpty])
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"All fields are required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        });
        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"All fields are required" parentView:self.view];
       // [self.view makeToast:@"All fields are required" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        return NO;
    }
    else if (![termsCheckButton isSelected])
    {
        
        //if ([termsCheckButton isSelected])
       // {
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please agree to terms and conditions." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please agree to terms and conditions" parentView:self.view];
      //  [self.view makeToast:@"Please agree to terms and conditions" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
            return NO;
        }
    else{
        return YES;
    }
}
#pragma mark - end

#pragma mark - Button actions
- (IBAction)continueButtonClicked:(id)sender {
    
    if([self performValidationsToContinue])
    {
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ReturnOrderThreeViewController *returnView =[storyboard instantiateViewControllerWithIdentifier:@"ReturnOrderThreeViewController"];
    returnView.addressStringText = addressString;
    returnView.reasonId = reasonId;
    returnView.typeId = typeId;
    returnView.packingId = packingId;
    returnView.orderIdData = orderIdData;
    returnView.additionalInfo = additionalInfoField.text;
    returnView.itemDetailDataDictionary = itemDetailDataDictionary;
    [self.navigationController pushViewController:returnView animated:YES];
        
    }

}
- (IBAction)termsCheckButtonClicked:(id)sender {
    
    if(!checkToggleState)
    {
        [termsCheckButton setSelected:YES];
        [termsCheckButton setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateSelected];
        
    }
    else
    {
        [termsCheckButton setSelected:NO];
        [termsCheckButton setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];

    }
    checkToggleState = !checkToggleState;
}
- (IBAction)returnPolicyButtonClicked:(id)sender {
    
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ReturnPolicyViewController *returnView =[storyboard instantiateViewControllerWithIdentifier:@"ReturnPolicyViewController"];
    returnView.policyStringText = policyString;
    [self.navigationController pushViewController:returnView animated:YES];
}


- (IBAction)tagPickerButtonClicked:(id)sender {
    managePicker = 0;
            [self pickerShow];
}
- (IBAction)requestTypePickerButtonClicked:(id)sender{
      managePicker = 1;
     [self pickerShow];

}
- (IBAction)reasonPickerButtonClicked:(id)sender {
      managePicker = 2;
     [self pickerShow];

}
#pragma mark - end
@end
