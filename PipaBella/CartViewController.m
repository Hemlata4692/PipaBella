//
//  CartViewController.m
//  PipaBella
//
//  Created by Ranosys on 16/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "CartViewController.h"
#import "CartTableViewCell.h"
#import "ProductService.h"
#import "CheckoutReviewViewController.h"
#import "CurrencyConverter.h"
#import "ProductDetailViewController.h"
#import "SearchViewController.h"
@interface CartViewController ()<UIGestureRecognizerDelegate,BSKeyboardControlsDelegate,SWTableViewCellDelegate>{
    NSMutableArray *array;
    NSMutableArray *cartArray;
    NSArray * textFields;
    NSString *totalAmount;
    NSString * productId;
    NSString * itemId;
    bool isBuildGift;
    int tax;
    int isEditGiftMsg;
    
    int globalTax;
    NSMutableArray *globalTaxArray;
    NSString *giftMessageText;
    
    
    NSMutableDictionary* myDict,* myDict1;
    
    int buttonTag;
    
}
@property (weak, nonatomic) IBOutlet UIView *giftMessageBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *addGiftMessageView;
@property (weak, nonatomic) IBOutlet UILabel *addGiftMessageLabel;
@property (weak, nonatomic) IBOutlet UITextView *addMessageTextView;
@property (weak, nonatomic) IBOutlet UIButton *saveMessageBtn;
@property (weak, nonatomic) IBOutlet UIButton *deliverToBtn;
@property (weak, nonatomic) IBOutlet UIButton *reviewBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UITableView *myCartTableView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@end

@implementation CartViewController
@synthesize giftMessageBackgroundView,addGiftMessageView,addGiftMessageLabel,addMessageTextView;
@synthesize saveMessageBtn,deliverToBtn,reviewBtn,payBtn,myCartTableView;
@synthesize keyboardControls;
#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    myDict = [NSMutableDictionary new];
    myDict1 = [NSMutableDictionary new];
    isBuildGift = false;
    [self addBorder];
    buttonTag=0;
    self.title=@"MY SHOPPING BAG";
    isEditGiftMsg=0;
    // Do any additional setup after loading the view.
    giftMessageText=@"";
    giftMessageBackgroundView.hidden = YES;
    array = [[NSMutableArray alloc] init];
    cartArray = [[NSMutableArray alloc]init];
    globalTaxArray= [[NSMutableArray alloc]init];
    [reviewBtn addBorder:reviewBtn color:[UIColor colorWithRed:241.0/255.0 green:0.0/255.0 blue:136.0/255.0 alpha:1.0]];
    [reviewBtn setTitleColor:[UIColor colorWithRed:241.0/255.0 green:0.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    
    [deliverToBtn addBorder:deliverToBtn color:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0]];
    [deliverToBtn setTitleColor:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    [myCartTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    myCartTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    myCartTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [payBtn addBorder:payBtn color:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0]];
    [payBtn setTitleColor:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    textFields = @[addMessageTextView];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFields]];
    [self.keyboardControls setDelegate:self];
    
    UITapGestureRecognizer *menuItemTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    menuItemTapGestureRecognizer.numberOfTapsRequired    = 1;
    menuItemTapGestureRecognizer.delegate                = self;
    [giftMessageBackgroundView addGestureRecognizer:menuItemTapGestureRecognizer];
    
    //    [myDelegate ShowIndicator];
    //    [self performSelector:@selector(getMyCartList) withObject:nil afterDelay:.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSArray *viewControllers = self.navigationController.viewControllers;
    UIViewController *rootViewController = (UIViewController *)[viewControllers objectAtIndex:0];
    NSLog(@"Tab Id = %d, SELECTED INDEX = %lu",myDelegate.tabId,self.tabBarController.selectedIndex);
    if (myDelegate.tabId != self.tabBarController.selectedIndex && !([rootViewController isKindOfClass:[SearchViewController class]]))
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Localytics tagScreen:@"Cart View"];
}
- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    giftMessageBackgroundView.hidden = YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [myDelegate ShowIndicator];
    [self performSelector:@selector(getMyCartList) withObject:nil afterDelay:.5];
}

-(void)addBorder
{
    [saveMessageBtn addBorder:saveMessageBtn color:[UIColor colorWithRed:132.0/255.0 green:132.0/255.0 blue:132.0/255.0 alpha:1.0]];
    [addGiftMessageView setViewBorder:addGiftMessageView color:[UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0]];
    [addGiftMessageLabel setBottomBorder:addGiftMessageLabel color:[UIColor colorWithRed:78.0/255.0 green:78.0/255.0 blue:78.0/255.0 alpha:1.0]];
}

