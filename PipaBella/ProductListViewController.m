//
//  ProductListViewController.m
//  PipaBella
//
//  Created by Ranosys on 17/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "ProductListViewController.h"
#import "ProductListCollectionViewCell.h"
#import "ProductService.h"
#import "SortByViewController.h"
#import "ProductDetailViewController.h"
#import "CartViewController.h"
#import "WaitlistViewController.h"
#import "BannerCell.h"
#import "SortByCell.h"
#define kCellsPerRow 2


@interface ProductListViewController ()<UIGestureRecognizerDelegate>{
    
    int buttonTag;
    int totalNoOfRecords;
    //Sort by sending params
    NSString * priceOrder;
    NSString * WhatsNewOrder;
    NSString * inStockOrder;
    int wishlistCounter;
    UIView *mainView;
    
    __weak IBOutlet UIButton *cartBtn;
    __weak IBOutlet UITextField *waitlistNameField;
    __weak IBOutlet UITextField *waitlistMailField;
    __weak IBOutlet UIButton *saveBtn;
    __weak IBOutlet UIView *waitlistContainerView;
    int alertCount;
    NSTimer * timer;
    
    __weak IBOutlet UILabel *noRecordLbl;
    UIButton *button;
    UIButton *button1;
    UIBarButtonItem *barButton,*barButton1,*barButton2;
}
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *productListCollectionView;
@property (weak, nonatomic) IBOutlet UIView *paginationView;


@property(nonatomic,strong)NSString *productId;

//@property(nonatomic, strong) NSString *Offset;
//@property(nonatomic, strong) NSString *pageNumber;
@end

@implementation ProductListViewController
@synthesize bannerImageView,productListCollectionView,paginationView;
@synthesize categoryId,productId,navigationTitle;
@synthesize sortbyColor;
@synthesize sortByinStock;
@synthesize sortByPrice;
@synthesize sortByWhatsNew;
@synthesize colorString;
@synthesize productDataArray;
@synthesize pageNumber;
@synthesize sortBySelectedArray;
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    if ([UserDefaultManager getValue:@"productDetailDict"]!=nil)
    {
        NSDictionary *dict=[UserDefaultManager getValue:@"productDetailDict"];
        self.navigationItem.title=[dict objectForKey:@"navigationTitle"];
    }
    else
    {
        self.navigationItem.title= navigationTitle;
    }
    priceOrder = @"";
    WhatsNewOrder =@"";
    inStockOrder =@"";
    sortbyColor =@"";
    wishlistCounter = 0;
    
    [self setViewFrame];
    mainView.hidden = YES;
    
    
    sortBySelectedArray = [[NSMutableArray alloc]initWithObjects:@"N",@"N",@"N",@"N", nil];
    
    bannerImageView.contentMode = UIViewContentModeScaleAspectFit;
    bannerImageView.clipsToBounds = NO;
    bannerImageView.autoresizingMask =
    ( UIViewAutoresizingFlexibleBottomMargin
     | UIViewAutoresizingFlexibleHeight
     | UIViewAutoresizingFlexibleLeftMargin
     | UIViewAutoresizingFlexibleRightMargin
     | UIViewAutoresizingFlexibleTopMargin
     | UIViewAutoresizingFlexibleWidth );
    
    self.productListCollectionView.translatesAutoresizingMaskIntoConstraints=YES;
    self.productListCollectionView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.height-100);
    
    //setting collection view cell size according to iPhone screens
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.productListCollectionView.collectionViewLayout;
    CGFloat availableWidthForCells = CGRectGetWidth(self.view.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow -1);
    CGFloat cellWidth = (availableWidthForCells / kCellsPerRow);
    flowLayout.itemSize = CGSizeMake(cellWidth, flowLayout.itemSize.height);
    
    
    paginationView.hidden=YES;
    
    // Offset=@"1";
    pageNumber = 1;
    [saveBtn addBorder:saveBtn color:[UIColor colorWithRed:132.0/255.0 green:132.0/255.0 blue:132.0/255.0 alpha:1.0]];
    productDataArray=[[NSMutableArray alloc]init];
    // sortByListArray=[[NSMutableArray alloc]initWithObjects:@"PRICE",@"COLOR",@"WHAT'S NEW",@"IN STOCK", nil];
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
    [self addNavigationItem];
    
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
    [button1 setImage:[UIImage imageNamed:@"sorticon"] forState:UIControlStateNormal];
    //    [button1 setImage:[UIImage imageNamed:@"product_detail_heart_full.png"] forState:UIControlStateSelected];
    //[button1 setBackgroundColor:[UIColor yellowColor] ];
    [button1 setImageEdgeInsets:UIEdgeInsetsMake(0.0, 7.0, 0.0, -7.0)];
    barButton1 =[[UIBarButtonItem alloc] initWithCustomView:button1];
    [button1 addTarget:self action:@selector(sortByButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:barButton,barButton1,nil];
}

- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    waitlistContainerView.hidden = YES;
    [waitlistNameField resignFirstResponder];
    [waitlistMailField resignFirstResponder];
}

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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [NSTimer scheduledTimerWithTimeInterval:.1
                                     target:self
                                   selector:@selector(showLoader)
                                   userInfo:nil
                                    repeats:NO];
    [super viewWillAppear:animated];
}
-(void)showLoader
{
    [myDelegate ShowIndicator];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [Localytics tagScreen:@"Product Listing View"];
    alertCount =0;
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
    [productDataArray removeAllObjects];
    [productListCollectionView reloadData];
    priceOrder = @"";
    [self setParameters];
    
    
    if ([UserDefaultManager getValue:@"productDetailDict"]!=nil)
    {
        NSDictionary *dict=[UserDefaultManager getValue:@"productDetailDict"];
        categoryId=[dict objectForKey:@"categoryId"];
    }
    
    
    [self performSelector:@selector(productListWebservice) withObject:nil afterDelay:.1];
    
    
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    if(!([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
    {
        [UserDefaultManager removeValue:@"productDetailDict"];
        [UserDefaultManager removeValue:@"CurrentView"];
    }
    
    
    [UIView animateWithDuration:0.6f animations:^{
        
        mainView.hidden = YES;
        
    }];
    
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
#pragma mark - end


#pragma mark - UICollectionView methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    else
    {
        return productDataArray.count;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section  == 0)
    {
        
        return CGSizeMake(self.view.frame.size.width, 130);
        
    }
    else
    {
        //        return CGSizeMake(self.view.frame.size.width/2, 215);
        return CGSizeMake(self.view.frame.size.width/2, 280);
        
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==0)
    {
        
        [self.productListCollectionView registerClass:[BannerCell class] forCellWithReuseIdentifier:@"BannerCell"];
        BannerCell*bannerCell=(BannerCell*)[self.productListCollectionView
                                            dequeueReusableCellWithReuseIdentifier:@"BannerCell"
                                            forIndexPath:indexPath];
        if(bannerCell==nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"BannerCell" owner:self options:nil] ;
            
        }
        if (productDataArray.count>0)
        {
            for (UIView *subView in bannerCell.contentView.subviews)
            {
                [subView removeFromSuperview];
            }
            NSLog(@"%@",[[productDataArray objectAtIndex:0] categoryImage]);
            
            UIImageView *bannerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, bannerCell.contentView.frame.size.width, 128)];
            bannerImage.contentMode = UIViewContentModeScaleAspectFit;
            [bannerCell.contentView addSubview:bannerImage];
            [bannerImage setImageWithURL:[NSURL URLWithString:[[productDataArray objectAtIndex:0] categoryImage]]
                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
             {
                 //                 bannerImage.contentMode = UIViewContentModeScaleToFill;
                 bannerImage.clipsToBounds = NO;
                 bannerImage.autoresizingMask =
                 ( UIViewAutoresizingFlexibleBottomMargin
                  | UIViewAutoresizingFlexibleHeight
                  | UIViewAutoresizingFlexibleLeftMargin
                  | UIViewAutoresizingFlexibleRightMargin
                  | UIViewAutoresizingFlexibleTopMargin
                  | UIViewAutoresizingFlexibleWidth );
                 
             }];
            [bannerImage sd_setImageWithURL:[NSURL URLWithString:[[productDataArray objectAtIndex:0] categoryImage]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        }
        
        bannerCell.backgroundColor = [UIColor clearColor];
        return bannerCell;
    }
    //    else if (indexPath.section==1)
    //    {
    //
    //        [self.productListCollectionView registerClass:[BannerCell class] forCellWithReuseIdentifier:@"SortByCell"];
    //        SortByCell*bannerCell=(SortByCell*)[self.productListCollectionView
    //                                            dequeueReusableCellWithReuseIdentifier:@"SortByCell"
    //                                            forIndexPath:indexPath];
    //        if(bannerCell==nil)
    //        {
    //            [[NSBundle mainBundle] loadNibNamed:@"SortByCell" owner:self options:nil];
    //        }
    //
    //
    //        bannerCell.backgroundColor = [UIColor clearColor];
    //
    //        UIButton * sortByButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 7, bannerCell.contentView.frame.size.width, bannerCell.contentView.frame.size.height)];
    //        [sortByButton.titleLabel setFont:[UIFont systemFontOfSize:12 weight:UIFontWeightLight]];
    //        [sortByButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //        [sortByButton setImage:[UIImage imageNamed:@"sort"] forState:UIControlStateNormal];
    //        [sortByButton addTarget:self action:@selector(sortByAction:) forControlEvents:UIControlEventTouchUpInside];
    //        [bannerCell.contentView addSubview:sortByButton];
    //        return bannerCell;
    //
    //    }
    else
    {
        
        ProductListCollectionViewCell *myCell = [self.productListCollectionView
                                                 dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                 forIndexPath:indexPath];
        [myCell layoutView:myCell.frame index:(int)indexPath.row];
        [myCell displayData:[productDataArray objectAtIndex:indexPath.row]];
        // NSLog(@"totalproducts are----------------------------%d",[[[productDataArray objectAtIndex:indexPath.row] totalProducts]intValue]);
        myCell.addToWishlistButton.Tag=(int)indexPath.row;
        myCell.addToWishlistButton.section=(int)indexPath.section;
        myCell.addToWaitlistBtn.tag = indexPath.row;
        [myCell.addToWaitlistBtn addTarget:self action:@selector(addTowaitListAction:) forControlEvents:UIControlEventTouchUpInside];
        [myCell.addToWishlistButton addTarget:self action:@selector(addToWishlist:) forControlEvents:UIControlEventTouchDown];
        return myCell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return;
    }
    alertCount = (int)indexPath.row;
    timer = [NSTimer scheduledTimerWithTimeInterval:.1
                                             target:self
                                           selector:@selector(goToProductDetail)
                                           userInfo:nil
                                            repeats:YES];
}
-(void)sortByAction:(id)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SortByViewController *objSortView =[storyboard instantiateViewControllerWithIdentifier:@"SortByViewController"];
    objSortView.objProductListing = self;
    objSortView.sortBySelectedArray = sortBySelectedArray;
    objSortView.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1f];
    [objSortView setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    [self presentViewController:objSortView animated: YES completion:nil];
    
}
-(void)goToProductDetail
{
    if (wishlistCounter==0)
    {
        [timer invalidate];
        ProductListingDataModel * objProductModel = [productDataArray objectAtIndex:alertCount];
        ProductDetailViewController * objProductDetail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
        objProductDetail.productId = objProductModel.productId;
        objProductDetail.productName = objProductModel.productName;
        objProductDetail.isInStock = objProductModel.isInStock;
        objProductDetail.isAddedtoWishlist =objProductModel.isAddedToWishlist;
        objProductDetail.stockQuantity = [objProductModel.stockQuantity intValue];
        NSLog(@"bool is %d",objProductDetail.isAddedtoWishlist);
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
        if (productListCollectionView.contentOffset.y == productListCollectionView.contentSize.height - scrollView1.frame.size.height)
        {
            if (productDataArray.count<totalNoOfRecords)
            {
                paginationView.hidden=NO;
                [self performSelector:@selector(productListWebservice) withObject:nil afterDelay:.1];
                
            }
        }
    }
    
}
-(void)hideactivityIndicator
{
    paginationView.hidden=YES;
    [productListCollectionView reloadData];
}

#pragma mark - end
#pragma mark - Webservices
-(void)productListWebservice
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
                                    for (int i=0; i<tempArray.count; i++)
                                    {
                                        [productDataArray addObject:[tempArray objectAtIndex:i]];
                                    }
                                    if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
                                    {
                                        [myDelegate StopIndicator];
                                        productDataArray = [UserDefaultManager wishListcomparision:productDataArray];
                                        [productListCollectionView reloadData];
                                        if (productDataArray.count<1)
                                        {
                                            return;
                                        }
                                        [self hideactivityIndicator];
                                        // code here
                                        [bannerImageView sd_setImageWithURL:[NSURL URLWithString:[[productDataArray objectAtIndex:0] categoryImage]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                                        NSLog(@"%@",[[productDataArray objectAtIndex:0] categoryImage]);
                                        totalNoOfRecords = [[[productDataArray objectAtIndex:0] totalProducts]intValue];
                                        pageNumber++;
                                        NSLog(@"%d",[[[productDataArray objectAtIndex:0] totalProducts]intValue]);
                                        [productListCollectionView reloadData];
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
                 wishlistCounter--;
                 if (data != nil)
                 {
                     
                     
                     
                 }
                 else
                 {
                     
                     NSIndexPath *indexPath=[NSIndexPath indexPathForRow:buttonTag inSection:0];
                     ProductListCollectionViewCell * cell = (ProductListCollectionViewCell *)[self.productListCollectionView cellForItemAtIndexPath:indexPath];
                     [cell.addToWishlistButton setSelected:NO];
                     [cell.addToWishlistLoader stopAnimating];
                     cell.addToWishlistLoader.hidden = YES;
                     
                     if (alertCount==0)
                     {
                         
                         UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                         //[alert1 show];
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
-(void)getMyWishlist
{
    
    [[ProductService sharedManager] getWishlist:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(),^
                        {
                            [myDelegate StopIndicator];
                            productDataArray = [UserDefaultManager wishListcomparision:productDataArray];
                            [productListCollectionView reloadData];
                            if (productDataArray.count<1)
                            {
                                return;
                            }
                            [self hideactivityIndicator];
                            NSString *catImageString;
                            if ([[productDataArray objectAtIndex:0] categoryImage] == nil)
                            {
                                catImageString = @"";
                            }
                            else
                            {
                                catImageString =[[productDataArray objectAtIndex:0] categoryImage];
                            }
                            [bannerImageView sd_setImageWithURL:[NSURL URLWithString:[[productDataArray objectAtIndex:0] categoryImage]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                            NSLog(@"%@",[[productDataArray objectAtIndex:0] categoryImage]);
                            totalNoOfRecords = [[[productDataArray objectAtIndex:0] totalProducts]intValue];
                            pageNumber++;
                            NSLog(@"%d",[[[productDataArray objectAtIndex:0] totalProducts]intValue]);
                            myDelegate.wishlistItems =(int)[[UserDefaultManager getValue:@"wishListData"] count];
                            
                            if ([UserDefaultManager getValue:@"productDetailDict"]!=nil)
                            {
                                NSDictionary *dict=[UserDefaultManager getValue:@"productDetailDict"];
                                buttonTag=[[dict objectForKey:@"objectIndex"]intValue];
                                [self addproductToWishlist:buttonTag];
                            }
                            
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
    if (myDelegate.wishlistItems<1)
    {
        [[self.tabBarController.tabBar.items objectAtIndex:2] setCustomBadgeValue:nil withFont:nil andFontColor:[UIColor whiteColor] andBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        [[self.tabBarController.tabBar.items objectAtIndex:2] setCustomBadgeValue:[NSString stringWithFormat:@"%lu",(unsigned long)myDelegate.wishlistItems] withFont:[UIFont systemFontOfSize:8 weight:UIFontWeightRegular] andFontColor:[UIColor whiteColor] andBackgroundColor:[UIColor colorWithRed:60.0/255.0 green:171.0/225.0 blue:233.0/255.0 alpha:1.0]];
        
        
    }
    
}
-(void)addtoWaitlistService
{
    NSLog(@"mail add is %@",[UserDefaultManager getValue:@"userEmail"]);
    
    [[ProductService sharedManager] addTowaitList:productId name:[UserDefaultManager getValue:@"customer_name"] email:[UserDefaultManager getValue:@"userEmail"] success:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            if (data != nil)
                            {
                                [myDelegate StopIndicator];
                                [self handleTap:nil];
                                //                                waitlistMailField.text =@"";
                                //                                waitlistNameField.text=@"";
                                
                                if ([[data objectForKey:@"status"] isEqualToString:@"1"])
                                {
                                    MozTopAlertView *alertView = [MozTopAlertView showWithType:MozAlertTypeSuccess text:[data objectForKey:@"message"] parentView:self.view];
                                    alertView.dismissBlock = ^(){
                                        NSLog(@"dismissBlock");
                                    };
                                   // [self.view makeToast:[data objectForKey:@"message"] image:[UIImage imageNamed:@"sign.png"] color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
                                }
                                else
                                {
                                    [MozTopAlertView showWithType:MozAlertTypeWarning text:[data objectForKey:@"message"] doText:nil doBlock:^{
                                        
                                    } parentView:self.view];
                                    //[self.view makeToast:[data objectForKey:@"message"] image:[UIImage imageNamed:@"excl.png"] color:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]];
                                }
                                
                                //                                dispatch_async(dispatch_get_main_queue(), ^{
                                //                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:[data objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                //                                    [alert show];
                                //                                });
                                
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
                 wishlistCounter--;
                 if (data != nil)
                 {
                     
                     
                 }
                 else
                 {
                     
                     NSIndexPath *indexPath=[NSIndexPath indexPathForRow:buttonTag inSection:0];
                     ProductListCollectionViewCell * cell = (ProductListCollectionViewCell *)[self.productListCollectionView cellForItemAtIndexPath:indexPath];
                     [cell.addToWishlistButton setSelected:NO];
                     [cell.addToWishlistLoader stopAnimating];
                     cell.addToWishlistLoader.hidden = YES;
                     if (alertCount==0)
                     {
                         
                         UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                         //[alert1 show];
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


#pragma mark - end

#pragma mark - Button actions

- (IBAction)addToWishlist:(MyButton*)sender
{
    
    NSLog(@"tag is %d and section is %d",[sender Tag],[sender section]);
    buttonTag = (int)[sender Tag];
    
    [self addproductToWishlist:buttonTag];
    
    //    wishlistCounter++;
    //    if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL)) {
    //        //        dispatch_async(dispatch_get_main_queue(), ^{
    //        //            UIAlertiVew *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"You need to login first." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //        //            alert.tag=1;
    //        //            [alert show];
    //        //        });
    //
    //        myDelegate.istoast = true;
    //        if([[UIScreen mainScreen] bounds].size.height>480)
    //        {
    //            myDelegate.toastMessage = @"SIGN IN to add products to your wishlist";
    //        }else{
    //            myDelegate.toastMessage = @"SIGN IN to add products to your wishlist";
    //        }
    //
    //        //  myDelegate.toastMessage = @"SIGN IN to add products to your wishlist            X";
    //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //        myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
    //        myDelegate.window.rootViewController = myDelegate.navigationController;
    //    }
    //    else
    //    {
    //        productId=[[productDataArray objectAtIndex:[sender Tag] ]productId];
    //        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[sender Tag] inSection:2];
    //        ProductListCollectionViewCell * cell = (ProductListCollectionViewCell *)[self.productListCollectionView cellForItemAtIndexPath:indexPath];
    //        ProductListingDataModel *objProductModel = [productDataArray objectAtIndex:[sender Tag]];
    //        if ([[productDataArray objectAtIndex:buttonTag] isAddedToWishlist])
    //        {
    //            [cell.addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_full.png"] forState:UIControlStateNormal];
    //            objProductModel.isAddedToWishlist = false;
    //            [cell.addToWishlistButton setSelected:NO];
    //            myDelegate.wishlistItems--;
    //            [self updateBadge];
    //            [self performSelector:@selector(removeFromWishlistWebservice:) withObject:[NSNumber numberWithInt:buttonTag] afterDelay:.1];
    //
    //        }
    //        else
    //        {
    //            [cell.addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_selected_full.png"] forState:UIControlStateNormal];
    //            objProductModel.isAddedToWishlist = true;
    //            [cell.addToWishlistButton setSelected:YES];
    //            //[myDelegate ShowIndicator];
    //            myDelegate.wishlistItems++;
    //            [self updateBadge];
    //            [self performSelector:@selector(addToWishlistWebservice:) withObject:[NSNumber numberWithInt:buttonTag] afterDelay:.1];
    //        }
    //        [productListCollectionView reloadData];
    //    }
    
}
-(void)addproductToWishlist:(int)tag
{
    buttonTag=tag;
    
    wishlistCounter++;
    if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
    {
        NSDictionary *productDetailDict=[NSDictionary new];
        myDelegate.istoast = true;
        if([[UIScreen mainScreen] bounds].size.height>480)
        {
            myDelegate.toastMessage = @"SIGN IN to add products to your wishlist";
        }else{
            myDelegate.toastMessage = @"SIGN IN to add products to your wishlist";
        }
        productId=[[productDataArray objectAtIndex:buttonTag ]productId];
        
        productDetailDict = @{@"productId":productId,@"objectIndex":[NSString stringWithFormat:@"%d",buttonTag],@"categoryId":categoryId,@"navigationTitle":navigationTitle};
        
        [UserDefaultManager setValue:productDetailDict key:@"productDetailDict"];
        [UserDefaultManager setValue:@"ProductListViewController" key:@"CurrentView"];
        
        NSLog(@"productDetailDict = %@ ,Current View = %@ ",[UserDefaultManager getValue:@"productDetailDict"],[UserDefaultManager getValue:@"CurrentView"]);
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
        myDelegate.window.rootViewController = myDelegate.navigationController;
    }
    else
    {
        productId=[[productDataArray objectAtIndex:tag ]productId];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:tag inSection:2];
        ProductListCollectionViewCell * cell = (ProductListCollectionViewCell *)[self.productListCollectionView cellForItemAtIndexPath:indexPath];
        ProductListingDataModel *objProductModel = [productDataArray objectAtIndex:tag];
        if ([[productDataArray objectAtIndex:buttonTag] isAddedToWishlist])
        {
            if ([UserDefaultManager getValue:@"productDetailDict"]!=nil)
            {
                [UserDefaultManager removeValue:@"productDetailDict"];
                [UserDefaultManager removeValue:@"CurrentView"];
                
                NSLog(@"product already added to wishlist");
                
                
            }
            else
            {
                NSLog(@"******");
                
                
                [cell.addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_full.png"] forState:UIControlStateNormal];
                objProductModel.isAddedToWishlist = false;
                [cell.addToWishlistButton setSelected:NO];
                myDelegate.wishlistItems--;
                [self updateBadge];
                [self performSelector:@selector(removeFromWishlistWebservice:) withObject:[NSNumber numberWithInt:buttonTag] afterDelay:.1];
            }
            
            
        }
        else
        {
            [cell.addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_selected_full.png"] forState:UIControlStateNormal];
            objProductModel.isAddedToWishlist = true;
            [cell.addToWishlistButton setSelected:YES];
            //[myDelegate ShowIndicator];
            myDelegate.wishlistItems++;
            [self updateBadge];
            
            [UserDefaultManager removeValue:@"productDetailDict"];
            [UserDefaultManager removeValue:@"CurrentView"];
            
            [self performSelector:@selector(addToWishlistWebservice:) withObject:[NSNumber numberWithInt:buttonTag] afterDelay:.1];
        }
        [productListCollectionView reloadData];
    }
    
    
}
-(void)addTowaitListAction :(id)sender
{
    productId=[[productDataArray objectAtIndex:[sender tag] ]productId];
    
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
    //    waitlistMailField.text = [waitlistMailField.text stringByTrimmingCharactersInSet:
    //                              [NSCharacterSet whitespaceCharacterSet]];
    //    waitlistNameField.text = [waitlistNameField.text stringByTrimmingCharactersInSet:
    //                              [NSCharacterSet whitespaceCharacterSet]];
    //
    //    if ([waitlistNameField.text isEqualToString:@""])
    //    {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //            [alert show];
    //        });
    //        return;
    //    }
    //    else if ([waitlistMailField.text isEqualToString:@""])
    //    {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //            [alert show];
    //        });
    //        return;
    //    }
    //    [waitlistNameField resignFirstResponder];
    //    [waitlistMailField resignFirstResponder];
    //    [myDelegate ShowIndicator];
    //    [self performSelector:@selector(addtoWaitlistService) withObject:nil afterDelay:.5];
}

- (IBAction)sortByButtonAction:(id)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SortByViewController *objSortView =[storyboard instantiateViewControllerWithIdentifier:@"SortByViewController"];
    objSortView.objProductListing = self;
    objSortView.sortBySelectedArray = sortBySelectedArray;
    objSortView.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1f];
    [objSortView setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    [self presentViewController:objSortView animated: YES completion:nil];
    
    
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
