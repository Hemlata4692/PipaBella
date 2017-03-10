//
//  ProductDetailViewController.m
//  PipaBella
//
//  Created by Ranosys on 17/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProductDetailCell.h"
#import "ProductService.h"
#import "CartViewController.h"
#import <SDWebImage/SDWebImageManager.h>
#import "PersonalizeViewController.h"
#import "SizeGuideViewController.h"
#import "CurrencyConverter.h"
#import "J2TRewardsViewController.h"
#import "ImageGalleryViewController.h"
#import "WaitlistViewController.h"
static CGFloat contractedHeight = 44.0;
@interface ProductDetailViewController ()<UIGestureRecognizerDelegate>
{
    int rowindex;
    NSMutableArray *uploadedImages,*uploadImageUrl;
    NSMutableArray *detailInformationArray;
    NSMutableArray *swipeProductImages;
    NSArray *productImages;
    int imageIndex;
    int expendedCell;
    float  initialHeight;
    NSMutableDictionary * productDetailDict;
    NSMutableArray * tableDataArray;
    NSArray *keys;
    UIView *mainView;
    __weak IBOutlet UIButton *cartBtn;
    __weak IBOutlet UILabel *imageSeperator;
    NSMutableDictionary * cartDict;
    int remainingInventry;
    bool isAddedtoCart;
    
    __weak IBOutlet UILabel *rewardSeperator;
    __weak IBOutlet UIButton *learnHowBtn;
    __weak IBOutlet UILabel *rewardLbl;
    NSMutableArray * sizeGuideArray;
    UIBarButtonItem *barButton,*barButton1,*barButton2;
    NSMutableArray *quantityArray;
    NSString *str;
    UIButton *button;
    UIButton *button1;
    
    int qty;
}
@property (weak, nonatomic) IBOutlet UILabel *currencyLbl;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *qtyLbl;
@property (weak, nonatomic) IBOutlet UILabel *seperator;
@property (weak, nonatomic) IBOutlet UIScrollView *productDetailScrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *productSliderImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *productSliderPageControl;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UIButton *addToWishlistButton;
@property (weak, nonatomic) IBOutlet UIButton *personaliseButton;
@property (weak, nonatomic) IBOutlet UIButton *quantityDecrementButton;
@property (weak, nonatomic) IBOutlet UIButton *quantityIncrementButton;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UIButton *addToBagButton;
@property (weak, nonatomic) IBOutlet UITableView *detailInformationTableView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIToolbar *pickerToolBar;
@property (weak, nonatomic) IBOutlet UIPickerView *quantityPickerView;
@property (weak, nonatomic) IBOutlet UIButton *addQuantityButton;

@end

@implementation ProductDetailViewController
@synthesize productSliderImageView,productSliderPageControl,priceLabel,skuLabel,addToWishlistButton,personaliseButton,quantityDecrementButton,quantityLabel,quantityIncrementButton,addToBagButton,detailInformationTableView,shareButton,productDetailScrollView,mainContainerView,seperator,containerView,productNameLabel,pickerToolBar,quantityPickerView,addQuantityButton;
@synthesize productId;
@synthesize productName;
@synthesize currencyLbl;
@synthesize isInStock;
@synthesize stockQuantity;
@synthesize personalizeDict;
@synthesize categoryId,navigationTitle;
@synthesize isInWaitlist;
@synthesize hasPersonalized;
#pragma mark - View lifecycle

-(void)removeViewAutolayouts
{
    productDetailScrollView.translatesAutoresizingMaskIntoConstraints = YES;
    mainContainerView.translatesAutoresizingMaskIntoConstraints=YES;
    productSliderImageView.translatesAutoresizingMaskIntoConstraints =YES;
    productSliderPageControl.translatesAutoresizingMaskIntoConstraints = YES;
    productNameLabel.translatesAutoresizingMaskIntoConstraints = YES;
    priceLabel.translatesAutoresizingMaskIntoConstraints=YES;
    skuLabel.translatesAutoresizingMaskIntoConstraints = YES;
    addToWishlistButton.translatesAutoresizingMaskIntoConstraints = YES;
    personaliseButton.translatesAutoresizingMaskIntoConstraints = YES;
    seperator.translatesAutoresizingMaskIntoConstraints = YES;
    //    quantityDecrementButton.translatesAutoresizingMaskIntoConstraints = YES;
    //    quantityIncrementButton.translatesAutoresizingMaskIntoConstraints = YES;
    //    quantityLabel.translatesAutoresizingMaskIntoConstraints = YES;
    detailInformationTableView.translatesAutoresizingMaskIntoConstraints = YES;
    // shareButton.translatesAutoresizingMaskIntoConstraints = YES;
    //  containerView.translatesAutoresizingMaskIntoConstraints = YES;
    currencyLbl.translatesAutoresizingMaskIntoConstraints = YES;
    imageSeperator.translatesAutoresizingMaskIntoConstraints = YES;
    rewardLbl.translatesAutoresizingMaskIntoConstraints = YES;
    learnHowBtn.translatesAutoresizingMaskIntoConstraints = YES;
    rewardSeperator.translatesAutoresizingMaskIntoConstraints = YES;
    quantityPickerView.translatesAutoresizingMaskIntoConstraints = YES;
    pickerToolBar.translatesAutoresizingMaskIntoConstraints = YES;
    
    
    [self setFrameOfObject];
    
    //[productDetailScrollView setContentOffset:CGPointMake(0, 300) animated:YES];
    
    
}

