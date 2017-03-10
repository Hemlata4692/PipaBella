//
//  CheckoutAddAddressViewController.m
//  PipaBella
//
//  Created by Ranosys on 05/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "CheckoutAddAddressViewController.h"
#import "AccountService.h"
@interface CheckoutAddAddressViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate>
{
    NSArray *textFields;
    NSArray *countryIdArray;
    NSMutableDictionary *countryList;
    NSMutableDictionary *regionList;
    NSArray *stateArray;
    bool isCountryPicker;
    NSInteger pickerIndex;
    
}
@property (weak, nonatomic) IBOutlet UIButton *reviewButton;
@property (weak, nonatomic) IBOutlet UIButton *deliverToButton;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *address1Field;
@property (weak, nonatomic) IBOutlet UITextField *address2Field;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *country;
@property (weak, nonatomic) IBOutlet UITextField *postalCode;
@property (weak, nonatomic) IBOutlet UITextField *state;
@property (weak, nonatomic) IBOutlet UITextField *regionField;
@property (weak, nonatomic) IBOutlet UIButton *countryButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic, strong)NSString *countryId;
@property (nonatomic, strong)NSString *coustmerAddressId;
@property (nonatomic, strong)NSString *regionStateId;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
- (IBAction)cancelButtonPickerToolbar:(id)sender;

@end

@implementation CheckoutAddAddressViewController
@synthesize reviewButton,deliverToButton,payButton,scrollView,containerView,firstName,lastName,phoneNumber,address1Field,address2Field,city,country,postalCode,state,regionField,stateBtn,countryButton,saveButton,pickerView,toolBar,regionStateId,isEditScreen,indexPathPosition;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=@"CHECKOUT";
    
    if (isEditScreen) {
//        self.navigationItem.title=@"EDIT ADDRESS";
        [self getAddressInfo];
    }
    else
    {
//        self.navigationItem.title=@"ADD ADDRESS";
    }

    
    [reviewButton addBorder:reviewButton color:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0]];
    [reviewButton setTitleColor:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [deliverToButton addBorder:deliverToButton color:[UIColor colorWithRed:241.0/255.0 green:0.0/255.0 blue:136.0/255.0 alpha:1.0]];
    [deliverToButton setTitleColor:[UIColor colorWithRed:241.0/255.0 green:0.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [payButton addBorder:payButton color:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0]];
    [payButton setTitleColor:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0] forState:UIControlStateNormal];

    
    
    //Adding textfield to array
    textFields = @[firstName,lastName,phoneNumber,address1Field,address2Field,city,state,postalCode];
    //Keyboard toolbar action to display toolbar with keyboard to move next,previous
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFields]];
    [self.keyboardControls setDelegate:self];
    
    pickerView.translatesAutoresizingMaskIntoConstraints=YES;
    toolBar.translatesAutoresizingMaskIntoConstraints=YES;
    countryIdArray=[[NSArray alloc] init ];
    regionField.hidden=YES;
    stateArray=[[NSArray alloc]init];
    stateBtn.enabled=NO;
    state.userInteractionEnabled=NO;
    // Corner radius and border
    [self setCornerRadius];
    [self addborder];
    [self setBorder];
    [self addPadding];
    // Do any additional setup after loading the view.
    
    [myDelegate ShowIndicator];
    [self performSelector:@selector(getCountryCodeList) withObject:nil afterDelay:.1];

    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)proceedToSecurePayButton:(id)sender {
}
#pragma mark - end

#pragma mark - Corner radius, border and textfield padding
-(void) setCornerRadius
{
    [firstName setCornerRadius:2.0f];
    [lastName setCornerRadius:2.0f];
    [phoneNumber setCornerRadius:2.0f];
    [address1Field setCornerRadius:2.0f];
    [address2Field setCornerRadius:2.0f];
    [city setCornerRadius:2.0f];
    [state setCornerRadius:2.0f];
    [postalCode setCornerRadius:2.0f];
    [country setCornerRadius:2.0f];
    
}

-(void)addborder
{
    [firstName addBorder:firstName];
    [lastName addBorder:lastName];
    [phoneNumber addBorder:phoneNumber];
    [address1Field addBorder:address1Field];
    [address2Field addBorder:address2Field];
    [city addBorder:city];
    [state addBorder:state];
    [postalCode addBorder:postalCode];
    [country addBorder:country];
    [regionField addBorder:regionField];
}

