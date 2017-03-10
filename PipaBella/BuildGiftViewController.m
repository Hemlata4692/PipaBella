//
//  BuildGiftViewController.m
//  PipaBella
//
//  Created by Sumit on 06/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "BuildGiftViewController.h"
#import "ProductService.h"
#import "BuildGiftCell.h"
#import "BuildGiftModel.h"
#import "BuildGiftFinalViewController.h"
#define kCellPerRow 2
@interface BuildGiftViewController ()
{
    __weak IBOutlet UIView *stepBlock;
    __weak IBOutlet UILabel *setpLbl;
    __weak IBOutlet UILabel *stepDescLbl;
    __weak IBOutlet UIImageView *giftBanner;
    __weak IBOutlet UICollectionView *giftCollectionView;
    __weak IBOutlet UIPageControl *pageControl;
    BuildGiftModel * objBuildGift;
    NSMutableArray * GiftArray;
    
    int wishlistCounter;
    NSString * subProductId;
    
    NSMutableArray * mainSelectedDataArray;
    NSMutableArray * stepSelectedDataArray;
}

@end
@implementation BuildGiftViewController
@synthesize productId;
@synthesize imageUrl;
@synthesize stepCounter;

#pragma mark - View life cycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [giftCollectionView reloadData];
    if (stepCounter==0)
    {

    [NSTimer scheduledTimerWithTimeInterval:.1
                                     target:self
                                   selector:@selector(showLoader)
                                   userInfo:nil
                                    repeats:NO];
    }
    
}
-(void)showLoader
{
   [myDelegate ShowIndicator];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (stepCounter==0)
    {
        [mainSelectedDataArray removeAllObjects];
        [stepSelectedDataArray removeAllObjects];
        [GiftArray removeAllObjects];
        [giftCollectionView reloadData];
        
        
        if(!([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
        {
            if ([UserDefaultManager getValue:@"CurrentView"]!=nil)
            {
                [UserDefaultManager removeValue:@"CurrentView"];
                if ([UserDefaultManager getValue:@"productDetailDict"]!=nil)
                {
                    NSDictionary *dict=[UserDefaultManager getValue:@"productDetailDict"];
                    productId=[dict objectForKey:@"productId"];
                }
                
            }
        }
        
       
        [self performSelector:@selector(getBuildGiftData) withObject:nil afterDelay:.1];
    }
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(!([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] == NULL))
    {
        [UserDefaultManager removeValue:@"productDetailDict"];
        [UserDefaultManager removeValue:@"CurrentView"];
    }
    
    //self.tabBarController.hidesBottomBarWhenPushed = NO;
    
}
//- (BOOL)hidesBottomBarWhenPushed {
//    return YES;
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    stepBlock.layer.borderWidth = 1;
    stepBlock.layer.borderColor = [[UIColor colorWithRed:166.0/255.0 green:166.0/255.0 blue:166.0/255.0 alpha:1.0] CGColor];
    stepSelectedDataArray = [[NSMutableArray alloc]init];
    mainSelectedDataArray = [[NSMutableArray alloc]init];
    [giftBanner sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    stepCounter = 0;
    wishlistCounter=0;
    //setting collection view cell size according to iPhone screens
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)giftCollectionView.collectionViewLayout;
    CGFloat availableWidthForCells = CGRectGetWidth(self.view.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellPerRow -1);
    CGFloat cellWidth = (availableWidthForCells / kCellPerRow);
    flowLayout.itemSize = CGSizeMake(cellWidth, flowLayout.itemSize.height);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Web service methods
-(void)getBuildGiftData
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
        });
    }
    
    
    [[ProductService sharedManager] buildGiftService:productId success:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [myDelegate StopIndicator];
                            if (data != nil)
                            {
                                GiftArray = [(NSMutableArray *)data mutableCopy];
                                [giftCollectionView reloadData];
                                if (GiftArray.count>0)
                                {
                                    [self updateWishlistData];
                                    NSMutableArray *tmpAry = [GiftArray objectAtIndex:0];
                                    NSMutableDictionary * tmpDict = [tmpAry lastObject];
                                    setpLbl.text = [NSString stringWithFormat:@"STEP %d",stepCounter+1];
                                    stepDescLbl.text = [tmpDict objectForKey:@"default_title"];
                                    
                                    if ([UserDefaultManager getValue:@"productDetailDict"]!=nil)
                                    {
                                        NSDictionary *dict=[UserDefaultManager getValue:@"productDetailDict"];
                                        int buttonTag=[[dict objectForKey:@"objectIndex"] intValue];
                                        [self addProductToWishlist:buttonTag];
                                    }
                                    
                                }
                                else
                                {
                                    
                                    //display no data fount label.
                                    
                                }
                                
                                
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
         
     }];
    
    
}