-(void)setFrameOfObject
{
    productDetailScrollView.frame = CGRectMake(productDetailScrollView.frame.origin.x, productDetailScrollView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    mainContainerView.frame = CGRectMake(productDetailScrollView.frame.origin.x, productDetailScrollView.frame.origin.y, self.view.frame.size.width, 1000);
    
    productSliderImageView.frame = CGRectMake(productSliderImageView.frame.origin.x, productSliderImageView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-220);
    addToWishlistButton.frame = CGRectMake(self.view.frame.size.width-40, 0, self.addToWishlistButton.frame.size.width, self.addToWishlistButton.frame.size.height);
    
    imageSeperator.frame = CGRectMake(imageSeperator.frame.origin.x, productSliderImageView.frame.origin.y+self.productSliderImageView.frame.size.height+2, self.view.frame.size.width, imageSeperator.frame.size.height);
    
    productSliderPageControl.frame = CGRectMake(productSliderPageControl.frame.origin.x, productSliderImageView.frame.origin.y+productSliderImageView.frame.size.height+10, self.view.frame.size.width, self.productSliderPageControl.frame.size.height);
    productNameLabel.frame = CGRectMake(productNameLabel.frame.origin.x, productSliderPageControl.frame.origin.y+30, self.view.frame.size.width, self.productNameLabel.frame.size.height);
    priceLabel.frame = CGRectMake(priceLabel.frame.origin.x, productNameLabel.frame.origin.y+productNameLabel.frame.size.height+5, self.view.frame.size.width-200, self.priceLabel.frame.size.height);
    currencyLbl.frame = CGRectMake(currencyLbl.frame.origin.x, productNameLabel.frame.origin.y+productNameLabel.frame.size.height+5, self.currencyLbl.frame.size.width, self.currencyLbl.frame.size.height);
    
    skuLabel.frame = CGRectMake(skuLabel.frame.origin.x, priceLabel.frame.origin.y+priceLabel.frame.size.height+5, self.view.frame.size.width, self.skuLabel.frame.size.height);
    
    
    
    personaliseButton.frame = CGRectMake(self.priceLabel.frame.origin.x+self.priceLabel.frame.size.width, priceLabel.frame.origin.y, self.personaliseButton.frame.size.width, self.personaliseButton.frame.size.height);
    
    seperator.frame =CGRectMake(self.seperator.frame.origin.x, skuLabel.frame.origin.y+skuLabel.frame.size.height+5,self.view.frame.size.width-30, self.seperator.frame.size.height);
    
    //set frame for J2T buttons and label and button.
    
    if (self.view.frame.size.width<=320)
    {
        rewardLbl.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        self.productDetailScrollView.contentSize =CGSizeMake(320, 800);
        
        
        rewardLbl.frame = CGRectMake(26, seperator.frame.origin.y+15, rewardLbl.frame.size.width, rewardLbl.frame.size.height);
        learnHowBtn.frame = CGRectMake(rewardLbl.frame.origin.x+rewardLbl.frame.size.width, rewardLbl.frame.origin.y, learnHowBtn.frame.size.width, learnHowBtn.frame.size.height);
        rewardSeperator.frame = CGRectMake(26, rewardLbl.frame.origin.y+rewardLbl.frame.size.height+14, rewardLbl.frame.size.width+learnHowBtn.frame.size.width, rewardSeperator.frame.size.height);
        
    }
    else
    {
        rewardLbl.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        self.productDetailScrollView.contentSize =CGSizeMake(320, 1000);
        
        rewardLbl.frame = CGRectMake(36, seperator.frame.origin.y+15, rewardLbl.frame.size.width+20, rewardLbl.frame.size.height);
        learnHowBtn.frame = CGRectMake(rewardLbl.frame.origin.x+rewardLbl.frame.size.width+15, rewardLbl.frame.origin.y, learnHowBtn.frame.size.width, learnHowBtn.frame.size.height);
        rewardSeperator.frame = CGRectMake(35, rewardLbl.frame.origin.y+rewardLbl.frame.size.height+14, rewardLbl.frame.size.width+learnHowBtn.frame.size.width+20, rewardSeperator.frame.size.height);
    }
    //    rewardLbl.frame = CGRectMake(rewardLbl.frame.origin.x, seperator.frame.origin.y+15, rewardLbl.frame.size.width+20, rewardLbl.frame.size.height);
    //    learnHowBtn.frame = CGRectMake(rewardLbl.frame.origin.x+rewardLbl.frame.size.width+20, rewardLbl.frame.origin.y, learnHowBtn.frame.size.width, learnHowBtn.frame.size.height);
    //    rewardSeperator.frame = CGRectMake(rewardSeperator.frame.origin.x, rewardLbl.frame.origin.y+rewardLbl.frame.size.height+14, rewardLbl.frame.size.width+learnHowBtn.frame.size.width+20, rewardSeperator.frame.size.height);
    // containerView.frame =CGRectMake(self.containerView.frame.origin.x, rewardLbl.frame.origin.y+rewardLbl.frame.size.height+30,self.view.frame.size.width-20, self.containerView.frame.size.height);
    self.detailInformationTableView.frame = CGRectMake(self.detailInformationTableView.frame.origin.x, rewardLbl.frame.origin.y+rewardLbl.frame.size.height+30, self.view.frame.size.width, self.detailInformationTableView.frame.size.height-10);
    //   self.shareButton.frame =CGRectMake(self.shareButton.frame.origin.x, detailInformationTableView.frame.origin.y+detailInformationTableView.frame.size.height+10, self.shareButton.frame.size.width, self.shareButton.frame.size.height);
    self.detailInformationTableView.scrollEnabled = NO;
    self.productSliderPageControl.userInteractionEnabled = NO;
    
    
}
-(void)getProductInventory
{
    NSMutableArray * cartArray =[[UserDefaultManager getValue:@"cartData"]mutableCopy];
    
    if (cartArray.count<1)
    {
        isAddedtoCart =false;
    }
    else
    {
        for (int i =0; i<cartArray.count; i++)
        {
            cartDict = [cartArray objectAtIndex:i];
            if ([[cartDict objectForKey:@"product_id"]isEqualToString:productId])
            {
                isAddedtoCart =true;
                remainingInventry = stockQuantity - [[cartDict objectForKey:@"product_quantity"]intValue];
                break;
            }
            else
            {
                isAddedtoCart =false;
            }
        }
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (hasPersonalized)
    {
        hasPersonalized =false;
        MozTopAlertView *alertView = [MozTopAlertView showWithType:MozAlertTypeSuccess text:@"Your entry has been submitted." parentView:self.view];
        alertView.dismissBlock = ^(){
            NSLog(@"dismissBlock");
        };
    }
    if (productDetailDict!=nil)
    {
        self.priceLabel.text =[CurrencyConverter converCurrency:[productDetailDict objectForKey:@"price"]];
    }
    
    [self getProductInventory];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:81.0/255.0 green:82.0/255.0 blue:82.0/255.0 alpha:1.0], NSForegroundColorAttributeName, [UIFont systemFontOfSize:16 weight:UIFontWeightRegular], NSFontAttributeName, nil]];
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
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(!([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
    {
        [UserDefaultManager removeValue:@"productDetailDict"];
        [UserDefaultManager removeValue:@"CurrentView"];
        
    }
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:81.0/255.0 green:82.0/255.0 blue:82.0/255.0 alpha:1.0], NSForegroundColorAttributeName, [UIFont systemFontOfSize:22 weight:UIFontWeightRegular], NSFontAttributeName, nil]];
    
    [UIView animateWithDuration:0.6f animations:^{
        
        mainView.hidden = YES;
        
    }];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    cartDict = [NSMutableDictionary new];
    // Do any additional setup after loading the view.
    [self removeViewAutolayouts];
    qty = 0;
    //addQuantityButton.hidden = YES;
    UIFont *fnt = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    NSMutableAttributedString *attributedStringFirst = [[NSMutableAttributedString alloc] initWithString:@"QUANTITY : " attributes:@{NSFontAttributeName: [fnt fontWithSize:14]}];
    str = [NSString stringWithFormat:@"%d",1];
    [attributedStringFirst addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:(NSMakeRange(0, @"QUANTITY : ".length))];
    NSMutableAttributedString * stringFirst = [[NSMutableAttributedString alloc] initWithString:str];
    [stringFirst addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular] range:(NSMakeRange(0, str.length))];
    [stringFirst addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:241.0/255.0 green:0.0/255.0 blue:136.0/255.0 alpha:1.0] range:(NSMakeRange(0, str.length))];
    
    NSMutableAttributedString *resultFirst = [attributedStringFirst mutableCopy];
    [resultFirst appendAttributedString:stringFirst];
    [addQuantityButton setAttributedTitle:resultFirst forState:UIControlStateNormal];
    remainingInventry=stockQuantity;
    //  self.navigationItem.title=self.productName;
    [self setBorder];
    expendedCell = 0;
    swipeProductImages=[[NSMutableArray alloc]init];
    productImages=[[NSArray alloc]init];
    [self setViewFrame];
    mainView.hidden = YES;
    
    quantityArray=[[NSMutableArray alloc] init];
    
    int i;
    for (i = 1; i <= 100; i++) {
        [quantityArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    
    
    pickerToolBar.backgroundColor = [UIColor whiteColor];
    
    //Border to picker view and toolbar
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 1.0f);
    topBorder.backgroundColor = [UIColor grayColor].CGColor;
    [pickerToolBar.layer addSublayer:topBorder];
    
    CALayer *leftBorder = [CALayer layer];
    leftBorder.frame = CGRectMake(0.0f, 0.0f, 1.0f, 44.0f);
    leftBorder.backgroundColor = [UIColor grayColor].CGColor;
    [pickerToolBar.layer addSublayer:leftBorder];
    
    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(self.view.frame.size.width-1, 0.0f, 1.0f, 44.0f);
    rightBorder.backgroundColor = [UIColor grayColor].CGColor;
    [pickerToolBar.layer addSublayer:rightBorder];
    
    
    CALayer *leftBorderPicker = [CALayer layer];
    leftBorderPicker.frame = CGRectMake(0.0f, 0.0f, 1.0f, 146.0f);
    leftBorderPicker.backgroundColor = [UIColor grayColor].CGColor;
    [quantityPickerView.layer addSublayer:leftBorderPicker];
    
    CALayer *rightBorderPicker = [CALayer layer];
    rightBorderPicker.frame = CGRectMake(self.view.frame.size.width-1, 0.0f, 1.0f, 146.0f);
    rightBorderPicker.backgroundColor = [UIColor grayColor].CGColor;
    [quantityPickerView.layer addSublayer:rightBorderPicker];
    //end
    
    
    
    
    //Adding swipe gesture
    [productSliderImageView setUserInteractionEnabled:YES];
    
    UISwipeGestureRecognizer *swipeImageLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBannerImageLeft:)];
    swipeImageLeft.delegate=self;
    UISwipeGestureRecognizer *swipeImageRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBannerImageRight:)];
    swipeImageRight.delegate=self;
    [self.detailInformationTableView setAllowsMultipleSelection:YES];
    // Setting the swipe direction.
    [swipeImageLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeImageRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [productSliderImageView addGestureRecognizer:swipeImageLeft];
    [productSliderImageView addGestureRecognizer:swipeImageRight];
    
    productSliderPageControl.currentPage = 0;
    //    quantityLabel.layer.borderColor = [UIColor colorWithRed:154.0/255.0 green:153.0/255.0 blue:154.0/255.0 alpha:1.0].CGColor;
    //    quantityLabel.layer.borderWidth = 1.5;
    uploadedImages=[NSMutableArray new];
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    sublayer.frame = CGRectMake(productSliderImageView.frame.origin.x, productSliderImageView.frame.size.height, productSliderImageView.frame.size.width, 1);
    [productSliderImageView.layer addSublayer:sublayer];
    
    if ([UserDefaultManager getValue:@"productDetailDict"]!=nil)
    {
        NSDictionary *dict= [UserDefaultManager getValue:@"productDetailDict"];
        productId=[dict objectForKey:@"productId"];
        isInStock=[dict objectForKey:@"isInStock"];
    }
    
    if(!([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
    {
        if ([UserDefaultManager getValue:@"CurrentView"]!=nil)
        {
            [UserDefaultManager removeValue:@"CurrentView"];
            
            NSLog(@"wishListData ===== %@",[UserDefaultManager getValue:@"wishListData"]);
            
            NSMutableArray *arr=[[NSMutableArray alloc]init];
            arr=[UserDefaultManager getValue:@"wishListData"];
            for (int i=0;i < arr.count; i++)
            {
                NSDictionary *dict=[arr objectAtIndex:i];
                if ([productId isEqualToString:[dict objectForKey:@"product_id"]])
                {
                    self.isAddedtoWishlist=true;
                }
            }
        }
    }
    
    
    
    if (![self.isInStock boolValue])
    {
        [addToBagButton setTitle:@"ADD TO WAITLIST" forState:UIControlStateNormal];
        addQuantityButton.hidden = YES;
        [self addNavigationButtonsWithoutWishlist];
    }
    else
    {
        [addToBagButton setTitle:@"ADD TO BAG" forState:UIControlStateNormal];
        [self addNavigationButtonWithWishlist];
        
    }
    if (isInWaitlist)
    {
        addToBagButton.hidden=YES;
        addQuantityButton.hidden = YES;
        [self addNavigationButtonsWithoutWishlist];
    }
    else
    {
        addToBagButton.hidden = NO;
        //[self addNavigationButtonWithWishlist];
    }
    if (self.isAddedtoWishlist)
    {
        [button1 setSelected:YES];
        [button1 setImage:[UIImage imageNamed:@"product_detail_heart_full"] forState:UIControlStateNormal];
        
    }
    else
    {
        [button1 setSelected:NO];
        [button1 setImage:[UIImage imageNamed:@"product_detail_heart"] forState:UIControlStateNormal];
    }
    personalizeDict = [NSMutableDictionary new];
    [personalizeDict setObject:@"" forKey:@"selectedRadioId"];
    [personalizeDict setObject:@"" forKey:@"RadioId"];
    [personalizeDict setObject:@"" forKey:@"fieldId"];
    [personalizeDict setObject:@"" forKey:@"fieldValue"];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    productSliderImageView.userInteractionEnabled = YES;
    [productSliderImageView addGestureRecognizer:singleTap];
    
    
    
    // uploadImageUrl=[NSMutableArray new];
    
    if ([UserDefaultManager getValue:@"productDetailDict"] == nil)
    {
        [myDelegate ShowIndicator];
        [self performSelector:@selector(getProductDetailService) withObject:nil afterDelay:.1];
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Localytics tagScreen:@"Product Detail View"];
    if ([UserDefaultManager getValue:@"productDetailDict"] != nil)
    {
        [myDelegate ShowIndicator];
        [self performSelector:@selector(getProductDetailService) withObject:nil afterDelay:.1];
    }
}

-(void)tapDetected
{
    ImageGalleryViewController *objGallery = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ImageGalleryViewController"];
    objGallery.productDetailDict = productDetailDict;
    objGallery.imageIndex = imageIndex;
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:objGallery];
    [self.navigationController presentViewController:navBar animated: YES completion: ^ {
    }];
    NSLog(@"single Tap on imageview");
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setBorder
{
    //    [quantityDecrementButton addBorder:quantityDecrementButton color:[UIColor colorWithRed:154.0/255.0 green:153.0/255.0 blue:154.0/255.0 alpha:1.0]];
    //    [quantityIncrementButton addBorder:quantityIncrementButton color:[UIColor colorWithRed:154.0/255.0 green:153.0/255.0 blue:154.0/255.0 alpha:1.0]];
    [personaliseButton addBorder:personaliseButton color:[UIColor colorWithRed:241.0/255.0 green:0.0/255.0 blue:136.0/255.0 alpha:1.0]];
    
}

-(void)addNavigationButtonWithWishlist
{

    //Navigation bar buttons
    CGRect framing = CGRectMake(0, 0, 40, 40);
    button = [[UIButton alloc] initWithFrame:framing];
    [button setImage:[UIImage imageNamed:@"cart.png"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, -4.0)];
    // [button setBackgroundColor:[UIColor redColor] ];
    barButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(cartButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect framing1 = CGRectMake(0, 0, 30, 30);
    button1 = [[UIButton alloc] initWithFrame:framing1];
    [button1 setImage:[UIImage imageNamed:@"product_detail_heart.png"] forState:UIControlStateNormal];
    //    [button1 setImage:[UIImage imageNamed:@"product_detail_heart_full.png"] forState:UIControlStateSelected];
    //[button1 setBackgroundColor:[UIColor yellowColor] ];
    [button1 setImageEdgeInsets:UIEdgeInsetsMake(0.0, 7.0, 0.0, -7.0)];
    barButton1 =[[UIBarButtonItem alloc] initWithCustomView:button1];
    [button1 addTarget:self action:@selector(addToWishlistButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect framing2 = CGRectMake(0, 0, 30, 30);
    UIButton *button2 = [[UIButton alloc] initWithFrame:framing2];
    [button2 setImage:[UIImage imageNamed:@"upload_arrow.png"] forState:UIControlStateNormal];
    //[button2 setBackgroundColor:[UIColor purpleColor] ];
    [button2 setImageEdgeInsets:UIEdgeInsetsMake(0.0, 8.0, 0.0, -8.0)];
    barButton2 =[[UIBarButtonItem alloc] initWithCustomView:button2];
    //  [barButton2 setImageInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, -20.0)];
    [button2 addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:barButton,barButton1,barButton2, nil];
    //end
    

}
-(void)addNavigationButtonsWithoutWishlist
{

    //Navigation bar buttons
    CGRect framing = CGRectMake(0, 0, 40, 40);
    button = [[UIButton alloc] initWithFrame:framing];
    [button setImage:[UIImage imageNamed:@"cart.png"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, -4.0)];
    // [button setBackgroundColor:[UIColor redColor] ];
    barButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(cartButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
        CGRect framing2 = CGRectMake(0, 0, 30, 30);
        UIButton *button2 = [[UIButton alloc] initWithFrame:framing2];
        [button2 setImage:[UIImage imageNamed:@"upload_arrow.png"] forState:UIControlStateNormal];
        //[button2 setBackgroundColor:[UIColor purpleColor] ];
        [button2 setImageEdgeInsets:UIEdgeInsetsMake(0.0, 8.0, 0.0, -8.0)];
        barButton1 =[[UIBarButtonItem alloc] initWithCustomView:button2];
        //  [barButton2 setImageInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, -20.0)];
        [button2 addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    

    
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:barButton,barButton1, nil];
    //end
    

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
                                
                                //                                waitlistMailField.text =@"";
                                //                                waitlistNameField.text=@"";
                                
                                if ([[data objectForKey:@"status"] isEqualToString:@"1"])
                                {
                                    MozTopAlertView *alertView = [MozTopAlertView showWithType:MozAlertTypeSuccess text:[data objectForKey:@"message"] parentView:self.view];
                                    alertView.dismissBlock = ^(){
                                        NSLog(@"dismissBlock");
                                    };
                                    
                                    //   [self.view makeToast:[data objectForKey:@"message"] image:[UIImage imageNamed:@"sign.png"] color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
                                }
                                else
                                {
                                    [MozTopAlertView showWithType:MozAlertTypeWarning text:[data objectForKey:@"message"] doText:nil doBlock:^{
                                        
                                    } parentView:self.view];
                                    
                                    // [self.view makeToast:[data objectForKey:@"message"] image:[UIImage imageNamed:@"excl.png"] color:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]];
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

-(void)addPersonalizeProductToCart
{
    
    [[ProductService sharedManager] addToCartPersonalize:productId qty:str dataArray:personalizeDict success:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            
                            if (data != nil)
                            {
                                NSString  *status =(NSString *)data;
                                NSString *count =[UserDefaultManager getValue:@"total_cart_item"];
                                int total =[count intValue];
                                
                                
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
-(void)removeFromWishlistWebservice
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
                 if (data == nil)
                 {
//                     UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                     [alert1 show];
                     [button1 setSelected:YES];
                     
                 }
                 else
                 {
                     //[self getMyWishlist];
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
-(void)addToWishlistWebservice
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }
    else
    {
        
        [[ProductService sharedManager] addToWishlist:productId success:^(id data)
         {
             //Handle fault cases
             dispatch_async(dispatch_get_main_queue(), ^{
                 // code here
                 [myDelegate StopIndicator];
                 if (data != nil)
                 {
                     
                     //[self getMyWishlist];
                     
                 }
                 else
                 {
//                     UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                     [alert1 show];
                     [button1 setSelected:NO];
                 }
                 
                 
                 
             });
             
         }
                                              failure:^(NSError *error)
         {
             //Handle if response is nil
             
         }];
    }
    
}
-(void)downloadImages :(int)index
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager downloadWithURL:[[productDetailDict objectForKey:@"url"] objectAtIndex:index]
                     options:0
                    progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
         
         
     }
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
     {
         if (image)
         {
             [uploadedImages replaceObjectAtIndex:index withObject:image];
             productSliderImageView.image =[uploadedImages objectAtIndex:0];
             
         } else {
             
             NSLog(@"error is %@", error);
         }
     }];
    
}




-(void)getProductDetailService
{
    
    [[ProductService sharedManager] productDetailService:productId success:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            
                            if (data != nil)
                            {
                                productDetailDict = (NSMutableDictionary *)data;
                                isInStock = [productDetailDict objectForKey:@"is_in_stock"];
                                if (![self.isInStock boolValue])
                                {
                                    [addToBagButton setTitle:@"ADD TO WAITLIST" forState:UIControlStateNormal];
                                    addQuantityButton.enabled = NO;
                                }
                                else
                                {
                                    [addToBagButton setTitle:@"ADD TO BAG" forState:UIControlStateNormal];
                                    
                                }
                                if (productDetailDict.count<1)
                                {
                                    return;
                                }
                                if ([[productDetailDict objectForKey:@"has_options"] boolValue])
                                {
                                    personaliseButton.hidden = NO;
                                }
                                else
                                {
                                    personaliseButton.hidden = YES;
                                    
                                }
                                for (int i=0; i<[[productDetailDict objectForKey:@"url"]count]; i++)
                                {
                                    [uploadedImages addObject:[UIImage imageNamed:@"placeholder.png"]];
                                }
                                productSliderImageView.image = [UIImage imageNamed:@"placeholder.png"];
                                productSliderPageControl.numberOfPages = uploadedImages.count;
                                for (int i=0; i<uploadedImages.count; i++)
                                {
                                    
                                    [self downloadImages:i];
                                }
                                self.skuLabel.text = [NSString stringWithFormat:@"SKU# %@",[productDetailDict objectForKey:@"sku"]];
                                rewardLbl.text = [NSString stringWithFormat:@"Earn upto %d loyalty points",[[productDetailDict objectForKey:@"price"] intValue]];
                                NSString *name = [productDetailDict objectForKey:@"name"];
                                name = [name lowercaseString];
                                name = [name stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[name substringToIndex:1] uppercaseString]];
                                self.productNameLabel.text = name;
                                productName = name;
                                
                                // self.navigationItem.title=self.productName;
                                self.priceLabel.text =[CurrencyConverter converCurrency:[productDetailDict objectForKey:@"price"]];
                                
                                NSMutableDictionary * deliveryDict = [NSMutableDictionary new];
                                NSMutableDictionary * descriptionDict = [NSMutableDictionary new];
                                [descriptionDict setObject:[productDetailDict objectForKey:@"Details"] forKey:@"Details"];
                                NSMutableDictionary * sizeGuideDict = [NSMutableDictionary new];
                                [sizeGuideDict setObject:@"View our sizing guide" forKey:@"sizeGuide"];
                                if (productDetailDict[@"Delivery"])
                                {
                                    [deliveryDict setObject:[productDetailDict objectForKey:@"Delivery"] forKey:@"Delivery"];
                                    tableDataArray = [[NSMutableArray alloc]initWithObjects:deliveryDict,descriptionDict,sizeGuideDict, nil];
                                    keys = [[NSArray alloc]initWithObjects:@"Delivery",@"Details",@"View our sizing guide", nil];
                                }
                                else
                                {
                                    tableDataArray = [[NSMutableArray alloc]initWithObjects:descriptionDict,sizeGuideDict, nil];
                                    keys = [[NSArray alloc]initWithObjects:@"Details",@"View our sizing guide", nil];
                                }
                                self.detailInformationTableView.frame = CGRectMake(self.detailInformationTableView.frame.origin.x, rewardLbl.frame.origin.y+rewardLbl.frame.size.height+30, self.view.frame.size.width, 35*keys.count+25);
                                //  self.shareButton.frame =CGRectMake(self.shareButton.frame.origin.x, detailInformationTableView.frame.origin.y+detailInformationTableView.frame.size.height+10, self.shareButton.frame.size.width, self.shareButton.frame.size.height);
                                initialHeight = self.detailInformationTableView.frame.size.height;
                                [detailInformationTableView reloadData];
                                //[self getProductImage];
                                [self getSizeGuideData];
                                
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
-(void)getSizeGuideData
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
            
        });
    }
    [[ProductService sharedManager] sizeGuide:^(id data)
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
                                sizeGuideArray = (NSMutableArray *)data;
                                
                                if ([UserDefaultManager getValue:@"productDetailDict"] != nil)
                                {
                                    NSDictionary *dict=[UserDefaultManager getValue:@"productDetailDict"];
                                    if ([[dict objectForKey:@"isWishlist"] isEqualToString:@"yes"])
                                    {
                                        [self addToWishlistButtonAction:nil];
                                    }
                                }
                                else
                                {
                                    [myDelegate StopIndicator];
                                }
                                
                                
                            }
                        });
         
     }
                                      failure:^(NSError *error)
     {
         [myDelegate StopIndicator];
         dispatch_async(dispatch_get_main_queue(), ^{
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
         });
         
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
                                [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Your product has been added to cart" parentView:self.view];
                                NSMutableArray *tempArray=[UserDefaultManager getValue:@"cartData"];
                                NSMutableArray * cartArray = [tempArray mutableCopy];
                                NSMutableArray * tmpAry = [cartArray mutableCopy];
                                for (int i =0; i<cartArray.count; i++)
                                {
                                    NSMutableDictionary * myCartDict = [cartArray objectAtIndex:i];
                                    if (![[myCartDict objectForKey:@"parent_item_id"] isEqualToString:@"\n"])
                                    {
                                        [tmpAry removeObject:myCartDict];
                                        
                                    }
                                    
                                }
                                [cartArray removeAllObjects];
                                cartArray = [tmpAry mutableCopy];
                                [UserDefaultManager setValue:cartArray key:@"cartData"];
                                
                                
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
                                
                                
                            }
                        });
         
     }
                                        failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
    
}

-(void)updateCartProduct
{
    
    
    NSMutableArray *cartArray = [[UserDefaultManager getValue:@"cartData"] mutableCopy];
    
    if (isAddedtoCart)
    {
        for (int i =0; i<cartArray.count; i++)
        {
            NSMutableDictionary * tmpDict =[cartArray objectAtIndex:i];
            if ([[tmpDict objectForKey:@"product_id"] isEqualToString:[cartDict objectForKey:@"product_id"]])
            {
                NSMutableDictionary *tempDict = [tmpDict mutableCopy];
                int alreadyAdded =[[tempDict objectForKey:@"product_quantity"]intValue];
                // alreadyAdded = alreadyAdded+[quantityLabel.text intValue];
                alreadyAdded = alreadyAdded+[str intValue];
                
                [tempDict setObject:[NSString stringWithFormat:@"%d",alreadyAdded] forKey:@"product_quantity"];
                [cartArray replaceObjectAtIndex:i withObject:tempDict];
                [UserDefaultManager setValue:cartArray key:@"cartData"];
                break;
            }
            
        }
    }
    else
    {
        if (cartArray.count<1) {
            cartArray = [[NSMutableArray alloc]init];
        }
        NSMutableDictionary *tempDict = [NSMutableDictionary new];
        cartDict = nil;
        // int alreadyAdded =[quantityLabel.text intValue];
        int alreadyAdded =[str intValue];
        
        [tempDict setObject:[NSString stringWithFormat:@"%d",alreadyAdded] forKey:@"product_quantity"];
        [tempDict setObject:productId forKey:@"product_id"];
        cartDict = [tempDict mutableCopy];
        [cartArray addObject:tempDict];
        [UserDefaultManager setValue:cartArray key:@"cartData"];
        NSMutableArray *tmpArray =[UserDefaultManager getValue:@"cartData"];
        NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)[tmpArray count]];
        button.badgeValue = count;
        button.badgeBGColor = [UIColor colorWithRed:237.0/255.0 green:0.0/255.0 blue:140.0/255.0 alpha:1.0];
        isAddedtoCart = true;
        
    }
    
    
}

