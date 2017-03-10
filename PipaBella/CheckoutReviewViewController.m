//
//  CheckoutReviewViewController.m
//  PipaBella
//
//  Created by Ranosys on 05/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "CheckoutReviewViewController.h"
#import "OrderService.h"
#import "CheckoutManageAddressViewController.h"
#import "CurrencyConverter.h"
@interface CheckoutReviewViewController ()<BSKeyboardControlsDelegate>
{
    NSArray *textFields;

    int checkCoupon;
    int checkRedeem;
    
    NSString* discountPrice;
    UILabel *totalPriceLabel;
    UILabel *totalPriceLbl;
    NSString *loyaltyPoints;
    
    UILabel *productNameLbl;
    UILabel *priceLbl;
}
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIButton *gotACouponButton;
@property (weak, nonatomic) IBOutlet UIButton *redeemPointsButton;
@property (weak, nonatomic) IBOutlet UILabel *loyaltyPointsLabel;
@property (weak, nonatomic) IBOutlet UITextField *enterCouponCodeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *enterPointsToRedeemTextfield;
@property (weak, nonatomic) IBOutlet UIButton *reviewButton;
@property (weak, nonatomic) IBOutlet UIButton *deliverToButton;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (strong, nonatomic) IBOutlet UIView *productPurchasedView;
@property (strong, nonatomic) IBOutlet UILabel *productNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *productPriceLabel;
- (IBAction)proceedAddAddressScreenClickAction:(id)sender;

@end

