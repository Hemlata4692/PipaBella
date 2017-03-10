//
//  AddAddressViewController.m
//  PipaBella
//
//  Created by Ranosys on 01/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "AddAddressViewController.h"
#import "AccountService.h"
#import "ManageAddressesViewController.h"

@interface AddAddressViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate>
{
    NSArray *textFields;
    NSArray *countryIdArray;
    NSMutableDictionary *countryList;
    NSMutableDictionary *regionList;
    NSArray *stateArray;
    bool isCountryPicker;
    NSInteger pickerIndex;
    
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *address1Field;
@property (weak, nonatomic) IBOutlet UITextField *address2Field;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *stateField;
@property (weak, nonatomic) IBOutlet UITextField *postalCodeField;
@property (weak, nonatomic) IBOutlet UITextField *countryField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *regionField;
@property (nonatomic, strong)NSString *countryId;
@property (nonatomic, strong)NSString *coustmerAddressId;
@property (nonatomic, strong)NSString *regionStateId;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
- (IBAction)cancelButtonPickerToolbar:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
@end

@implementation AddAddressViewController
@synthesize scrollView,mainContainerView,firstNameField,lastNameField,phoneNumberField,address1Field,address2Field,cityField,stateField,postalCodeField,countryField,saveButton,pickerView,toolBar,countryId,regionField,stateBtn,regionStateId,coustmerAddressId,regionId;
@synthesize addressId,firstName,lastName,address1,address2,state,city,country,postalCode,phoneNumber,isEditScreen;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (isEditScreen) {
        self.navigationItem.title=@"EDIT ADDRESS";
        [self getAddressInfo];
    }
    else
    {
        self.navigationItem.title=@"ADD ADDRESS";
    }
    
    //Adding textfield to array
    textFields = @[firstNameField,lastNameField,phoneNumberField,address1Field,address2Field,cityField,stateField,postalCodeField];
    //Keyboard toolbar action to display toolbar with keyboard to move next,previous
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFields]];
    [self.keyboardControls setDelegate:self];
    
    pickerView.translatesAutoresizingMaskIntoConstraints=YES;
    toolBar.translatesAutoresizingMaskIntoConstraints=YES;
    countryIdArray=[[NSArray alloc] init ];
    regionField.hidden=YES;
    stateArray=[[NSArray alloc]init];
    stateBtn.enabled=NO;
    stateField.userInteractionEnabled=NO;
    // Corner radius and border
    [self setCornerRadius];
    [self addborder];
    [self setBorder];
    [self addPadding];
    // Do any additional setup after loading the view.
    
    [myDelegate ShowIndicator];
    [self performSelector:@selector(getCountryCodeList) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
}

#pragma mark - end

#pragma mark - Corner radius, border and textfield padding
-(void) setCornerRadius
{
    [firstNameField setCornerRadius:2.0f];
    [lastNameField setCornerRadius:2.0f];
    [phoneNumberField setCornerRadius:2.0f];
    [address1Field setCornerRadius:2.0f];
    [address2Field setCornerRadius:2.0f];
    [cityField setCornerRadius:2.0f];
    [stateField setCornerRadius:2.0f];
    [postalCodeField setCornerRadius:2.0f];
    [countryField setCornerRadius:2.0f];
    
}

-(void)addborder
{
    [firstNameField addBorder:firstNameField];
    [lastNameField addBorder:lastNameField];
    [phoneNumberField addBorder:phoneNumberField];
    [address1Field addBorder:address1Field];
    [address2Field addBorder:address2Field];
    [cityField addBorder:cityField];
    [stateField addBorder:stateField];
    [postalCodeField addBorder:postalCodeField];
    [countryField addBorder:countryField];
    [regionField addBorder:regionField];
}