-(void)addPadding
{
    [firstName addTextFieldPaddingWithoutImages:firstName];
    [lastName addTextFieldPaddingWithoutImages:lastName];
    [phoneNumber addTextFieldPaddingWithoutImages:phoneNumber];
    [address1Field addTextFieldPaddingWithoutImages:address1Field];
    [address2Field addTextFieldPaddingWithoutImages:address2Field];
    [city addTextFieldPaddingWithoutImages:city];
    [state addTextFieldPaddingWithoutImages:state];
    [postalCode addTextFieldPaddingWithoutImages:postalCode];
    [country addTextFieldPaddingWithoutImages:country];
    [regionField addTextFieldPaddingWithoutImages:regionField];
}


-(void)setBorder
{
    [saveButton addBorder:saveButton color:[UIColor colorWithRed:154.0/255.0 green:153.0/255.0 blue:154.0/255.0 alpha:1.0]];
    
}
#pragma mark - end

#pragma mark - Keyboard controls delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    UIView *view;
    
    if ([[UIDevice currentDevice].systemVersion floatValue]< 7.0) {
        view = field.superview.superview;
    } else {
        view = field.superview.superview.superview;
    }
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [keyboardControls.activeField resignFirstResponder];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - end

#pragma mark - Textfield delegates
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==phoneNumber)
    {
        if (range.length > 0 && [string length] == 0)
        {
            return YES;
        }
        if (textField.text.length >=10 && range.length == 0)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    if(textField==postalCode)
    {
        if (range.length > 0 && [string length] == 0)
        {
            return YES;
        }
        if (textField.text.length >= 6 && range.length == 0)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    scrollView.scrollEnabled = NO;
    [self hidePickerWithAnimation];
    [self.keyboardControls setActiveField:textField];
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

#pragma mark - Picker view methods

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,600,20)];
        pickerLabel.font = [UIFont fontWithName:@"SF-UI-Display-Light" size:15];
        pickerLabel.textAlignment=NSTextAlignmentCenter;
    }
    if (isCountryPicker)
    {
        
        pickerLabel.text=[countryList objectForKey:[countryIdArray objectAtIndex:row]];
    }
    else
    {
        pickerLabel.text=[regionList objectForKey:[stateArray objectAtIndex:row]];
    }
    
    return pickerLabel;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (isCountryPicker)
    {
        return countryIdArray.count;
    }
    else
    {
        return stateArray.count;
    }
    
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (isCountryPicker)
    {
        
        return [countryList objectForKey:[countryIdArray objectAtIndex:row]];
    }
    else
    {
        return [regionList objectForKey:[stateArray objectAtIndex:row]];
    }
}
#pragma mark - Button action

-(void)getAddressInfo
{
    firstName.text=_firstNameStr;
    lastName.text=_lastNameStr;
    address1Field.text=_address1;
    address2Field.text=_address2;
    state.text=_stateStr;
    phoneNumber.text=_phoneNumberStr;
    postalCode.text=_postalCodeStr;
    city.text=_cityStr;
    regionStateId=_regionId;
}

- (IBAction)pickerToolBar:(id)sender
{
    if (isCountryPicker)
    {
        NSInteger index = [pickerView selectedRowInComponent:0];
        country.text=[countryList objectForKey:[countryIdArray objectAtIndex:index]];
        _countryId=[countryIdArray objectAtIndex:index];
        _countryStr=[countryIdArray objectAtIndex:index];
        [pickerView selectRow:index inComponent:0 animated:YES];
        pickerIndex=index;
        //NSLog(@"country id is %@",_countryId);
        state.placeholder=@"Loading States...";
        state.text=@"";
        stateBtn.hidden=NO;
        state.userInteractionEnabled=NO;
        regionStateId = @"0";
        
        [self performSelector:@selector(getRegionList) withObject:nil afterDelay:.1];
    }
    else
    {
        NSInteger index = [pickerView selectedRowInComponent:0];
        state.text=[regionList objectForKey:[stateArray objectAtIndex:index]];
        regionStateId=[stateArray objectAtIndex:index];
        [pickerView selectRow:index inComponent:0 animated:YES];
        pickerIndex=index;
        //NSLog(@"country id is %@",regionStateId);
    }
    [self hidePickerWithAnimation];
    
}
-(void)hidePickerWithAnimation
{
    scrollView.scrollEnabled = YES;
    // [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    pickerView.frame = CGRectMake(pickerView.frame.origin.x, 1000, self.view.bounds.size.width, pickerView.frame.size.height);
    toolBar.frame = CGRectMake(toolBar.frame.origin.x, 1000, self.view.bounds.size.width, toolBar.frame.size.height);
    [UIView commitAnimations];
}