@implementation CheckoutReviewViewController
@synthesize gotACouponButton,redeemPointsButton,loyaltyPointsLabel,enterCouponCodeTextfield,enterPointsToRedeemTextfield,reviewButton,deliverToButton,payButton,productPurchasedView,totalPrice;
@synthesize cartArray,scrollView,mainView;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=@"CHECKOUT";
    
    textFields = @[enterPointsToRedeemTextfield];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFields]];
    [self.keyboardControls setDelegate:self];

    checkCoupon=0;
    checkCoupon=0;
    [reviewButton addBorder:reviewButton color:[UIColor colorWithRed:241.0/255.0 green:0.0/255.0 blue:136.0/255.0 alpha:1.0]];
    [reviewButton setTitleColor:[UIColor colorWithRed:241.0/255.0 green:0.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    
    [deliverToButton addBorder:deliverToButton color:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0]];
    [deliverToButton setTitleColor:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    
    [payButton addBorder:payButton color:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0]];
    [payButton setTitleColor:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    
    [self addborder];
    
    enterCouponCodeTextfield.hidden = YES;
    enterPointsToRedeemTextfield.hidden = YES;
    [enterPointsToRedeemTextfield addTextFieldPaddingWithoutImages:enterPointsToRedeemTextfield];
    [enterCouponCodeTextfield addTextFieldPaddingWithoutImages:enterCouponCodeTextfield];
    
    [self setViewFrames:1];
    
    
    
    [self performSelector:@selector(getLoyaltyDetail) withObject:nil afterDelay:.5];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //NSLog(@"Tab Id = %d, SELECTED INDEX = %lu",myDelegate.tabId,self.tabBarController.selectedIndex);
    if (myDelegate.tabId != self.tabBarController.selectedIndex)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)setViewFrames:(int)number
{
    
    [productNameLbl removeFromSuperview];
    [priceLbl removeFromSuperview];
    
    self.scrollView.translatesAutoresizingMaskIntoConstraints = YES;
    self.mainView.translatesAutoresizingMaskIntoConstraints = YES;

    //Purchased view
    productPurchasedView.translatesAutoresizingMaskIntoConstraints = YES;
    self.productNameLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.productPriceLabel.translatesAutoresizingMaskIntoConstraints = YES;
 
    productPurchasedView.layer.borderColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0].CGColor;
    productPurchasedView.layer.borderWidth = 1.5f;
    productPurchasedView.frame = CGRectMake(productPurchasedView.frame.origin.x, productPurchasedView.frame.origin.y, self.view.frame.size.width-20, 20*(cartArray.count+number+1)+30);
    
    self.productNameLabel.frame = CGRectMake(self.productNameLabel.frame.origin.x, self.productNameLabel.frame.origin.y, self.productNameLabel.frame.size.width, 0);
    self.productPriceLabel.frame = CGRectMake(self.productPurchasedView.frame.size.width-70, self.productPriceLabel.frame.origin.y, self.productPriceLabel.frame.size.width, self.productPriceLabel.frame.size.height);
    
    float y = 7.0;
    for (int i = 0; i < cartArray.count+number; i++)
    {
        NSMutableDictionary * dataDict;
        productNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, y, 200, 20)];
        priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(productPurchasedView.frame.size.width-65, y, 80,20)];//replace 40 with desired label width
        productNameLbl.textColor = [UIColor colorWithRed:107.0/255.0 green:107.0/255.0 blue:107.0/255.0 alpha:1.0];
        priceLbl.textColor = [UIColor colorWithRed:107.0/255.0 green:107.0/255.0 blue:107.0/255.0 alpha:1.0];
        productNameLbl.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
        priceLbl.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
        
        if (i < cartArray.count)
        {
            dataDict= [cartArray objectAtIndex:i];
            
            //calculate dynamic width of product label
            float widthIs =
            [[dataDict objectForKey:@"product_name"]
             boundingRectWithSize:productNameLbl.frame.size
             options:NSStringDrawingUsesLineFragmentOrigin
             attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:8 weight:UIFontWeightRegular] }
             context:nil]
            .size.width;
            //NSLog(@"the width of yourLabel is %f", widthIs);
            CGRect rect = productNameLbl.frame;
            
            if([[UIScreen mainScreen] bounds].size.height>667)
            {
               rect.size.width = widthIs;
            }
            else
            {
               rect.size.width = widthIs;
            }
            productNameLbl.frame = rect;
            NSString * productNameStr = [dataDict objectForKey:@"product_name"];
            
            productNameStr = [productNameStr lowercaseString];
            productNameStr = [productNameStr stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[productNameStr substringToIndex:1] uppercaseString]];
            productNameLbl.text = [NSString stringWithFormat:@"%@",productNameStr];
            //end
            //productNameLbl.backgroundColor = [UIColor greenColor];
            //multi color string for price label
            
            
            NSString * priceStr = [CurrencyConverter converCurrency:[NSString stringWithFormat:@"%f",[[dataDict objectForKey:@"price"] floatValue]*[[dataDict objectForKey:@"product_quantity"] intValue]]];
            NSRange currencyRange = [priceStr rangeOfString:@"Rs" options:NSCaseInsensitiveSearch];
            //NSRange priceRange = [priceStr rangeOfString:[dataDict objectForKey:@"price"] options:NSCaseInsensitiveSearch];
            //NSLog(@"priceStr.length is %lu",(unsigned long)priceStr.length);
            NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:priceStr];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0] range:currencyRange];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10 weight:UIFontWeightMedium] range:currencyRange];
            priceLbl.attributedText =string;
        }
        else if (i == cartArray.count+1)
        {
            float widthIs =
            [@"Discount"
             boundingRectWithSize:productNameLbl.frame.size
             options:NSStringDrawingUsesLineFragmentOrigin
             attributes:@{ NSFontAttributeName:productNameLbl.font }
             context:nil]
            .size.width;
            //NSLog(@"the width of yourLabel is %f", widthIs);
            CGRect rect = productNameLbl.frame;
            rect.size.width = widthIs;
            productNameLbl.frame = rect;
            productNameLbl.text =@"Discount";
            //end
            
            //multi color string for price label
            NSString * priceStr = [CurrencyConverter converCurrency:discountPrice];
            NSRange currencyRange = [priceStr rangeOfString:@"Rs" options:NSCaseInsensitiveSearch];
            //NSRange priceRange = [priceStr rangeOfString:[dataDict objectForKey:@"price"] options:NSCaseInsensitiveSearch];
            //NSLog(@"priceStr.length is %lu",(unsigned long)priceStr.length);
            NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:priceStr];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0] range:currencyRange];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10 weight:UIFontWeightMedium] range:currencyRange];
            priceLbl.attributedText =string;
            
        }
        else  if (cartArray.count>0)
        {
            float widthIs =
            [@"Tax"
             boundingRectWithSize:productNameLbl.frame.size
             options:NSStringDrawingUsesLineFragmentOrigin
             attributes:@{ NSFontAttributeName:productNameLbl.font }
             context:nil]
            .size.width;
            //NSLog(@"the width of yourLabel is %f", widthIs);
            CGRect rect = productNameLbl.frame;
            rect.size.width = widthIs;
            productNameLbl.frame = rect;
            productNameLbl.text =@"Tax";
            //end
            
            //multi color string for price label
            NSString * priceStr = [CurrencyConverter converCurrency:[UserDefaultManager getValue:@"total_tax_amount"]];
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
            //NSLog(@"priceStr.length is %lu",(unsigned long)priceStr.length);
            NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:priceStr];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0] range:currencyRange];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10 weight:UIFontWeightMedium] range:currencyRange];
            priceLbl.attributedText =string;
            
        }
        
        //dot label initialization
        UILabel *dotLbl = [[UILabel alloc] initWithFrame:CGRectMake(productNameLbl.frame.origin.x+productNameLbl.frame.size.width+1, y+3, productPurchasedView.frame.size.width-productNameLbl.frame.size.width-priceLbl.frame.size.width+10, 10)];
        dotLbl.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
        dotLbl.backgroundColor = [UIColor clearColor];
        dotLbl.textColor = [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1.0];
        dotLbl.text = @".....................................................................................................";
        //end
        y =productNameLbl.frame.origin.y+productNameLbl.frame.size.height+2;
        
        [totalPriceLbl removeFromSuperview];
        [totalPriceLabel removeFromSuperview];
        
        [productPurchasedView addSubview:dotLbl];
        [productPurchasedView addSubview:productNameLbl];
        [productPurchasedView addSubview:priceLbl];
    }
    
    
    totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, y, 200, 20)];
    totalPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(productPurchasedView.frame.size.width-85, y, 80,20)];//replace 40 with desired label width
    totalPriceLabel.textColor = [UIColor colorWithRed:107.0/255.0 green:107.0/255.0 blue:107.0/255.0 alpha:1.0];
    totalPriceLbl.textColor = [UIColor colorWithRed:107.0/255.0 green:107.0/255.0 blue:107.0/255.0 alpha:1.0];
    totalPriceLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
    totalPriceLbl.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    
    
    float widthIs =
    [@"Total Payable"
     boundingRectWithSize:totalPriceLabel.frame.size
     options:NSStringDrawingUsesLineFragmentOrigin
     attributes:@{ NSFontAttributeName:totalPriceLabel.font }
     context:nil]
    .size.width;
    //NSLog(@"the width of yourLabel is %f", widthIs);
    CGRect rect = totalPriceLabel.frame;
    rect.size.width = widthIs;
    totalPriceLabel.frame = rect;
    totalPriceLabel.text =@"Total Payable";
    //end
    
    //multi color string for price label
    NSString * priceStr = [CurrencyConverter converCurrency:totalPrice];
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
    //NSLog(@"priceStr.length is %lu",(unsigned long)priceStr.length);
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0] range:currencyRange];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15 weight:UIFontWeightRegular] range:currencyRange];
    totalPriceLbl.attributedText =string;
    
    UILabel *dotLbl = [[UILabel alloc] initWithFrame:CGRectMake(totalPriceLabel.frame.origin.x+totalPriceLabel.frame.size.width+1, y+3, productPurchasedView.frame.size.width-totalPriceLabel.frame.size.width-totalPriceLbl.frame.size.width+15, 10)];
    dotLbl.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
    dotLbl.backgroundColor = [UIColor clearColor];
    dotLbl.textColor = [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1.0];
    dotLbl.text = @".....................................................................................................";
    //end
    y =totalPriceLabel.frame.origin.y+totalPriceLabel.frame.size.height+2;
    //    [productPurchasedView addSubview:dotLbl];
    [productPurchasedView addSubview:totalPriceLabel];
    [productPurchasedView addSubview:totalPriceLbl];
    
    //Coupon code
    gotACouponButton.translatesAutoresizingMaskIntoConstraints = YES;
    redeemPointsButton.translatesAutoresizingMaskIntoConstraints = YES;
    enterCouponCodeTextfield.translatesAutoresizingMaskIntoConstraints = YES;
    enterPointsToRedeemTextfield.translatesAutoresizingMaskIntoConstraints = YES;
    loyaltyPointsLabel.translatesAutoresizingMaskIntoConstraints = YES;
    
    if ([gotACouponButton isHidden])
    {
        redeemPointsButton.frame = CGRectMake(self.view.frame.size.width-130, productPurchasedView.frame.origin.y+productPurchasedView.frame.size.height+20,redeemPointsButton.frame.size.width, redeemPointsButton.frame.size.height);
        
        enterPointsToRedeemTextfield.frame = CGRectMake(redeemPointsButton.frame.origin.x-enterPointsToRedeemTextfield.frame.size.width, productPurchasedView.frame.origin.y+productPurchasedView.frame.size.height+20,enterPointsToRedeemTextfield.frame.size.width, redeemPointsButton.frame.size.height);
        
        loyaltyPointsLabel.frame = CGRectMake(20, redeemPointsButton.frame.origin.y+redeemPointsButton.frame.size.height+5,self.view.frame.size.width-40, loyaltyPointsLabel.frame.size.height);
    }
    else
    {
        gotACouponButton.frame = CGRectMake(self.view.frame.size.width-130, productPurchasedView.frame.origin.y+productPurchasedView.frame.size.height+20,gotACouponButton.frame.size.width, gotACouponButton.frame.size.height);
        
        enterCouponCodeTextfield.frame = CGRectMake(gotACouponButton.frame.origin.x-enterCouponCodeTextfield.frame.size.width, productPurchasedView.frame.origin.y+productPurchasedView.frame.size.height+20,enterCouponCodeTextfield.frame.size.width, gotACouponButton.frame.size.height);
        
        redeemPointsButton.frame = CGRectMake(self.view.frame.size.width-130, gotACouponButton.frame.origin.y+gotACouponButton.frame.size.height+20,redeemPointsButton.frame.size.width, redeemPointsButton.frame.size.height);
        
        enterPointsToRedeemTextfield.frame = CGRectMake(redeemPointsButton.frame.origin.x-enterPointsToRedeemTextfield.frame.size.width, gotACouponButton.frame.origin.y+gotACouponButton.frame.size.height+20,enterPointsToRedeemTextfield.frame.size.width, redeemPointsButton.frame.size.height);
        
        loyaltyPointsLabel.frame = CGRectMake(20, redeemPointsButton.frame.origin.y+redeemPointsButton.frame.size.height+5,self.view.frame.size.width-40, loyaltyPointsLabel.frame.size.height);
    }
    
    scrollView.frame=CGRectMake(0,0, self.view.frame.size.width,self.view.frame.size.height);

    mainView.frame=CGRectMake(0,0, self.view.frame.size.width,loyaltyPointsLabel.frame.size.height+loyaltyPointsLabel.frame.origin.y+60);
    
    scrollView.contentSize=CGSizeMake(self.view.frame.size.width,mainView.frame.size.height);

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addborder
{
    [enterCouponCodeTextfield addBorder:enterCouponCodeTextfield];
    [enterPointsToRedeemTextfield addBorder:enterPointsToRedeemTextfield];
}
#pragma mark - end