#pragma mark - end
#pragma mark - Web service method
-(void)removeFromCart
{
    
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
            return ;
            
        });
    }
    
    
    
    [[ProductService sharedManager] removeFromCart:itemId success:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            
                            if (data != nil)
                            {
                                NSString *status = (NSString *)data;
                                if ([status boolValue])
                                {
                                    NSLog(@"removeFromCart success!!!!!!!!!!!!!!!!!!!!!!");
                                    [self getMyCartList];
                                }
                                
                            }
                            else
                            {
                                [myDelegate StopIndicator];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                    [alert show];
                                });
                            }
                            
                            
                        });
         
         
     }
                                           failure:^(NSError *error)
     {
         
     }];
    
}
-(void)addGiftMessage
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
            return ;
            
        });
    }
    
    
    [[ProductService sharedManager] addGiftMessage:addMessageTextView.text  success:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [myDelegate StopIndicator];
                            if (data != nil)
                            {
                                giftMessageBackgroundView.hidden = YES;
                                isEditGiftMsg=1;
                                giftMessageText=[addMessageTextView.text stringByTrimmingCharactersInSet:
                                                 [NSCharacterSet whitespaceCharacterSet]];
                                
                               
                                [self.myCartTableView reloadData];
                                
                            }
                            else
                            {
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

-(void)removeGiftMessage
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
            return ;
            
        });
    }
    
    
    [[ProductService sharedManager] removeGiftMessage:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [myDelegate StopIndicator];
                            if (data != nil)
                            {
                                giftMessageBackgroundView.hidden = YES;
                                isEditGiftMsg=0;
                                giftMessageText=@"";
                                
                                
                                [self.myCartTableView reloadData];
                                
                            }
                            else
                            {
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
-(void)getMyCartList
{
    myDict = [NSMutableDictionary new];
    myDict1 = [NSMutableDictionary new];
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
            return ;
            
        });
    }
    [[ProductService sharedManager] cartListing:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            
                            if(data==nil)
                            {
                                
                                [myDelegate StopIndicator];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                    [alert1 show];
                                });
                                
                            }
                            else
                            {
                                NSLog(@"cartListing success!!!!!!!!!!!!!!!!!!!!!!");
                                if ([[UserDefaultManager getValue:@"status"]intValue]==0)
                                {
                                    [myDelegate StopIndicator];
                                    [UserDefaultManager setValue:nil key:@"total_cart_item"];
                                    [UserDefaultManager setValue:nil key:@"cartData"];
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your bag is empty now, please add some items in your bag." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                        alert1.tag =5;
                                        [alert1 show];
                                    });
                                }
                                else
                                {
                                    NSMutableArray *tempArray=[UserDefaultManager getValue:@"cartData"];
                                    cartArray = [tempArray mutableCopy];
                                    NSMutableArray * tmpAry = [cartArray mutableCopy];
                                    for (int i =0; i<cartArray.count; i++)
                                    {
                                        NSMutableDictionary * cartDict = [cartArray objectAtIndex:i];
                                        if (![[cartDict objectForKey:@"parent_item_id"] isEqualToString:@"\n"])
                                        {
                                            [tmpAry removeObject:cartDict];
                                            isBuildGift = true;
                                        }
                                        float taxValue = [[cartDict objectForKey:@"tax_amount"] floatValue]/[[cartDict objectForKey:@"product_quantity"] floatValue];
                                        [myDict setObject:[NSString stringWithFormat:@"%f",taxValue] forKey:[cartDict objectForKey:@"product_id"]];
                                        [myDict1 setObject:[cartDict objectForKey:@"product_quantity"] forKey:[cartDict objectForKey:@"product_id"]];
                                        
                                    }
                                    NSLog(@"myDelegate.giftMessage is %@",myDelegate.giftMessage);
                                    giftMessageText = [NSString stringWithFormat:@"%@",myDelegate.giftMessage];
                                    giftMessageText = [giftMessageText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                    giftMessageText = [giftMessageText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                    if (giftMessageText.length>0)
                                    {
                                        isEditGiftMsg=1;
                                    }
                                    addMessageTextView.text = giftMessageText;
                                    [cartArray removeAllObjects];
                                    cartArray = [tmpAry mutableCopy];
                                    [UserDefaultManager setValue:cartArray key:@"cartData"];
                                    [UserDefaultManager setValue:[NSString stringWithFormat:@"%lu",(unsigned long)cartArray.count] key:@"total_cart_item"];
                                    [self setAllElementofArrayToZero];
                                    [self getMyWishlist];
                                }
                                
                            }
                        });
         
     }
       failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
    
}

-(void)getMyWishlist
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
        });
    }
    
    
    [[ProductService sharedManager] getWishlist:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(),^
                        {
                            [myDelegate StopIndicator];
                            
                            myDelegate.wishlistItems =(int)[[UserDefaultManager getValue:@"wishListData"] count];
                            [self updateBadge];
                            NSMutableArray * wishlistArray =[UserDefaultManager getValue:@"wishListData"];
                            for (int i =0; i<cartArray.count; i++)
                            {
                                NSMutableDictionary * cartDict = [cartArray objectAtIndex:i];
                                NSMutableDictionary *mutablecartDict = [cartDict mutableCopy];
                                for (int j =0; j<wishlistArray.count; j++)
                                {
                                    NSMutableDictionary * wishlistDict = [wishlistArray objectAtIndex:j];
                                    
                                    if ([[mutablecartDict objectForKey:@"product_id"]isEqualToString:[wishlistDict objectForKey:@"product_id"]])
                                    {
                                        [mutablecartDict setObject:@"Y" forKey:@"isWishlist"];
                                        [cartArray replaceObjectAtIndex:i withObject:mutablecartDict];
                                        break;
                                    }
                                    
                                }
                                
                            }
                            [myCartTableView reloadData];
                            
                            
                        });
         
     }
                                        failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
    
    
    
}
-(void)addToWishlistWebservice:(NSNumber *)tag
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
        
        [[ProductService sharedManager] addToWishlist:productId success:^(id data)
         {
             //Handle fault cases
             dispatch_async(dispatch_get_main_queue(), ^{
                 // code here
                 
                 if (data != nil)
                 {
                     NSMutableDictionary * cartDict = [cartArray objectAtIndex:[tag intValue]];
                     NSMutableDictionary *mutablecartDict = [cartDict mutableCopy];
                     [mutablecartDict setObject:@"Y" forKey:@"isWishlist"];
                     [cartArray replaceObjectAtIndex:[tag intValue] withObject:mutablecartDict];
                     [self removeFromCart];
                     [myCartTableView reloadData];
                 }
                 else
                 {
                     
                     //                     NSIndexPath *indexPath=[NSIndexPath indexPathForRow:buttonTag inSection:0];
                     //                     ProductListCollectionViewCell * cell = (ProductListCollectionViewCell *)[self.productListCollectionView cellForItemAtIndexPath:indexPath];
                     //                     [cell.addToWishlistButton setSelected:NO];
                     //                     [cell.addToWishlistLoader stopAnimating];
                     //                     cell.addToWishlistLoader.hidden = YES;
                     
                     
                     
                     
                     
                 }
                 
                 
                 
                 
             });
             
         }
                                              failure:^(NSError *error)
         {
             //Handle if response is nil
             
         }];
    }
    
}

