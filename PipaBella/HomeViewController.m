//
//  HomeViewController.m
//  PipaBella
//
//  Created by Ranosys on 20/10/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCollectionViewCell.h"
#import "WhatsNewTableViewCell.h"
#import "HomeService.h"
#import "UserService.h"
#import "ProductListViewController.h"
#import "ProductService.h"
#import "ProductDetailViewController.h"
#import "UIButton+Badge.h"
#import "BuildGiftViewController.h"
#import "J2TRewardsViewController.h"
#import "CartViewController.h"
#import "WaitlistViewController.h"
#import "UITabBarItem+CustomBadge.h"
#import "SortByViewController.h"
#define kCellsPerRow 2

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>{
    NSMutableArray *bannersArray;
    NSMutableArray *whatsNewDataArray;
    NSMutableArray *bestsellersDataArray;
    NSMutableArray *restockDataArray;
    int buttonTag;
    int totalNoOfRecords;
    int pageNumber;
    int tabTracker;
    int wishlistCounter;
    __weak IBOutlet UIButton *cartBtn;
    
    UIView *mainView;
    
    __weak IBOutlet UITextField *waitlistNameField;
    __weak IBOutlet UITextField *waitlistMailField;
    __weak IBOutlet UIButton *saveBtn;
    __weak IBOutlet UIView *waitlistContainerView;
    
    __weak IBOutlet UIButton *sortByBtn;
    NSTimer * timer;
    int index;
    
    NSString * priceOrder;
    NSString * WhatsNewOrder;
    NSString * inStockOrder;
    __weak IBOutlet UILabel *noRecordLbl;
}
@property (weak, nonatomic) IBOutlet UIButton *whatsNewButton;
@property (weak, nonatomic) IBOutlet UIButton *bestsellersButton;
@property (weak, nonatomic) IBOutlet UIButton *saleButton;
@property (weak, nonatomic) IBOutlet UITableView *whatsNewTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *productListingCollectionView;
@property (weak, nonatomic) IBOutlet UIView *paginationView;

@property(nonatomic,strong)NSString *productId;
@property (strong, nonatomic) NSString *categoryId;

@property (strong, nonatomic) UITabBarController *tabbarcontroller;
@end