-(void)addToCartService
{
    
    [[ProductService sharedManager] addToCart:productId qty:str success:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [myDelegate StopIndicator];
                            if (data != nil)
                            {
                                NSString  *status =(NSString *)data;
                                NSString *count =[UserDefaultManager getValue:@"total_cart_item"];
                                int total =[count intValue];
                                
                                
                                if ([status boolValue])
                                {
                                    [self updateCartProduct];
                                    
                                    [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Your product has been added to cart" parentView:self.view];
                                    
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
#pragma mark - end
#pragma mark - Swipe Images
- (void)addLeftAnimationPresentToView:(UIView *)viewTobeAnimatedLeft
{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.30;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [transition setValue:@"IntroSwipeIn" forKey:@"IntroAnimation"];
    transition.fillMode=kCAFillModeForwards;
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromRight;
    [viewTobeAnimatedLeft.layer addAnimation:transition forKey:nil];
    
}

- (void)addRightAnimationPresentToView:(UIView *)viewTobeAnimatedRight
{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.30;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [transition setValue:@"IntroSwipeIn" forKey:@"IntroAnimation"];
    transition.fillMode=kCAFillModeForwards;
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromLeft;
    [viewTobeAnimatedRight.layer addAnimation:transition forKey:nil];
    
}

-(void) swipeBannerImageLeft: (UISwipeGestureRecognizer *)sender
{
    
    imageIndex++;
    if (imageIndex<uploadedImages.count)
    {
        // productSliderImageView.image=[swipeProductImages objectAtIndex:imageIndex];
        productSliderImageView.image =[uploadedImages objectAtIndex:imageIndex];
        UIImageView *moveIMageView = productSliderImageView;
        [self addLeftAnimationPresentToView:moveIMageView];
        int page=imageIndex;
        productSliderPageControl.currentPage=page;
    }
    else
    {
        imageIndex--;
    }
    
}

-(void) swipeBannerImageRight: (UISwipeGestureRecognizer *)sender
{
    imageIndex--;
    if (imageIndex<uploadedImages.count)
    {
        //  productSliderImageView.image=[swipeProductImages objectAtIndex:imageIndex];
        productSliderImageView.image =[uploadedImages objectAtIndex:imageIndex];
        UIImageView *moveIMageView = productSliderImageView;
        [self addRightAnimationPresentToView:moveIMageView];
        int page=imageIndex;
        productSliderPageControl.currentPage=page;
    }
    else
    {
        imageIndex++;
    }
}

#pragma mark - end
-(CGSize)getLabelHeight : (NSString *)string
{
    
    
    CGSize maximumLabelSize = CGSizeMake(284, FLT_MAX);
    
    CGSize expectedLabelSize = [string sizeWithFont:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    
    //adjust the label the the new height.
    CGRect newFrame;
    newFrame.size.height = expectedLabelSize.height;
    if (expectedLabelSize.height<25.0)
    {
        expectedLabelSize.height = 35;
    }
    return expectedLabelSize;
}
#pragma mark - Tableview methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView indexPathsForSelectedRows].count)
    {
        
        if ([[tableView indexPathsForSelectedRows] indexOfObject:indexPath] != NSNotFound)
        {
            NSMutableDictionary *tmpDict = [tableDataArray objectAtIndex:indexPath.row];
            //adjust the label the the new height.
            return [self getLabelHeight:[tmpDict objectForKey:[keys objectAtIndex:indexPath.row]]].height+40; // Expanded height
        }
        return contractedHeight; // Normal height
    }
    
    return contractedHeight; // Normal height
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableDataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"ProductDetailCell";
    ProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[ProductDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    [cell layouutView:self.view.frame];
    cell.titleLabel.text =[keys objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *tmpDict = [tableDataArray objectAtIndex:indexPath.row];
    if ([[tmpDict objectForKey:@"sizeGuide"] isEqualToString:@"View our sizing guide"])
    {
        SizeGuideViewController * objSizeGuide = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SizeGuideViewController"];
        objSizeGuide.sizeGuideArray = sizeGuideArray;
        [self.navigationController pushViewController:objSizeGuide animated:YES];
        
    }
    else
    {
        CGSize size =[self getLabelHeight:[tmpDict objectForKey:[keys objectAtIndex:indexPath.row]]];
        [self updateTableView];
        expendedCell++;
        ProductDetailCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.borderView.frame = CGRectMake(cell.borderView.frame.origin.x, cell.borderView.frame.origin.y, self.view.frame.size.width, cell.frame.size.height-7);
        cell.detailLabel.text = [tmpDict objectForKey:[keys objectAtIndex:indexPath.row]];
        cell.detailLabel.frame =CGRectMake(cell.detailLabel.frame.origin.x, cell.detailLabel.frame.origin.y, cell.borderView.frame.size.width-30, size.height);
        [cell.contentView sendSubviewToBack:cell.borderView];
        float height = size.height;
        height *= expendedCell;
        self.productDetailScrollView.contentSize =CGSizeMake(320, 1000);
        self.detailInformationTableView.frame = CGRectMake(self.detailInformationTableView.frame.origin.x, self.detailInformationTableView.frame.origin.y, self.detailInformationTableView.frame.size.width, initialHeight+height+10);
        //  self.shareButton.frame = CGRectMake(self.shareButton.frame.origin.x, self.detailInformationTableView.frame.origin.y+self.detailInformationTableView.frame.size.height+10, self.shareButton.frame.size.width, self.shareButton.frame.size.height);
        mainContainerView.frame = CGRectMake(productDetailScrollView.frame.origin.x, productDetailScrollView.frame.origin.y, self.view.frame.size.width, 1000);
        cell.detailLabel.hidden = NO;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *tmpDict = [tableDataArray objectAtIndex:indexPath.row];
    if ([[tmpDict objectForKey:@"sizeGuide"] isEqualToString:@"View our sizing guide"])
    {
        SizeGuideViewController * objSizeGuide = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SizeGuideViewController"];
        objSizeGuide.sizeGuideArray = sizeGuideArray;
    }
    else
    {
        expendedCell--;
        ProductDetailCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.borderView.frame = CGRectMake(cell.borderView.frame.origin.x, cell.borderView.frame.origin.y, self.view.frame.size.width, contractedHeight-8);
        [cell.contentView sendSubviewToBack:cell.borderView];
        cell.detailLabel.hidden = YES;
        NSMutableDictionary *tmpDict = [tableDataArray objectAtIndex:indexPath.row];
        CGSize size =[self getLabelHeight:[tmpDict objectForKey:[keys objectAtIndex:indexPath.row]]];
        float height = size.height;
        height *= expendedCell;
        self.detailInformationTableView.frame = CGRectMake(self.detailInformationTableView.frame.origin.x, self.detailInformationTableView.frame.origin.y, self.detailInformationTableView.frame.size.width, initialHeight+height+10);
        self.productDetailScrollView.contentSize =CGSizeMake(320, 1000);
        // self.shareButton.frame = CGRectMake(self.shareButton.frame.origin.x, self.detailInformationTableView.frame.origin.y+self.detailInformationTableView.frame.size.height, self.shareButton.frame.size.width, self.shareButton.frame.size.height);
        mainContainerView.frame = CGRectMake(productDetailScrollView.frame.origin.x, productDetailScrollView.frame.origin.y, self.view.frame.size.width, 1000);
        [self updateTableView];
    }
}

- (void)updateTableView
{
    [self.detailInformationTableView beginUpdates];
    [self.detailInformationTableView endUpdates];
    
}

#pragma mark - end
#pragma mark - Picker View methods

-(void)pickerShow
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [quantityPickerView setNeedsLayout];
    [quantityPickerView reloadAllComponents];
    quantityPickerView.frame = CGRectMake(quantityPickerView.frame.origin.x, self.view.bounds.size.height-quantityPickerView.frame.size.height , self.view.bounds.size.width, quantityPickerView.frame.size.height);
    pickerToolBar.frame = CGRectMake(pickerToolBar.frame.origin.x, quantityPickerView.frame.origin.y-44, self.view.bounds.size.width, pickerToolBar.frame.size.height);
    [UIView commitAnimations];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,600,20)];
        pickerLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightRegular];
        pickerLabel.textAlignment=NSTextAlignmentCenter;
    }
    
    NSString *str1=[quantityArray objectAtIndex:row];
    pickerLabel.text=str1;
    return pickerLabel;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return quantityArray.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str1=[quantityArray objectAtIndex:row];
    return str1;
}
- (IBAction)pickerToolBar:(id)sender
{
    NSInteger index = [quantityPickerView selectedRowInComponent:0];
    [quantityPickerView selectRow:index inComponent:0 animated:YES];
    
    UIFont *fnt = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    
    NSMutableAttributedString *attributedStringFirst = [[NSMutableAttributedString alloc] initWithString:@"QUANTITY : " attributes:@{NSFontAttributeName: [fnt fontWithSize:14]}];
    str = [quantityArray objectAtIndex:index];
    [attributedStringFirst addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:(NSMakeRange(0, @"QUANTITY : ".length))];
    NSMutableAttributedString * stringFirst = [[NSMutableAttributedString alloc] initWithString:str];
    [stringFirst addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular] range:(NSMakeRange(0, str.length))];
    [stringFirst addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:241.0/255.0 green:0.0/255.0 blue:136.0/255.0 alpha:1.0] range:(NSMakeRange(0, str.length))];
    NSMutableAttributedString *resultFirst = [attributedStringFirst mutableCopy];
    [resultFirst appendAttributedString:stringFirst];
    [addQuantityButton setAttributedTitle:resultFirst forState:UIControlStateNormal];
    [self hidePickerWithAnimation];
    NSLog(@"addQuantityButton.titleLabel.text is %@",addQuantityButton.titleLabel.text);
    //[self addToBagButtonAction:nil];
}
- (IBAction)cancelButtonPickerToolbar:(id)sender {
    [self hidePickerWithAnimation];
}
-(void)hidePickerWithAnimation
{
    // scrollView.scrollEnabled = YES;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    quantityPickerView.frame = CGRectMake(quantityPickerView.frame.origin.x, 1000, self.view.bounds.size.width, quantityPickerView.frame.size.height);
    pickerToolBar.frame = CGRectMake(pickerToolBar.frame.origin.x, 1000, self.view.bounds.size.width, pickerToolBar.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark - end
#pragma mark - Button actions
- (IBAction)learnHowAction:(id)sender {
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    J2TRewardsViewController *view =[storyboard instantiateViewControllerWithIdentifier:@"J2TRewardsViewController"];
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)quantityIncrementButtonAction:(id)sender
{
    //
    //
    //    remainingInventry--;
    //    quantityLabel.text = [NSString stringWithFormat:@"%ld", quantityLabel.text.integerValue +1];
    //
    
    
}

- (IBAction)quantityDecrementButtonAction:(id)sender
{
    //    remainingInventry++;
    //    int value = [quantityLabel.text intValue];
    //    if (value>1)
    //    {
    //        quantityLabel.text = [NSString stringWithFormat:@"%ld", quantityLabel.text.integerValue -1];
    //    }
    
}
- (IBAction)addToBagButtonAction:(id)sender
{
    
    if ([addToBagButton.titleLabel.text isEqualToString:@"ADD TO WAITLIST"])
    {
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
        return;
    }
    
    else if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
    {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"You need to login first." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //            alert.tag=1;
        //            [alert show];
        //        });
        
        NSDictionary *detailDict=[NSDictionary new];
        
        myDelegate.istoast = true;
        if([[UIScreen mainScreen] bounds].size.height>480)
        {
            myDelegate.toastMessage = @"SIGN IN to add products to your cart";
        }
        else
        {
            myDelegate.toastMessage = @"SIGN IN to add products to your cart";
        }
        
        NSLog(@"productId = %@",productId);
        NSLog(@"isInStock = %@",isInStock);
        
        
        detailDict = @{@"productId":productId,@"objectIndex":@"0",@"isInStock":isInStock,@"isWishlist":@"no"};
        
        [UserDefaultManager setValue:detailDict key:@"productDetailDict"];
        [UserDefaultManager setValue:@"ProductDetailViewController" key:@"CurrentView"];
        
        NSLog(@"productDetailDict = %@ ,Current View = %@ ",[UserDefaultManager getValue:@"productDetailDict"],[UserDefaultManager getValue:@"CurrentView"]);
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
        myDelegate.window.rootViewController = myDelegate.navigationController;
        return;
    }
    
    addQuantityButton.hidden = NO;
    NSLog(@"addQuantityButton.titleLabel.text is %@",addQuantityButton.titleLabel.text);
    if (str==nil)
    {
        [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please select quantity" parentView:self.view];
    }
    else
    {
        if (![[productDetailDict objectForKey:@"has_options"] boolValue])
        {
            if (remainingInventry>0 || [isInStock boolValue])
            {
                [myDelegate ShowIndicator];
                [self performSelector:@selector(addToCartService) withObject:nil afterDelay:.1];
            }
            else
            {
                [MozTopAlertView showWithType:MozAlertTypeInfo text:[NSString stringWithFormat:@"The requested quantity for %@ is not available.",productName] parentView:self.view];
                
            }
        }
        else
        {
            bool isRequired = false;
            for (int i =0; i<[[productDetailDict objectForKey:@"Personalize"] count]; i++)
            {
                NSMutableDictionary * tempDict =[[productDetailDict objectForKey:@"Personalize"]objectAtIndex:i];
                if ([[tempDict objectForKey:@"is_require"] boolValue])
                {
                    isRequired = true;
                    break;
                }
            }
            if (isRequired)
            {
                    [MozTopAlertView showWithType:MozAlertTypeInfo text:[NSString stringWithFormat:@"Please personalize this product."] parentView:self.view];
            }
            
            else if (remainingInventry>0 || [isInStock boolValue])
            {
                [myDelegate ShowIndicator];
                [self performSelector:@selector(addPersonalizeProductToCart) withObject:nil afterDelay:.1];
            }
            else
            {
                [MozTopAlertView showWithType:MozAlertTypeInfo text:[NSString stringWithFormat:@"The requested quantity for %@ is not available.",productName] parentView:self.view];
            }
        }
    }
}
- (IBAction)addToWishlistButtonAction:(id)sender
{
    if(([[UserDefaultManager getValue:@"customer_id"] isEqualToString:@""] || [[UserDefaultManager getValue:@"customer_id"] isEqualToString:@"(null)"] ||[UserDefaultManager getValue:@"customer_id"] ==NULL))
    {
        NSDictionary *detailDict=[NSDictionary new];
        
        myDelegate.istoast = true;
        if([[UIScreen mainScreen] bounds].size.height>480)
        {
            myDelegate.toastMessage = @"SIGN IN to add products to your wishlist";
        }
        else
        {
            myDelegate.toastMessage = @"SIGN IN to add products to your wishlist";
        }
        
        NSLog(@"productId = %@",productId);
        NSLog(@"isInStock = %@",isInStock);
        
        
        detailDict = @{@"productId":productId,@"objectIndex":@"0",@"isInStock":isInStock,@"isWishlist":@"yes"};
        
        [UserDefaultManager setValue:detailDict key:@"productDetailDict"];
        [UserDefaultManager setValue:@"ProductDetailViewController" key:@"CurrentView"];
        
        NSLog(@"productDetailDict = %@ ,Current View = %@ ",[UserDefaultManager getValue:@"productDetailDict"],[UserDefaultManager getValue:@"CurrentView"]);
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
        myDelegate.window.rootViewController = myDelegate.navigationController;
    }
    
    else if ([button1 isSelected])
    {
        if ([UserDefaultManager getValue:@"productDetailDict"]!=nil)
        {
            [UserDefaultManager removeValue:@"productDetailDict"];
            [UserDefaultManager removeValue:@"CurrentView"];
            
            NSLog(@"added to wishlist");
        }
        else
        {
            
            [button1 setSelected:NO];
            [button1 setImage:[UIImage imageNamed:@"product_detail_heart"] forState:UIControlStateNormal];
            [self removeFromWishlistWebservice];
            myDelegate.wishlistItems--;
            [self updateBadge];
        }
    }
    else
    {
        [UserDefaultManager removeValue:@"productDetailDict"];
        [UserDefaultManager removeValue:@"CurrentView"];
        
        
        [button1 setImage:[UIImage imageNamed:@"product_detail_heart_full"] forState:UIControlStateNormal];
        [button1 setSelected:YES];
        myDelegate.wishlistItems++;
        [self updateBadge];
        [self addToWishlistWebservice];
    }
}
- (IBAction)personaliseButtonAction:(id)sender
{
    PersonalizeViewController * objPersonalize = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalizeViewController"];
    objPersonalize.personalizeArray = [productDetailDict objectForKey:@"Personalize"];
    objPersonalize.productName = self.productName;
    objPersonalize.objProductDetail = self;
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:objPersonalize];
    [self.navigationController presentViewController:navBar animated: YES completion: ^ {
    }];
}
- (IBAction)cartButtonAction:(id)sender
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
- (IBAction)shareButtonAction:(id)sender {
    NSString *textToShare = @"Look at this awesome pipa+bella product!";
    NSURL *myWebsite = [NSURL URLWithString:[productDetailDict objectForKey:@"product_url"]];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

-(void)backButtonAction :(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addQuantityButtonClicked:(id)sender {
    [self pickerShow];
}




#pragma mark - end
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1)
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
