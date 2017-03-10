//
//  SortByViewController.m
//  PipaBella
//
//  Created by Ranosys on 08/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "SortByViewController.h"
#import "ProductService.h"

@interface SortByViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UINavigationControllerDelegate,UITabBarControllerDelegate,UITabBarDelegate>
{
    NSMutableArray *sortByListArray;
    NSMutableArray *priceArray,*colorArray,*whatsNewArray,*inStockArray;
    int managePicker;
    NSMutableArray *colorIdArray;
    __weak IBOutlet UIView *bgView;
    
}
@property (weak, nonatomic) IBOutlet UITableView *sortByTableView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end

@implementation SortByViewController
@synthesize sortByTableView,pickerView,toolBar;
@synthesize objProductListing,objSearchProductListing;
@synthesize isSearchScreen;
@synthesize sortBySelectedArray;
@synthesize objHomeView;
@synthesize isHomeScreen;
#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    UITabBarController *tabBarController = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController ;
    [tabBarController setDelegate:self];
    self.navigationItem.title=@"SORT BY";
    // Do any additional setup after loading the view.
    NSLog(@"price : %@, color : %@, inStock : %@, whatsNew : %@",objProductListing.sortByPrice, objProductListing.colorString, objProductListing.sortByinStock, objProductListing.sortByWhatsNew);
    NSLog(@"price : %@, color : %@, inStock : %@, whatsNew : %@",objSearchProductListing.sortByPrice, objSearchProductListing.colorString, objSearchProductListing.sortByinStock, objSearchProductListing.sortByWhatsNew);
    if (isHomeScreen)
    {
        sortByListArray=[[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%@",objHomeView.sortByPrice],[NSString stringWithFormat:@"%@",objHomeView.colorString],[NSString stringWithFormat:@"%@",objHomeView.sortByWhatsNew],[NSString stringWithFormat:@"%@",objHomeView.sortByinStock], nil];
    }
    else if (isSearchScreen)
    {
        sortByListArray=[[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%@",objSearchProductListing.sortByPrice],[NSString stringWithFormat:@"%@",objSearchProductListing.colorString],[NSString stringWithFormat:@"%@",objSearchProductListing.sortByWhatsNew],[NSString stringWithFormat:@"%@",objSearchProductListing.sortByinStock], nil];
    }
    else
    {
        sortByListArray=[[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%@",objProductListing.sortByPrice],[NSString stringWithFormat:@"%@",objProductListing.colorString],[NSString stringWithFormat:@"%@",objProductListing.sortByWhatsNew],[NSString stringWithFormat:@"%@",objProductListing.sortByinStock], nil];
    }
    
    
    
    colorIdArray = [[NSMutableArray alloc]init];
    priceArray=[[NSMutableArray alloc] initWithObjects:
                @"Low to high",
                @"High to low",
                nil];
    
    whatsNewArray=[[NSMutableArray alloc] initWithObjects:
                   @"What's New",
                   @"Restocked",
                   nil];
    
    inStockArray=[[NSMutableArray alloc] initWithObjects:
                  @"Instock",
                  @"All",
                  nil];
    
    
    pickerView.translatesAutoresizingMaskIntoConstraints=YES;
    toolBar.translatesAutoresizingMaskIntoConstraints=YES;
    pickerView.frame = CGRectMake(pickerView.frame.origin.x, 1000 , self.view.bounds.size.width, 210);
    toolBar.frame = CGRectMake(toolBar.frame.origin.x, pickerView.frame.origin.y-44, self.view.bounds.size.width, toolBar.frame.size.height);
//    [pickerView setNeedsLayout];
//    [pickerView reloadAllComponents];
    UITapGestureRecognizer *menuItemTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    menuItemTapGestureRecognizer.numberOfTapsRequired    = 1;
    menuItemTapGestureRecognizer.delegate                = self;
    [bgView addGestureRecognizer:menuItemTapGestureRecognizer];
    
    
    [myDelegate ShowIndicator];
    [self performSelector:@selector(getColorList) withObject:nil afterDelay:.1];
}
- (void)navigationController:(UINavigationController  *)navigationController didShowViewController:(UIViewController  *)viewController animated:(BOOL)animated {
    
    NSLog(@"worked!!!");
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    [self closeButtonAction:nil];
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark - end

#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return sortByListArray.count;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView;
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40.0)];
    
    headerView.backgroundColor = [UIColor whiteColor];
    //title label
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.origin.y, headerView.frame.size.width, 40)];
    titleLabel.backgroundColor=[UIColor whiteColor];
    titleLabel.textColor =[UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = @"SORT BY";
    [headerView addSubview:titleLabel];
    //end
    
    //seperator
    UILabel * seperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.origin.y+headerView.frame.size.height-2, headerView.frame.size.width, 1)];
    seperatorLabel.backgroundColor=[UIColor colorWithRed:154.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.0];
    [headerView addSubview:seperatorLabel];
    
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"sortByCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    UILabel *sortByCategory = (UILabel*)[cell viewWithTag:2];
//
    sortByCategory.text=[sortByListArray objectAtIndex:indexPath.row];
    if ([[sortBySelectedArray objectAtIndex:indexPath.row] isEqualToString:@"N"])
    {
       sortByCategory.textColor = [UIColor blackColor];
       
    }
    else
    {
      sortByCategory.textColor = [UIColor colorWithRed:237.0/255.0 green:0.0/255.0 blue:140.0/255.0 alpha:1.0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    managePicker = (int)indexPath.row;
    
    [self pickerShow];
    
}
#pragma mark - end

#pragma mark - Picker View methods

-(void)pickerShow
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [pickerView setNeedsLayout];
    
    if (managePicker==0) {
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:managePicker inSection:0];
        UITableViewCell * cell = (UITableViewCell *)[self.sortByTableView cellForRowAtIndexPath:indexPath];
        UILabel *sortByCategory = (UILabel*)[cell viewWithTag:2];
        if ([sortByCategory.text isEqualToString: @"PRICE"]) {
            [pickerView selectRow:0 inComponent:0 animated:YES];
        }
        else{
            [pickerView selectRow:[priceArray indexOfObject:sortByCategory.text] inComponent:0 animated:YES];
        }
    }
    if (managePicker==1) {
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:managePicker inSection:0];
        UITableViewCell * cell = (UITableViewCell *)[self.sortByTableView cellForRowAtIndexPath:indexPath];
        UILabel *sortByCategory = (UILabel*)[cell viewWithTag:2];
        if ([sortByCategory.text isEqualToString: @"COLOR"]) {
            [pickerView selectRow:0 inComponent:0 animated:YES];
        }
        else{
            
            //            NSMutableDictionary *tmpDict=[colorArray objectAtIndex:managePicker];
            //            objProductListing.sortbyColor=[tmpDict objectForKey:@"value"];
            //            [pickerView selectRow:[colorArray indexOfObject:sortByCategory.text] inComponent:0 animated:YES];
            
            [pickerView selectRow:[colorArray indexOfObject:sortByCategory.text] inComponent:0 animated:YES];
        }
    }
    if (managePicker==2) {
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:managePicker inSection:0];
        UITableViewCell * cell = (UITableViewCell *)[self.sortByTableView cellForRowAtIndexPath:indexPath];
        UILabel *sortByCategory = (UILabel*)[cell viewWithTag:2];
        if ([sortByCategory.text isEqualToString: @"WHAT'S NEW"]) {
            [pickerView selectRow:0 inComponent:0 animated:YES];
        }
        else{
            [pickerView selectRow:[whatsNewArray indexOfObject:sortByCategory.text] inComponent:0 animated:YES];
        }
    }
    if (managePicker==3)
    {
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:managePicker inSection:0];
        UITableViewCell * cell = (UITableViewCell *)[self.sortByTableView cellForRowAtIndexPath:indexPath];
        UILabel *sortByCategory = (UILabel*)[cell viewWithTag:2];
        if ([sortByCategory.text isEqualToString: @"IN STOCK"])
        {
            [pickerView selectRow:0 inComponent:0 animated:YES];
        }
        else
        {
            [pickerView selectRow:[inStockArray indexOfObject:sortByCategory.text] inComponent:0 animated:YES];
        }
    }
    pickerView.frame = CGRectMake(pickerView.frame.origin.x, self.view.bounds.size.height-pickerView.frame.size.height-30 , self.view.bounds.size.width, 213);
    toolBar.frame = CGRectMake(toolBar.frame.origin.x, pickerView.frame.origin.y-44, self.view.bounds.size.width, toolBar.frame.size.height);
    
    
    [pickerView reloadAllComponents];
    [UIView commitAnimations];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,600,20)];
        pickerLabel.font = [UIFont fontWithName:@"Helvetica" size:22];
        pickerLabel.textAlignment=NSTextAlignmentCenter;
    }
    
    if (managePicker==0)
    {
        if (priceArray.count>row)
        {
            NSString *str=[priceArray objectAtIndex:row];
            pickerLabel.text=str;
        }
        
    }
    else if (managePicker==1)
    {
        //        NSMutableDictionary *tmpDict=[colorArray objectAtIndex:row];
        //        NSString *str=[tmpDict objectForKey:@"label"];
        //
        //        pickerLabel.text=str;
        
        NSString *str=[colorArray objectAtIndex:row];
        pickerLabel.text=str;
    }
    else if (managePicker==2)
    {
        NSLog(@"index before crash is  in viewForRow %ld",(long)row);
        if (whatsNewArray.count>row)
        {
            NSString *str=[whatsNewArray objectAtIndex:row];
            pickerLabel.text=str;
        }
        
    }
    else
    {
        if (whatsNewArray.count>row)
        {
            NSString *str=[inStockArray objectAtIndex:row];
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
    if (managePicker == 0)
    {
        return priceArray.count;
    }
    else if (managePicker == 1)
    {
        return colorArray.count;
    }
    else if (managePicker == 2)
    {
        return whatsNewArray.count;
    }
    else
    {
        return inStockArray.count;
    }
    
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // [_keyboardControls.activeField resignFirstResponder];
    
    if (managePicker == 0) {
        NSString *str=[priceArray objectAtIndex:row];
        return str;
    }
    else if (managePicker == 1)
    {
        //        NSMutableDictionary *tmpDict=[colorArray objectAtIndex:row];
        //        return [tmpDict objectForKey:@"label"];
        
        NSString *str=[colorArray objectAtIndex:row];
        return str;
        
    }
    else if (managePicker == 2)
    {
        NSLog(@"index before crash is  in titleForRow %ld",(long)row);
        NSString *str=[whatsNewArray objectAtIndex:row];
        return str;
    }
    else{
        NSString *str=[inStockArray objectAtIndex:row];
        return str;
    }
}
- (IBAction)pickerToolBar:(id)sender
{
    NSInteger index = [pickerView selectedRowInComponent:0];
    NSString *str;
    if (isHomeScreen)
    {
        if (managePicker == 0)
        {
            objHomeView.sortByPrice=[priceArray objectAtIndex:index];
            str =objHomeView.sortByPrice;
            
        }
        else if (managePicker == 1)
        {
            objHomeView.sortbyColor=[colorIdArray objectAtIndex:index];
            str =[colorArray objectAtIndex:index];
            objHomeView.colorString = str;
        }
        else if (managePicker == 2)
        {
            objHomeView.sortByWhatsNew=[whatsNewArray objectAtIndex:index];
            str =objHomeView.sortByWhatsNew;
        }
        else
        {
            objHomeView.sortByinStock=[inStockArray objectAtIndex:index];
            str =objHomeView.sortByinStock;
        }
    }
    else if (isSearchScreen)
    {
        if (managePicker == 0)
        {
            objSearchProductListing.sortByPrice=[priceArray objectAtIndex:index];
            str =objSearchProductListing.sortByPrice;
            
        }
        else if (managePicker == 1)
        {
            objSearchProductListing.sortbyColor=[colorIdArray objectAtIndex:index];
            str =[colorArray objectAtIndex:index];
            objSearchProductListing.colorString = str;
        }
        else if (managePicker == 2)
        {
            objSearchProductListing.sortByWhatsNew=[whatsNewArray objectAtIndex:index];
            str =objSearchProductListing.sortByWhatsNew;
        }
        else
        {
            objSearchProductListing.sortByinStock=[inStockArray objectAtIndex:index];
            str =objSearchProductListing.sortByinStock;
        }
        
    }
    else
    {
        if (managePicker == 0)
        {
            objProductListing.sortByPrice=[priceArray objectAtIndex:index];
            str =objProductListing.sortByPrice;
            
        }
        else if (managePicker == 1)
        {
            objProductListing.sortbyColor=[colorIdArray objectAtIndex:index];
            str = [colorArray objectAtIndex:index];
            objProductListing.colorString = str;
        }
        else if (managePicker == 2)
        {
            objProductListing.sortByWhatsNew=[whatsNewArray objectAtIndex:index];
            str =objProductListing.sortByWhatsNew;
        }
        else
        {
            objProductListing.sortByinStock=[inStockArray objectAtIndex:index];
            str =objProductListing.sortByinStock;
        }
    }
    
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:managePicker inSection:0];
    [sortBySelectedArray replaceObjectAtIndex:managePicker withObject:@"Y"];
    UITableViewCell * cell = (UITableViewCell *)[self.sortByTableView cellForRowAtIndexPath:indexPath];
    UILabel *sortByCategory = (UILabel*)[cell viewWithTag:2];
    sortByCategory.textColor = [UIColor colorWithRed:237.0/255.0 green:0.0/255.0 blue:140.0/255.0 alpha:1.0];
    sortByCategory.text = str;
    [self hidePickerWithAnimation];
}
-(void)hidePickerWithAnimation
{
    // scrollView.scrollEnabled = YES;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    pickerView.frame = CGRectMake(pickerView.frame.origin.x, 1000, self.view.bounds.size.width, pickerView.frame.size.height);
    toolBar.frame = CGRectMake(toolBar.frame.origin.x, 1000, self.view.bounds.size.width, toolBar.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark - end

#pragma mark - Webservice
-(void)getColorList{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
            
        });
    }
    [[ProductService sharedManager] colorListing:^(id data)
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
                                
                            }
                            else
                            {
                                //                                colorArray = (NSMutableArray *)data;
                                //                                NSLog(@"colorArray count is %lu",(unsigned long)colorArray.count);
                                colorArray = [[NSMutableArray alloc]init];
                                for (int i=0; i<[data count]; i++) {
                                    [colorArray addObject:[[data objectAtIndex:i] objectForKey:@"label"]];
                                    [colorIdArray addObject:[[data objectAtIndex:i] objectForKey:@"value"]];
                                }
                            }
                        });
         
     }
                                         failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
    
}
#pragma mark - end
#pragma mark - Button actions
- (IBAction)pickerCancel:(id)sender
{
    [self hidePickerWithAnimation];
}