-(void)updateBadge
{
    if (myDelegate.wishlistItems<1)
    {
        [[self.tabBarController.tabBar.items objectAtIndex:2] setCustomBadgeValue:nil withFont:nil andFontColor:[UIColor whiteColor] andBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        [[self.tabBarController.tabBar.items objectAtIndex:2] setCustomBadgeValue:[NSString stringWithFormat:@"%lu",(unsigned long)myDelegate.wishlistItems] withFont:[UIFont systemFontOfSize:8 weight:UIFontWeightRegular] andFontColor:[UIColor whiteColor] andBackgroundColor:[UIColor colorWithRed:60.0/255.0 green:171.0/225.0 blue:233.0/255.0 alpha:1.0]];
    }
    
}

-(void)updateCartService
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
            return ;
            
        });
    }
    
    
    [[ProductService sharedManager] shoppingCartProductUpdateRequestParam:[UserDefaultManager getValue:@"quoteId"] productData:cartArray success:^(id data)
     {
         
         
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            
                            if (data != nil)
                            {
                                if ([[UserDefaultManager getValue:@"status"]intValue]==1)
                                {
                                    
                                    
                                    
                                    CheckoutReviewViewController * objChkout = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CheckoutReviewViewController"];
                                    objChkout.cartArray = cartArray;
                                    objChkout.totalPrice=totalAmount;
                                    [self.navigationController pushViewController:objChkout animated:YES];
                                }
                                
                            }
                            else{
                                [myDelegate StopIndicator];
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
#pragma mark - end
#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (section == 0)
    {
        return cartArray.count;
    }
    else if (section == 1)
    {
        return 1;
    }
    else if (section == 2)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if (indexPath.section==0)
    {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        // Prevent the cell from inheriting the Table View's margin settings
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        
        // Explictly set your cell's layout margins
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 70;
        
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        return 64;
        
    }
    else if (indexPath.section == 2)
    {
        //return 25*(cartArray.count+1);
        return 0;
    }
    else{
        return 60;
    }
}
- (void)setAllElementofArrayToZero
{
    array = [NSMutableArray new];
    double  newTotal = 0.00;
    for(int i = 0;i < cartArray.count ;i++)
    {
        NSMutableDictionary * tempDict =[cartArray objectAtIndex:i];
        [array addObject:[tempDict objectForKey:@"product_quantity"]];
        
        newTotal =([[tempDict objectForKey:@"product_quantity"] doubleValue]*[[tempDict objectForKey:@"price"] intValue])+newTotal;
        
        
    }
    [UserDefaultManager setValue:[NSString stringWithFormat:@"%.2f",newTotal] key:@"cart_total"];
    NSLog(@"newTotal is %f",newTotal);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==3 && indexPath.row == 0)
        
    {
        CartTableViewCell *cell ;
        NSString *simpleTableIdentifier = @"totalAmountCell";
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            cell = [[CartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        [cell layoutView4:self.view.frame];
        //[tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
        
        
        float finalTaxValue = 0.0;
        for (int i = 0; i < cartArray.count; i++)
        {
            finalTaxValue = finalTaxValue + [[myDict objectForKey:[[cartArray objectAtIndex:i] objectForKey:@"product_id"]] floatValue] * [[myDict1 objectForKey:[[cartArray objectAtIndex:i] objectForKey:@"product_id"]] intValue];
            //                    [myDict objectForKey:[[cartArray objectAtIndex:i] objectForKey:@"product_id"]];
            //                    [myDict1 objectForKey:[[cartArray objectAtIndex:i] objectForKey:@"product_id"]];
        }
        
        float finalValue = finalTaxValue + [[UserDefaultManager getValue:@"cart_total"] floatValue];
        //multi color string for price label
        cell.cartBtn.badgeValue = [UserDefaultManager getValue:@"total_cart_item"];
        cell.cartBtn.badgeBGColor = [UIColor colorWithRed:237.0/255.0 green:0.0/255.0 blue:140.0/255.0 alpha:1.0];
        //        NSString * priceStr = [CurrencyConverter converCurrency:[UserDefaultManager getValue:@"cart_total"]];
        NSString * priceStr = [CurrencyConverter converCurrency:[NSString stringWithFormat:@"%.2f",finalValue]];
        
        
        
        NSRange currencyRange = [priceStr rangeOfString:@"Rs" options:NSCaseInsensitiveSearch];
        //NSRange priceRange = [priceStr rangeOfString:[dataDict objectForKey:@"price"] options:NSCaseInsensitiveSearch];
        NSLog(@"priceStr.length is %lu",(unsigned long)priceStr.length);
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:priceStr];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0] range:currencyRange];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 weight:UIFontWeightMedium] range:currencyRange];
        cell.amountLabel.attributedText =string;
        totalAmount=[NSString stringWithFormat:@"%f",finalValue];
        return cell;
    }
    else if (indexPath.section==2)
    {
        
        CartTableViewCell *cell1 ;
        NSString *simpleTableIdentifier = @"paymentCell";
        cell1 = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell1 == nil)
        {
            cell1 = [[CartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        //[tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [cell1 layoutView3:self.view.frame count:(int)cartArray.count];
        //        cell1.productName.text = [dataDict objectForKey:@"product_name"];
        //        cell1.productPriceLabel.text =[dataDict objectForKey:@"price"];
        //        cell1.quantitylabel.text = [NSString stringWithFormat:@"%i",[[array objectAtIndex:indexPath.row] intValue]];
        
        cell1.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
        for (UIView *subView in cell1.contentView.subviews)
        {
            if (subView != cell1.paymentContainerView) {
                [subView removeFromSuperview];
            }
            
        }
        
        //NSLog([NSString stringWithFormat:@"%d labels", nLabels]);
        float y = 7.0;
        for (int i = 0; i < cartArray.count+1; i++)
        {
            //NSLog([NSString stringWithFormat:@"%d", i]);
            NSMutableDictionary * dataDict;
            UILabel *productNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 200, 20)];
            UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(cell1.frame.size.width-62, y, 57,20)];//replace 40 with desired label width
            productNameLbl.textColor = [UIColor colorWithRed:107.0/255.0 green:107.0/255.0 blue:107.0/255.0 alpha:1.0];
            priceLbl.textColor = [UIColor colorWithRed:107.0/255.0 green:107.0/255.0 blue:107.0/255.0 alpha:1.0];
            productNameLbl.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
            priceLbl.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
            
            if (i!=cartArray.count)
            {
                dataDict= [cartArray objectAtIndex:i];
                
                
                //                if ([dataDict objectForKey:@"parent_item_id"] == nil)
                //                {
                //calculate dynamic width of product label
                float widthIs =
                [[dataDict objectForKey:@"product_name"]
                 boundingRectWithSize:productNameLbl.frame.size
                 options:NSStringDrawingUsesLineFragmentOrigin
                 attributes:@{ NSFontAttributeName:productNameLbl.font }
                 context:nil]
                .size.width;
                NSLog(@"the width of yourLabel is %f", widthIs);
                CGRect rect = productNameLbl.frame;
                rect.size.width = widthIs;
                productNameLbl.frame = rect;
                productNameLbl.text =[dataDict objectForKey:@"product_name"];
                //end
                
                //multi color string for price label
                int qty=[[dataDict objectForKey:@"product_quantity"] intValue];
                int testPrice=[[dataDict objectForKey:@"price"]intValue];
                
                int totalTestPrice=qty*testPrice;
                
                NSString *finalTestPrice=[NSString stringWithFormat:@"%d",totalTestPrice];
                NSString * priceStr = [CurrencyConverter converCurrency:finalTestPrice];
                
                //                NSString * priceStr = [CurrencyConverter converCurrency:[dataDict objectForKey:@"price"]];
                NSMutableDictionary * currencyDict = [UserDefaultManager getValue:@"selectedCurrency"];
                NSRange currencyRange;
                if (currencyDict!=nil)
                {
                    currencyRange= [priceStr rangeOfString:[currencyDict objectForKey:@"symbol"] options:NSCaseInsensitiveSearch];
                }
                else
                {
                    currencyRange= [priceStr rangeOfString:@"Rs" options:NSCaseInsensitiveSearch];
                }
                
                //NSRange priceRange = [priceStr rangeOfString:[dataDict objectForKey:@"price"] options:NSCaseInsensitiveSearch];
                NSLog(@"priceStr.length is %lu",(unsigned long)priceStr.length);
                NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:priceStr];
                [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0] range:currencyRange];
                [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10 weight:UIFontWeightMedium] range:currencyRange];
                priceLbl.attributedText =string;
                //                }
                
            }
            
            else if (cartArray.count>0)
            {
                NSMutableArray *arrayTax = [[NSMutableArray alloc]init ];
                for (int i=0; i<cartArray.count; i++) {
                    
                    NSMutableDictionary *tempDict= [cartArray objectAtIndex:i];
                    NSLog(@"temp dict %@",tempDict);
                    
                    float widthIs =
                    [@"Tax"
                     boundingRectWithSize:productNameLbl.frame.size
                     options:NSStringDrawingUsesLineFragmentOrigin
                     attributes:@{ NSFontAttributeName:productNameLbl.font }
                     context:nil]
                    .size.width;
                    NSLog(@"the width of yourLabel is %f", widthIs);
                    CGRect rect = productNameLbl.frame;
                    rect.size.width = widthIs;
                    productNameLbl.frame = rect;
                    productNameLbl.text =@"Tax";
                    //end
                    //
                    //                    float taxTotal=[[tempDict objectForKey:@"tax_amount"]intValue];
                    //                    int qtyForTax=[[tempDict objectForKey:@"product_quantity"] intValue];
                    //
                    //
                    //
                    //                    globalTax=taxTotal/qtyForTax;
                    //
                    //                    [globalTaxArray addObject:[NSString stringWithFormat:@"%d",globalTax]];
                    //
                    //
                    ////                     tax=globalTax*qtyForTax;
                    //
                    //
                    //                    [arrayTax addObject:[NSString stringWithFormat:@"%d",taxTotal]];
                    //
                    //                    NSLog(@"array Tax %@",arrayTax);
                    
                }
                //                NSInteger finalTax = 0;
                //                for (NSNumber *num in arrayTax)
                //                {
                //                    finalTax += [num intValue];
                //                }
                //                //multi color string for price label
                //
                //
                //                NSArray *tempArr = [myDict allKeys];
                
                
                
                float finalTaxValue = 0.0;
                for (int i = 0; i < cartArray.count; i++) {
                    finalTaxValue = finalTaxValue + [[myDict objectForKey:[[cartArray objectAtIndex:i] objectForKey:@"product_id"]] floatValue] * [[myDict1 objectForKey:[[cartArray objectAtIndex:i] objectForKey:@"product_id"]] intValue];
                    //                    [myDict objectForKey:[[cartArray objectAtIndex:i] objectForKey:@"product_id"]];
                    //                    [myDict1 objectForKey:[[cartArray objectAtIndex:i] objectForKey:@"product_id"]];
                }
                
                [UserDefaultManager setValue:[NSString stringWithFormat:@"%f",finalTaxValue] key:@"total_tax_amount"];
                
                NSString * priceStr = [CurrencyConverter converCurrency:[NSString stringWithFormat:@"%f",finalTaxValue]];
                
                //                NSString * priceStr = [CurrencyConverter converCurrency:[UserDefaultManager getValue:@"total_tax_amount"]];
                NSRange currencyRange = [priceStr rangeOfString:@"Rs" options:NSCaseInsensitiveSearch];
                //NSRange priceRange = [priceStr rangeOfString:[dataDict objectForKey:@"price"] options:NSCaseInsensitiveSearch];
                NSLog(@"priceStr.length is %lu",(unsigned long)priceStr.length);
                
                NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:priceStr];
                [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0] range:currencyRange];
                [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10 weight:UIFontWeightMedium] range:currencyRange];
                priceLbl.attributedText =string;
                
                
                
            }
            //end
            
            //dot label initialization
            UILabel *dotLbl = [[UILabel alloc] initWithFrame:CGRectMake(productNameLbl.frame.origin.x+productNameLbl.frame.size.width+1, y+3, cell1.frame.size.width-productNameLbl.frame.size.width-priceLbl.frame.size.width-15, 10)];
            dotLbl.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
            dotLbl.backgroundColor = [UIColor clearColor];
            dotLbl.textColor = [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1.0];
            dotLbl.text = @".....................................................................................................";
            //end
            y =productNameLbl.frame.origin.y+productNameLbl.frame.size.height+2;
            [cell1.contentView addSubview:dotLbl];
            [cell1.contentView addSubview:productNameLbl];
            [cell1.contentView addSubview:priceLbl];
        }
        
        
        return cell1;
        
    }
    else if (indexPath.section==1 && indexPath.row == 0)
    {
        
        CartTableViewCell *cell2 ;
        NSString *simpleTableIdentifier = @"giftCell";
        cell2 = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell2 == nil)
        {
            cell2 = [[CartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        //[tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [cell2 layoutView2:self.view.frame];
         cell2.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
        if (isEditGiftMsg==0)
        {
            cell2.addGiftMessageButton.hidden=NO;
            cell2.editGiftMessageButton.hidden=YES;
            cell2.cellBg.hidden = YES;
            cell2.editIcon.hidden = YES;
            cell2.cancelEditMessageBtn.hidden = YES;

        }
        else
        {
            cell2.addGiftMessageButton.hidden=YES;
            cell2.editGiftMessageButton.hidden=NO;
            cell2.cellBg.hidden = NO;
            cell2.editIcon.hidden = NO;
            cell2.cancelEditMessageBtn.hidden = NO;

        }
        cell2.editGiftMessageButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell2.editGiftMessageButton.titleLabel setNumberOfLines:4];
        [cell2.editGiftMessageButton.titleLabel setLineBreakMode: UILineBreakModeTailTruncation];
        if (![giftMessageText isEqualToString:@""])
        {
            //            cell2.editGiftMessageButton.lineBreakMode = NSLineBreakByWordWrapping;
            //            cell2.editGiftMessageButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            //            [cell2.editGiftMessageButton setTitle: giftMessageText forState: UIControlStateNormal];
            
            
            [cell2.editGiftMessageButton setTitle:giftMessageText forState:UIControlStateNormal];
        }
        
        
        [cell2.addGiftMessageButton addTarget:self action:@selector(addMessage:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.editGiftMessageButton addTarget:self action:@selector(addMessage:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.cancelEditMessageBtn addTarget:self action:@selector(RemoveMessage:) forControlEvents:UIControlEventTouchUpInside];

        
        return cell2;
        
    }
    
    else
    {
        CartTableViewCell *cell3 ;
        NSString *simpleTableIdentifier = @"productCell";
        cell3 = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        NSMutableDictionary * dataDict = [cartArray objectAtIndex:indexPath.row];
        if (cell3 == nil)
        {
            cell3 = [[CartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        [cell3 setRightUtilityButtons:[self rightButtons:(int)indexPath.row] WithButtonWidth:58.0f];
        cell3.delegate = self;
        [cell3 layoutView1:self.view.frame];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [tableView setSeparatorInset:UIEdgeInsetsZero];
        //UILabel *displayCount = (UILabel *)[cell3 viewWithTag:1];
        cell3.decButton.tag = indexPath.row;
        cell3.incButton.tag = indexPath.row;
        cell3.closeButton.tag = indexPath.row;
        //        cell3.closeButton.hidden = YES;
        
        [cell3.decButton addTarget:self action:@selector(decreaseItemCount:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.incButton addTarget:self action:@selector(increaseItemCount:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.closeButton addTarget:self action:@selector(removeFromCart:) forControlEvents:UIControlEventTouchUpInside];
       
        NSString * productNameStr = [dataDict objectForKey:@"product_name"];
        
        productNameStr = [productNameStr lowercaseString];
        productNameStr = [productNameStr stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[productNameStr substringToIndex:1] uppercaseString]];
        cell3.productName.text = [NSString stringWithFormat:@"%@",productNameStr];
        if ([dataDict objectForKey:@"value"]!=nil)
        {
            //NSLog(@"entered in setting text in personalized label!!!!!!!");
            cell3.personalizeLbl.hidden=NO;
            
            UIFont *font1 = [UIFont systemFontOfSize:10 weight:UIFontWeightBold];
            NSDictionary *arialDict = [NSDictionary dictionaryWithObject: font1 forKey:NSFontAttributeName];
            NSMutableAttributedString *aAttrString1 = [[NSMutableAttributedString alloc] initWithString:@"TEXT " attributes: arialDict];
            
            UIFont *font2 = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
            NSDictionary *arialDict2 = [NSDictionary dictionaryWithObject: font2 forKey:NSFontAttributeName];
            NSMutableAttributedString *aAttrString2 = [[NSMutableAttributedString alloc] initWithString:[dataDict objectForKey:@"value"] attributes: arialDict2];
            
            
            [aAttrString1 appendAttributedString:aAttrString2];
            cell3.personalizeLbl.attributedText = aAttrString1;
            
            
            //cell3.personalizeLbl.text = [NSString stringWithFormat:@"TEXT : %@",[dataDict objectForKey:@"value"]];

        }
        else
        {
            cell3.personalizeLbl.hidden = YES;
        }
        
        NSString * priceStr = [CurrencyConverter converCurrency:[dataDict objectForKey:@"price"]];
        cell3.priceLabel.text =priceStr;
        
        
        cell3.quantitylabel.text = [NSString stringWithFormat:@"%i",[[array objectAtIndex:indexPath.row] intValue]];
        [cell3.productImage sd_setImageWithURL:[NSURL URLWithString:[dataDict objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        return cell3;
    }
    
    
}
- (NSArray *)rightButtons : (int)index
{
    
    NSLog(@"index is %d",index);
    
    NSMutableDictionary * tempDict = [cartArray objectAtIndex:index];
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    if ([[tempDict objectForKey:@"product_type"] isEqualToString:@"simple"])
    {
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]icon:[UIImage imageNamed:@"SAVE2"]];
        
    }
    
    
    
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:60.0/255.0 green:171.0/255.0 blue:233.0/255.0 alpha:1.0]   icon:[UIImage imageNamed:@"deleteSwipe"]];
    
    return rightUtilityButtons;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        
        NSMutableDictionary * dataDict = [cartArray objectAtIndex:indexPath.row];
        
        if ([[dataDict objectForKey:@"product_type"] isEqualToString:@"bundle"])
        {
            return;
        }
        
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProductDetailViewController *objProductDetail =[storyboard instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
        objProductDetail.productId = [dataDict objectForKey:@"product_id"];
        objProductDetail.productName = [dataDict objectForKey:@"product_name"];
        objProductDetail.isInStock = [dataDict objectForKey:@"inStock"];
        if([[dataDict objectForKey:@"isWishlist"] isEqualToString:@"Y"])
        {
            objProductDetail.isAddedtoWishlist=true;
        }
        else
        {
            objProductDetail.isAddedtoWishlist=false;
            
        }
        
        objProductDetail.stockQuantity = [[dataDict objectForKey:@"product_quantity"] intValue];
        NSLog(@"bool is %d",objProductDetail.isAddedtoWishlist);
        [self.navigationController pushViewController:objProductDetail animated:YES];
    }
    else if (indexPath.section==1)
    {
        [self addMessage:nil];
    }
}

-(void)addMessage:(UIButton *)sender
{
    giftMessageBackgroundView.hidden = NO;
    addMessageTextView.text=giftMessageText;
    
}
-(void)RemoveMessage:(UIButton *)sender
{
//    giftMessageBackgroundView.hidden = NO;
//    addMessageTextView.text=giftMessageText;
    
    [myDelegate ShowIndicator];
    [self performSelector:@selector(removeGiftMessage) withObject:nil afterDelay:.5];

}

-(void)increaseItemCount:(UIButton *)sender
{
    //    long tag = [sender tag];
    //
    //    NSMutableDictionary * productDict = [cartArray objectAtIndex:[sender tag]];
    //    double  newTotal =[[productDict objectForKey:@"price"] doubleValue]+[[UserDefaultManager getValue:@"cart_total"] doubleValue];
    //    [UserDefaultManager setValue:[NSString stringWithFormat:@"%.2f",newTotal] key:@"cart_total"];
    //
    //    [array replaceObjectAtIndex:tag withObject:[NSNumber numberWithInteger:[[array objectAtIndex:tag] intValue]+1 ]];
    //    NSMutableDictionary * tempDict = [productDict mutableCopy];
    //    [tempDict setObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[array objectAtIndex:tag] intValue]+1]] forKey:@"product_quantity"];
    //
    //    [cartArray replaceObjectAtIndex:[sender tag] withObject:productDict];
    //    [myCartTableView reloadData];
    
    long tag = [sender tag];
    
    NSMutableDictionary * productDict = [cartArray objectAtIndex:[sender tag]];
    double  newTotal =[[productDict objectForKey:@"price"] doubleValue]+[[UserDefaultManager getValue:@"cart_total"] doubleValue];
    [UserDefaultManager setValue:[NSString stringWithFormat:@"%.2f",newTotal] key:@"cart_total"];
    NSLog(@"%@",[UserDefaultManager getValue:@"cart_total"]);
    [array replaceObjectAtIndex:tag withObject:[NSNumber numberWithInteger:[[array objectAtIndex:tag] intValue]+1 ]];
    NSMutableDictionary * tempDict = [productDict mutableCopy];
    
    //    float taxValue = [[cartDict objectForKey:@"tax_amount"] floatValue]/[[cartDict objectForKey:@"product_quantity"] floatValue];
    //    [myDict setObject:[NSString stringWithFormat:@"%f",taxValue] forKey:[cartDict objectForKey:@"product_id"]];
    //    [myDict1 setObject:[cartDict objectForKey:@"product_quantity"] forKey:[cartDict objectForKey:@"product_id"]];
    
    
    
    
    
    int quty = [[myDict1 objectForKey:[productDict objectForKey:@"product_id"]] intValue];
    [myDict1 setObject:[NSString stringWithFormat:@"%d",quty+1] forKey:[productDict objectForKey:@"product_id"]];
    
    
    
    
    [tempDict setObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[array objectAtIndex:tag] intValue]]] forKey:@"product_quantity"];
    //    [tempDict setObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[array objectAtIndex:tag] intValue]+1]] forKey:@"product_quantity"];
    
    int qty= [[tempDict objectForKey:@"product_quantity"] intValue];
    
    int value=globalTax * qty;
    
    
    [tempDict setObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:value]] forKey:@"tax_amount"];
    
    [cartArray replaceObjectAtIndex:[sender tag] withObject:tempDict];
    
    
    //    [cartArray replaceObjectAtIndex:[sender tag] withObject:productDict];
    [myCartTableView reloadData];
    
    
    
    //        long tag = [sender tag];
    //
    //        NSMutableDictionary * productDict = [cartArray objectAtIndex:[sender tag]];
    //        double  newTotal =[[productDict objectForKey:@"price"] doubleValue]+[[UserDefaultManager getValue:@"cart_total"] doubleValue];
    //        [UserDefaultManager setValue:[NSString stringWithFormat:@"%.2f",newTotal] key:@"cart_total"];
    //
    //        [array replaceObjectAtIndex:tag withObject:[NSNumber numberWithInteger:[[array objectAtIndex:tag] intValue]+1 ]];
    //        NSMutableDictionary * tempDict = [productDict mutableCopy];
    //        [tempDict setObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[array objectAtIndex:tag] intValue]+1]] forKey:@"product_quantity"];
    //
    //        [cartArray replaceObjectAtIndex:[sender tag] withObject:productDict];
    //        [myCartTableView reloadData];
    
    
    
}