-(void)addPadding
{
    [firstNameField addTextFieldPaddingWithoutImages:firstNameField];
    [lastNameField addTextFieldPaddingWithoutImages:lastNameField];
    [phoneNumberField addTextFieldPaddingWithoutImages:phoneNumberField];
    [address1Field addTextFieldPaddingWithoutImages:address1Field];
    [address2Field addTextFieldPaddingWithoutImages:address2Field];
    [cityField addTextFieldPaddingWithoutImages:cityField];
    [stateField addTextFieldPaddingWithoutImages:stateField];
    [postalCodeField addTextFieldPaddingWithoutImages:postalCodeField];
    [countryField addTextFieldPaddingWithoutImages:countryField];
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
    if(textField==phoneNumberField)
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
    
    if(textField==postalCodeField)
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

#pragma mark - Picker View methods

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
- (IBAction)cancelButtonPickerToolbar:(id)sender {
    [self hidePickerWithAnimation];
}
-(void)getAddressInfo
{
    firstNameField.text=firstName;
    lastNameField.text=lastName;
    address1Field.text=address1;
    address2Field.text=address2;
    stateField.text=state;
    phoneNumberField.text=phoneNumber;
    postalCodeField.text=postalCode;
    cityField.text=city;
    regionStateId=regionId;
}

- (IBAction)pickerToolBar:(id)sender
{
    if (isCountryPicker)
    {
        NSInteger index = [pickerView selectedRowInComponent:0];
        countryField.text=[countryList objectForKey:[countryIdArray objectAtIndex:index]];
        countryId=[countryIdArray objectAtIndex:index];
        country=[countryIdArray objectAtIndex:index];
        [pickerView selectRow:index inComponent:0 animated:YES];
        pickerIndex=index;
        //NSLog(@"country id is %@",countryId);
        stateField.placeholder=@"Loading States...";
        stateField.text=@"";
        stateBtn.hidden=NO;
        stateField.userInteractionEnabled=NO;
        regionStateId = @"0";
        
        [self performSelector:@selector(getRegionList) withObject:nil afterDelay:.1];
    }
    else
    {
        NSInteger index = [pickerView selectedRowInComponent:0];
        stateField.text=[regionList objectForKey:[stateArray objectAtIndex:index]];
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
    [scrollView setContentOffset:CGPointMake(0, countryField.frame.origin.y-70) animated:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [pickerView setNeedsLayout];
//    [pickerView selectRow:pickerIndex inComponent:0 animated:YES];
    
    if ([country isEqualToString:@""] || country == nil) {
         [pickerView selectRow:0 inComponent:0 animated:YES];
    }
    else{
         [pickerView selectRow:[countryIdArray indexOfObject:country] inComponent:0 animated:YES];
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
    [scrollView setContentOffset:CGPointMake(0, stateField.frame.origin.y-70) animated:YES];
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
        
        [[AccountService sharedManager]regionList:countryId success:^(id data)
         {
             //Handle fault cases
             dispatch_async(dispatch_get_main_queue(), ^{
                 // code here
                 [myDelegate StopIndicator];
                 stateField.placeholder=@"State";
                 stateBtn.enabled=YES;
                 stateField.userInteractionEnabled=YES;
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
                     // stateField.hidden=YES;
                     //regionField.hidden=NO;
                     regionStateId=@"0";
                     stateBtn.hidden=YES;
                     
                 }
                 else
                 {
                     // stateField.hidden=NO;
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
                         countryField.text=[countryList objectForKey:country];
                         countryIdArray = [countryList keysSortedByValueUsingSelector:@selector(compare:)];
                         countryId=country;
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
                     countryField.text=[countryList objectForKey:country];
                     
                     // countryIdArray = [[countryList allKeys] mutableCopy];
                     countryIdArray = [countryList keysSortedByValueUsingSelector:@selector(compare:)];
                     country = @"";
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
        
        [[AccountService sharedManager]addAddress:firstNameField.text lastName:lastNameField.text phoneNumber:phoneNumberField.text address1:address1Field.text address2:address2Field.text city:cityField.text country:countryId state:stateField.text postalCode:postalCodeField.text customerAddressId:addressId regionId:regionStateId isEdit:isEditScreen success:^(id data)
         {
             //Handle fault cases
             dispatch_async(dispatch_get_main_queue(), ^{
                 // code here
                 [myDelegate StopIndicator];
                 
                 if (data != nil)
                 {
                     
                     if ([data objectForKey:@"result"] != nil || [data objectForKey:@"result"] != NULL)
                     {
                         coustmerAddressId=[data objectForKey:@"result"];
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
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else if (alertView.tag==2)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - end
#pragma mark - Validations
- (BOOL)performValidationsForAddress
{
//    if ([firstNameField isEmpty] || [lastNameField isEmpty]|| [phoneNumberField isEmpty] ||[address1Field isEmpty] || [cityField isEmpty] || [postalCodeField isEmpty] || [countryField isEmpty] || [stateField isEmpty])
//    {
////        dispatch_async(dispatch_get_main_queue(), ^{
////            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"All fields are required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
////            [alert show];
////        });
//        [self.view makeToast:@"All fields are required" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
//        
//        return NO;
//        
//    }
     if ([firstNameField isEmpty] )
    {

        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter the first name" parentView:self.view];
       // [self.view makeToast:@"Please enter the first name" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        return NO;
    }
    else if ([lastNameField isEmpty] )
    {

        
        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter the last name" parentView:self.view];
        //[self.view makeToast:@"Please enter the last name" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        return NO;
    }
    else if ([phoneNumberField isEmpty] )
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the phone number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        });
        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter the phone number" parentView:self.view];
        //[self.view makeToast:@"Please enter the phone number" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        return NO;
    }
    else if ([address1Field isEmpty] && [address2Field isEmpty])
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        });
        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter the address" parentView:self.view];
        //[self.view makeToast:@"Please enter the address" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        return NO;
    }
//    else if ([address2Field isEmpty] )
//    {
////        dispatch_async(dispatch_get_main_queue(), ^{
////            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
////            [alert show];
////        });
//        
//        [self.view makeToast:@"Please enter the address" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
//        return NO;
//    }
    else if ([cityField isEmpty] )
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the city." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        });
         [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter the city" parentView:self.view];
      //  [self.view makeToast:@"Please enter the city" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        return NO;
    }
    else if ([stateField isEmpty] )
    {
        
//        UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the state." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
         [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter the state" parentView:self.view];
       // [self.view makeToast:@"Please enter the state" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        return NO;
    }
    else if ([postalCodeField isEmpty] )
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the postal code." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        });
        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter the postal code" parentView:self.view];
       // [self.view makeToast:@"Please enter the postal code" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        return NO;
    }
    else if ([countryField isEmpty] )
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the country." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        });
        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter the country" parentView:self.view];
        //[self.view makeToast:@"Please enter the country" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
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


@end