- (IBAction)closeButtonAction:(id)sender
{
    if (isHomeScreen)
    {
        objHomeView.sortbyColor =@"";
        objHomeView.colorString =@"COLOR";
        objHomeView.sortByinStock = @"IN STOCK";
        objHomeView.sortByPrice = @"PRICE";
        objHomeView.sortByWhatsNew = @"WHAT'S NEW";
        [objHomeView.bestsellersDataArray removeAllObjects];
        [objHomeView.restockDataArray removeAllObjects];
        [self.objHomeView viewDidAppear:YES];
        [self.objHomeView viewWillAppear:YES];
        objSearchProductListing.pageNumber = 1;
    }
    
    if (isSearchScreen)
    {
        objSearchProductListing.sortbyColor =@"";
        objSearchProductListing.colorString =@"COLOR";
        objSearchProductListing.sortByinStock = @"IN STOCK";
        objSearchProductListing.sortByPrice = @"PRICE";
        objSearchProductListing.sortByWhatsNew = @"WHAT'S NEW";
        [objSearchProductListing.searchProductDataArray removeAllObjects];
        [self.objSearchProductListing viewWillAppear:YES];
        
        objSearchProductListing.pageNumber = 1;
        
    }
    else
    {
        objProductListing.sortbyColor =@"";
        objProductListing.colorString =@"COLOR";
        objProductListing.sortByinStock = @"IN STOCK";
        objProductListing.sortByPrice = @"PRICE";
        objProductListing.sortByWhatsNew = @"WHAT'S NEW";
        [objProductListing.productDataArray removeAllObjects];
        [self.objProductListing viewDidAppear:YES];
        [self.objProductListing viewWillAppear:YES];
        objProductListing.pageNumber = 1;
        
    }
    for (int i=0; i<sortByListArray.count; i++)
    {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
        [sortBySelectedArray replaceObjectAtIndex:i withObject:@"N"];
        UITableViewCell * cell = (UITableViewCell *)[self.sortByTableView cellForRowAtIndexPath:indexPath];
        UILabel *sortByCategory = (UILabel*)[cell viewWithTag:2];
        sortByCategory.textColor = [UIColor blackColor];
    }
    [self.sortByTableView reloadData];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)doneButtonAction:(id)sender
{
    if (isHomeScreen)
    {
        [self.objHomeView viewDidAppear:YES];
        [self.objHomeView viewWillAppear:YES];
    }
    else if (isSearchScreen)
    {
        [self.objSearchProductListing viewWillAppear:YES];
        
    }
    else
    {
        [self.objProductListing viewDidAppear:YES];
        [self.objProductListing viewWillAppear:YES];
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)resetButtonAction:(id)sender
{
    
    if (isHomeScreen)
    {
        objHomeView.sortbyColor =@"";
        objHomeView.colorString =@"COLOR";
        objHomeView.sortByinStock = @"IN STOCK";
        objHomeView.sortByPrice = @"PRICE";
        objHomeView.sortByWhatsNew = @"WHAT'S NEW";
        [objHomeView.bestsellersDataArray removeAllObjects];
        [objHomeView.restockDataArray removeAllObjects];
        objSearchProductListing.pageNumber = 1;
        [sortByListArray removeAllObjects];
        sortByListArray=[[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%@",objHomeView.sortByPrice],[NSString stringWithFormat:@"%@",objHomeView.colorString],[NSString stringWithFormat:@"%@",objHomeView.sortByWhatsNew],[NSString stringWithFormat:@"%@",objHomeView.sortByinStock], nil];
    }
    else if (isSearchScreen)
    {
        objSearchProductListing.sortbyColor =@"";
        objSearchProductListing.colorString =@"COLOR";
        objSearchProductListing.sortByinStock = @"IN STOCK";
        objSearchProductListing.sortByPrice = @"PRICE";
        objSearchProductListing.sortByWhatsNew = @"WHAT'S NEW";
        [objSearchProductListing.searchProductDataArray removeAllObjects];
        objSearchProductListing.pageNumber = 1;
        [sortByListArray removeAllObjects];
        sortByListArray=[[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%@",objSearchProductListing.sortByPrice],[NSString stringWithFormat:@"%@",objSearchProductListing.colorString],[NSString stringWithFormat:@"%@",objSearchProductListing.sortByWhatsNew],[NSString stringWithFormat:@"%@",objSearchProductListing.sortByinStock], nil];
    }
    else
    {
        objProductListing.sortbyColor =@"";
        objProductListing.colorString =@"COLOR";
        objProductListing.sortByinStock = @"IN STOCK";
        objProductListing.sortByPrice = @"PRICE";
        objProductListing.sortByWhatsNew = @"WHAT'S NEW";
        [objProductListing.productDataArray removeAllObjects];
        objProductListing.pageNumber = 1;
        [sortByListArray removeAllObjects];
        sortByListArray=[[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%@",objProductListing.sortByPrice],[NSString stringWithFormat:@"%@",objProductListing.colorString],[NSString stringWithFormat:@"%@",objProductListing.sortByWhatsNew],[NSString stringWithFormat:@"%@",objProductListing.sortByinStock], nil];
    }
    
    for (int i=0; i<sortByListArray.count; i++)
    {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
        [sortBySelectedArray replaceObjectAtIndex:i withObject:@"N"];
        UITableViewCell * cell = (UITableViewCell *)[self.sortByTableView cellForRowAtIndexPath:indexPath];
        UILabel *sortByCategory = (UILabel*)[cell viewWithTag:2];
        sortByCategory.textColor = [UIColor blackColor];
    }
    [self.sortByTableView reloadData];
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