-(void)decreaseItemCount:(UIButton *)sender
{
    //    long tag = [sender tag];
    //    NSMutableDictionary * productDict = [cartArray objectAtIndex:[sender tag]];
    //    double  newTotal =[[UserDefaultManager getValue:@"cart_total"] doubleValue]-[[productDict objectForKey:@"price"] doubleValue];
    //    [UserDefaultManager setValue:[NSString stringWithFormat:@"%.2f",newTotal] key:@"cart_total"];
    //    if ([[array objectAtIndex:tag] intValue]==1)
    //    {
    //        return;
    //    }
    //    [array replaceObjectAtIndex:tag withObject:[NSNumber numberWithInteger:[[array objectAtIndex:tag] intValue]-1]];
    //    NSMutableDictionary * tempDict = [productDict mutableCopy];
    //    [tempDict setObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[array objectAtIndex:tag] intValue]+1]] forKey:@"product_quantity"];
    //    [cartArray replaceObjectAtIndex:[sender tag] withObject:productDict];
    //    [myCartTableView reloadData];
    
    
    long tag = [sender tag];
    buttonTag = (int)tag;
    if ([[array objectAtIndex:tag] intValue]==1)
    {
        [self removeFromCart:nil];
        return;
        
    }
    
    NSMutableDictionary * productDict = [cartArray objectAtIndex:[sender tag]];
    double  newTotal =[[UserDefaultManager getValue:@"cart_total"] doubleValue]-[[productDict objectForKey:@"price"] doubleValue];
    [UserDefaultManager setValue:[NSString stringWithFormat:@"%.2f",newTotal] key:@"cart_total"];
    [array replaceObjectAtIndex:tag withObject:[NSNumber numberWithInteger:[[array objectAtIndex:tag] intValue]-1]];
    NSMutableDictionary * tempDict = [productDict mutableCopy];
    //    [tempDict setObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[array objectAtIndex:tag] intValue]+1]] forKey:@"product_quantity"];
    [tempDict setObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[array objectAtIndex:tag] intValue]]] forKey:@"product_quantity"];
    
    
    
    
    int quty = [[myDict1 objectForKey:[productDict objectForKey:@"product_id"]] intValue];
    [myDict1 setObject:[NSString stringWithFormat:@"%d",quty-1] forKey:[productDict objectForKey:@"product_id"]];
    
    
    
    
    
    [cartArray replaceObjectAtIndex:[sender tag] withObject:tempDict];
    
    //    [cartArray replaceObjectAtIndex:[sender tag] withObject:productDict];
    [myCartTableView reloadData];
    
    
    //        long tag = [sender tag];
    //        NSMutableDictionary * productDict = [cartArray objectAtIndex:[sender tag]];
    //        double  newTotal =[[UserDefaultManager getValue:@"cart_total"] doubleValue]-[[productDict objectForKey:@"price"] doubleValue];
    //        [UserDefaultManager setValue:[NSString stringWithFormat:@"%.2f",newTotal] key:@"cart_total"];
    //        if ([[array objectAtIndex:tag] intValue]==1)
    //        {
    //            return;
    //        }
    //        [array replaceObjectAtIndex:tag withObject:[NSNumber numberWithInteger:[[array objectAtIndex:tag] intValue]-1]];
    //        NSMutableDictionary * tempDict = [productDict mutableCopy];
    //        [tempDict setObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[array objectAtIndex:tag] intValue]+1]] forKey:@"product_quantity"];
    //        [cartArray replaceObjectAtIndex:[sender tag] withObject:productDict];
    //        [myCartTableView reloadData];
    
    
    
}