#pragma mark - Table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.contentView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0f];
    
    return cell;
}
#pragma mark - end

#pragma mark - Button actions
- (IBAction)gotACouponButtonClicked:(id)sender
{
    [self.keyboardControls.activeField resignFirstResponder];

    enterCouponCodeTextfield.hidden = NO;
    [self.view endEditing:YES];
    [enterCouponCodeTextfield resignFirstResponder];
    //  [enterPointsToRedeemTextfield resignFirstResponder];
    
    if(checkCoupon == 1)
    {
        
        if (![enterCouponCodeTextfield isEmpty])
        {
            [myDelegate ShowIndicator];
            [self performSelector:@selector(addCouponCodeWebService) withObject:nil afterDelay:.1];
            [enterCouponCodeTextfield resignFirstResponder];
            self.view.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
            
        }
        else
        {
             [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter coupon code" parentView:self.view];
            // [self.view makeToast:@"Please enter coupon code" image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
            
//            UIAlertView *  alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter coupon code." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
        }
        
    }
    else
    {
        checkCoupon=1;
        [gotACouponButton setTitle:@"Apply" forState:UIControlStateNormal];
    }
}
- (IBAction)redeemPointsButtonClicked:(id)sender
{
    [self.keyboardControls.activeField resignFirstResponder];

    enterPointsToRedeemTextfield.hidden = NO;
    [self.view endEditing:YES];
    // [enterCouponCodeTextfield resignFirstResponder];
    [enterPointsToRedeemTextfield resignFirstResponder];
    
    if(checkRedeem == 1)
    {
        
        if (![enterPointsToRedeemTextfield isEmpty])
        {
            int eneterdPoints = [enterPointsToRedeemTextfield.text intValue];
            int loyaltyPoint = [loyaltyPoints intValue];
            
            if (eneterdPoints > loyaltyPoint)
            {
                [MozTopAlertView showWithType:MozAlertTypeInfo text:@"You can not redeem more than available point(s)" parentView:self.view];
               //  [self.view makeToast:@"You can not redeem more than available point(s)." image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
                
//                UIAlertView *  alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"You can not redeem more than available point(s)."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
            }
            else if (eneterdPoints <= 50)
            {
                [MozTopAlertView showWithType:MozAlertTypeInfo text:@"You can not redeem less than 50 points" parentView:self.view];
                // [self.view makeToast:@"You can not redeem less than 50 points." image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];
                
//                UIAlertView *  alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"You can not redeem less than 50 points." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
            }
            else
            {
                [myDelegate ShowIndicator];
                [self performSelector:@selector(redeemPointsWebService) withObject:nil afterDelay:.1];
            }
            self.view.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
            [enterPointsToRedeemTextfield resignFirstResponder];
        }
        else
        {
             [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Please enter redeem points" parentView:self.view];
          //  [self.view makeToast:@"Please enter redeem points." image:nil color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];

            
//            UIAlertView *  alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter redeem points." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
        }
        
    }
    else
    {
        checkRedeem=1;
        [redeemPointsButton setTitle:@"Apply" forState:UIControlStateNormal];
    }
    
    
}

- (IBAction)proceedAddAddressScreenClickAction:(id)sender {
    
    CheckoutManageAddressViewController * objChkout = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CheckoutManageAddressViewController"];
    objChkout.totalPrice=totalPrice;
    [self.navigationController pushViewController:objChkout animated:YES];
    
}

#pragma mark - end
#pragma mark - Add coupon webservice
-(void)addCouponCodeWebService
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
            
        });
    }

    
    [[OrderService sharedManager] shoppingCartCouponAddRequestParam:enterCouponCodeTextfield.text success:^(id data) {
        //Handle fault cases
        dispatch_async(dispatch_get_main_queue(),^
                       {
                           [myDelegate StopIndicator];
                           if ([[data objectForKey:@"result"] isEqualToString:@"true"])
                           {
                               MozTopAlertView *alertView = [MozTopAlertView showWithType:MozAlertTypeSuccess text:@"Discount successfully applied to your shopping bag!" parentView:self.view];
                               alertView.dismissBlock = ^(){
                                   //NSLog(@"dismissBlock");
                               };
//                               [self.view makeToast:@"Discount successfully applied to your shopping bag!" image:[UIImage imageNamed:@"sign.png"] color:[UIColor colorWithRed:38/255.0 green:152/255.0 blue:194/255.0 alpha:1.0]];

                               enterCouponCodeTextfield.hidden=YES;
                               gotACouponButton.hidden=YES;
                               
                               [myDelegate ShowIndicator];
                               [self performSelector:@selector(cartTotals) withObject:nil afterDelay:.1];
                           }
                           else
                           {
                               [MozTopAlertView showWithType:MozAlertTypeWarning text:@"Invalid Discount Code!" doText:nil doBlock:^{
                                   
                               } parentView:self.view];
                              // [self.view makeToast:@"Invalid Discount Code!" image:[UIImage imageNamed:@"excl.png"] color:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]];

                           }
                           
                       });
    }
                                                            failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }];
    
}
#pragma mark - end
#pragma mark - Redeem points webservice
-(void)redeemPointsWebService
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
            
        });
    }

    [[OrderService sharedManager] generalApiShoppingCartRewardPointAddRequestParam:enterPointsToRedeemTextfield.text success:^(id data) {
        //Handle fault cases
        dispatch_async(dispatch_get_main_queue(),^
                       {
                           [myDelegate StopIndicator];
                           if ([[data objectForKey:@"status"] isEqualToString:@"1"])
                           {
                               enterPointsToRedeemTextfield.hidden=YES;
                               redeemPointsButton.hidden=YES;
                               loyaltyPointsLabel.hidden=YES;
                               [myDelegate ShowIndicator];
                               [self performSelector:@selector(cartTotals) withObject:nil afterDelay:.1];
                           }
                           
                       });
    }
                                                                           failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }];
    
}
#pragma mark - end
#pragma mark - Cart totals webservice
-(void)cartTotals
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
            
        });
    }

    
    [[OrderService sharedManager] shoppingCartTotalsRequestParam:^(id data) {
        //Handle fault cases
        dispatch_async(dispatch_get_main_queue(),^
                       {
                           [myDelegate StopIndicator];
//                           discountPrice=[data objectForKey:@"discount"];
                           
//                           int disc=[discountPrice intValue];
//                           int total=[totalPrice intValue];
//                           
//                           total=total + disc;
                           
                           totalPrice = [data objectForKey:@"Grand Total"];
                           discountPrice = [data objectForKey:@"discount"];
                           
                           [self setViewFrames:2];
                           

                           
                       });
    }
                                                         failure:^(NSError *error)
     {
         //Handle if response is nil
     }];
    
}
#pragma mark - end

