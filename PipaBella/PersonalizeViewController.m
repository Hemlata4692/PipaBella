//
//  PersonalizeViewController.m
//  PipaBella
//
//  Created by Sumit on 14/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "PersonalizeViewController.h"
#import "MyButton.h"
#define kCellPerRow 5
@interface PersonalizeViewController ()
{
    
    __weak IBOutlet UILabel *previewLbl;
    __weak IBOutlet UIView *textContainer;
    __weak IBOutlet UITextField *personalizeField;
    __weak IBOutlet UILabel *titleLabel;
    
    __weak IBOutlet UICollectionView *radioCollectionView;
    __weak IBOutlet UILabel *radioTitleLabel;
    NSMutableDictionary  * sendingDataDict;
    
    bool hasText;
    bool hasRadio;
    bool hasDropdown;
    NSMutableArray * selectedRadioArray;
    NSMutableDictionary * radioDict;
    
    NSString * fieldOptionId;
}

@end

@implementation PersonalizeViewController
@synthesize personalizeArray;
@synthesize objProductDetail;
@synthesize productName;
#pragma mark - View life cycle
-(void)removeAutolayouts
{
    textContainer.translatesAutoresizingMaskIntoConstraints = YES;
    personalizeField.translatesAutoresizingMaskIntoConstraints= YES;
    titleLabel.translatesAutoresizingMaskIntoConstraints = YES;
    radioCollectionView.translatesAutoresizingMaskIntoConstraints = YES;
    radioTitleLabel.translatesAutoresizingMaskIntoConstraints = YES;
    
}
-(void)showField
{
    //textContainer.backgroundColor = [UIColor grayColor];
    if (hasText)
    {
        textContainer.frame =    CGRectMake(textContainer.frame.origin.x, textContainer.frame.origin.y, self.view.frame.size.width-textContainer.frame.origin.x-40, textContainer.frame.size.height);
        personalizeField.frame = CGRectMake(personalizeField.frame.origin.x, personalizeField.frame.origin.y, textContainer.frame.size.width-8, personalizeField.frame.size.height);
    }
    else
    {
        textContainer.frame =    CGRectMake(textContainer.frame.origin.x, textContainer.frame.origin.y, self.view.frame.size.width-40, 0);
        personalizeField.frame = CGRectMake(personalizeField.frame.origin.x, personalizeField.frame.origin.y, textContainer.frame.size.width-8, 0);
    }
    
}
-(void)showRadio
{
    if (hasRadio)
    {
        radioTitleLabel.frame =  CGRectMake(radioTitleLabel.frame.origin.x, textContainer.frame.origin.y+textContainer.frame.size.height+30, radioTitleLabel.frame.size.width, radioTitleLabel.frame.size.height);
        radioCollectionView.frame =  CGRectMake(radioCollectionView.frame.origin.x, radioTitleLabel.frame.origin.y+radioTitleLabel.frame.size.height+10, self.view.frame.size.width-radioCollectionView.frame.origin.x-45, radioCollectionView.frame.size.height);
        
        //setting collection view cell size according to iPhone screens
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)radioCollectionView.collectionViewLayout;
        CGFloat availableWidthForCells = CGRectGetWidth(self.view.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellPerRow -1);
        CGFloat cellWidth = (availableWidthForCells / kCellPerRow);
        flowLayout.itemSize = CGSizeMake(cellWidth, flowLayout.itemSize.height);
    }
    else
    {
        radioTitleLabel.frame =  CGRectMake(radioTitleLabel.frame.origin.x, textContainer.frame.origin.y+textContainer.frame.size.height+10, radioTitleLabel.frame.size.width, 0);
        radioCollectionView.frame =  CGRectMake(radioCollectionView.frame.origin.x, radioTitleLabel.frame.origin.y+radioTitleLabel.frame.size.height+10, self.view.frame.size.width-30, 0);
    }
    
}

