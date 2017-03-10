//
//  SearchProductViewController.m
//  PipaBella
//
//  Created by Ranosys on 23/12/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "SearchProductViewController.h"
#import "SearchProductCollectionViewCell.h"
#import "SortByViewController.h"
#import "ProductService.h"
#import "ProductDetailViewController.h"
#import "CartViewController.h"
#import "WaitlistViewController.h"
#define kCellsPerRow 2

@interface SearchProductViewController ()<UIGestureRecognizerDelegate>{
     int totalNoOfRecords;
    int buttonTag;
    NSString * priceOrder;
    NSString * WhatsNewOrder;
    NSString * inStockOrder;
    int wishlistCounter;
    __weak IBOutlet UIButton *cartBtn;
    
    __weak IBOutlet UILabel *noRecordLbl;
    UIView *mainView;
    
    __weak IBOutlet UITextField *waitlistNameField;
    __weak IBOutlet UITextField *waitlistMailField;
    __weak IBOutlet UIButton *saveBtn;
    __weak IBOutlet UIView *waitlistContainerView;
    
    UIButton *button;
    UIButton *button1;
    UIBarButtonItem *barButton,*barButton1,*barButton2;
    NSTimer * timer;
    int index;
}
@property (weak, nonatomic) IBOutlet UICollectionView *searchProductListCollectionView;
@property (weak, nonatomic) IBOutlet UIView *paginationView;
@property(nonatomic,strong)NSString *productId;
@end

@implementation SearchProductViewController
@synthesize searchProductListCollectionView,paginationView,searchProductDataArray,productId;
@synthesize sortbyColor;
@synthesize sortByinStock;
@synthesize sortByPrice;
@synthesize sortByWhatsNew;
@synthesize colorString;
@synthesize pageNumber;
@synthesize searchKeyword;
@synthesize sortBySelectedArray;
#pragma mark - View lifestyle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //setting collection view cell size according to iPhone screens
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.searchProductListCollectionView.collectionViewLayout;
    CGFloat availableWidthForCells = CGRectGetWidth(self.view.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow -1);
    CGFloat cellWidth = (availableWidthForCells / kCellsPerRow);
    flowLayout.itemSize = CGSizeMake(cellWidth, flowLayout.itemSize.height);
    wishlistCounter=0;
    searchProductDataArray=[[NSMutableArray alloc]init];
    
    searchKeyword = [searchKeyword lowercaseString];
    searchKeyword = [searchKeyword stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[searchKeyword substringToIndex:1] uppercaseString]];
    
    self.title = searchKeyword;
    pageNumber =1;
    paginationView.hidden=YES;
    priceOrder = @"";
    WhatsNewOrder =@"";
    inStockOrder =@"";
    sortbyColor =@"";
    [saveBtn addBorder:saveBtn color:[UIColor colorWithRed:132.0/255.0 green:132.0/255.0 blue:132.0/255.0 alpha:1.0]];
    sortBySelectedArray = [[NSMutableArray alloc]initWithObjects:@"N",@"N",@"N",@"N", nil];
    [self setViewFrame];
    mainView.hidden = YES;

    colorString =@"COLOR";
    sortByinStock = @"IN STOCK";
    sortByPrice = @"PRICE";
    sortByWhatsNew = @"WHAT'S NEW";
    UITapGestureRecognizer *menuItemTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    menuItemTapGestureRecognizer.numberOfTapsRequired    = 1;
    menuItemTapGestureRecognizer.delegate                = self;
    [waitlistContainerView addGestureRecognizer:menuItemTapGestureRecognizer];
    if (self.view.frame.size.height<=480)
    {
        waitlistContainerView.translatesAutoresizingMaskIntoConstraints = YES;
    }
}
- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    waitlistContainerView.hidden = YES;
    [waitlistNameField resignFirstResponder];
    [waitlistMailField resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self addNavigationItem];
    if ([[UserDefaultManager getValue:@"cartData"] count]>0)
    {
        NSMutableArray *tmpArray =[UserDefaultManager getValue:@"cartData"];
        NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)[tmpArray count]];
        button.badgeValue = count;
        button.badgeBGColor = [UIColor colorWithRed:237.0/255.0 green:0.0/255.0 blue:140.0/255.0 alpha:1.0];
        
        
    }
    else
    {
        button.badgeBGColor = [UIColor clearColor];
    }
    pageNumber =1;
    [searchProductDataArray removeAllObjects];
    [searchProductListCollectionView reloadData];
    priceOrder = @"";
    [self setParameters];
    [myDelegate ShowIndicator];
    [self performSelector:@selector(searchProductListWebservice) withObject:nil afterDelay:.1];
    
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Localytics tagScreen:@"Search View"];
}


