//
//  CurrencyViewController.m
//  PipaBella
//
//  Created by Ranosys on 20/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "CurrencyViewController.h"
#import "CurrencyTableViewCell.h"
#import "GeneralInfoService.h"
#import "CurrencyConverter.h"
@interface CurrencyViewController ()<UITableViewDelegate,UITableViewDataSource,RadioCellDelegate>
{
    NSMutableArray *currencyArray;
    int currencyFlag;
    __weak IBOutlet UIButton *retryBtn;
}
@property (weak, nonatomic) IBOutlet UITableView *currencyTableView;

@end

@implementation CurrencyViewController
@synthesize currencyTableView;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
   // [CurrencyConverter converCurrency];
    self.navigationItem.title=@"CURRENCY";
    // Do any additional setup after loading the view.
    currencyFlag=0;
    currencyArray=[[NSMutableArray alloc]init];
                   //WithObjects:@"SGD",@"IND",@"PAS",@"JOT",@"ABC", nil];
    retryBtn.hidden=YES;
    
    [myDelegate ShowIndicator];
    [self performSelector:@selector(getCurrencyData) withObject:nil afterDelay:.1];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Webservice
-(void)getCurrencyData
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        retryBtn.hidden=NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
        });
    }
    else
    {
        [[GeneralInfoService sharedManager] currency:^(id data)
         {
             //Handle fault cases
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                [myDelegate StopIndicator];
                                
                                if(data==nil || [data count]==0)
                                {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                        [alert1 show];
                                    });
                                    retryBtn.hidden=NO;
                                }
                                else
                                {
                                retryBtn.hidden=YES;
                                currencyArray=data;
                                    
                                    for (int i=0; i<currencyArray.count; i++)
                                    {
                                       NSString * currencyCode = [[currencyArray objectAtIndex:i] currencyCode];
                                        NSMutableDictionary *tempDict = [UserDefaultManager getValue:@"selectedCurrency"];
                                        if ([currencyCode isEqualToString:@"INR"] && ([[tempDict objectForKey:@"code"] isEqualToString:@"INR"]))
                                        {
                                           [UserDefaultManager setValue:currencyCode key:@"currencyCode"];
                                            CurrencyDataModel * objCurrency = [currencyArray objectAtIndex:i];
                                            NSMutableDictionary * currencyDict = [NSMutableDictionary new];
                                            [currencyDict setObject:objCurrency.currencySymbol forKey:@"symbol"];
                                            [currencyDict setObject:objCurrency.currencyCode forKey:@"code"];
                                            [currencyDict setObject:objCurrency.convertingPrice forKey:@"price"];
                                            [UserDefaultManager setValue:currencyDict key:@"selectedCurrency"];
                                        }
                                        //
                                    }
                                    
                                [currencyTableView reloadData];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return currencyArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"currencyCell";
    CurrencyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[CurrencyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.borderView.layer.borderColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0f].CGColor;
    cell.borderView.layer.borderWidth = 2.0f;
     [cell displayData:[currencyArray objectAtIndex:indexPath.row]];
 
    [cell.radioButton addTarget:self action:@selector(radioTouched:) forControlEvents:UIControlEventTouchUpInside];
    cell.radioButton.tag=indexPath.row;
    cell.delegate = self;
    NSString * Currency = [[currencyArray objectAtIndex:indexPath.row] currencyCode];
    NSString * selectedCurrency = [UserDefaultManager getValue:@"currencyCode"];

    if ([selectedCurrency isEqualToString: Currency])
        {
            [cell radioButtonTouched:[[currencyArray objectAtIndex:indexPath.row] currencyCode]];
        }
    
    else if ([UserDefaultManager getValue:@"currencyCode"]==nil && [UserDefaultManager getValue:@"currencyCode"]==NULL && [Currency isEqualToString:@"INR"])
    {
            [cell radioButtonTouched:Currency];
    }
//    else
//    {
//        [cell radioButtonTouched:[[currencyArray objectAtIndex:indexPath.row] currencyCode]];
//    }


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CurrencyTableViewCell * cell = (CurrencyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

   [cell radioButtonTouched:[[currencyArray objectAtIndex:indexPath.row] currencyCode]];
    
}
#pragma mark - end

#pragma mark - Radiobutton action
- (IBAction)radioTouched:(id)sender
{
    NSIndexPath *index=[NSIndexPath indexPathForRow:[sender tag] inSection:0];
    CurrencyTableViewCell * cell = (CurrencyTableViewCell *)[currencyTableView cellForRowAtIndexPath:index];
    [cell radioButtonTouched:[[currencyArray objectAtIndex:[sender tag]] currencyCode]];
}
//Method to change city using radio button
-(void) myRadioCellDelegateDidCheckRadioButton:(CurrencyTableViewCell*)checkedCell
{
    NSIndexPath *checkPath = [currencyTableView indexPathForCell:checkedCell];
    
    for (int section = 0; section < [currencyTableView numberOfSections]; section++) {
        if(section == checkPath.section)
        {
            for (int row = 0; row < [currencyTableView numberOfRowsInSection:section]; row++)
            {
                NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
                CurrencyTableViewCell* cell = (CurrencyTableViewCell *)[currencyTableView cellForRowAtIndexPath:cellPath];
                
                if(checkPath.row != cellPath.row)
                {
                    [cell unCheckRadio];
                }
                else if(checkPath!=nil)
                {
                    CurrencyDataModel * objCurrency = [currencyArray objectAtIndex:cellPath.row];
                    NSMutableDictionary * currencyDict = [NSMutableDictionary new];
                    [currencyDict setObject:objCurrency.currencySymbol forKey:@"symbol"];
                    [currencyDict setObject:objCurrency.currencyCode forKey:@"code"];
                    [currencyDict setObject:objCurrency.convertingPrice forKey:@"price"];
                    [UserDefaultManager setValue:currencyDict key:@"selectedCurrency"];
                    //NSLog(@"index is %d and checkPath.row is %d",cellPath.row,checkPath.row);
                }
            }
        }
    }
}
#pragma mark - end

#pragma mark - Button Action
- (IBAction)retryButtonAction:(id)sender
{
    [myDelegate ShowIndicator];
    [self performSelector:@selector(getCurrencyData) withObject:nil afterDelay:.1];
}

#pragma mark - end
@end