#pragma mark - end



#pragma mark - Button actions

- (IBAction)saveMessageBtnAction:(id)sender
{
    addMessageTextView.text = [addMessageTextView.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    
    addMessageTextView.text = [addMessageTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if ([addMessageTextView.text isEqualToString:@""])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please add gift message" parentView:self.view];
          //  [self.view makeToast:@"Please add gift message" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
            
            //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please add gift message." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //            [alert show];
        });
        return;
    }
    [myDelegate ShowIndicator];
    [self performSelector:@selector(addGiftMessage) withObject:nil afterDelay:.5];
    
}

- (IBAction)proceedToCheckoutBtnAction:(id)sender
{
    [myDelegate ShowIndicator];
//    if (isBuildGift)
//    {
//        CheckoutReviewViewController * objChkout = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CheckoutReviewViewController"];
//        objChkout.cartArray = cartArray;
//        objChkout.totalPrice=totalAmount;
//        [self.navigationController pushViewController:objChkout animated:YES];
//    }
//    else
//    {
    
        [self performSelector:@selector(updateCartService) withObject:nil afterDelay:.2];
//    }
    
}

- (IBAction)shopSomeMoreBtnAction:(id)sender
{
    if (self.tabBarController.selectedIndex==0)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.tabBarController setSelectedIndex:0];
    }
}
- (IBAction)deliverBtnAction:(id)sender
{
    
}

