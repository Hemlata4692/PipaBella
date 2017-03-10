//
//  CategoryViewController.m
//  PipaBella
//
//  Created by Ranosys on 21/10/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "CategoryViewController.h"
#import "ProductService.h"
#import "CategoryListingModel.h"
#import "SubCategoryModel.h"
#import "ProductListViewController.h"
#import "CartViewController.h"
#import "BuildGiftViewController.h"
#import "ProductDetailViewController.h"

@interface CategoryViewController ()<UIGestureRecognizerDelegate>
{
    NSMutableArray *categoryArray;
    NSMutableDictionary *expandCollapseTrackerDict;
    NSArray *keyValue;
    int btnTag;
    UIView *mainView;
    __weak IBOutlet UIButton *retryBtn;
    __weak IBOutlet UIButton *cartBtn;
}
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;

@end

@implementation CategoryViewController
@synthesize categoryTableView;




#pragma mark - View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    retryBtn.hidden=YES;
    self.navigationItem.title=@"CATEGORIES";
    // Do any additional setup after loading the view.
    
    categoryArray = [NSMutableArray new];
    expandCollapseTrackerDict = [NSMutableDictionary new];
    
    [self setViewFrame];
    mainView.hidden = YES;
    
    [myDelegate ShowIndicator];
    [self performSelector:@selector(categoryListingWebservice) withObject:nil afterDelay:.3];
    //[self categoryListingWebservice];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Localytics tagScreen:@"Categories View"];
    myDelegate.tabId = (int)self.tabBarController.selectedIndex;
    if ([UserDefaultManager getValue:@"CurrentView"]!=nil)
    {
        if (![([UserDefaultManager getValue:@"CurrentView"]) isEqualToString:@"HomeViewController"])
        {
            UIViewController * objChkout = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:[UserDefaultManager getValue:@"CurrentView"]];
            [self.navigationController pushViewController:objChkout animated:YES];
            return;
        }
    }
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [UIView animateWithDuration:0.6f animations:^{
        
        mainView.hidden = YES;
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [UIView animateWithDuration:0.4f animations:^{
        
        mainView.hidden = YES;
        
    }];
    
}

#pragma mark - end


#pragma mark - Webservice method
-(void)categoryListingWebservice
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        retryBtn.hidden=NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
        });
        return;
    }
    
    [[ProductService sharedManager] getCategoryList:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            categoryArray = (NSMutableArray *)data;
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
                                for (int i=0; i<categoryArray.count; i++)
                                {
                                    
                                    [expandCollapseTrackerDict setValue:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%d",i]];
                                    
                                }
                                [categoryTableView reloadData];
                            }
                        });
         
     }
                                            failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
    
}

