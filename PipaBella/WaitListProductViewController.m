//
//  WaitListProductViewController.m
//  PipaBella
//
//  Created by Monika on 2/4/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "WaitListProductViewController.h"
#import "WaitlistCollectionViewCell.h"
#import "ProductService.h"
#import "WaitlistViewController.h"
#import "ProductDetailViewController.h"
#define kCellsPerRow 2

@interface WaitListProductViewController ()
{
    NSMutableArray *productDataArray;
    int buttonTag;
    int wishlistCounter;
    int alertCount;

    __weak IBOutlet UILabel *norecordLbl;
}
@property(nonatomic,strong)NSString *productId;

@property (weak, nonatomic) IBOutlet UICollectionView *waitListCollectionView;

@end

@implementation WaitListProductViewController
@synthesize productId;
@synthesize mailId;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"WAITLIST";
    wishlistCounter = 0;

    //setting collection view cell size according to iPhone screens
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.waitListCollectionView.collectionViewLayout;
    CGFloat availableWidthForCells = CGRectGetWidth(self.view.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow -1);
    CGFloat cellWidth = (availableWidthForCells / kCellsPerRow);
    flowLayout.itemSize = CGSizeMake(cellWidth, flowLayout.itemSize.height);
    
    if(!(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL)))
    {
        mailId = [UserDefaultManager getValue:@"userEmail"];
    }
    productDataArray=[[NSMutableArray alloc]init];