- (IBAction)countryButtonClicked:(id)sender
{
    isCountryPicker=true;
    [self.view endEditing:YES];
    scrollView.scrollEnabled = NO;
    [scrollView setContentOffset:CGPointMake(0, country.frame.origin.y-70) animated:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [pickerView setNeedsLayout];
    //    [pickerView selectRow:pickerIndex inComponent:0 animated:YES];
    
    if ([_countryStr isEqualToString:@""] || _countryStr == nil) {
        [pickerView selectRow:0 inComponent:0 animated:YES];
    }
    else{
        [pickerView selectRow:[countryIdArray indexOfObject:_countryStr] inComponent:0 animated:YES];
    }
    pickerView.translatesAutoresizingMaskIntoConstraints=YES;

    
    [pickerView reloadAllComponents];
    pickerView.frame = CGRectMake(pickerView.frame.origin.x, self.view.bounds.size.height-pickerView.frame.size.height , self.view.bounds.size.width, pickerView.frame.size.height);
    toolBar.frame = CGRectMake(toolBar.frame.origin.x, pickerView.frame.origin.y-44, self.view.bounds.size.width, toolBar.frame.size.height);
    [UIView commitAnimations];
    
}


- (IBAction)stateButtonClicked:(id)sender
{
    isCountryPicker = false;
    [self.view endEditing:YES];
    scrollView.scrollEnabled = NO;
    [scrollView setContentOffset:CGPointMake(0, state.frame.origin.y-70) animated:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [pickerView setNeedsLayout];
    if ([regionStateId isEqualToString: @"0"]) {
        [pickerView selectRow:0 inComponent:0 animated:YES];
    }
    else
    {
        //        [pickerView selectRow:pickerIndex inComponent:0 animated:YES];
        [pickerView selectRow:[stateArray indexOfObject:regionStateId] inComponent:0 animated:YES];
    }
    
    
    [pickerView reloadAllComponents];
    pickerView.frame = CGRectMake(pickerView.frame.origin.x, self.view.bounds.size.height-pickerView.frame.size.height , self.view.bounds.size.width, pickerView.frame.size.height);
    toolBar.frame = CGRectMake(toolBar.frame.origin.x, pickerView.frame.origin.y-44, self.view.bounds.size.width, toolBar.frame.size.height);
    [UIView commitAnimations];
}




- (IBAction)saveButtonAction:(id)sender {
    
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.keyboardControls.activeField resignFirstResponder];
    if([self performValidationsForAddress])
    {
        [myDelegate ShowIndicator];
        [self performSelector:@selector(saveAddress) withObject:nil afterDelay:.1];
    }
    
}
#pragma mark - end

#pragma mark - end
#pragma mark - Webservice
-(void)getRegionList
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
        
        [[AccountService sharedManager]regionList:_countryId success:^(id data)
         {
             //Handle fault cases
             dispatch_async(dispatch_get_main_queue(), ^{
                 // code here
                 [myDelegate StopIndicator];
                 state.placeholder=@"State";
                 stateBtn.enabled=YES;
                 state.userInteractionEnabled=YES;
                 regionList = [data  mutableCopy];
                 // stateArray = [[regionList allKeys] mutableCopy];
                 
                 stateArray = [regionList keysSortedByValueUsingSelector:@selector(compare:)];
                 
                 //                 regionStateId =@"0";
                 if ([regionStateId isEqualToString: @"0"]) {
                     pickerIndex=0;
                 }
                 else
                 {
                     pickerIndex = [stateArray indexOfObject:regionStateId];
                 }
                 
                 
                 
                 if (stateArray.count==0) {
                     // state.hidden=YES;
                     //regionField.hidden=NO;
                     regionStateId=@"0";
                     stateBtn.hidden=YES;
                     
                 }
                 else
                 {
                     // state.hidden=NO;
                     // regionField.hidden=YES;
                     stateBtn.hidden=NO;
                 }
                 
                 
             });
             
         }
                                          failure:^(NSError *error)
         {
             //Handle if response is nil
             
         }];
    }
    
}

-(void)getCountryCodeList
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
        if (isEditScreen)
        {
            [[AccountService sharedManager]countryList:^(id data)
             {
                 //Handle fault cases
                 dispatch_async(dispatch_get_main_queue(), ^{
                     // code here
                     [myDelegate StopIndicator];
                     if(data==nil || [data count]==0)
                     {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                             alert1.tag=2;
                             [alert1 show];
                         });
                     }
                     else
                     {
                         
                         countryList = [data  mutableCopy];
                         country.text=[countryList objectForKey:_countryStr];
                         countryIdArray = [countryList keysSortedByValueUsingSelector:@selector(compare:)];
                         _countryId=_countryStr;
                         [self getRegionList];
                     }
                     
                 });
                 
             }
                                               failure:^(NSError *error)
             {
                 //Handle if response is nil
                 
             }];
            
        }
        else
        {
            [[AccountService sharedManager]countryList:^(id data)
             {
                 //Handle fault cases
                 dispatch_async(dispatch_get_main_queue(), ^{
                     // code here
                     [myDelegate StopIndicator];
                     if(data==nil || [data count]==0)
                     {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                             alert1.tag=2;
                             [alert1 show];
                         });
                     }
                     else
                     {
                         countryList = [data  mutableCopy];
                         country.text=[countryList objectForKey:_countryStr];
                         
                         // countryIdArray = [[countryList allKeys] mutableCopy];
                         countryIdArray = [countryList keysSortedByValueUsingSelector:@selector(compare:)];
                         _countryStr = @"";
                     }
                     
                 });
                 
             }
                                               failure:^(NSError *error)
             {
                 //Handle if response is nil
                 
             }];
        }
    }
    
}

