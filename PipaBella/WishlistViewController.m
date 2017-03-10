//
//  WishlistViewController.m
//  PipaBella
//
//  Created by Ranosys on 03/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "WishlistViewController.h"
#import "WishlistCollectionViewCell.h"
#import "ProductService.h"
#import "CartViewController.h"
#import "CurrencyConverter.h"
#import "WishlistCell.h"
#import "ProductDetailViewController.h"
#define kCellsPerRow 2

@interface WishlistViewController ()<SWTableViewCellDelegate,UIGestureRecognizerDelegate>{
    UIBarButtonItem *barButton;
    __weak IBOutlet UILabel *noRecordLbl;
    
      UIView *mainView;
    __weak IBOutlet UITableView *wishlistTable;
    NSString * productId;
}
@property (weak, nonatomic) IBOutlet UICollectionView *wishlistCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *noProductsLbl;
@property(nonatomic,retain)NSMutableArray * wishListArray;
@property (weak, nonatomic) IBOutlet UIButton *cartIcon;
@end

@implementation WishlistViewController
@synthesize wishlistCollectionView,cartIcon;
@synthesize wishListArray;
@synthesize noProductsLbl;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"MY WISHLIST";
    
    [self setViewFrame];
    
    [wishlistTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    wishlistTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    wishlistTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    mainView.hidden = YES;
    wishListArray = [[NSMutableArray alloc]init];
    //setting collection view cell size according to iPhone screens
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.wishlistCollectionView.collectionViewLayout;
    CGFloat availableWidthForCells = CGRectGetWidth(self.view.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow -1);
    CGFloat cellWidth = (availableWidthForCells / kCellsPerRow);
    flowLayout.itemSize = CGSizeMake(cellWidth, flowLayout.itemSize.height);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [UIView animateWithDuration:0.6f animations:^{
        
        mainView.hidden = YES;
        
    }];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Localytics tagScreen:@"Wishlist View"];
    myDelegate.tabId = (int)self.tabBarController.selectedIndex;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    noRecordLbl.hidden = YES;
//    [wishListArray removeAllObjects];
//    [wishlistCollectionView reloadData];
    
    if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL)) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"You need to login first." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            alert.tag=1;
//            [alert show];
//        });
        
        myDelegate.istoast = true;
        if([[UIScreen mainScreen] bounds].size.height>480)
        {
            myDelegate.toastMessage = @"SIGN IN to add products to your wishlist";
        }else{
            myDelegate.toastMessage = @"SIGN IN to add products to your wishlist";
        }

       // myDelegate.toastMessage = @"SIGN IN to add products to your wishlist            X";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
        myDelegate.window.rootViewController = myDelegate.navigationController;
    }
    else
    {
        [myDelegate ShowIndicator];
        [self performSelector:@selector(getMyWishlist) withObject:nil afterDelay:.1];
    }    
    
    
    if ([[UserDefaultManager getValue:@"cartData"] count]>0)
    {
        NSMutableArray *tmpArray =[UserDefaultManager getValue:@"cartData"];
        NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)[tmpArray count]];
        cartIcon.badgeValue = count;
        cartIcon.badgeBGColor = [UIColor colorWithRed:237.0/255.0 green:0.0/255.0 blue:140.0/255.0 alpha:1.0];
        
        
    }
    else
    {
        cartIcon.badgeBGColor = [UIColor clearColor];
    }

}

