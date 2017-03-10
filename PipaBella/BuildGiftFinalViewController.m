//
//  BuildGiftFinalViewController.m
//  PipaBella
//
//  Created by Sumit on 10/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "BuildGiftFinalViewController.h"
#import "BuildGiftFinalStepCell.h"
#import "ProductService.h"
#import "CurrencyConverter.h"
#import "CurrencyConverter.h"
@interface BuildGiftFinalViewController ()
{
    __weak IBOutlet UIView *stepBlock;
    __weak IBOutlet UIImageView *giftBanner;
    
    NSMutableDictionary * cartDict;
    int remainingInventry;
    bool isAddedtoCart;
    __weak IBOutlet UITableView *giftTableview;
}

@end

@implementation BuildGiftFinalViewController
@synthesize dataArray;
@synthesize bannerImage;
@synthesize sendingDataArray;
@synthesize productId;
@synthesize stockQuantity;
@synthesize objBuildGift;
#pragma mark - View life cycle
- (void)viewDidLoad {
    stepBlock.layer.borderWidth = 1;
    stepBlock.layer.borderColor = [[UIColor colorWithRed:166.0/255.0 green:166.0/255.0 blue:166.0/255.0 alpha:1.0] CGColor];
    giftBanner.image = bannerImage;
    [self calculatePrice];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [giftTableview reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (BOOL)hidesBottomBarWhenPushed {
//    return YES;
//}

-(NSString *)calculatePrice
{
    double price = 0.0;
    for (int i= 0; i<dataArray.count; i++)
    {
        NSMutableDictionary * dataDict = [dataArray objectAtIndex:i];
        double singlePrice = [[dataDict objectForKey:@"price"]doubleValue];
        price = price+singlePrice;
        
    }
    
    //NSLog(@"price is %f",price);
    return [NSString stringWithFormat:@"%f",price];
    
}
-(void)getProductInventory
{
    NSMutableArray * cartArray =[[UserDefaultManager getValue:@"cartData"]mutableCopy];
    for (int i =0; i<cartArray.count; i++)
    {
        cartDict = [cartArray objectAtIndex:i];
        if ([[cartDict objectForKey:@"product_id"]isEqualToString:productId])
        {
            isAddedtoCart =true;
            remainingInventry = stockQuantity - [[cartDict objectForKey:@"product_quantity"]intValue];
            break;
        }
    }
    
    
}
#pragma mark - end
#pragma mark - Tableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==0) {
        
        
        if (dataArray.count%2==0)
        {
            return dataArray.count/2;
        }
        else
        {
            return (dataArray.count/2)+1;
        }
    }
    else
    {
        return 1;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section==0)
    {
        return 235;
    }
    else
    {
        
        return 65;
        
    }
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        
        BuildGiftFinalStepCell *cell ;
        NSString *simpleTableIdentifier = @"BuildGiftFinalStepCell";
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            cell = [[BuildGiftFinalStepCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        
        
        NSMutableDictionary *evenDict =[dataArray objectAtIndex:indexPath.row*2];
        
        NSString * productName = [[evenDict objectForKey:@"name"] lowercaseString];
        productName = [[evenDict objectForKey:@"name"] stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[[evenDict objectForKey:@"name"] substringToIndex:1] uppercaseString]];
        
        cell.leftProductName.text = productName;
        cell.leftPriceLbl.text =[CurrencyConverter converCurrency:[evenDict objectForKey:@"price"]];
        [cell.leftImageview sd_setImageWithURL:[NSURL URLWithString:[evenDict objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        if (indexPath.row*2+1<dataArray.count)
        {
           // NSLog(@"index is %ld",(long)indexPath.row);
            NSMutableDictionary *oddDict =[dataArray objectAtIndex:(indexPath.row*2)+1];
            [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:[oddDict objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            
            NSString * productName = [[oddDict objectForKey:@"name"] lowercaseString];
            productName = [[oddDict objectForKey:@"name"] stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[[oddDict objectForKey:@"name"] substringToIndex:1] uppercaseString]];
            
            
            cell.rightProductName.text = productName;
            cell.rightPriceLbl.text =[CurrencyConverter converCurrency:[oddDict objectForKey:@"price"]];
        }
        
        return cell;
    }
    else
    {
        UITableViewCell *cell ;
        NSString *simpleTableIdentifier = @"buttonCell";
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        UILabel * priceLbl = (UILabel *)[cell viewWithTag:2];
        priceLbl.text = [CurrencyConverter converCurrency:[self calculatePrice]];
        return cell;
    }
}
#pragma mark - end

-(void)getMyCartList
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
            
        });
    }
    [[ProductService sharedManager] cartListing:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [myDelegate StopIndicator];
                            if(data==nil)
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                    [alert1 show];
                                });
                                
                            }
                            else
                            {
                                self.objBuildGift.stepCounter = 0;
                                
                                NSMutableArray *tempArray=[UserDefaultManager getValue:@"cartData"];
                                NSMutableArray * cartArray = [tempArray mutableCopy];
                                NSMutableArray * tmpAry = [tempArray mutableCopy];
                                for (int i =0; i<tempArray.count; i++) {
                                    NSMutableDictionary * cartDict1 = [tempArray objectAtIndex:i];
                                    if (![[cartDict1 objectForKey:@"parent_item_id"] isEqualToString:@"\n"])
                                    {
                                        [tmpAry removeObject:cartDict1];
                                        
                                    }
                                }
                                [cartArray removeAllObjects];
                                cartArray = [tmpAry mutableCopy];
                                [UserDefaultManager setValue:cartArray key:@"cartData"];
                                [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Your product has been added to cart" parentView:self.view];
//                                if([[UIScreen mainScreen] bounds].size.height>480)
//                                {
//                                    [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Your product has been added to cart" parentView:self.view];
//                                   // [self.view makeToast:@"Your product has been added to cart" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
//                                }else{
//                                    [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Your product has been added to cart" parentView:self.view];
//                                    //[self.view makeToast:@"Your product has been added to cart" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
//                                }
                                [self.navigationController popToRootViewControllerAnimated:YES];
                                
                            }
                        });
         
     }
                                        failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
    
}