-(void)updateWishlistData
{
    if (GiftArray.count==stepCounter) {
        return;
    }
    NSMutableArray * tmpAry =[GiftArray objectAtIndex:stepCounter];
    tmpAry =[UserDefaultManager wishListcomparisionForGiftModule:tmpAry];
    [GiftArray replaceObjectAtIndex:stepCounter withObject:tmpAry];
    
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
                            [myDelegate StopIndicator];
                            [self updateWishlistData];
                            [giftCollectionView reloadData];
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
        
        [[ProductService sharedManager] addToWishlist:subProductId success:^(id data)
         {
             //Handle fault cases
             dispatch_async(dispatch_get_main_queue(), ^{
                 // code here
                 

                 wishlistCounter--;
                 if (data != nil)
                 {
                     

                     
                     if (wishlistCounter==0)
                     {
                         [self getMyWishlist];
                     }
                     
                 }
                 else
                 {
                     if (wishlistCounter==0)
                     {
                         [self getMyWishlist];
                     }
                     else
                     {
                         [myDelegate StopIndicator];
                         
                         NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[tag intValue] inSection:0];
                         BuildGiftCell * cell = (BuildGiftCell *)[giftCollectionView cellForItemAtIndexPath:indexPath];
                         [cell.addToWishlistButton setSelected:NO];
                         UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                         [alert1 show];
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
        
        [[ProductService sharedManager] removeFromWishlist:subProductId success:^(id data)
         {
             
             
             //Handle fault cases
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 [myDelegate StopIndicator];
                 
                 // code here
                 wishlistCounter--;
                 if (data != nil)
                 {
                     
                     if (wishlistCounter==0)
                     {
                         [self getMyWishlist];
                     }
                 }
                 else
                 {
                     if (wishlistCounter==0)
                     {
                         [self getMyWishlist];
                     }
                     else
                     {
                         [myDelegate StopIndicator];
                         
                         NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[tag intValue] inSection:0];
                         BuildGiftCell * cell = (BuildGiftCell *)[giftCollectionView cellForItemAtIndexPath:indexPath];
                         [cell.addToWishlistButton setSelected:NO];
                         UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                         [alert1 show];
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
#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //    NSLog(@"rows are %lu",(unsigned long)[[GiftArray objectAtIndex:stepCounter] count]);
    if (GiftArray.count>0)
    {
        return [[GiftArray objectAtIndex:stepCounter] count]-1;
    }
    else
    {
        return 0;
    }
    
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    BuildGiftCell *myCell = [giftCollectionView
                             dequeueReusableCellWithReuseIdentifier:@"BuildGiftCell"
                             forIndexPath:indexPath];
    [myCell layoutView:myCell.contentView.frame index:(int)indexPath.row];
    [myCell displayData:[[GiftArray objectAtIndex:stepCounter] objectAtIndex:indexPath.row]];
    myCell.addToWishlistButton.tag=indexPath.row;
    [myCell.addToWishlistButton addTarget:self action:@selector(addToWishlist:) forControlEvents:UIControlEventTouchDown];
    return myCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"selected");
    NSMutableArray * tmpAry =[GiftArray objectAtIndex:stepCounter];
    NSMutableDictionary * tmpDict =[tmpAry lastObject];
    
    if ([[tmpDict objectForKey:@"type"] isEqualToString:@"radio"])
    {
        for (int i =0; i<tmpAry.count-1; i++)
        {
            if (indexPath.row==i)
            {
                BuildGiftModel * objModel = [tmpAry objectAtIndex:i];
                [objModel.giftDict setObject:@"Yes" forKey:@"isSelected"];
                [tmpAry replaceObjectAtIndex:i withObject:objModel];
                [GiftArray replaceObjectAtIndex:stepCounter withObject:tmpAry];
                [stepSelectedDataArray removeAllObjects];
                [stepSelectedDataArray addObject:objModel.giftDict];
                
            }
            else
            {
                BuildGiftModel * objModel = [tmpAry objectAtIndex:i];
                [objModel.giftDict setObject:@"No" forKey:@"isSelected"];
                [tmpAry replaceObjectAtIndex:i withObject:objModel];
                [GiftArray replaceObjectAtIndex:stepCounter withObject:tmpAry];
                
            }
        }
    }
    else
    {
        BuildGiftModel * objModel = [tmpAry objectAtIndex:indexPath.row];
        if ([[objModel.giftDict objectForKey:@"isSelected"]isEqualToString:@"Yes"])
        {
            [objModel.giftDict setObject:@"No" forKey:@"isSelected"];
            
            for (int i =0; i<stepSelectedDataArray.count; i++)
            {
                NSMutableDictionary * tmpDict =[stepSelectedDataArray objectAtIndex:i];
                if ([[objModel.giftDict objectForKey:@"id"] isEqualToString:[tmpDict objectForKey:@"id"]])
                {
                    [stepSelectedDataArray removeObjectAtIndex:i];
                }
            }
            
            
        }
        else
        {
            [objModel.giftDict setObject:@"Yes" forKey:@"isSelected"];
            [stepSelectedDataArray addObject:objModel.giftDict];
            
        }
        
    }
    
    [giftCollectionView reloadData];
    
}
#pragma mark - end
#pragma mark - IBActions
- (IBAction)addToWishlist:(UIButton*)sender
{
    wishlistCounter++;
    
    [self addProductToWishlist:[sender tag]];
    //    if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
    //    {
    //        NSDictionary *productDetailDict=[NSDictionary new];
    //
    //        myDelegate.istoast = true;
    //        if([[UIScreen mainScreen] bounds].size.height>480)
    //        {
    //            myDelegate.toastMessage = @"SIGN IN to add products to your wishlist";
    //        }else{
    //            myDelegate.toastMessage = @"SIGN IN to add products to your wishlist";
    //        }
    //
    //
    //        productDetailDict = @{@"productId":productId,@"objectIndex":[NSString stringWithFormat:@"%ld",(long)[sender tag]]};
    //
    //        [UserDefaultManager setValue:productDetailDict key:@"productDetailDict"];
    //        [UserDefaultManager setValue:@"BuildGiftViewController" key:@"CurrentView"];
    //
    //
    //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //        myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
    //        myDelegate.window.rootViewController = myDelegate.navigationController;
    //    }
    //    else
    //    {
    //
    //        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:sender.tag inSection:0];
    //        BuildGiftCell * cell = (BuildGiftCell *)[giftCollectionView cellForItemAtIndexPath:indexPath];
    //        NSMutableArray *tempGiftArray = [GiftArray objectAtIndex:stepCounter];
    //        BuildGiftModel *objGiftModel = [tempGiftArray objectAtIndex:[sender tag]];
    //        subProductId =[objGiftModel.giftDict objectForKey:@"id"];
    //        [myDelegate ShowIndicator];
    //        if ([[objGiftModel.giftDict objectForKey:@"isWishlist"] isEqualToString:@"Yes"])
    //        {
    //            [cell.addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_full.png"] forState:UIControlStateNormal];
    //            [objGiftModel.giftDict setObject:@"No" forKey:@"isWishlist"];
    //            [cell.addToWishlistButton setSelected:NO];
    //            [self performSelector:@selector(removeFromWishlistWebservice:) withObject:[NSNumber numberWithInt:[sender tag]] afterDelay:.1];
    //
    //        }
    //        else
    //        {
    //            [cell.addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_selected_full.png"] forState:UIControlStateNormal];
    //            [objGiftModel.giftDict setObject:@"Yes" forKey:@"isWishlist"];
    //            [cell.addToWishlistButton setSelected:YES];
    //            //[myDelegate ShowIndicator];
    //            [self performSelector:@selector(addToWishlistWebservice:) withObject:[NSNumber numberWithInt:[sender tag]] afterDelay:.1];
    //        }
    //
    //    }
    
}

-(void)addProductToWishlist:(int)tag
{
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
        
        
        productDetailDict = @{@"productId":productId,@"objectIndex":[NSString stringWithFormat:@"%d",tag]};
        
        [UserDefaultManager setValue:productDetailDict key:@"productDetailDict"];
        [UserDefaultManager setValue:@"BuildGiftViewController" key:@"CurrentView"];
        
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
        myDelegate.window.rootViewController = myDelegate.navigationController;
    }
    else
    {
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:tag inSection:0];
        BuildGiftCell * cell = (BuildGiftCell *)[giftCollectionView cellForItemAtIndexPath:indexPath];
        NSMutableArray *tempGiftArray = [GiftArray objectAtIndex:stepCounter];
        BuildGiftModel *objGiftModel = [tempGiftArray objectAtIndex:tag];
        subProductId =[objGiftModel.giftDict objectForKey:@"id"];
        
        
        
        
        if ([[objGiftModel.giftDict objectForKey:@"isWishlist"] isEqualToString:@"Yes"])
        {
            if ([UserDefaultManager getValue:@"productDetailDict"]!=nil)
            {
                [UserDefaultManager removeValue:@"productDetailDict"];
                [UserDefaultManager removeValue:@"CurrentView"];

                //NSLog(@"added to wishlist");
            }
            else
            {
            
                [cell.addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_full.png"] forState:UIControlStateNormal];
                [objGiftModel.giftDict setObject:@"No" forKey:@"isWishlist"];
                [cell.addToWishlistButton setSelected:NO];

            
                if ([UserDefaultManager getValue:@"productDetailDict"]==nil)
                {
                    [myDelegate ShowIndicator];
                }
                
                [self performSelector:@selector(removeFromWishlistWebservice:) withObject:[NSNumber numberWithInt:tag] afterDelay:.1];
            }
            
        }
        else
        {
            if ([UserDefaultManager getValue:@"productDetailDict"]==nil)
            {
                [myDelegate ShowIndicator];
            }
            [cell.addToWishlistButton setImage:[UIImage imageNamed:@"wishlist_selected_full.png"] forState:UIControlStateNormal];
            [objGiftModel.giftDict setObject:@"Yes" forKey:@"isWishlist"];
            [cell.addToWishlistButton setSelected:YES];
            
            [UserDefaultManager removeValue:@"productDetailDict"];
            [UserDefaultManager removeValue:@"CurrentView"];
            
            [self performSelector:@selector(addToWishlistWebservice:) withObject:[NSNumber numberWithInt:tag] afterDelay:.1];
        }
        
    }
    
    
}
- (IBAction)nextBtnAction:(id)sender
{
    NSMutableArray * tempArray =[[NSMutableArray alloc]init];
    tempArray = [stepSelectedDataArray mutableCopy];
    [stepSelectedDataArray removeAllObjects];
    
    if (mainSelectedDataArray.count<=stepCounter)
    {
        
        [mainSelectedDataArray insertObject:tempArray atIndex:stepCounter];
    }
    else if(tempArray.count>0)
    {
      [mainSelectedDataArray replaceObjectAtIndex:stepCounter withObject:tempArray];
    }
    
    
    
    
    NSMutableArray *tmpAry = [GiftArray objectAtIndex:stepCounter];
    NSMutableDictionary * tmpDict = [tmpAry lastObject];
    bool isSelected = false;
    for (int i=0; i<[[GiftArray objectAtIndex:stepCounter]count ]-1; i++)
    {
        BuildGiftModel *model =[[GiftArray objectAtIndex:stepCounter]objectAtIndex:i];
        if ([[model.giftDict objectForKey:@"isSelected"] isEqualToString:@"Yes"])
        {
            isSelected = true;
            
        }
        
    }
    if ([[tmpDict objectForKey:@"required"] isEqualToString:@"1"] && !isSelected)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please select any product" parentView:self.view];
          //  [self.view makeToast:@"Please select any product" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
            
            //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select any product." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //            [alert show];
        });
    }
    else
    {
        stepCounter++;
        [self updateWishlistData];
        if (stepCounter<GiftArray.count)
        {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.35;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            transition.type = kCATransitionPush;
            transition.subtype =kCATransitionFromRight;
            transition.delegate = self;
            [self.view.layer addAnimation:transition forKey:nil];
            [giftCollectionView setContentOffset:CGPointZero animated:NO];
            NSMutableArray *tmpAry = [GiftArray objectAtIndex:stepCounter];
            NSMutableDictionary * tmpDict = [tmpAry lastObject];
            setpLbl.text = [NSString stringWithFormat:@"STEP %d",stepCounter+1];
            stepDescLbl.text = [tmpDict objectForKey:@"default_title"];
            [giftCollectionView reloadData];
        }
        else
        {
            
            stepCounter--;
            BuildGiftFinalViewController *objFialStep = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BuildGiftFinalViewController"];
            objFialStep.objBuildGift = self;
            objFialStep.dataArray = [self sendDataToFinalStep];
            objFialStep.bannerImage = giftBanner.image;
            objFialStep.sendingDataArray = mainSelectedDataArray;
            objFialStep.productId = productId;
            objFialStep.title = self.title;
            // NSLog(@"count is %d",objFialStep.dataArray.count);
            [self.navigationController pushViewController:objFialStep animated:YES];
            
        }
    }
    
}

-(void)resetData
{
    
    NSMutableArray * tmpAry =[GiftArray objectAtIndex:stepCounter];
    for (int i =0; i<tmpAry.count-1; i++)
    {
        BuildGiftModel * objModel = [tmpAry objectAtIndex:i];
        [objModel.giftDict setObject:@"No" forKey:@"isSelected"];
        [tmpAry replaceObjectAtIndex:i withObject:objModel];
        [GiftArray replaceObjectAtIndex:stepCounter withObject:tmpAry];
    }
}

-(void)backButtonAction :(id)sender
{
    
    if (mainSelectedDataArray.count>stepCounter)
    {
        [self resetData];
        [self updateWishlistData];
        [mainSelectedDataArray removeObjectAtIndex:stepCounter];
    }
    stepCounter--;
    if (stepCounter>=0)
    {
        stepSelectedDataArray = [mainSelectedDataArray objectAtIndex:stepCounter];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.35;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionPush;
        transition.subtype =kCATransitionFromLeft;
        transition.delegate = self;
        [self.view.layer addAnimation:transition forKey:nil];
        [giftCollectionView setContentOffset:CGPointZero animated:NO];
        NSMutableArray *tmpAry = [GiftArray objectAtIndex:stepCounter];
        NSMutableDictionary * tmpDict = [tmpAry lastObject];
        setpLbl.text = [NSString stringWithFormat:@"STEP %d",stepCounter+1];
        stepDescLbl.text = [tmpDict objectForKey:@"default_title"];
        [giftCollectionView reloadData];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        //NSLog(@"do nothing");
        
    }
    
}

-(NSMutableArray *)sendDataToFinalStep
{
    NSMutableArray * sendingArray = [[NSMutableArray alloc]init];
    for (int i =0; i<mainSelectedDataArray.count; i++)
    {
        NSMutableArray *tmpAry = [mainSelectedDataArray objectAtIndex:i];
        for (int j =0; j<tmpAry.count; j++)
        {
            [sendingArray addObject:[tmpAry objectAtIndex:j]];
        }
        
    }
    return sendingArray;
    
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