//    [myDelegate ShowIndicator];
//    [self performSelector:@selector(getWaitlistProductService) withObject:nil afterDelay:.1];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(!([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
    {
        [UserDefaultManager removeValue:@"CurrentView"];
    }
    [myDelegate ShowIndicator];
    [self performSelector:@selector(getWaitlistProductService) withObject:nil afterDelay:.1];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    alertCount =0;
   [productDataArray removeAllObjects];
    [self.waitListCollectionView reloadData];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    if(!([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
    {
        [UserDefaultManager removeValue:@"productDetailDict"];
        [UserDefaultManager removeValue:@"CurrentView"];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end
#pragma mark - UICollectionview methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return productDataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    WaitlistCollectionViewCell *myCell = [self.waitListCollectionView
                                          dequeueReusableCellWithReuseIdentifier:@"Cell"
                                          forIndexPath:indexPath];
    [myCell layoutView:myCell.frame index:(int)indexPath.row];
    [myCell displayData:[productDataArray objectAtIndex:indexPath.row]];
    myCell.addToWishlistButton.Tag=(int)indexPath.row;
    myCell.addToWishlistButton.section=(int)indexPath.section;
    [myCell.addToWishlistButton addTarget:self action:@selector(addToWishlist:) forControlEvents:UIControlEventTouchDown];
    return myCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductListingDataModel * objProductModel = [productDataArray objectAtIndex:indexPath.row];
//    ProductListingDataModel * objProductModel = [productDataArray objectAtIndex:alertCount];
    ProductDetailViewController * objProductDetail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
    objProductDetail.productId = objProductModel.productId;
    objProductDetail.productName = objProductModel.productName;
    objProductDetail.isInStock = @"0";
    objProductDetail.isInWaitlist = true;
    objProductDetail.isAddedtoWishlist =objProductModel.isAddedToWishlist;
    objProductDetail.stockQuantity = [objProductModel.stockQuantity intValue];
    NSLog(@"bool is %d",objProductDetail.isAddedtoWishlist);
    [self.navigationController pushViewController:objProductDetail animated:YES];
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
//        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[sender Tag] inSection:0];
//        WaitlistCollectionViewCell * cell = (WaitlistCollectionViewCell *)[self.waitListCollectionView cellForItemAtIndexPath:indexPath];
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
//            myDelegate.wishlistItems++;
//            [self updateBadge];
//            [self performSelector:@selector(addToWishlistWebservice:) withObject:[NSNumber numberWithInt:buttonTag] afterDelay:.1];
//        }
//        [self.waitListCollectionView reloadData];
//    }
    
}

-(void)addproductToWishlist:(int)tag
{
    wishlistCounter++;
    if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL)) {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            UIAlertiVew *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"You need to login first." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //            alert.tag=1;
        //            [alert show];
        //        });
        NSDictionary *productDetailDict=[NSDictionary new];
        
        myDelegate.istoast = true;
        if([[UIScreen mainScreen] bounds].size.height>480)
        {
            myDelegate.toastMessage = @"SIGN IN to add products to your wishlist";
        }else{
            myDelegate.toastMessage = @"SIGN IN to add products to your wishlist";
        }
        
        productId=[[productDataArray objectAtIndex:buttonTag ]productId];
        
        productDetailDict = @{@"productId":productId,@"objectIndex":[NSString stringWithFormat:@"%d",buttonTag]};
        
        [UserDefaultManager setValue:productDetailDict key:@"productDetailDict"];
        [UserDefaultManager setValue:@"WaitListProductViewController" key:@"CurrentView"];
        
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
        myDelegate.window.rootViewController = myDelegate.navigationController;
    }
    else
    {
        productId=[[productDataArray objectAtIndex:tag ]productId];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:tag inSection:0];
        WaitlistCollectionViewCell * cell = (WaitlistCollectionViewCell *)[self.waitListCollectionView cellForItemAtIndexPath:indexPath];
        ProductListingDataModel *objProductModel = [productDataArray objectAtIndex:tag];
        if ([[productDataArray objectAtIndex:buttonTag] isAddedToWishlist])
        {
            
            if ([UserDefaultManager getValue:@"productDetailDict"]!=nil)
            {
                [UserDefaultManager removeValue:@"productDetailDict"];
                [UserDefaultManager removeValue:@"CurrentView"];
                
                NSLog(@"added to wishlist");
            }
            else
            {

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
            [UserDefaultManager removeValue:@"productDetailDict"];
            [UserDefaultManager removeValue:@"CurrentView"];

            
            [cell.addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_selected_full.png"] forState:UIControlStateNormal];
            objProductModel.isAddedToWishlist = true;
            [cell.addToWishlistButton setSelected:YES];
            myDelegate.wishlistItems++;
            [self updateBadge];
            [self performSelector:@selector(addToWishlistWebservice:) withObject:[NSNumber numberWithInt:buttonTag] afterDelay:.1];
        }
        [self.waitListCollectionView reloadData];
    }
    
}
#pragma mark - end
#pragma mark - Webservices
-(void)getWaitlistProductService
{
    
    [[ProductService sharedManager] generalApiMyWaitListRequestParam:mailId success:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            if (data != nil)
                            {
                                
                                NSMutableArray *tempArray = (NSMutableArray *)data;
                                for (int i=0; i<tempArray.count; i++)
                                {
                                    [productDataArray addObject:[tempArray objectAtIndex:i]];
                                }
                                
                                if (productDataArray.count<1)
                                {
                                    norecordLbl.hidden = NO;
                                    self.waitListCollectionView.hidden = YES;
                                }
                                else
                                {
                                
                                    norecordLbl.hidden = YES;
                                    self.waitListCollectionView.hidden = NO;
                                }
                                
                                if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
                                {
                                    [myDelegate StopIndicator];
                                    productDataArray = [UserDefaultManager wishListcomparision:productDataArray];
                                    [self.waitListCollectionView reloadData];
                                    if (productDataArray.count<1)
                                    {
                                        return;
                                    }
                                    [self hideactivityIndicator];
                                    [self.waitListCollectionView reloadData];
                                    
                                }
                                else
                                {
                                    [self getMyWishlist];
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
                     WaitlistCollectionViewCell * cell = (WaitlistCollectionViewCell *)[self.waitListCollectionView cellForItemAtIndexPath:indexPath];
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
                            [self.waitListCollectionView reloadData];
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
//                            [bannerImageView sd_setImageWithURL:[NSURL URLWithString:[[productDataArray objectAtIndex:0] categoryImage]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
//                            NSLog(@"%@",[[productDataArray objectAtIndex:0] categoryImage]);
//                            totalNoOfRecords = [[[productDataArray objectAtIndex:0] totalProducts]intValue];
//                            pageNumber++;
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
                     WaitlistCollectionViewCell * cell = (WaitlistCollectionViewCell *)[self.waitListCollectionView cellForItemAtIndexPath:indexPath];
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

-(void)hideactivityIndicator
{
    [self.waitListCollectionView reloadData];
}

@end