-(void)addToCartService
{
    [[ProductService sharedManager] buildGiftAddToCart:productId dataArray:sendingDataArray success:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            
                            if (data != nil)
                            {
                                NSString  *status =(NSString *)data;
                                NSString *count =[UserDefaultManager getValue:@"total_cart_item"];
                                int total =[count intValue];
                                total++;
                                [UserDefaultManager setValue:[NSString stringWithFormat:@"%d",total] key:@"total_cart_item"];
                                //cartBtn.badgeValue = [UserDefaultManager getValue:@"total_cart_item"];
                                if ([status boolValue])
                                {
                                    [self getMyCartList];
                                    
                                }
                            }
                            else{
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                    [alert show];
                                });
                            }
                            
                            
                        });
         
         
     }
                                               failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
    
    
}
-(IBAction)addTocart:(id)sender
{
    if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
    {
        myDelegate.istoast = true;
        [UserDefaultManager setValue:@"buildGift" key:@"isGift"];
        if([[UIScreen mainScreen] bounds].size.height>480)
        {
            myDelegate.toastMessage = @"SIGN IN to add products to your cart";
        }else
        {
            myDelegate.toastMessage = @"SIGN IN to add products to your cart";
        }

      //  myDelegate.toastMessage = @"SIGN IN to add products to your cart          X";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
        myDelegate.window.rootViewController = myDelegate.navigationController;
    }
    else
    {
    [myDelegate ShowIndicator];
    [self performSelector:@selector(addToCartService) withObject:nil afterDelay:.5];
    }
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(alertView.tag==25)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
        
        myDelegate.window.rootViewController = myDelegate.navigationController;
        
    }
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