#pragma mark - end
#pragma mark - table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //categoryDict=[categoryArray objectAtIndex:0];
    return categoryArray.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([expandCollapseTrackerDict objectForKey:[NSString stringWithFormat:@"%ld",(long)section]] == [NSNumber numberWithBool:YES])
    {
        CategoryListingModel * catModel=[categoryArray objectAtIndex:section];
        return catModel.subCatArray.count;
    }
    else
    {
        return 0;
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView;
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 60.0)];
    
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel * seperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.origin.y, headerView.frame.size.width, 2)];
    seperatorLabel.backgroundColor=[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    [headerView addSubview:seperatorLabel];
    if (section==0)
    {
        seperatorLabel.hidden=YES;
    }
    //Label which shows the category name
    UILabel * categoryLabel = [[UILabel alloc] init];
    CategoryListingModel * catModel = [categoryArray objectAtIndex:section];
    [categoryLabel setText:catModel.catName];
    //end
    categoryLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    
    float width =  [categoryLabel.text boundingRectWithSize:categoryLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:categoryLabel.font } context:nil]
    .size.width;
    
    categoryLabel.frame = CGRectMake(70.0, 15, width,30.0);
    categoryLabel.textColor=[UIColor colorWithRed:(63.0/255.0) green:(63.0/255.0) blue:(63.0/255.0) alpha:1];
    [headerView addSubview:categoryLabel];
    
    
    UIImageView *categoryImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 13, 35, 35)];
    categoryImage.contentMode = UIViewContentModeScaleAspectFit;
    categoryImage.layer.cornerRadius = categoryImage.frame.size.height/2;
    categoryImage.clipsToBounds = YES;
    [categoryImage sd_setImageWithURL:[NSURL URLWithString:catModel.catIcon] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    //categoryImage.backgroundColor=[UIColor purpleColor];
    [headerView addSubview:categoryImage];
    
    UIImageView *downArrowImage=[[UIImageView alloc]initWithFrame:CGRectMake(categoryLabel.frame.origin.x+categoryLabel.frame.size.width+10, categoryLabel.frame.origin.y+10, 9, 9)];
    if (catModel.subCatArray.count<1)
    {
    
    downArrowImage.image=[UIImage imageNamed:@""];
    }
    else
    {
       downArrowImage.image=[UIImage imageNamed:@"down_arrow.png"];
    }
    
    [headerView addSubview:downArrowImage];
    
    
    UIButton * headerClick = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, headerView.frame.size.width,headerView.frame.size.height)];
    
    [headerClick addTarget:self action:@selector(headerMethod:) forControlEvents:UIControlEventTouchUpInside];
    headerClick.tag = section;
    [headerView addSubview:headerClick];
    
    return headerView;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 60.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell ;
    NSString *simpleTableIdentifier = @"categoryCell";
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UILabel *productName = (UILabel*)[cell viewWithTag:1];
    
    
    CategoryListingModel * catModel=[categoryArray objectAtIndex:indexPath.section];
    SubCategoryModel * subCatModel =[catModel.subCatArray objectAtIndex:indexPath.row];
    productName.text=subCatModel.subCatName;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CategoryListingModel *catModel =[categoryArray objectAtIndex:indexPath.section];
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProductListViewController *objProductView =[storyboard instantiateViewControllerWithIdentifier:@"ProductListViewController"];
    SubCategoryModel *subCatModel = [catModel.subCatArray objectAtIndex:indexPath.row];
    objProductView.categoryId =subCatModel.subCatId;
    objProductView.navigationTitle = subCatModel.subCatName;
    [self.navigationController pushViewController:objProductView animated:YES];
    
}
#pragma mark - end
- (IBAction)headerMethod:(UIButton *)sender
{
    btnTag = (int)[sender tag];
    CategoryListingModel * catModel=[categoryArray objectAtIndex:[sender tag]];
    if (catModel.subCatArray.count<1)
    {
        if ([catModel.type isEqualToString:@"product"] && [catModel.productType isEqualToString:@"simple"])
        {
            UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ProductDetailViewController *objProductView =[storyboard instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
            objProductView.productId =catModel.productId;
            objProductView.isInStock = catModel.isInstock;
            objProductView.navigationTitle = catModel.catName;
            [self.navigationController pushViewController:objProductView animated:YES];
        }
        else if ([catModel.type isEqualToString:@"product"] && [catModel.productType isEqualToString:@"bundle"])
        {
        
           
            
            UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            BuildGiftViewController *objProductView =[storyboard instantiateViewControllerWithIdentifier:@"BuildGiftViewController"];
            objProductView.productId =catModel.productId;
            objProductView.title = catModel.catName;
            objProductView.imageUrl =catModel.catIcon;
            [self.navigationController pushViewController:objProductView animated:YES];
        }
        else
        {
        
            UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ProductListViewController *objProductView =[storyboard instantiateViewControllerWithIdentifier:@"ProductListViewController"];
            objProductView.categoryId =catModel.catId;
            objProductView.navigationTitle = catModel.catName;
            [self.navigationController pushViewController:objProductView animated:YES];
        
        }
    }
    else
    {
        if ([expandCollapseTrackerDict objectForKey:[NSString stringWithFormat:@"%d",btnTag]] == [NSNumber numberWithBool:NO])
        {
            for (int i=0; i<expandCollapseTrackerDict.count; i++)
            {
                if (i==btnTag)
                {
                    [expandCollapseTrackerDict setValue:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%d",i]];
                }
                else
                {
                    [expandCollapseTrackerDict setValue:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%d",i]];
                }
            }
        }
        else
        {
            for (int i=0; i<expandCollapseTrackerDict.count; i++) {
                
                [expandCollapseTrackerDict setValue:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%d",i]];
            }
            
        }
    }
    [categoryTableView reloadData];
}

- (IBAction)retryButtonAction:(id)sender
{
    [myDelegate ShowIndicator];
    [self performSelector:@selector(categoryListingWebservice) withObject:nil afterDelay:.1];
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

}

#pragma mark - end



#pragma end
@end