#pragma mark - end
- (void)addLeftBarButtonWithImage:(UIImage *)backButton{
    
    if (self.tabBarController.selectedIndex == 4) {
        CGRect framing = CGRectMake(0, 0, backButton.size.width, backButton.size.height);
        UIButton *button = [[UIButton alloc] initWithFrame:framing];
        [button setBackgroundImage:backButton forState:UIControlStateNormal];
        barButton =[[UIBarButtonItem alloc] initWithCustomView:button];
        [button addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItems=[NSArray arrayWithObjects:barButton, nil];

    }
    
    
}
//back button action
-(void)backButtonAction :(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - end

#pragma mark - Set frame
-(void)setViewFrame{
    mainView = [[UIView alloc] initWithFrame:
                CGRectMake(0,0,
                           [[UIScreen mainScreen] applicationFrame].size.width,
                           [[UIScreen mainScreen] applicationFrame].size.height)];
    mainView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.8];
    
    UITapGestureRecognizer *menuItemTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideCartPopup:)];
    menuItemTapGestureRecognizer.numberOfTapsRequired    = 1;
    menuItemTapGestureRecognizer.delegate                = self;
    [mainView addGestureRecognizer:menuItemTapGestureRecognizer];
    
    UIView *emptyBagView = [[UIView alloc] initWithFrame:
                            CGRectMake(120,20,mainView.frame.size.width-120,120)];
    emptyBagView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0, 0, emptyBagView.frame.size.width, 1.5);
    topBorder.backgroundColor = [UIColor colorWithRed:133.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1.0].CGColor;
    [emptyBagView.layer addSublayer:topBorder];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, emptyBagView.frame.size.height-1.5, emptyBagView.frame.size.width, 1.5);
    bottomBorder.backgroundColor = [UIColor colorWithRed:133.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1.0].CGColor;
    [emptyBagView.layer addSublayer:bottomBorder];
    
    CALayer *leftBorder = [CALayer layer];
    leftBorder.frame = CGRectMake(0, 0, 1.5, emptyBagView.frame.size.height);
    leftBorder.backgroundColor = [UIColor colorWithRed:133.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1.0].CGColor;
    [emptyBagView.layer addSublayer:leftBorder];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0,0,40,40)];
    [closeButton setTitle:@"X" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UILabel *shoppingLabel = [[UILabel alloc] initWithFrame:
                              CGRectMake(30,22,emptyBagView.frame.size.width-80,30)];
    shoppingLabel.text = @"MY SHOPPING BAG";
    shoppingLabel.backgroundColor = [UIColor clearColor];
    shoppingLabel.textColor = [UIColor colorWithRed:60.0/255.0 green:60.0/255.0 blue:60.0/255.0 alpha:1.0];
    if (self.view.frame.size.width<=320) {
        shoppingLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    }
    else
    {
        shoppingLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    }
    
    // shoppingLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    shoppingLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UIButton *emptyBagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [emptyBagButton setFrame:CGRectMake(shoppingLabel.frame.origin.x+shoppingLabel.frame.size.width+10,22,25,25)];
    [emptyBagButton setImage:[UIImage imageNamed:@"cart.png"] forState:UIControlStateNormal];
    
    
    UILabel *bagLabel = [[UILabel alloc] initWithFrame:
                         CGRectMake(25,54,emptyBagView.frame.size.width-60,20)];
    bagLabel.text = @"YOUR BAG IS EMPTY";
    bagLabel.backgroundColor = [UIColor clearColor];
    bagLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    bagLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UILabel *keepShoppingLabel = [[UILabel alloc] initWithFrame:
                                  CGRectMake(25,74,emptyBagView.frame.size.width-45,30)];
    keepShoppingLabel.text = @"Life's too short. Keep shopping";
    keepShoppingLabel.backgroundColor = [UIColor clearColor];
    keepShoppingLabel.textColor = [UIColor colorWithRed:138.0/255.0 green:138.0/255.0 blue:138.0/255.0 alpha:1.0];
    keepShoppingLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
    keepShoppingLabel.textAlignment = NSTextAlignmentCenter;
    
    [emptyBagView addSubview:emptyBagButton];
    [emptyBagView addSubview:closeButton];
    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [emptyBagView addSubview:keepShoppingLabel];
    [emptyBagView addSubview:shoppingLabel];
    [emptyBagView addSubview:bagLabel];
    [mainView addSubview:emptyBagView];
    [self.navigationController.view addSubview:mainView];
    
}

-(void)hideCartPopup:(UITapGestureRecognizer *)gestureRecognizer
{
    [self closeAction:nil];
}

-(void)closeAction :(id)sender
{
    [UIView animateWithDuration:0.6f animations:^{
        
        mainView.hidden = YES;
        
    }];
    
}
#pragma mark - end




