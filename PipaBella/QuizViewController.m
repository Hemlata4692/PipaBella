//
//  QuizViewController.m
//  PipaBella
//
//  Created by Hema on 19/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "QuizViewController.h"
#import "QuizLevel2ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface QuizViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate>
@property (weak, nonatomic) IBOutlet UIView *helloQuizView;
@property (weak, nonatomic) IBOutlet UIScrollView *helloQuizScrollView;

@property (weak, nonatomic) IBOutlet UILabel *helloLabel;
@property (weak, nonatomic) IBOutlet UILabel *knowUsLabel;
@property (weak, nonatomic) IBOutlet UITextField *enterEmailField;
@property (weak, nonatomic) IBOutlet UILabel *tellUsLabel;
@property (weak, nonatomic) IBOutlet UILabel *surpriseLabel;
@property (weak, nonatomic) IBOutlet UIView *birthdateView;
@property (weak, nonatomic) IBOutlet UITextField *dateTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *monthTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@end

@implementation QuizViewController
@synthesize helloLabel,knowUsLabel,tellUsLabel,surpriseLabel,helloQuizScrollView,enterEmailField;
@synthesize birthdateView,dateTextFiled,monthTextField,yearTextField,startButton;
@synthesize keyboardControls;

#pragma mark - View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *textFields = @[dateTextFiled,monthTextField,yearTextField];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFields]];
    [self.keyboardControls setDelegate:self];
    //hide status bar
    [self prefersStatusBarHidden];
    
    [birthdateView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"date_bg.png"]]];
    // [birthdateView setBackgroundColor:[UIColor blackColor]];
    [self addShadow];
    [self addPadding];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    if (!([UserDefaultManager getValue:@"customer_id"] == nil))
    {
       enterEmailField.text= [UserDefaultManager getValue:@"userEmail"];
    }
    
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        helloQuizScrollView.scrollEnabled=NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addShadow
{
    [helloLabel setTextBorder:helloLabel color:[UIColor colorWithRed:220/255 green:146/255 blue:187/255 alpha:1]];
    [startButton addShadow:startButton color:[UIColor colorWithRed:149.0/255.0 green:0.0/255.0 blue:78.0/255.0 alpha:1.0] radius:15.0f];
    
}
-(void)addPadding
{
    [enterEmailField addTextFieldPaddingWithoutImages:enterEmailField];
    [dateTextFiled addTextFieldPaddingWithoutImages:dateTextFiled];
    [monthTextField addTextFieldPaddingWithoutImages:monthTextField];
    [yearTextField addTextFieldPaddingWithoutImages:yearTextField];
}

//hide status bar
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark - end
#pragma mark - Textfield delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    helloQuizScrollView.scrollEnabled = NO;
    [self.keyboardControls setActiveField:textField];
    if (textField!=enterEmailField) {
        [helloQuizScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y+205) animated:YES];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(textField==dateTextFiled || textField==monthTextField)
    {
        if ( [string isEqualToString:@" "] )
        {
            
            return NO;
        }
        if (range.length > 0 && [string length] == 0)
        {
            // enable delete
            return YES;
        }
        if (textField.text.length >= 2 && range.length == 0  )
        {
            
            return NO; // return NO to not change text
        }
        else
        {
            return YES;
        }
        
        
    }
    else if (textField==yearTextField)
    {
        if ( [string isEqualToString:@" "] )
        {
            
            return NO;
        }
        if (range.length > 0 && [string length] == 0)
        {
            // enable delete
            return YES;
        }
        if (textField.text.length >= 4 && range.length == 0)
        {
            
            return NO; // return NO to not change text
        }
        else
        {
            return YES;
        }
    
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    helloQuizScrollView.scrollEnabled = YES;
    [helloQuizScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [helloQuizScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end
#pragma mark - Keyboard controls delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    UIView *view;
    view = field.superview.superview.superview;
    
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls1
{
    [keyboardControls1.activeField resignFirstResponder];
    [helloQuizScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - end
#pragma mark - Validations

-(BOOL) isValidateDOB:(NSString *) dateOfBirth
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0:00"]];
    [format setDateStyle:NSDateFormatterShortStyle];
    [format setDateFormat:@"dd/MM/yyyy"];
    NSDate *validateDOB = [format dateFromString:dateOfBirth];
    NSLog(@"validateDOB is %@ and current date is %@",[self dateWithOutTime:validateDOB],[self dateWithOutTime:[NSDate date]]);
    if (validateDOB != nil)
    {
        if (([[self dateWithOutTime:validateDOB] compare:[self dateWithOutTime:[NSDate date]]] == NSOrderedSame) ||([[self dateWithOutTime:validateDOB] compare:[self dateWithOutTime:[NSDate date]]]==NSOrderedDescending))
        {
            return NO;
        }
        else if ([yearTextField.text intValue]<1900)
        {
            return NO;
        }
        else
        {
        return YES;
        }
        
    }
    else
    {
        return NO;
    }
}
-(NSDate *)dateWithOutTime:(NSDate *)datDate
{
    if( datDate == nil )
    {
        datDate = [NSDate date];
    }
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:datDate];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}
- (BOOL)performValidationsForChangePassword
{
    NSString *dob = [NSString stringWithFormat:@"%@/%@/%@",dateTextFiled.text,monthTextField.text,yearTextField.text ] ;
    if ([enterEmailField isEmpty] || [dateTextFiled isEmpty]|| [monthTextField isEmpty] || [yearTextField isEmpty])
    {
//        UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"All fields are required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
         [MozTopAlertView showWithType:MozAlertTypeInfo text:@"All fields are required" parentView:self.view];
        //[self.view makeToast:@"All fields are required" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        return NO;
        
    }
    else if (![enterEmailField isValidEmail])
        {
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter a valid email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
            [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter a valid email address" parentView:self.view];
          //  [self.view makeToast:@"Please enter a valid email address" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
            return NO;
        }
    
    else if (![self isValidateDOB:dob])
    {

          [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter valid date birth" parentView:self.view];
        return NO;
        
    }
    return YES;
}


#pragma mark - end
#pragma mark - Button actions
- (IBAction)startQuizAction:(id)sender
{
    [helloQuizScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [enterEmailField resignFirstResponder];
    [dateTextFiled resignFirstResponder];
    [monthTextField resignFirstResponder];
    [yearTextField resignFirstResponder];
    
    NSString *email = enterEmailField.text;
    NSString *dob = [NSString stringWithFormat:@"%@/%@/%@",dateTextFiled.text,monthTextField.text,yearTextField.text ] ;
    
    
    
    NSMutableDictionary *savedDic =[NSMutableDictionary new];
    [savedDic setObject:email forKey:@"email"];
    [savedDic setObject:dob forKey:@"dob"];
    
     if([self performValidationsForChangePassword])
    {
        
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        QuizLevel2ViewController *quizView =[storyboard instantiateViewControllerWithIdentifier:@"QuizLevel2ViewController"];
        quizView.userInfoDic = savedDic;
        [self.navigationController pushViewController:quizView animated:YES];
        
    }
    
}
#pragma mark - end
@end