#pragma mark - Loyalty point webservice
-(void)getLoyaltyDetail
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
        });
        return;
    }
    
    [[OrderService sharedManager] generalApiUserLoyaltiPointsRequestParam:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            //categoryArray = (NSMutableArray *)data;
//                            [myDelegate StopIndicator];
                            if(data==nil || [data count]==0)
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Slow internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                    alert1.tag=1;
                                    [alert1 show];
                                });
                            }
                            else
                            {
                                [self setViewFrames:2];
                                
                                loyaltyPoints=[data objectForKey:@"loyaly_points"];
                                
                                loyaltyPointsLabel.text=[NSString stringWithFormat:@"%@ %@ %@",@"You have",loyaltyPoints,@"loyalty points"];
                                //                                loyaltyPointsAmount=[data objectForKey:@"loyaly_points_amout"];
                                
                                //[myDelegate ShowIndicator];
                                [self performSelector:@selector(removeCouponCode) withObject:nil afterDelay:.1];

                            }
                        });
         
     }
                                                                  failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
    
}
-(void)removeCouponCode
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
        });
        return;
    }
    
    [[OrderService sharedManager] shoppingCartCouponRemoveRequestParam:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            //categoryArray = (NSMutableArray *)data;
//                            [myDelegate StopIndicator];
                            if(data==nil || [data count]==0)
                            {
                                [myDelegate StopIndicator];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Slow internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                     alert1.tag=1;
                                    [alert1 show];
                                });
                            }
                            else
                            {
                                //                                if ([[data objectForKey:@"result"] isEqualToString:@"true"])
                                //                                {
                                
                                [self performSelector:@selector(removeRedeemPoints) withObject:nil afterDelay:.1];
                                
                                //                                }
                            }
                        });
         
     }
                                                               failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
    
}
-(void)removeRedeemPoints
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate StopIndicator];
        });
        return;
    }
    
    [[OrderService sharedManager] generalApiShoppingCartRewardPointRemoveRequestParam:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            //categoryArray = (NSMutableArray *)data;
                            [myDelegate StopIndicator];
                            if(data==nil || [data count]==0)
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    UIAlertView *  alert1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Slow internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                     alert1.tag=1;
                                    [alert1 show];
                                });
                            }
                            else
                            {
                                

                            }
                        });
         
     }
                                                                              failure:^(NSError *error)
     {
         //Handle if response is nil
         
     }] ;
}


//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
////    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//    [textField resignFirstResponder];
//    return YES;
//}

#pragma mark - Keyboard controls delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    UIView *view;
    view = field.superview.superview.superview;
    
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [keyboardControls.activeField resignFirstResponder];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - end

#pragma mark - Textfield delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];

    if([[UIScreen mainScreen] bounds].size.height<=568)
    {
        //        if (textField==enterCouponCodeTextfield)
        //        {
        self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-110, self.view.frame.size.width, self.view.frame.size.height);
        //        }
        //        else if (textField==enterPointsToRedeemTextfield)
        //        {
        //            self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-120, self.view.frame.size.width, self.view.frame.size.height);
        //        }
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if([[UIScreen mainScreen] bounds].size.height<=568)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame=CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+110, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.keyboardControls.activeField resignFirstResponder];

    //    if([[UIScreen mainScreen] bounds].size.height<=568)
    //    {
    //        [UIView animateWithDuration:0.3 animations:^{
    //            self.view.frame=CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+94, self.view.frame.size.width, self.view.frame.size.height);
    //        }];
    //    }
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1)
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}


@end