@implementation HomeViewController
@synthesize whatsNewButton,bestsellersButton,saleButton,whatsNewTableView,productListingCollectionView,paginationView;
@synthesize categoryId,productId;
@synthesize sortbyColor;
@synthesize sortByinStock;
@synthesize sortByPrice;
@synthesize sortByWhatsNew;
@synthesize colorString;
@synthesize sortBySelectedArray;
@synthesize bestsellersDataArray;
@synthesize restockDataArray;
#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    //    [imageCache clearMemory];
    //    [imageCache clearDisk];
    // Do any additional setup after loading the view.
    
    NSDictionary *dict=[UserDefaultManager getValue:@"productDetailDict"];
    
    if ([dict objectForKey:@"productId"]!=nil)
    {
        tabTracker=[[UserDefaultManager getValue:@"Tab"] intValue];
    }
    else
    {
        tabTracker = 0;
    }
    
    priceOrder = @"";
    WhatsNewOrder =@"";
    inStockOrder =@"";
    sortbyColor =@"";
    wishlistCounter = 0;
    
    //    tabTracker = 0;
    self.navigationItem.title=@"DISCOVER";
    [myDelegate StopIndicator];
    wishlistCounter=0;
    UITabBarController * myTab = (UITabBarController *)self.tabBarController;
    //get reference of tabbar
    //NSLog(@"crt no is %@",[UserDefaultManager getValue:@"total_cart_item"]);
    sortBySelectedArray = [[NSMutableArray alloc]initWithObjects:@"N",@"N",@"N",@"N", nil];
    [self setViewFrame];
    mainView.hidden = YES;
    [myDelegate StopIndicator];
    
    UITabBar *tabBar = myTab.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    UITabBarItem *tabBarItem5 = [tabBar.items objectAtIndex:4];
    
    //   [[[self tabBarController] tabBar] setBackgroundImage:[UIImage imageNamed:@"tab.png"]];
    [[[self tabBarController] tabBar] setBackgroundColor:[UIColor whiteColor]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"SF-UI-Display-Light" size:14.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [saveBtn addBorder:saveBtn color:[UIColor colorWithRed:132.0/255.0 green:132.0/255.0 blue:132.0/255.0 alpha:1.0]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0] } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:241/255.0 green:0/255.0 blue:136/255.0 alpha:1.0] } forState:UIControlStateSelected];
    
    [tabBarItem1 setImage:[[UIImage imageNamed:@"discover.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem1 setSelectedImage:[[UIImage imageNamed:@"discover_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem1.imageInsets = UIEdgeInsetsMake(1, 0, -1, 0);
    
    [tabBarItem2 setImage:[[UIImage imageNamed:@"categories.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem2 setSelectedImage:[[UIImage imageNamed:@"categories_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem2.imageInsets = UIEdgeInsetsMake(1, 0, -1, 0);
    
    
    [tabBarItem3 setImage:[[UIImage imageNamed:@"wishlist_tab.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem3 setSelectedImage:[[UIImage imageNamed:@"wishlist_selected_tab.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem3.imageInsets = UIEdgeInsetsMake(1, 0, -1, 0);
    
    [tabBarItem4 setImage:[[UIImage imageNamed:@"search.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem4 setSelectedImage:[[UIImage imageNamed:@"search_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem4.imageInsets = UIEdgeInsetsMake(1, 0, -1, 0);
    
    
    [tabBarItem5 setImage:[[UIImage imageNamed:@"me.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem5 setSelectedImage:[[UIImage imageNamed:@"me_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem5.imageInsets = UIEdgeInsetsMake(1, 0, -1, 0);
    
    [[self.tabBarController.tabBar.items objectAtIndex:2] setCustomBadgeValue:[NSString stringWithFormat:@"%lu",(unsigned long)[[UserDefaultManager getValue:@"wishListData"] count]] withFont:[UIFont systemFontOfSize:8 weight:UIFontWeightRegular] andFontColor:[UIColor whiteColor] andBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:178.0/225.0 blue:229.0/255.0 alpha:1.0]];
    
    colorString =@"COLOR";
    sortByinStock = @"IN STOCK";
    sortByPrice = @"PRICE";
    sortByWhatsNew = @"WHAT'S NEW";
    
    myDelegate.wishlistItems =(int)[[UserDefaultManager getValue:@"wishListData"] count];
    [self updateBadge];
    
    if ([[UserDefaultManager getValue:@"Tab"] isEqualToString:@"1"])
    {
        productListingCollectionView.hidden = NO;
        whatsNewTableView.hidden = YES;
        bestsellersButton.selected=YES;
        [bestsellersButton addBorder:bestsellersButton color:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:108.0/255.0 alpha:1.0]];
        [bestsellersButton setTitleColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:108.0/255.0 alpha:1.0] forState:UIControlStateSelected];
        
        [whatsNewButton addBorder:whatsNewButton color:[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0]];
        [saleButton addBorder:saleButton color:[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0]];
    }
    else if ([[UserDefaultManager getValue:@"Tab"] isEqualToString:@"2"])
    {
        productListingCollectionView.hidden = NO;
        whatsNewTableView.hidden = YES;
        saleButton.selected=YES;
        [saleButton addBorder:saleButton color:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:108.0/255.0 alpha:1.0]];
        [saleButton setTitleColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:108.0/255.0 alpha:1.0] forState:UIControlStateSelected];
        
        [bestsellersButton addBorder:bestsellersButton color:[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0]];
        [whatsNewButton addBorder:whatsNewButton color:[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0]];
        
        
    }
    else
    {
        productListingCollectionView.hidden = YES;
        whatsNewTableView.hidden = NO;
        whatsNewButton.selected=YES;
        [whatsNewButton addBorder:whatsNewButton color:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:108.0/255.0 alpha:1.0]];
        [whatsNewButton setTitleColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:108.0/255.0 alpha:1.0] forState:UIControlStateSelected];
        
        [bestsellersButton addBorder:bestsellersButton color:[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0]];
        [saleButton addBorder:saleButton color:[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0]];
        
    }
    
    
    //    productListingCollectionView.hidden = YES;
    //    whatsNewTableView.hidden = NO;
    //    whatsNewButton.selected=YES;
    //    [whatsNewButton addBorder:whatsNewButton color:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:108.0/255.0 alpha:1.0]];
    //    [whatsNewButton setTitleColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:108.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    //
    //    [bestsellersButton addBorder:bestsellersButton color:[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0]];
    //    [saleButton addBorder:saleButton color:[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0]];
    
    //setting collection view cell size according to iPhone screens
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.productListingCollectionView.collectionViewLayout;
    CGFloat availableWidthForCells = CGRectGetWidth(self.view.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow -1);
    CGFloat cellWidth = (availableWidthForCells / kCellsPerRow);
    flowLayout.itemSize = CGSizeMake(cellWidth, flowLayout.itemSize.height);
    
    myDelegate.quizCompleted=@"true";
    [UserDefaultManager setValue:myDelegate.quizCompleted key:@"QuizCompleted"];
    
    paginationView.hidden=YES;
    pageNumber = 1;
    
    bannersArray=[[NSMutableArray alloc]init];
    whatsNewDataArray=[[NSMutableArray alloc]init];
    bestsellersDataArray=[[NSMutableArray alloc]init];
    restockDataArray=[[NSMutableArray alloc]init];
    
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
//-(void)viewDidAppear:(BOOL)animated
//{
//
//}

-(void)setParameters
{
    //price param
    priceOrder = @"";
    WhatsNewOrder =@"";
    inStockOrder =@"";
    
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [myDelegate StopIndicator];
    [whatsNewDataArray removeAllObjects];
    [whatsNewTableView reloadData];
    //NSLog(@"myDelegate.tabId is %d",myDelegate.tabId);
    [NSTimer scheduledTimerWithTimeInterval:.1
                                     target:self
                                   selector:@selector(showLoader)
                                   userInfo:nil
                                    repeats:NO];
    
}

-(void)showLoader
{
    
    if (!myDelegate.isRegistered)
    {
        [myDelegate ShowIndicator];
    }
    else
    {
        myDelegate.isRegistered = false;
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    myDelegate.tabId = (int)self.tabBarController.selectedIndex;
    [bestsellersDataArray removeAllObjects];
    [restockDataArray removeAllObjects];
    [productListingCollectionView reloadData];
   // NSLog(@"[[UserDefaultManager getValue:total_cart_item] intValue] is %d",[[UserDefaultManager getValue:@"total_cart_item"] intValue]);
    if ([[UserDefaultManager getValue:@"cartData"] count]>0)
    {
        NSMutableArray *tmpArray =[UserDefaultManager getValue:@"cartData"];
        NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)[tmpArray count]];
        cartBtn.badgeValue = count;
        cartBtn.badgeBGColor = [UIColor colorWithRed:237.0/255.0 green:0.0/255.0 blue:140.0/255.0 alpha:1.0];
    }
    else
    {
        cartBtn.badgeBGColor = [UIColor clearColor];
    }
    
    
    
    if ([UserDefaultManager getValue:@"CurrentView"]!=nil)
    {
        [myDelegate StopIndicator];
        if (![([UserDefaultManager getValue:@"CurrentView"]) isEqualToString:@"HomeViewController"])
        {
            UIViewController * objChkout = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:[UserDefaultManager getValue:@"CurrentView"]];
            [self.navigationController pushViewController:objChkout animated:YES];
            return;
        }
    }
    
    
    [self setParameters];
    if (tabTracker==0)
    {
        [Localytics tagScreen:@"Home:Whats New"];
        [whatsNewDataArray removeAllObjects];
        [whatsNewTableView reloadData];
        sortByBtn.hidden =YES;
        //[myDelegate ShowIndicator];
        [self performSelector:@selector(whatsNewWebservice) withObject:nil afterDelay:.1];
    }
    else if (tabTracker==1)
    {
        [Localytics tagScreen:@"Home:Best Sellers"];
        sortByBtn.hidden =NO;
        pageNumber =1;
        //[myDelegate ShowIndicator];
        [self performSelector:@selector(bestSellerWebservice) withObject:nil afterDelay:.1];
        
    }
    else if (tabTracker==2)
    {
        [Localytics tagScreen:@"Home:Restock"];
        sortByBtn.hidden =NO;
        pageNumber =1;
        //[myDelegate ShowIndicator];
        [self performSelector:@selector(restockWebservice) withObject:nil afterDelay:.1];
    }
    
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [UIView animateWithDuration:0.6f animations:^{
        
        mainView.hidden = YES;
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



#pragma mark - Webservice
-(void)whatsNewWebservice
{
    
    [whatsNewDataArray removeAllObjects];
    [whatsNewTableView reloadData];
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
        });
    }
    else
    {
        //NSLog(@"%@",[UserDefaultManager getValue:@"sessionId"]);
        if (([UserDefaultManager getValue:@"sessionId"] == nil) || [[UserDefaultManager getValue:@"sessionId"] isEqualToString:@""])
        {
            myDelegate.isSessionId=1;
            [[UserService sharedManager] getSessionId:^(id data)
             {
                 if (([UserDefaultManager getValue:@"sessionId"] == nil) || [[UserDefaultManager getValue:@"sessionId"] isEqualToString:@""])
                 {
                     [myDelegate StopIndicator];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, please try again." delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:nil, nil];
                         alert.tag=1;
                         [alert show];
                     });
                 }
                 else
                 {
                    [self whatsNewWebservice];
                 }
                 
             }
             failure:^(NSError *error)
             {
                 //NSLog(@"Failure check");
                 
             }] ;
            
        }
        
        else
        {
            [[HomeService sharedManager] whatsNewWebservice:^(id data)
             {
                 //Handle fault cases
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    // code here
                                    [myDelegate StopIndicator];
                                    whatsNewDataArray=data;
                                    [whatsNewTableView reloadData];
                                    
                                });
                 
                 
             }
                                                    failure:^(NSError *error)
             {
                 //Handle if response is nil
                 
             }] ;
        }
    }
}

-(void)bestSellerWebservice
{
    categoryId = @"56";
    
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
            return ;
        });
    }
    else
    {
        
        //NSLog(@"%@",[UserDefaultManager getValue:@"sessionId"]);
        if (([UserDefaultManager getValue:@"sessionId"] == nil) || [[UserDefaultManager getValue:@"sessionId"] isEqualToString:@""])
        {
            myDelegate.isSessionId=1;
            [[UserService sharedManager] getSessionId:^(id data)
             {
                 [[ProductService sharedManager] productListing:categoryId pageNumber:[NSString stringWithFormat:@"%d", pageNumber] color:sortbyColor price:priceOrder whatsNew:WhatsNewOrder inStock:inStockOrder success:^(id data)
                  {
                      //Handle fault cases
                      dispatch_async(dispatch_get_main_queue(), ^
                                     {
                                         if (data != nil)
                                         {
                                             //  if ([data objectForKey:@"result"] != nil || [data objectForKey:@"result"] != NULL)
                                             //{
                                             // code here
                                             if ([data count]<1)
                                             {
                                                 
                                                 noRecordLbl.hidden = NO;
                                             }
                                             else
                                             {
                                                 noRecordLbl.hidden = YES;
                                                 NSMutableArray *tempArray = (NSMutableArray *)data;
                                                 for (int i=0; i<tempArray.count; i++) {
                                                     [bestsellersDataArray addObject:[tempArray objectAtIndex:i]];
                                                     
                                                     
                                                 }
                                                 if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
                                                 {
                                                     [myDelegate StopIndicator];
                                                     bestsellersDataArray= [UserDefaultManager wishListcomparision:bestsellersDataArray];
                                                     [productListingCollectionView reloadData];
                                                     [self hideactivityIndicator];
                                                     
                                                     
                                                     if (bestsellersDataArray.count<1)
                                                     {
                                                         return;
                                                     }
                                                     totalNoOfRecords = [[[bestsellersDataArray objectAtIndex:0] totalProducts]intValue];
                                                     pageNumber++;
                                                     //NSLog(@"%d",[[[bestsellersDataArray objectAtIndex:0] totalProducts]intValue]);
                                                     
                                                     
                                                     
                                                     
                                                     [productListingCollectionView reloadData];
                                                 }
                                                 else
                                                 {
                                                     [self getMyWishlist];
                                                 }
                                             }
                                         }
                                         else
                                         {
                                             [myDelegate StopIndicator];
                                             UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                             [alert1 show];
                                         }
                                         
                                     });
                      
                      
                  }
                                                        failure:^(NSError *error)
                  {
                      dispatch_async(dispatch_get_main_queue(), ^
                                     {
                                         [myDelegate StopIndicator];
                                     });
                      
                  }] ;
                 
             }
                                              failure:^(NSError *error)
             {
                 //NSLog(@"Failure check");
                 [myDelegate StopIndicator];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, please try again." delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:nil, nil];
                     alert.tag=1;
                     [alert show];
                 });
             }] ;
            
        }
        else
        {
            
            [[ProductService sharedManager] productListing:categoryId pageNumber:[NSString stringWithFormat:@"%d", pageNumber] color:sortbyColor price:priceOrder whatsNew:WhatsNewOrder inStock:inStockOrder success:^(id data)
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
                                            NSMutableArray *tempArray = (NSMutableArray *)data;
                                            for (int i=0; i<tempArray.count; i++) {
                                                [bestsellersDataArray addObject:[tempArray objectAtIndex:i]];
                                                
                                                
                                            }
                                            if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
                                            {
                                                [myDelegate StopIndicator];
                                                bestsellersDataArray= [UserDefaultManager wishListcomparision:bestsellersDataArray];
                                                [productListingCollectionView reloadData];
                                                [self hideactivityIndicator];
                                                
                                                
                                                if (bestsellersDataArray.count<1)
                                                {
                                                    return;
                                                }
                                                totalNoOfRecords = [[[bestsellersDataArray objectAtIndex:0] totalProducts]intValue];
                                                pageNumber++;
                                                //NSLog(@"%d",[[[bestsellersDataArray objectAtIndex:0] totalProducts]intValue]);
                                                
                                                
                                                
                                                
                                                [productListingCollectionView reloadData];
                                            }
                                            else
                                            {
                                                [self getMyWishlist];
                                            }
                                        }
                                    }
                                    else
                                    {
                                        [myDelegate StopIndicator];
                                        UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                        [alert1 show];
                                    }
                                    
                                });
                 
                 
             }
                                                   failure:^(NSError *error)
             {
                 //Handle if response is nil
                 
             }] ;
        }
    }
    
}