#pragma mark - Webservice methods
-(void)removeFromWishlistWebservice:(NSString *)productId
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
        
        [[ProductService sharedManager] removeFromWishlist:productId success:^(id data)
         {
             //Handle fault cases
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 // code here
                 
                 if (data != nil)
                 {
                     [self getMyWishlist];
                     
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
    
}
-(void)getMyWishlist
{
    
    [[ProductService sharedManager] getWishlist:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(),^
                        {
                            [myDelegate StopIndicator];
                            if (data!=nil)
                            {
                                wishListArray = [UserDefaultManager getValue:@"wishListData"];
                                [wishlistCollectionView reloadData];
                                [wishlistTable reloadData];
                                if (wishListArray.count>0)
                                {
                                    wishlistTable.hidden = NO;
                                    noProductsLbl.hidden = YES;
                                    noRecordLbl.hidden = YES;
                                }
                                else
                                {
                                    wishlistTable.hidden =YES;
                                    noProductsLbl.hidden = NO;
                                    noRecordLbl.hidden = NO;
                                }
                                myDelegate.wishlistItems =(int)[[UserDefaultManager getValue:@"wishListData"] count];
                                [self updateBadge];
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
-(void)addToCartService : (NSString *)productId
{
    
    [[ProductService sharedManager] addToCart:productId qty:@"1" success:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            
                            if (data != nil)
                            {
                                NSString  *status =(NSString *)data;
                                
                                if ([status boolValue])
                                {
                                    [self getMyCartList:productId];
                                    
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

-(void)getMyCartList : (NSString *)productId
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
                            
                            if(data==nil)
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                    [alert1 show];
                                });
                                
                            }
                            else
                            {
                                
                                NSMutableArray *tempArray=[UserDefaultManager getValue:@"cartData"];
                                NSMutableArray * cartArray = [tempArray mutableCopy];
                                NSMutableArray * tmpAry = [cartArray mutableCopy];
                                for (int i =0; i<cartArray.count; i++)
                                {
                                    NSMutableDictionary * cartDict = [cartArray objectAtIndex:i];
                                    if (![[cartDict objectForKey:@"parent_item_id"] isEqualToString:@"\n"])
                                    {
                                        [tmpAry removeObject:cartDict];
                                        
                                    }
                                    
                                }
                                [cartArray removeAllObjects];
                                cartArray = [tmpAry mutableCopy];
                                [UserDefaultManager setValue:cartArray key:@"cartData"];
                                
                                
                                if ([[UserDefaultManager getValue:@"cartData"] count]>0)
                                {
                                    NSMutableArray *tmpArray =[UserDefaultManager getValue:@"cartData"];
                                    NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)[tmpArray count]];
                                    cartIcon.badgeValue = count;
                                    cartIcon.badgeBGColor = [UIColor colorWithRed:237.0/255.0 green:0.0/255.0 blue:140.0/255.0 alpha:1.0];
                                    
                                    
                                }
                                else
                                {
                                    cartIcon.badgeBGColor = [UIColor clearColor];
                                }
                                [self removeFromWishlistWebservice:productId];
                                
                            }
                        });
         
     }
                                        failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
    
}

#pragma mark - end


#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return wishListArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WishlistCollectionViewCell *myCell = [self.wishlistCollectionView
                                          dequeueReusableCellWithReuseIdentifier:@"Cell"
                                          forIndexPath:indexPath];
    [myCell layoutView:myCell.frame index:(int)indexPath.row];
    [myCell displayData:[wishListArray objectAtIndex:indexPath.row]];
    myCell.removeFromWishlistButton.tag = indexPath.row;
    myCell.moveToCartButton.tag = indexPath.row;
    [myCell.removeFromWishlistButton addTarget:self action:@selector(removeFromWishlist:) forControlEvents:UIControlEventTouchUpInside];
    [myCell.moveToCartButton addTarget:self action:@selector(moveTocart:) forControlEvents:UIControlEventTouchUpInside];
    
    return myCell;
}

#pragma mark - end


#pragma mark - Tableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return wishListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WishlistCell *cell ;
    NSString *simpleTableIdentifier = @"WishlistCell";
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[WishlistCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    [cell setRightUtilityButtons:[self rightButtons:(int)indexPath.row] WithButtonWidth:58.0f];
    cell.delegate = self;
    UIImageView * productImage = (UIImageView *)[cell.contentView viewWithTag:1];
    UILabel * upperSep = (UILabel *)[cell.contentView viewWithTag:9];
    
    if (indexPath.row==0) {
        upperSep.hidden = NO;
    }
    else
    {
        upperSep.hidden = YES;
    }
    
    UILabel * productName = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel * productPrice = (UILabel *)[cell.contentView viewWithTag:3];
    NSMutableDictionary * dataDict = [wishListArray objectAtIndex:indexPath.row];
    NSString * productNameStr = [dataDict objectForKey:@"name"];
    
    
    
    productNameStr = [productNameStr lowercaseString];
    productNameStr = [productNameStr stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[productNameStr substringToIndex:1] uppercaseString]];
    productName.text = productNameStr;
    
    productPrice.text =[CurrencyConverter converCurrency:[dataDict objectForKey:@"product_price"]];
    [productImage sd_setImageWithURL:[NSURL URLWithString:[dataDict objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;



}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSMutableDictionary * dataDict = [wishListArray objectAtIndex:indexPath.row];
    
    ProductDetailViewController * objProductDetail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
    objProductDetail.productId = [dataDict objectForKey:@"product_id"];
    objProductDetail.productName = [dataDict objectForKey:@"name"];
    objProductDetail.isInStock = [dataDict objectForKey:@"Isinstock"];
    objProductDetail.isAddedtoWishlist =true;
   
    NSLog(@"bool is %d",objProductDetail.isAddedtoWishlist);
    [self.navigationController pushViewController:objProductDetail animated:YES];
    

}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    
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
- (NSArray *)rightButtons : (int)index
{
    
    NSLog(@"index is %d",index);
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]icon:[UIImage imageNamed:@"Wishlistcart"]];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:60.0/255.0 green:171.0/255.0 blue:233.0/255.0 alpha:1.0]   icon:[UIImage imageNamed:@"wishlistDelete"]];
    
    return rightUtilityButtons;
}
#pragma mark - end