- (IBAction)reviewBtnAction:(id)sender
{
    
}

- (IBAction)payBtnAction:(id)sender
{
    
}
-(IBAction)removeFromCart:(id)sender
{
    NSMutableDictionary * dataDict;
    if (buttonTag==0)
    {
        dataDict = [cartArray objectAtIndex:[sender tag]];
    }
    else
    {
        dataDict = [cartArray objectAtIndex:buttonTag];
    }
    productId = [dataDict objectForKey:@"product_id"];
    itemId = [dataDict objectForKey:@"item_id"];
    [myDelegate ShowIndicator];
    [self performSelector:@selector(removeFromCart) withObject:nil afterDelay:.2];
    
}
- (IBAction)closeButtonClickAction:(id)sender {
    giftMessageBackgroundView.hidden = YES;
}
#pragma mark - end
#pragma mark - Keyboard controls delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    UIView *view;
    
    if ([[UIDevice currentDevice].systemVersion floatValue]< 7.0)
    {
        view = field.superview.superview;
    }
    else
    {
        view = field.superview.superview.superview;
    }
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControl
{
    [addMessageTextView resignFirstResponder];
    [keyboardControl.activeField resignFirstResponder];
    
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.keyboardControls setActiveField:textView];
    return YES;
}
#pragma mark - Alert view
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==5)
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (textView.text.length >=175 && range.length == 0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
#pragma mark - end


#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            NSLog(@"left button 0 was pressed");
            break;
        case 1:
            NSLog(@"left button 1 was pressed");
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            
            NSLog(@"More button was pressed");
            NSIndexPath *cellIndexPath = [myCartTableView indexPathForCell:cell];
            NSMutableDictionary * dataDict = [cartArray objectAtIndex:cellIndexPath.row];
            
            if ([[[dataDict objectForKey:@"product_name"] lowercaseString] isEqualToString:[@"BUILD A GIFT" lowercaseString]])
            {
                if (![[dataDict objectForKey:@"parent_item_id"] isEqualToString:@"\n"])
                {
                    
                    myDelegate.isBuildGift = true;
                }
                else
                {
                    myDelegate.isBuildGift =false;
                }
                
                NSMutableDictionary * dataDict = [cartArray objectAtIndex:cellIndexPath.row];
                productId = [dataDict objectForKey:@"product_id"];
                itemId = [dataDict objectForKey:@"item_id"];
                [myDelegate ShowIndicator];
                [self performSelector:@selector(removeFromCart) withObject:nil afterDelay:.2];
            }
            
            
            else if ([[dataDict objectForKey:@"isWishlist"] isEqualToString:@"N"])
            {
                productId = [dataDict objectForKey:@"product_id"];
                itemId = [dataDict objectForKey:@"item_id"];
                [myDelegate ShowIndicator];
                myDelegate.wishlistItems++;
                [self updateBadge];
                [self performSelector:@selector(addToWishlistWebservice:) withObject:[NSNumber numberWithInt:cellIndexPath.row] afterDelay:.2];
            }
            else
            {
                [MozTopAlertView showWithType:MozAlertTypeInfo text:@"This product is already added in wishlist" parentView:self.view];
               // [self.view makeToast:@"This product is already added in wishlist." image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
              //[cell hideUtilityButtonsAnimated:YES];
            }
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            
            
            
            
            NSLog(@"done pressed!!");
            NSIndexPath *cellIndexPath = [myCartTableView indexPathForCell:cell];
            
            NSMutableDictionary * cartDict = [cartArray objectAtIndex:cellIndexPath.row];
            if (![[cartDict objectForKey:@"parent_item_id"] isEqualToString:@"\n"])
            {
                
                myDelegate.isBuildGift = true;
            }
            else
            {
                myDelegate.isBuildGift =false;
            }
            
            NSMutableDictionary * dataDict = [cartArray objectAtIndex:cellIndexPath.row];
            productId = [dataDict objectForKey:@"product_id"];
            itemId = [dataDict objectForKey:@"item_id"];
            [myDelegate ShowIndicator];
            [self performSelector:@selector(removeFromCart) withObject:nil afterDelay:.2];
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        default:
            break;
    }
}
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}


@end