-(void)restockWebservice
{
    
    categoryId = @"158";
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
            return ;
        });
    }
    else
    {
        //NSLog(@"%@",[UserDefaultManager getValue:@"sessionId"]);
        if (([UserDefaultManager getValue:@"sessionId"] == nil) || [[UserDefaultManager getValue:@"sessionId"] isEqualToString:@""])
        {
            myDelegate.isSessionId=1;
            [[UserService sharedManager] getSessionId:^(id data)
             {
                 
                 [[ProductService sharedManager] productListing:categoryId pageNumber:[NSString stringWithFormat:@"%d", pageNumber] color:sortbyColor price:priceOrder whatsNew:WhatsNewOrder inStock:inStockOrder success:^(id data)
                  {
                      //Handle fault cases
                      dispatch_async(dispatch_get_main_queue(), ^
                                     {
                                         [myDelegate StopIndicator];
                                         if (data != nil)
                                         {
                                             NSMutableArray *tempArray = (NSMutableArray *)data;
                                             for (int i=0; i<tempArray.count; i++)
                                             {
                                                 [restockDataArray addObject:[tempArray objectAtIndex:i]];
                                             }
                                             if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
                                             {
                                                 [productListingCollectionView reloadData];
                                                 [self hideactivityIndicator];
                                                 
                                                 restockDataArray=[UserDefaultManager wishListcomparision:restockDataArray];
                                                 if (restockDataArray.count<1)
                                                 {
                                                     return;
                                                 }
                                                 totalNoOfRecords = [[[restockDataArray objectAtIndex:0] totalProducts]intValue];
                                                 pageNumber++;
                                                 //NSLog(@"%d",[[[restockDataArray objectAtIndex:0] totalProducts]intValue]);
                                             }
                                             else
                                             {
                                                 [self getMyWishlist];
                                             }
                                             
                                             
                                             
                                         }
                                         else
                                         {
                                             [myDelegate StopIndicator];
                                             UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                             [alert1 show];
                                         }
                                         
                                     });
                      
                      
                  }
                                                        failure:^(NSError *error)
                  {
                      dispatch_async(dispatch_get_main_queue(), ^
                                     {
                                         [myDelegate StopIndicator];
                                     });
                      
                  }] ;
                 
             }
                                              failure:^(NSError *error)
             {
                 //NSLog(@"Failure check");
                 [myDelegate StopIndicator];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, please try again." delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:nil, nil];
                     alert.tag=1;
                     [alert show];
                 });
             }] ;
            
        }
        else
        {
            //========================================
            
            [[ProductService sharedManager] productListing:categoryId pageNumber:[NSString stringWithFormat:@"%d", pageNumber] color:sortbyColor price:priceOrder whatsNew:WhatsNewOrder inStock:inStockOrder success:^(id data)
             {
                 //Handle fault cases
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    [myDelegate StopIndicator];
                                    if (data != nil)
                                    {
                                        NSMutableArray *tempArray = (NSMutableArray *)data;
                                        for (int i=0; i<tempArray.count; i++)
                                        {
                                            [restockDataArray addObject:[tempArray objectAtIndex:i]];
                                        }
                                        if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
                                        {
                                            [productListingCollectionView reloadData];
                                            [self hideactivityIndicator];
                                            
                                            restockDataArray=[UserDefaultManager wishListcomparision:restockDataArray];
                                            if (restockDataArray.count<1)
                                            {
                                                return;
                                            }
                                            totalNoOfRecords = [[[restockDataArray objectAtIndex:0] totalProducts]intValue];
                                            pageNumber++;
                                            //NSLog(@"%d",[[[restockDataArray objectAtIndex:0] totalProducts]intValue]);
                                        }
                                        else
                                        {
                                            [self getMyWishlist];
                                        }
                                        
                                        
                                        
                                    }
                                    else
                                    {
                                        [myDelegate StopIndicator];
                                        UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                        [alert1 show];
                                    }
                                    
                                });
                 
                 
             }
                                                   failure:^(NSError *error)
             {
                 //Handle if response is nil
                 
             }] ;
        }
    }
    
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
             myDelegate.counter--;
             dispatch_async(dispatch_get_main_queue(), ^{
                 // code here
                 if (data != nil)
                 {
                     
                     
                     [UserDefaultManager removeValue:@"productDetailDict"];
                     [UserDefaultManager removeValue:@"CurrentView"];
                     [UserDefaultManager removeValue:@"Tab"];
                     
                     
                     
                     wishlistCounter--;
                     
                     
                 }
                 else
                 {
                     NSIndexPath *indexPath=[NSIndexPath indexPathForRow:buttonTag inSection:0];
                     HomeCollectionViewCell * cell = (HomeCollectionViewCell *)[self.productListingCollectionView cellForItemAtIndexPath:indexPath];
                     [cell.addToWishlistButton setSelected:NO];
                     [cell.addToWishlistLoader stopAnimating];
                     [myDelegate StopIndicator];
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
    //NSLog(@"wishlist counter value is %d",wishlistCounter);
    [[ProductService sharedManager] getWishlist:^(id data)
     {
         //Handle fault cases
         
         dispatch_async(dispatch_get_main_queue(),^
                        {
                            [myDelegate StopIndicator];
                            myDelegate.wishlistItems =(int)[[UserDefaultManager getValue:@"wishListData"] count];
                            if (tabTracker == 1)
                            {
                                bestsellersDataArray= [UserDefaultManager wishListcomparision:bestsellersDataArray];
                                [productListingCollectionView reloadData];
                                [self hideactivityIndicator];
                                
                                if ([UserDefaultManager getValue:@"productDetailDict"]!=nil)
                                {
                                    NSDictionary *dict=[UserDefaultManager getValue:@"productDetailDict"];
                                    buttonTag=[[dict objectForKey:@"objectIndex"]intValue];
                                    [self addProductToWishlist:buttonTag];
                                }
                                
                                if (bestsellersDataArray.count<1)
                                {
                                    return;
                                }
                                totalNoOfRecords = [[[bestsellersDataArray objectAtIndex:0] totalProducts]intValue];
                                pageNumber++;
                                //NSLog(@"%d",[[[bestsellersDataArray objectAtIndex:0] totalProducts]intValue]);
                            }
                            else
                            {
                                [productListingCollectionView reloadData];
                                [self hideactivityIndicator];
                                
                                restockDataArray=[UserDefaultManager wishListcomparision:restockDataArray];
                                
                                if ([UserDefaultManager getValue:@"productDetailDict"]!=nil)
                                {
                                    NSDictionary *dict=[UserDefaultManager getValue:@"productDetailDict"];
                                    buttonTag=[[dict objectForKey:@"objectIndex"]intValue];
                                    [self addProductToWishlist:buttonTag];
                                }
                                
                                
                                if (restockDataArray.count<1)
                                {
                                    return;
                                }
                                totalNoOfRecords = [[[restockDataArray objectAtIndex:0] totalProducts]intValue];
                                pageNumber++;
                                //NSLog(@"%d",[[[restockDataArray objectAtIndex:0] totalProducts]intValue]);
                            }
                            
                            [self updateBadge];
                            
                            [productListingCollectionView reloadData];
                        });
         
     }
                                        failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }];
    
    
    
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
                 // code here
                 if (data != nil)
                 {
                     wishlistCounter--;
                     
                     
                 }
                 else
                 {
                     [myDelegate StopIndicator];
                     NSIndexPath *indexPath=[NSIndexPath indexPathForRow:buttonTag inSection:0];
                     HomeCollectionViewCell * cell = (HomeCollectionViewCell *)[self.productListingCollectionView cellForItemAtIndexPath:indexPath];
                     [cell.addToWishlistButton setSelected:NO];
                     [cell.addToWishlistLoader stopAnimating];
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
                                [myDelegate StopIndicator];
                                [self handleTap:nil];
                                waitlistMailField.text =@"";
                                waitlistNameField.text=@"";
                                if ([[data objectForKey:@"status"] isEqualToString:@"1"])
                                {
                                    MozTopAlertView *alertView = [MozTopAlertView showWithType:MozAlertTypeSuccess text:[data objectForKey:@"message"] parentView:self.view];
                                    alertView.dismissBlock = ^(){
                                        //NSLog(@"dismissBlock");
                                    };

                                 //   [self.view makeToast:[data objectForKey:@"message"] image:[UIImage imageNamed:@"sign.png"] color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
                                }
                                else
                                {
                                    [MozTopAlertView showWithType:MozAlertTypeWarning text:[data objectForKey:@"message"] doText:nil doBlock:^{
                                        
                                    } parentView:self.view];
                                    //[self.view makeToast:[data objectForKey:@"message"] image:[UIImage imageNamed:@"excl.png"] color:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]];
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

- (IBAction)addToWishlist:(UIButton*)sender
{
    buttonTag = (int)[sender tag];
    
    [self addProductToWishlist:buttonTag];
    
    //    wishlistCounter++;
    //    if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
    //    {
    ////        dispatch_async(dispatch_get_main_queue(), ^{
    ////            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"You need to login first." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    ////            alert.tag=2;
    ////            [alert show];
    ////        });
    //
    //        myDelegate.istoast = true;
    //
    //        if([[UIScreen mainScreen] bounds].size.height>480)
    //        {
    //            myDelegate.toastMessage = @"SIGN IN to add products to your wishlist";
    //        }else{
    //            myDelegate.toastMessage = @"SIGN IN to add products to your wishlist";
    //        }
    //
    //      //  myDelegate.toastMessage = @"SIGN IN to add products to your wishlist            X";
    //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //        myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
    //        myDelegate.window.rootViewController = myDelegate.navigationController;
    //    }
    //    else
    //    {
    //        if (tabTracker==1)
    //        {
    //
    //            productId=[[bestsellersDataArray objectAtIndex:[sender tag] ]productId];
    //            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:sender.tag inSection:0];
    //            HomeCollectionViewCell * cell = (HomeCollectionViewCell *)[self.productListingCollectionView cellForItemAtIndexPath:indexPath];
    //            ProductListingDataModel *objProductModel = [bestsellersDataArray objectAtIndex:buttonTag];
    //
    //
    //            if ([[bestsellersDataArray objectAtIndex:buttonTag] isAddedToWishlist])
    //            {
    //                objProductModel.isAddedToWishlist = false;
    //                [bestsellersDataArray replaceObjectAtIndex:buttonTag withObject:objProductModel];
    //                [cell.addToWishlistButton setSelected:NO];
    //                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
    //                                                         (unsigned long)NULL), ^(void) {
    //                    [self removeFromWishlistWebservice:[NSNumber numberWithInt:buttonTag]];
    //                });
    //                NSLog(@"myDelegate.wishlistItems is %d",myDelegate.wishlistItems);
    //                myDelegate.wishlistItems--;
    //                [self updateBadge];
    //            }
    //            else
    //            {
    //                objProductModel.isAddedToWishlist = true;
    //                [bestsellersDataArray replaceObjectAtIndex:buttonTag withObject:objProductModel];
    //                [cell.addToWishlistButton setSelected:YES];
    //                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
    //                                                         (unsigned long)NULL), ^(void) {
    //                    [self addToWishlistWebservice:[NSNumber numberWithInt:buttonTag]];
    //                });
    //                NSLog(@"myDelegate.wishlistItems is %d",myDelegate.wishlistItems);
    //                myDelegate.wishlistItems++;
    //                [self updateBadge];
    //            }
    //            if (objProductModel.isAddedToWishlist)
    //            {
    //                [cell.addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_selected_full.png"] forState:UIControlStateNormal];
    //            }
    //            else
    //            {
    //                [cell.addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_full.png"] forState:UIControlStateNormal];
    //            }
    //
    //        }
    //        else if (tabTracker==2)
    //        {
    //            productId=[[restockDataArray objectAtIndex:[sender tag] ]productId];
    //            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:sender.tag inSection:0];
    //            HomeCollectionViewCell * cell = (HomeCollectionViewCell *)[self.productListingCollectionView cellForItemAtIndexPath:indexPath];
    //            [cell.addToWishlistLoader startAnimating];
    //            ProductListingDataModel *objProductModel = [restockDataArray objectAtIndex:buttonTag];
    //
    //            [restockDataArray replaceObjectAtIndex:buttonTag withObject:objProductModel];
    //            if ([[restockDataArray objectAtIndex:buttonTag] isAddedToWishlist])
    //            {
    //                objProductModel.isAddedToWishlist = false;
    //                [restockDataArray replaceObjectAtIndex:buttonTag withObject:objProductModel];
    //                [cell.addToWishlistButton setSelected:NO];
    //                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
    //                                                         (unsigned long)NULL), ^(void) {
    //                    [self removeFromWishlistWebservice:[NSNumber numberWithInt:buttonTag]];
    //                });
    //                NSLog(@"myDelegate.wishlistItems is %d",myDelegate.wishlistItems);
    //                myDelegate.wishlistItems--;
    //                [self updateBadge];
    //
    //            }
    //            else
    //            {
    //                objProductModel.isAddedToWishlist = true;
    //                [restockDataArray replaceObjectAtIndex:buttonTag withObject:objProductModel];
    //                [cell.addToWishlistButton setSelected:YES];
    //                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
    //                                                         (unsigned long)NULL), ^(void) {
    //                    [self addToWishlistWebservice:[NSNumber numberWithInt:buttonTag]];
    //                });
    //                NSLog(@"myDelegate.wishlistItems is %d",myDelegate.wishlistItems);
    //                myDelegate.wishlistItems++;
    //                [self updateBadge];
    //            }
    //            if (objProductModel.isAddedToWishlist)
    //            {
    //                [cell.addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_selected_full.png"] forState:UIControlStateNormal];
    //            }
    //            else
    //            {
    //                [cell.addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_full.png"] forState:UIControlStateNormal];
    //            }
    //        }
    //    }
    
}

-(void)addProductToWishlist:(int)tag
{
    buttonTag = tag;
    wishlistCounter++;
    myDelegate.counter++;
    if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
    {
        myDelegate.istoast = true;
        
        if([[UIScreen mainScreen] bounds].size.height>480)
        {
            myDelegate.toastMessage = @"SIGN IN to add products to your wishlist";
        }
        else
        {
            myDelegate.toastMessage = @"SIGN IN to add products to your wishlist";
        }
        
        NSDictionary *productDetailDict = [NSDictionary new];
        
        if ((bestsellersDataArray!=nil) && ([bestsellersButton isSelected]))
        {
            productId=[[bestsellersDataArray objectAtIndex:buttonTag ]productId];
            [UserDefaultManager setValue:@"1" key:@"Tab"];
        }
        else if ((restockDataArray!=nil) && ([saleButton isSelected]))
        {
            productId=[[restockDataArray objectAtIndex:buttonTag ]productId];
            [UserDefaultManager setValue:@"2" key:@"Tab"];
        }
        else
        {
            [UserDefaultManager setValue:@"0" key:@"Tab"];
        }
        
        productDetailDict = @{@"productId":productId,@"objectIndex":[NSString stringWithFormat:@"%d",buttonTag]};
        
        [UserDefaultManager setValue:productDetailDict key:@"productDetailDict"];
        [UserDefaultManager setValue:@"HomeViewController" key:@"CurrentView"];
        
        //NSLog(@"productDetailDict = %@ ,Current View = %@ ",[UserDefaultManager getValue:@"productDetailDict"],[UserDefaultManager getValue:@"CurrentView"]);
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
        myDelegate.window.rootViewController = myDelegate.navigationController;
    }
    else
    {
        if (tabTracker==1)
        {
            
            productId=[[bestsellersDataArray objectAtIndex:buttonTag ]productId];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:buttonTag inSection:0];
            HomeCollectionViewCell * cell = (HomeCollectionViewCell *)[self.productListingCollectionView cellForItemAtIndexPath:indexPath];
            ProductListingDataModel *objProductModel = [bestsellersDataArray objectAtIndex:buttonTag];
            
            
            if ([[bestsellersDataArray objectAtIndex:buttonTag] isAddedToWishlist])
            {
                if ([UserDefaultManager getValue:@"productDetailDict"]!=nil)
                {
                    [UserDefaultManager removeValue:@"productDetailDict"];
                    [UserDefaultManager removeValue:@"CurrentView"];
                    
                    //NSLog(@"product already added to wishlist");
                    
                    
                }
                else
                {
                    objProductModel.isAddedToWishlist = false;
                    [bestsellersDataArray replaceObjectAtIndex:buttonTag withObject:objProductModel];
                    [cell.addToWishlistButton setSelected:NO];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                             (unsigned long)NULL), ^(void) {
                        [self removeFromWishlistWebservice:[NSNumber numberWithInt:buttonTag]];
                    });
                    //NSLog(@"myDelegate.wishlistItems is %d",myDelegate.wishlistItems);
                    myDelegate.wishlistItems--;
                    [self updateBadge];
                }
            }
            else
            {
                [UserDefaultManager removeValue:@"productDetailDict"];
                [UserDefaultManager removeValue:@"CurrentView"];
                
                
                objProductModel.isAddedToWishlist = true;
                [bestsellersDataArray replaceObjectAtIndex:buttonTag withObject:objProductModel];
                [cell.addToWishlistButton setSelected:YES];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                         (unsigned long)NULL), ^(void) {
                    [self addToWishlistWebservice:[NSNumber numberWithInt:buttonTag]];
                });
                //NSLog(@"myDelegate.wishlistItems is %d",myDelegate.wishlistItems);
                myDelegate.wishlistItems++;
                [self updateBadge];
            }
            if (objProductModel.isAddedToWishlist)
            {
                [cell.addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_selected_full.png"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_full.png"] forState:UIControlStateNormal];
            }
            
        }
        else if (tabTracker==2)
        {
            productId=[[restockDataArray objectAtIndex:buttonTag ]productId];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:buttonTag inSection:0];
            HomeCollectionViewCell * cell = (HomeCollectionViewCell *)[self.productListingCollectionView cellForItemAtIndexPath:indexPath];
            [cell.addToWishlistLoader startAnimating];
            ProductListingDataModel *objProductModel = [restockDataArray objectAtIndex:buttonTag];
            
            [restockDataArray replaceObjectAtIndex:buttonTag withObject:objProductModel];
            if ([[restockDataArray objectAtIndex:buttonTag] isAddedToWishlist])
            {
                if ([UserDefaultManager getValue:@"productDetailDict"]!=nil)
                {
                    [UserDefaultManager removeValue:@"productDetailDict"];
                    [UserDefaultManager removeValue:@"CurrentView"];
                    
                   // NSLog(@"product already added to wishlist");
                    
                    
                }
                else
                {
                    
                    objProductModel.isAddedToWishlist = false;
                    [restockDataArray replaceObjectAtIndex:buttonTag withObject:objProductModel];
                    [cell.addToWishlistButton setSelected:NO];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                             (unsigned long)NULL), ^(void) {
                        [self removeFromWishlistWebservice:[NSNumber numberWithInt:buttonTag]];
                    });
                    NSLog(@"myDelegate.wishlistItems is %d",myDelegate.wishlistItems);
                    myDelegate.wishlistItems--;
                    [self updateBadge];
                }
                
            }
            else
            {
                
                
                objProductModel.isAddedToWishlist = true;
                [restockDataArray replaceObjectAtIndex:buttonTag withObject:objProductModel];
                [cell.addToWishlistButton setSelected:YES];
                
                [UserDefaultManager removeValue:@"productDetailDict"];
                [UserDefaultManager removeValue:@"CurrentView"];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                         (unsigned long)NULL), ^(void) {
                    [self addToWishlistWebservice:[NSNumber numberWithInt:buttonTag]];
                });
                NSLog(@"myDelegate.wishlistItems is %d",myDelegate.wishlistItems);
                myDelegate.wishlistItems++;
                [self updateBadge];
            }
            if (objProductModel.isAddedToWishlist)
            {
                [cell.addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_selected_full.png"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_full.png"] forState:UIControlStateNormal];
            }
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1)
    {
        [myDelegate ShowIndicator];
        [self performSelector:@selector(whatsNewWebservice) withObject:nil afterDelay:.1];
        
    }
    else if (alertView.tag==2)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
        
        myDelegate.window.rootViewController = myDelegate.navigationController;
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
    return whatsNewDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section]; //first get total rows in that section by current indexPath.
    if (indexPath.row == 0)
    {
        if ([UIScreen mainScreen].bounds.size.height > 568.0)
        {
            return 500;
        }
        else
        {
            return 400;
        }
    }
    else
    {
        if ([UIScreen mainScreen].bounds.size.height > 568.0)
        {
            return 300;
        }
        else
        {
            return 200;
        }
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [myDelegate StopIndicator];
                   });
    
    
    NSString *simpleTableIdentifier = @"WhatsNewCell";
    WhatsNewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[WhatsNewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    [cell displayData:[whatsNewDataArray objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiscoverDataModel *dataModel = [whatsNewDataArray objectAtIndex:indexPath.row];
    
    if ([dataModel.type isEqualToString:@"category"])
    {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProductListViewController *objProductView =[storyboard instantiateViewControllerWithIdentifier:@"ProductListViewController"];
        objProductView.categoryId =dataModel.productId;
        objProductView.navigationTitle = dataModel.title;
        [self.navigationController pushViewController:objProductView animated:YES];
    }
    else
    {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BuildGiftViewController *objbuildGiftView =[storyboard instantiateViewControllerWithIdentifier:@"BuildGiftViewController"];
        objbuildGiftView.productId =dataModel.productId;
        objbuildGiftView.title = dataModel.title;
        objbuildGiftView.imageUrl =dataModel.imageUrl;
        [self.navigationController pushViewController:objbuildGiftView animated:YES];
    }
}

#pragma mark - end

#pragma mark - UICollectionView methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (tabTracker==1)
    {
        return bestsellersDataArray.count;
    }
    else{
        return restockDataArray.count;
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    HomeCollectionViewCell *myCell = [self.productListingCollectionView
                                      dequeueReusableCellWithReuseIdentifier:@"Cell"
                                      forIndexPath:indexPath];
    
    [myCell layoutView:myCell.contentView.frame index:(int)indexPath.row];
    
    
    
    
    if (tabTracker == 1)
    {
        [myCell displayData:[bestsellersDataArray objectAtIndex:indexPath.row]];
    }
    else if(tabTracker==2)
    {
        [myCell displayRestockedData:[restockDataArray objectAtIndex:indexPath.row]];
        
    }
    myCell.addToWaitlistBtn.tag = indexPath.row;
    [myCell.addToWaitlistBtn addTarget:self action:@selector(addTowaitListAction:) forControlEvents:UIControlEventTouchUpInside];
    myCell.addToWishlistButton.tag=indexPath.row;
    CGAffineTransform transform = CGAffineTransformMakeScale(0.7f, 0.7f);
    myCell.addToWishlistLoader.transform = transform;
    [myCell.addToWishlistButton addTarget:self action:@selector(addToWishlist:) forControlEvents:UIControlEventTouchDown];
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
        [timer invalidate];
        ProductListingDataModel * objProductModel;
        if (tabTracker == 1)
        {
            
            objProductModel = [bestsellersDataArray objectAtIndex:index];
        }
        else if(tabTracker==2)
        {
            objProductModel = [restockDataArray objectAtIndex:index];
            
        }
        
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
        if (productListingCollectionView.contentOffset.y == productListingCollectionView.contentSize.height - scrollView1.frame.size.height)
        {
            if (tabTracker==1 && bestsellersDataArray.count<totalNoOfRecords)
            {
                paginationView.hidden=NO;
                [self performSelector:@selector(bestSellerWebservice) withObject:nil afterDelay:.1];
                
            }
            else if (tabTracker ==2 && restockDataArray.count<totalNoOfRecords)
            {
                paginationView.hidden=NO;
                [self performSelector:@selector(restockWebservice) withObject:nil afterDelay:.1];
            }
        }
    }
    
}
-(void)hideactivityIndicator
{
    paginationView.hidden=YES;
    [productListingCollectionView reloadData];
}

#pragma mark - end


#pragma mark - Button actions
- (IBAction)sortByButtonAction:(id)sender
{
    
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SortByViewController *objSortView =[storyboard instantiateViewControllerWithIdentifier:@"SortByViewController"];
    objSortView.objHomeView = self;
    objSortView.isHomeScreen =true;
    objSortView.sortBySelectedArray = sortBySelectedArray;
    objSortView.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1f];
    [objSortView setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:objSortView animated: YES completion:nil];
    
}