-(void)addNavigationItem
{
    
    //Navigation bar buttons
    CGRect framing = CGRectMake(0, 0, 40, 40);
    button = [[UIButton alloc] initWithFrame:framing];
    [button setImage:[UIImage imageNamed:@"cart.png"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, -4.0)];
    // [button setBackgroundColor:[UIColor redColor] ];
    barButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(cartButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect framing1 = CGRectMake(0, 0, 30, 30);
    button1 = [[UIButton alloc] initWithFrame:framing1];
    [button1 setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    //    [button1 setImage:[UIImage imageNamed:@"product_detail_heart_full.png"] forState:UIControlStateSelected];
    //[button1 setBackgroundColor:[UIColor yellowColor] ];
    [button1 setImageEdgeInsets:UIEdgeInsetsMake(0.0, 7.0, 0.0, -7.0)];
    barButton1 =[[UIBarButtonItem alloc] initWithCustomView:button1];
    [button1 addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:barButton,barButton1,nil];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [UIView animateWithDuration:0.6f animations:^{
        
        mainView.hidden = YES;
        
    }];
    
}

-(void)setParameters
{
    priceOrder = @"";
    WhatsNewOrder =@"";
    inStockOrder =@"";
    //price param
    if ([sortByPrice isEqualToString:@"Low to high"])
    {
        priceOrder = @"asc";
    }
    else if ([sortByPrice isEqualToString:@"High to low"])
    {
        priceOrder = @"desc";
    }
    //end
    //Whats new param
    if ([sortByWhatsNew isEqualToString:@"What's New"])
    {
        WhatsNewOrder = @"1";
    }
    else if ([sortByWhatsNew isEqualToString:@"Restocked"])
    {
        WhatsNewOrder = @"2";
    }
    //end
    //In stock param
    if ([sortByinStock isEqualToString:@"Instock"])
    {
        inStockOrder =@"1";
    }
    else if ([sortByinStock isEqualToString:@"All"])
    {
        
    }
    
}

#pragma mark - end

#pragma mark - Object framing
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
                         CGRectMake(30,54,emptyBagView.frame.size.width-80,20)];
    bagLabel.text = @"YOUR BAG IS EMPTY";
    bagLabel.backgroundColor = [UIColor clearColor];
    bagLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    bagLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UILabel *keepShoppingLabel = [[UILabel alloc] initWithFrame:
                                  CGRectMake(30,74,emptyBagView.frame.size.width-80,30)];
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


#pragma mark - UICollectionView Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return searchProductDataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchProductCollectionViewCell *myCell = [self.searchProductListCollectionView
                                             dequeueReusableCellWithReuseIdentifier:@"Cell"
                                             forIndexPath:indexPath];
    
    [myCell layoutView:myCell.frame index:(int)indexPath.row];
    [myCell displayData:[searchProductDataArray objectAtIndex:indexPath.row]];
    myCell.addToWishlistButton.tag=indexPath.row;
    myCell.addToWaitlistBtn.tag = indexPath.row;
    [myCell.addToWaitlistBtn addTarget:self action:@selector(addTowaitListAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [myCell.addToWishlistButton addTarget:self action:@selector(addToWishlist:) forControlEvents:UIControlEventTouchUpInside];
    return myCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    index = (int)indexPath.row;
    timer = [NSTimer scheduledTimerWithTimeInterval:.1
                                             target:self
                                           selector:@selector(goToProductDetail)
                                           userInfo:nil
                                            repeats:YES];
    
    
}

-(void)goToProductDetail
{
    if (wishlistCounter==0)
    {
        [timer invalidate];
        SearchProductModel * objProductModel = [searchProductDataArray objectAtIndex:index];
        ProductDetailViewController * objProductDetail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
        objProductDetail.productId = objProductModel.productId;
        objProductDetail.productName = objProductModel.productName;
        objProductDetail.isInStock = objProductModel.isInStock;
        objProductDetail.isAddedtoWishlist =objProductModel.isAddedToWishlist;
        objProductDetail.stockQuantity = [objProductModel.stockQuantity intValue];
        [self.navigationController pushViewController:objProductDetail animated:YES];
    }
    

}
#pragma mark - end


#pragma mark - Pagination

//Handling pagination in collection view

- (void)scrollViewDidScroll:(UIScrollView *)scrollView1
{
    if (paginationView.hidden==YES)
    {
        if (searchProductListCollectionView.contentOffset.y == searchProductListCollectionView.contentSize.height - scrollView1.frame.size.height)
        {
            if (searchProductDataArray.count<totalNoOfRecords)
            {
                paginationView.hidden=NO;
                
                
                
                
                
                //  [myDelegate ShowIndicator];
                [self performSelector:@selector(searchProductListWebservice) withObject:nil afterDelay:.1];
                
            }
        }
    }
    
}
-(void)hideactivityIndicator
{
    paginationView.hidden=YES;
    [searchProductListCollectionView reloadData];
}

#pragma mark - end


#pragma mark - Webservices
-(void)searchProductListWebservice
{
    [[ProductService sharedManager] searchProductListing:searchKeyword pageNumber:[NSString stringWithFormat:@"%d", pageNumber] color:sortbyColor price:priceOrder whatsNew:WhatsNewOrder inStock:inStockOrder success:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            if (data != nil)
                            {
                                
                                if ([data count]<1)
                                {
                                    noRecordLbl.hidden = NO;
                                }
                                else
                                {
                                    noRecordLbl.hidden = YES;
                                [myDelegate StopIndicator];
                                NSMutableArray *tempArray = (NSMutableArray *)data;
                                for (int i=0; i<tempArray.count; i++)
                                {
                                    [searchProductDataArray addObject:[tempArray objectAtIndex:i]];
                                }
                                if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
                                {
                                    [myDelegate StopIndicator];
                                    searchProductDataArray = [UserDefaultManager wishListcomparision:searchProductDataArray];
                                    [searchProductListCollectionView reloadData];
                                    if (searchProductDataArray.count<1)
                                    {
                                        return;
                                    }
                                    [self hideactivityIndicator];
                                    // code here
                                    totalNoOfRecords = [[[searchProductDataArray objectAtIndex:0] totalProducts]intValue];
                                    pageNumber++;
                                    NSLog(@"%d",[[[searchProductDataArray objectAtIndex:0] totalProducts]intValue]);
                                    [searchProductListCollectionView reloadData];
                                }
                                else
                                {
                                    [self getMyWishlist];
                                }
                                
                                }
                            }
                            else
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, please try again." delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:nil, nil];
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
                     wishlistCounter--;
                     
                     
                         
                     
                 }
                 else
                 {

                     NSIndexPath *indexPath=[NSIndexPath indexPathForRow:buttonTag inSection:0];
                     SearchProductCollectionViewCell * cell = (SearchProductCollectionViewCell *)[self.searchProductListCollectionView cellForItemAtIndexPath:indexPath];
                     [cell.addToWishlistButton setSelected:NO];
                     
                     
                     UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     //[alert1 show];
                 
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
                            searchProductDataArray = [UserDefaultManager wishListcomparision:searchProductDataArray];
                            [searchProductListCollectionView reloadData];
                            if (searchProductDataArray.count<1)
                            {
                                return;
                            }
                            [self hideactivityIndicator];
                            // code here
                            totalNoOfRecords = [[[searchProductDataArray objectAtIndex:0] totalProducts]intValue];
                            pageNumber++;
                            NSLog(@"%d",[[[searchProductDataArray objectAtIndex:0] totalProducts]intValue]);
                            [searchProductListCollectionView reloadData];
                            myDelegate.wishlistItems =(int)[[UserDefaultManager getValue:@"wishListData"] count];
                            [self updateBadge];
                        });
         
     }
      failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
    
    
    
}
-(void)updateBadge
{
    if (myDelegate.wishlistItems<1) {
        [[self.tabBarController.tabBar.items objectAtIndex:2] setCustomBadgeValue:nil withFont:nil andFontColor:[UIColor whiteColor] andBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        [[self.tabBarController.tabBar.items objectAtIndex:2] setCustomBadgeValue:[NSString stringWithFormat:@"%lu",(unsigned long)myDelegate.wishlistItems] withFont:[UIFont systemFontOfSize:8 weight:UIFontWeightRegular] andFontColor:[UIColor whiteColor] andBackgroundColor:[UIColor colorWithRed:60.0/255.0 green:171.0/225.0 blue:233.0/255.0 alpha:1.0]];
        
        
    }
    
    
    
}
-(void)removeFromWishlistWebservice:(NSNumber *)tag
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
                 wishlistCounter--;
                 if (data != nil)
                 {
                     
                 }
                 else
                 {

                     NSIndexPath *indexPath=[NSIndexPath indexPathForRow:buttonTag inSection:0];
                     SearchProductCollectionViewCell * cell = (SearchProductCollectionViewCell *)[self.searchProductListCollectionView cellForItemAtIndexPath:indexPath];
                     [cell.addToWishlistButton setSelected:NO];
                     UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     //[alert1 show];
                 }
                 
             });
             
         }
           failure:^(NSError *error)
         {
             //Handle if response is nil
             
         }];
    }
    
}
-(void)addtoWaitlistService
{
    
    [[ProductService sharedManager] addTowaitList:productId name:[UserDefaultManager getValue:@"customer_name"] email:[UserDefaultManager getValue:@"userEmail"] success:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            if (data != nil)
                            {
                                [self handleTap:nil];
                                [myDelegate StopIndicator];
                                waitlistMailField.text =@"";
                                waitlistNameField.text=@"";
                                if ([[data objectForKey:@"status"] isEqualToString:@"1"])
                                {
                                    MozTopAlertView *alertView = [MozTopAlertView showWithType:MozAlertTypeSuccess text:[data objectForKey:@"message"] parentView:self.view];
                                    alertView.dismissBlock = ^(){
                                        NSLog(@"dismissBlock");
                                    };
                                  //  [self.view makeToast:[data objectForKey:@"message"] image:[UIImage imageNamed:@"sign.png"] color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
                                }
                                else
                                {
                                    [MozTopAlertView showWithType:MozAlertTypeWarning text:[data objectForKey:@"message"] doText:nil doBlock:^{
                                        
                                    } parentView:self.view];
                                  //  [self.view makeToast:[data objectForKey:@"message"] image:[UIImage imageNamed:@"excl.png"] color:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]];
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
         //Handle if response is nil
         
     }];
    
    
    
    
}
#pragma mark - end
#pragma mark - Button actions
-(void)searchButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addToWishlist:(UIButton*)sender
{
    buttonTag = (int)[sender tag];
    wishlistCounter++;
    if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL)) {
        myDelegate.istoast = true;
        if([[UIScreen mainScreen] bounds].size.height>480)
        {
            myDelegate.toastMessage = @"SIGN IN to add products to your wishlist";
        }else{
            myDelegate.toastMessage = @"SIGN IN to add products to your wishlist";
        }

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
        myDelegate.window.rootViewController = myDelegate.navigationController;
    }
    else
    {
        productId=[[searchProductDataArray objectAtIndex:[sender tag] ]productId];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:sender.tag inSection:0];
        SearchProductCollectionViewCell * cell = (SearchProductCollectionViewCell *)[self.searchProductListCollectionView cellForItemAtIndexPath:indexPath];
        SearchProductModel *objProductModel = [searchProductDataArray objectAtIndex:[sender tag]];
        if ([[searchProductDataArray objectAtIndex:buttonTag] isAddedToWishlist])
        {
            objProductModel.isAddedToWishlist = false;
            [cell.addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_full.png"] forState:UIControlStateNormal];
            [cell.addToWishlistButton setSelected:NO];
            [self performSelector:@selector(removeFromWishlistWebservice:) withObject:[NSNumber numberWithInt:buttonTag] afterDelay:.1];
            myDelegate.wishlistItems--;
            [self updateBadge];
        }
        else
        {
            objProductModel.isAddedToWishlist = YES;
            [cell.addToWishlistButton setSelected:YES];
            myDelegate.wishlistItems++;
            [self updateBadge];
            [cell.addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_selected_full.png"] forState:UIControlStateNormal];
            [self performSelector:@selector(addToWishlistWebservice:) withObject:[NSNumber numberWithInt:buttonTag] afterDelay:.1];
        }
    }
    
}