#pragma mark - IBActions
-(IBAction)removeFromWishlist:(id)sender
{
    NSMutableDictionary * tmpDict=[wishListArray objectAtIndex:[sender tag]];
    [myDelegate ShowIndicator];
    [self performSelector:@selector(removeFromWishlistWebservice:) withObject:[tmpDict objectForKey:@"product_id"] afterDelay:.1];
    
}
-(IBAction)moveTocart:(id)sender
{
    NSMutableDictionary * tmpDict=[wishListArray objectAtIndex:[sender tag]];
    if ([[tmpDict objectForKey:@"Isinstock"] boolValue])
    {
        if ([[[tmpDict objectForKey:@"name"] lowercaseString] isEqualToString:@"build a gift"])
        {
            myDelegate.isBuildGift = true;
        }
        else
        {
            myDelegate.isBuildGift = false;
        }
        [myDelegate ShowIndicator];
        [self performSelector:@selector(addToCartService:) withObject:[tmpDict objectForKey:@"product_id"] afterDelay:.1];
    }
    else
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"The requested quantity for %@ is not available.",[tmpDict objectForKey:@"name"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        });
        [MozTopAlertView showWithType:MozAlertTypeInfo text:[NSString stringWithFormat:@"The requested quantity for %@ is not available.",[tmpDict objectForKey:@"name"]] parentView:self.view];
       // [self.view makeToast:[NSString stringWithFormat:@"The requested quantity for %@ is not available.",[tmpDict objectForKey:@"name"]] image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        
    }
    
    
}
- (IBAction)cartIconClickedAction:(id)sender {
    
    if ([[UserDefaultManager getValue:@"cartData"] count]<1) {
        [UIView animateWithDuration:0.6f animations:^{
            mainView.hidden = NO;
            
        }];
    }
    else
    {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CartViewController *cartView =[storyboard instantiateViewControllerWithIdentifier:@"CartViewController"];
        [self.navigationController pushViewController:cartView animated:YES];
        
    }

}
#pragma mark - end

#pragma mark - Alert view
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
        
        myDelegate.window.rootViewController = myDelegate.navigationController;
        
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
            NSIndexPath *cellIndexPath = [wishlistTable indexPathForCell:cell];
            NSMutableDictionary * dataDict = [wishListArray objectAtIndex:cellIndexPath.row];
            
           
            
            if ([[dataDict objectForKey:@"Isinstock"] boolValue])
            {
                if ([[[dataDict objectForKey:@"name"] lowercaseString] isEqualToString:@"build a gift"])
                {
                    myDelegate.isBuildGift = true;
                }
                else
                {
                    myDelegate.isBuildGift = false;
                }
                [myDelegate ShowIndicator];
                [self performSelector:@selector(addToCartService:) withObject:[dataDict objectForKey:@"product_id"] afterDelay:.1];
            }
            else
            {
                //        dispatch_async(dispatch_get_main_queue(), ^{
                //            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"The requested quantity for %@ is not available.",[tmpDict objectForKey:@"name"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                //            [alert show];
                //        });
                  [MozTopAlertView showWithType:MozAlertTypeInfo text:[NSString stringWithFormat:@"The requested quantity for %@ is not available.",[dataDict objectForKey:@"name"]] parentView:self.view];
               // [self.view makeToast:[NSString stringWithFormat:@"The requested quantity for %@ is not available.",[dataDict objectForKey:@"name"]] image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
                
            }
            
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            
            
            
            
            NSLog(@"done pressed!!");
            NSIndexPath *cellIndexPath = [wishlistTable indexPathForCell:cell];
            
            NSMutableDictionary * tmpDict = [wishListArray objectAtIndex:cellIndexPath.row];
            if ([[[tmpDict objectForKey:@"name"] lowercaseString] isEqualToString:@"build a gift"])
            {
                myDelegate.isBuildGift = true;
            }
            else
            {
                myDelegate.isBuildGift = false;
            }
            
            NSMutableDictionary * dataDict = [wishListArray objectAtIndex:cellIndexPath.row];
            productId = [dataDict objectForKey:@"product_id"];
            [myDelegate ShowIndicator];
            [self performSelector:@selector(removeFromWishlistWebservice:) withObject:productId afterDelay:.2];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