- (IBAction)whatsNewButtonAction:(id)sender
{
    [whatsNewDataArray removeAllObjects];
    [whatsNewTableView reloadData];
    sortByBtn.hidden =YES;
    tabTracker = 0;
    [whatsNewButton setSelected:YES];
    [bestsellersButton setSelected:NO];
    [saleButton setSelected:NO];
    productListingCollectionView.hidden = YES;
    whatsNewTableView.hidden = NO;
    [whatsNewButton addBorder:whatsNewButton color:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:108.0/255.0 alpha:1.0]];
    [bestsellersButton addBorder:bestsellersButton color:[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0]];
    [saleButton addBorder:saleButton color:[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0]];
    [whatsNewButton setTitleColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:108.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    [whatsNewButton setTitleColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:108.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [bestsellersButton setTitleColor:[UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [ saleButton setTitleColor:[UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [myDelegate ShowIndicator];
    [self performSelector:@selector(whatsNewWebservice) withObject:nil afterDelay:.1];
}

- (IBAction)bestsellersButtonAction:(id)sender
{
    sortByBtn.hidden =NO;
    tabTracker = 1;
    productListingCollectionView.hidden = NO;
    whatsNewTableView.hidden = YES;
    [bestsellersButton setSelected:YES];
    [whatsNewButton setSelected:NO];
    [saleButton setSelected:NO];
    pageNumber =1;
    [bestsellersDataArray removeAllObjects];
    [productListingCollectionView reloadData];
    [bestsellersButton addBorder:bestsellersButton color:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:108.0/255.0 alpha:1.0]];
    [whatsNewButton addBorder:whatsNewButton color:[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0]];
    [saleButton addBorder:saleButton color:[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0]];
    [bestsellersButton setTitleColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:108.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    [bestsellersButton setTitleColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:108.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [whatsNewButton setTitleColor:[UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [saleButton setTitleColor:[UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [myDelegate ShowIndicator];
    [self performSelector:@selector(bestSellerWebservice) withObject:nil afterDelay:.1];
}
- (IBAction)saleButtonAction:(id)sender
{
    sortByBtn.hidden =NO;
    tabTracker = 2;
    [bestsellersButton setSelected:NO];
    [whatsNewButton setSelected:NO];
    [saleButton setSelected:YES];
    pageNumber =1;
    [restockDataArray removeAllObjects];
    productListingCollectionView.hidden = NO;
    whatsNewTableView.hidden = YES;
    [productListingCollectionView reloadData];
    [saleButton addBorder:saleButton color:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:108.0/255.0 alpha:1.0]];
    [bestsellersButton addBorder:bestsellersButton color:[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0]];
    [whatsNewButton addBorder:whatsNewButton color:[UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0]];
    
    [saleButton setTitleColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:108.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    [saleButton setTitleColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:108.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    
    [whatsNewButton setTitleColor:[UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [ bestsellersButton setTitleColor:[UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [myDelegate ShowIndicator];
    [self performSelector:@selector(restockWebservice) withObject:nil afterDelay:.1];
    
}
-(void)addTowaitListAction :(id)sender
{
    if (tabTracker==1)
    {
        productId=[[bestsellersDataArray objectAtIndex:[sender tag] ]productId];
        
    }
    else
    {
        productId=[[restockDataArray objectAtIndex:[sender tag] ]productId];
        
    }
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
    waitlistMailField.text = [waitlistMailField.text stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceCharacterSet]];
    waitlistNameField.text = [waitlistNameField.text stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceCharacterSet]];
    
    if ([waitlistNameField.text isEqualToString:@""])
    {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //            [alert show];
        //        });
        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter your name" parentView:self.view];
       // [self.view makeToast:@"Please enter your name" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        return;
    }
    else if ([waitlistMailField.text isEqualToString:@""])
    {
        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter your email address" parentView:self.view];
      //  [self.view makeToast:@"Please enter your email address" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
        return;
    }
    [waitlistNameField resignFirstResponder];
    [waitlistMailField resignFirstResponder];
    [myDelegate ShowIndicator];
    [self performSelector:@selector(addtoWaitlistService) withObject:nil afterDelay:.5];
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
- (IBAction)cartButtonClicked:(id)sender {
    
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
    
    
    //    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    J2TRewardsViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"J2TRewardsViewController"];
    //    [self.navigationController pushViewController:view animated:YES];
    
}
@end