-(void)checkAvailableFields
{
    for (int i =0; i<personalizeArray.count; i++)
    {
        NSMutableDictionary * tempDict = [personalizeArray objectAtIndex:i];
        if ([[tempDict objectForKey:@"type"] isEqualToString:@"field"])
        {
            hasText = true;
            fieldOptionId = [tempDict objectForKey:@"option_id"];
            titleLabel.text = [tempDict objectForKey:@"title"];
        }
        else if ([[tempDict objectForKey:@"type"] isEqualToString:@"radio"])
        {
            hasRadio = true;
            radioDict = [tempDict mutableCopy];
            radioTitleLabel.text = [radioDict objectForKey:@"title"];
        }
        else if ([[tempDict objectForKey:@"type"] isEqualToString:@"dropdown"])
        {
            hasDropdown = true;
        }
    }
    
    for (int i =0; i<[[radioDict objectForKey:@"personalizeType"] count]; i++)
    {
        NSMutableDictionary * dataDict=[[radioDict objectForKey:@"personalizeType"]objectAtIndex:i];
        if (i==0)
        {
            [selectedRadioArray addObject:@"Yes"];
            [sendingDataDict setObject:[dataDict objectForKey:@"value_id"] forKey:@"selectedRadioId"];
            [sendingDataDict setObject:[radioDict objectForKey:@"option_id"] forKey:@"RadioId"];
        }
        else
        {
            [selectedRadioArray addObject:@"No"];
        }
    }
    
    [self showField];
    [self showRadio];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    sendingDataDict = [[NSMutableDictionary alloc]init];
    selectedRadioArray = [[NSMutableArray alloc]init];
    [sendingDataDict setObject:@"" forKey:@"selectedRadioId"];
    [sendingDataDict setObject:@"" forKey:@"RadioId"];
    [sendingDataDict setObject:@"" forKey:@"fieldId"];
    [sendingDataDict setObject:@"" forKey:@"fieldValue"];
    self.navigationItem.title=self.productName;
    [personalizeField addTextFieldPaddingWithoutImages:personalizeField];
    [self removeAutolayouts];
    [self checkAvailableFields];
    NSLog(@"objProductDetail.personalizeDict is %@",objProductDetail.personalizeDict);
    personalizeField.text =[objProductDetail.personalizeDict objectForKey:@"fieldValue"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end
#pragma mark -Collection view methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[radioDict objectForKey:@"personalizeType"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    MyButton * btn = (MyButton *)[cell viewWithTag:1];
    NSMutableDictionary * dataDict = [[radioDict objectForKey:@"personalizeType"]objectAtIndex:indexPath.item];
    [btn setTitle:[[dataDict objectForKey:@"title"] uppercaseString] forState:UIControlStateNormal];
    btn.Tag = indexPath.row;
    if ([[selectedRadioArray objectAtIndex:indexPath.item] isEqualToString:@"Yes"])
    {
        [btn setSelected:YES];
    }
    else
    {
        [btn setSelected:NO];
    }
    [btn addTarget:self action:@selector(radioBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //cell.backgroundColor = [UIColor colorWithPatternImage:[self.results objectAtIndex:indexPath.row]];
    return cell;
}
#pragma mark -end
#pragma mark - IBActions
- (IBAction)preview:(id)sender
{
    if ([personalizeField.text isEqualToString:@""])
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the text first." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//            return ;
//        });
         [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter the text first" parentView:self.view];
        //[self.view makeToast:@"Please enter the text first" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
    }
    else
    {
     previewLbl.text = personalizeField.text;
    }
    
}

- (IBAction)submit:(id)sender
{
    if ([personalizeField.text isEqualToString:@""] && hasText)
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the text first." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//            return ;
//        });
         [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter the text first" parentView:self.view];
      //  [self.view makeToast:@"Please enter the text first" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
    }
    objProductDetail.hasPersonalized = true;
    [sendingDataDict setObject:fieldOptionId forKey:@"fieldId"];
    [sendingDataDict setObject:personalizeField.text forKey:@"fieldValue"];
    objProductDetail.personalizeDict = sendingDataDict;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}



-(IBAction)radioBtnClicked:(MyButton *)sender
{
    NSMutableDictionary * dataDict=[[radioDict objectForKey:@"personalizeType"]objectAtIndex:sender.Tag];
    for (int i = 0; i<selectedRadioArray.count;i++)
    {
        if (i==sender.Tag)
        {
            [selectedRadioArray replaceObjectAtIndex:i withObject:@"Yes"];
        }
        else
        {
            [selectedRadioArray replaceObjectAtIndex:i withObject:@"No"];
        }
    }
    [sendingDataDict setObject:[dataDict objectForKey:@"value_id"] forKey:@"selectedRadioId"];
    [sendingDataDict setObject:[radioDict objectForKey:@"option_id"] forKey:@"RadioId"];
    
    [radioCollectionView reloadData];

}
- (IBAction)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - end
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==personalizeField)
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
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([personalizeField.text isEqualToString:@""])
    {
       previewLbl.text = @"PERSONALIZE IT!";
    
    }
    return YES;
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