- (IBAction)sortByButtonAction:(id)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SortByViewController *objSortView =[storyboard instantiateViewControllerWithIdentifier:@"SortByViewController"];
    objSortView.objSearchProductListing = self;
    objSortView.sortBySelectedArray = sortBySelectedArray;
    objSortView.isSearchScreen = YES;
    objSortView.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1f];
    [objSortView setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:objSortView animated: YES completion:nil];
    
    
}

-(void)addTowaitListAction :(id)sender
{
    productId=[[searchProductDataArray objectAtIndex:[sender tag] ]productId];
    
    if ([UserDefaultManager getValue:@"customer_id"] == nil)
    {
        WaitlistViewController * objWaitList = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"WaitlistViewController"];
        objWaitList.productId = productId;
        UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:objWaitList];
        [self.navigationController presentViewController:navBar animated: YES completion: ^ {
        }];
    }
    else
    {
        [myDelegate ShowIndicator];
        [self performSelector:@selector(addtoWaitlistService) withObject:nil afterDelay:.5];
    }
    
}
- (IBAction)addToWaitlist:(id)sender
{
    productId=[[searchProductDataArray objectAtIndex:[sender tag] ]productId];
    
    if ([UserDefaultManager getValue:@"customer_id"] == nil)
    {
        WaitlistViewController * objWaitList = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"WaitlistViewController"];
        objWaitList.productId = productId;
        UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:objWaitList];
        [self.navigationController presentViewController:navBar animated: YES completion: ^ {
        }];
    }
    else
    {
        [myDelegate ShowIndicator];
        [self performSelector:@selector(addtoWaitlistService) withObject:nil afterDelay:.5];
    }
}

- (IBAction)cartButtonClicked:(id)sender
{
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
#pragma mark - Textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField==waitlistNameField)
    {
        textField.returnKeyType = UIReturnKeyNext;
        return  YES;
        
    }
    else
    {
        if (self.view.frame.size.height<=480)
        {
            waitlistContainerView.frame = CGRectMake(waitlistContainerView.frame.origin.x, waitlistContainerView.frame.origin.y-40, waitlistContainerView.frame.size.width, waitlistContainerView.frame.size.height);
        }
        textField.returnKeyType = UIReturnKeyDone;
        return  YES;
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if(textField==waitlistNameField)
    {
        [waitlistNameField resignFirstResponder];
        [waitlistMailField becomeFirstResponder];
        return  YES;
        
    }
    else
    {
        if (self.view.frame.size.height<=480)
        {
            waitlistContainerView.frame = CGRectMake(waitlistContainerView.frame.origin.x, waitlistContainerView.frame.origin.y+40, waitlistContainerView.frame.size.width, waitlistContainerView.frame.size.height);
        }
        [waitlistMailField resignFirstResponder];
        return  YES;
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