-(void)saveAddress
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
        
        [[AccountService sharedManager]addAddress:firstName.text lastName:lastName.text phoneNumber:phoneNumber.text address1:address1Field.text address2:address2Field.text city:city.text country:_countryId state:state.text postalCode:postalCode.text customerAddressId:_addressId regionId:regionStateId isEdit:isEditScreen success:^(id data)
         {
             //Handle fault cases
             dispatch_async(dispatch_get_main_queue(), ^{
                 // code here
                 [myDelegate StopIndicator];
                 
                 if (data != nil)
                 {
                     
                     if ([data objectForKey:@"result"] != nil || [data objectForKey:@"result"] != NULL)
                     {
                         _coustmerAddressId=[data objectForKey:@"result"];
                         if (isEditScreen)
                         {
                             UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your address has been updated successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                             alert1.tag=1;
                             [alert1 show];
                             
                         }
                         else
                         {
                             
                             
                             
                             UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your address has been added successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                             alert1.tag=1;
                             [alert1 show];
                             
                         }
                         
                     }
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1)
    {
        _checkVC.indexPathPosition=indexPathPosition;
        _checkVC.isAddScreen=1;
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else if (alertView.tag==2)
    {
        _checkVC.indexPathPosition=indexPathPosition;
        _checkVC.isAddScreen=1;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - end
#pragma mark - Validations
- (BOOL)performValidationsForAddress
{
//{
//    if ([firstName isEmpty] || [lastName isEmpty]|| [phoneNumber isEmpty] ||[address1Field isEmpty] || [address2Field isEmpty]|| [city isEmpty] || [postalCode isEmpty] || [country isEmpty] || [state isEmpty])
//
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"All fields are required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        });
//        return NO;
//        
//    }
    if ([firstName isEmpty] )
    {
        dispatch_async(dispatch_get_main_queue(), ^{
             [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter the first name" parentView:self.view];
           // [self.view makeToast:@"Please enter the first name" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
            
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the first name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
        });
        return NO;
    }
    else if ([lastName isEmpty] )
    {
        dispatch_async(dispatch_get_main_queue(), ^{
             [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter the last name" parentView:self.view];
            // [self.view makeToast:@"Please enter the last name" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
//            
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the last name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
        });
        return NO;
    }
    else if ([phoneNumber isEmpty] )
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
             [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter the phone number" parentView:self.view];
           //  [self.view makeToast:@"Please enter the phone number." image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
            
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the phone number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
        });
        return NO;
    }
    else if ([address1Field isEmpty] && [address2Field isEmpty])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter the address" parentView:self.view];
            // [self.view makeToast:@"Please enter the address" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
            
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
        });
        return NO;
    }
//    else if ([address2Field isEmpty] )
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//              [self.view makeToast:@"Please enter the address" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
//            
////            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
////            [alert show];
//        });
//        return NO;
//    }
    else if ([city isEmpty] )
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter the city" parentView:self.view];
          //  [self.view makeToast:@"Please enter the city" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];

            
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the city." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
        });
        return NO;
    }
    else if ([state isEmpty] )
    {
        dispatch_async(dispatch_get_main_queue(), ^{

            [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter the state" parentView:self.view];
           // [self.view makeToast:@"Please enter the state" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];

            
//        UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the state." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
        });

            return NO;
    }
    else if ([postalCode isEmpty] )
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter the postal code" parentView:self.view];
           // [self.view makeToast:@"Please enter the postal code" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
            
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the postal code." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
        });
        return NO;
    }
    else if ([country isEmpty])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter the country" parentView:self.view];
           // [self.view makeToast:@"Please enter the country" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];

//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the country." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
        });
        return NO;
    }
    else
    {
        return YES;
    }
    
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

- (IBAction)cancelButtonPickerToolbar:(id)sender {
    [self hidePickerWithAnimation];

}
@end
