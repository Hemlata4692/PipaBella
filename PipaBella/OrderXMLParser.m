//
//  OrderXMLParser.m
//  PipaBella
//
//  Created by Monika on 1/6/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "OrderXMLParser.h"
#import "OrderHistoryModel.h"
#import "OrderDetailModel.h"
#import "CheckoutReviewViewController.h"
@implementation OrderXMLParser
{
    NSMutableDictionary *dataDic;
    NSMutableArray *orderHistoryArray;
    NSMutableArray *orderDetailArray;
    
    NSMutableDictionary *shippingAddressDict;
    NSMutableDictionary *billingAddressDict;
    
    OrderHistoryModel *orderHistDataModel;
    OrderDetailModel  *orderDetDataModel;
    NSString *key,*value;
    
    int isShipping;
    NSString * position;
}
@synthesize currentNodeContent;
@synthesize responseString,status;
//Shared instance init
+ (id)sharedManager
{
    static OrderXMLParser *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}
- (id)init
{
    if (self = [super init])
    {
        dataDic = [NSMutableDictionary new];
        
    }
    return self;
}
//end

-(id) loadxmlByData:(NSData *)data
{
    status=nil;
    key = @"";
    value = @"";
    parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    return dataDic;
}
- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (currentNodeContent==nil)
    {
        currentNodeContent = [[NSMutableString alloc] initWithString:string];
        
    }
    else
    {
        NSString *trimString= [currentNodeContent stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        currentNodeContent = [trimString mutableCopy];
        [currentNodeContent appendString:string];
    }
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([myDelegate.methodName isEqualToString: @"salesOrderListRequestParam"])
    {
        if ([elementname isEqualToString:@"result"])
        {
            orderHistoryArray=[[NSMutableArray alloc]init];
        }
        else if ([elementname isEqualToString:@"complexObjectArray"])
        {
            orderHistDataModel=[[OrderHistoryModel alloc]init];
            
        }
    }
    else if ([myDelegate.methodName isEqualToString: @"generalApiTrackOrderRequestParam"])
    {
        if ([elementname isEqualToString:@"items"])
        {
            orderDetailArray = [NSMutableArray new];
        }
        else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
            orderDetDataModel=[[OrderDetailModel alloc]init];
        }
        else if ([elementname isEqualToString:@"shipping_address"])
        {
            isShipping=1;
            shippingAddressDict=[NSMutableDictionary new];
        }
        else if ([elementname isEqualToString:@"billing_address"])
        {
            isShipping=0;
            billingAddressDict=[NSMutableDictionary new];
            
        }
    }
    
    /************************** Loyalty points *******************************************/
    else if ([myDelegate.methodName isEqualToString: @"generalApiUserLoyaltiPointsRequestParam"])
    {
        if ([elementname isEqualToString:@"result"])
        {
            // dataDic=[NSMutableDictionary new];
        }
    }
    
    /************************** Reward points *******************************************/
    else if ([myDelegate.methodName isEqualToString: @"generalApiLoyalityPageRequestParam"])
    {
        if ([elementname isEqualToString:@"data"])
        {
            // dataDic=[NSMutableDictionary new];
        }
    }
    
    
    
}
- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    /************************** Order History *******************************************/
    if ([myDelegate.methodName isEqualToString: @"salesOrderListRequestParam"])
    {
        if ([elementname isEqualToString:@"result"])
        {
            [dataDic setObject:currentNodeContent forKeyedSubscript:@"result"];
        }
        else if ([elementname isEqualToString:@"increment_id"])
        {
            orderHistDataModel.OrderId=currentNodeContent;
        }
        
        else if ([elementname isEqualToString:@"order_id"])
        {
            orderHistDataModel.orderIdForReturnOrder=currentNodeContent;
        }
        
        else if ([elementname isEqualToString:@"created_at"])
        {
            //UTC time
            NSDateFormatter *utcDateFormatter = [[NSDateFormatter alloc] init];
            [utcDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [utcDateFormatter setTimeZone :[NSTimeZone timeZoneForSecondsFromGMT: 0]];
            
            // utc format
            NSDate *dateInUTC = [utcDateFormatter dateFromString: currentNodeContent];
            
            // offset second
            NSInteger seconds = [[NSTimeZone systemTimeZone] secondsFromGMT];
            
            // format it and send
            NSDateFormatter *localDateFormatter = [[NSDateFormatter alloc] init];
            [localDateFormatter setDateFormat:@"dd MMM yyyy - HH:mm a"];
            [localDateFormatter setTimeZone :[NSTimeZone timeZoneForSecondsFromGMT: seconds]];
            
            // formatted string
            NSString *localDate = [localDateFormatter stringFromDate: dateInUTC];
            
            NSArray * arr = [localDate componentsSeparatedByString:@"-"];
            orderHistDataModel.date=[arr objectAtIndex:0];
            
        }
        
        else if ([elementname isEqualToString:@"grand_total"])
        {
            orderHistDataModel.grandTotal=currentNodeContent;
        }
        else if ([elementname isEqualToString:@"firstname"])
        {
            orderHistDataModel.firstname=currentNodeContent;
        }
        else if ([elementname isEqualToString:@"lastname"])
        {
            orderHistDataModel.lastname=currentNodeContent;
        }
        else if ([elementname isEqualToString:@"order_currency_code"])
        {
            orderHistDataModel.currency=currentNodeContent;
        }
        else if ([elementname isEqualToString:@"status"])
        {
            orderHistDataModel.status=currentNodeContent;
            
            responseString = currentNodeContent;
            responseString = [responseString stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            status=responseString;
        }
        else if ([elementname isEqualToString:@"complexObjectArray"])
        {
            [orderHistoryArray addObject:orderHistDataModel];
            [dataDic setObject:orderHistoryArray forKey:@"orderHistory"];
            
        }
    }
    /************************** Order Detail *******************************************/
    else if ([myDelegate.methodName isEqualToString: @"generalApiTrackOrderRequestParam"])
    {
        //Get address
        if ([elementname isEqualToString:@"firstname"])
        {
            if (isShipping)
            {
                [shippingAddressDict setObject:currentNodeContent forKey:@"sfirstname"];
            }
            else
            {
                [billingAddressDict setObject:currentNodeContent forKey:@"bfirstname"];
            }
        }
        else if ([elementname isEqualToString:@"lastname"])
        {
            if (isShipping)
            {
                [shippingAddressDict setObject:currentNodeContent forKey:@"slastname"];
            }
            else
            {
                [billingAddressDict setObject:currentNodeContent forKey:@"blastname"];
            }
        }
        else if ([elementname isEqualToString:@"street"])
        {
            if (isShipping)
            {
                [shippingAddressDict setObject:currentNodeContent forKey:@"sstreet"];
            }
            else
            {
                [billingAddressDict setObject:currentNodeContent forKey:@"bstreet"];
            }
        }
        else if ([elementname isEqualToString:@"city"])
        {
            if (isShipping)
            {
                [shippingAddressDict setObject:currentNodeContent forKey:@"scity"];
            }
            else
            {
                [billingAddressDict setObject:currentNodeContent forKey:@"bcity"];
            }
        }
        else if ([elementname isEqualToString:@"region"])
        {
            if (isShipping)
            {
                [shippingAddressDict setObject:currentNodeContent forKey:@"sregion"];
            }
            else
            {
                [billingAddressDict setObject:currentNodeContent forKey:@"bregion"];
            }
        }
        else if ([elementname isEqualToString:@"postcode"])
        {
            if (isShipping)
            {
                [shippingAddressDict setObject:currentNodeContent forKey:@"spostcode"];
            }
            else
            {
                [billingAddressDict setObject:currentNodeContent forKey:@"bpostcode"];
            }
        }
        else if ([elementname isEqualToString:@"telephone"])
        {
            if (isShipping)
            {
                [shippingAddressDict setObject:currentNodeContent forKey:@"stelephone"];
            }
            else
            {
                [billingAddressDict setObject:currentNodeContent forKey:@"btelephone"];
            }
        }
        //Shipping address
        else if ([elementname isEqualToString:@"shipping_address"])
        {
            [dataDic setObject:shippingAddressDict forKey:@"shipping_address"];
        }
        //Billing address
        else if ([elementname isEqualToString:@"billing_address"])
        {
            [dataDic setObject:billingAddressDict forKey:@"billing_address"];
        }
        
        //Status
        else if ([elementname isEqualToString:@"status"])
        {
            [dataDic setObject:currentNodeContent forKey:@"status"];
        }
        else if ([elementname isEqualToString:@"state"])
        {
            [dataDic setObject:currentNodeContent forKey:@"state"];
        } 

        else if ([elementname isEqualToString:@"base_shipping_incl_tax"])
        {
            [dataDic setObject:currentNodeContent forKey:@"base_shipping_incl_tax"];
        }
        
        //Updated at
        else if ([elementname isEqualToString:@"formated_time"])
        {
            [dataDic setObject:currentNodeContent forKey:@"formated_time"];
            
        }
        
        
        //Get product details
        else if ([elementname isEqualToString:@"product_id"])
        {
            orderDetDataModel.productId=currentNodeContent;
        }
        else if ([elementname isEqualToString:@"parent_item_id"])
        {
            orderDetDataModel.parentId=currentNodeContent;
        }
        else if ([elementname isEqualToString:@"name"])
        {
            orderDetDataModel.name=currentNodeContent;
        }
        else if ([elementname isEqualToString:@"sku"])
        {
            orderDetDataModel.sku=currentNodeContent;
        }
        else if ([elementname isEqualToString:@"base_row_total_incl_tax"])
        {
            orderDetDataModel.amountPaid=currentNodeContent;
        }
        else if ([elementname isEqualToString:@"qty_ordered"])
        {
            orderDetDataModel.quantity=currentNodeContent;
        }
        else if ([elementname isEqualToString:@"price"])
        {
            orderDetDataModel.totalPrice=currentNodeContent;
        }
        else if ([elementname isEqualToString:@"base_price"])
        {
            orderDetDataModel.subTotalPrice=currentNodeContent;
        }
        //image
        
        else if ([elementname isEqualToString:@"position"])
        {
            position=currentNodeContent;
        }
        else if ([elementname isEqualToString:@"url"])
        {
            if ([position isEqualToString:@"1"])
            {
                orderDetDataModel.imageUrl=currentNodeContent;
            }
        }
        else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
            [orderDetailArray addObject:orderDetDataModel];
        }
        else if ([elementname isEqualToString:@"items"])
        {
            [dataDic setObject:orderDetailArray forKey:@"ProductDetails"];
        }
        
        else if ([elementname isEqualToString:@"method"])
        {
            [dataDic setObject:currentNodeContent forKey:@"PaymentMethod"];
        }
        else if ([elementname isEqualToString:@"grand_total"])
        {
            [dataDic setObject:currentNodeContent forKey:@"grand_total"];
        }
        else if ([elementname isEqualToString:@"base_grand_total"])
        {
            [dataDic setObject:currentNodeContent forKey:@"base_grand_total"];
        }
        else if ([elementname isEqualToString:@"base_shipping_amount"])
        {
            [dataDic setObject:currentNodeContent forKey:@"base_shipping_amount"];
        }
        else if ([elementname isEqualToString:@"tax_percent"])
        {
            [dataDic setObject:currentNodeContent forKey:@"tax_percent"];
        }
        else if ([elementname isEqualToString:@"base_tax_amount"])
        {
            [dataDic setObject:currentNodeContent forKey:@"base_tax_amount"];
        }
        else if ([elementname isEqualToString:@"ssn"])
        {
            [dataDic setObject:currentNodeContent forKey:@"giftMessage"];
        }
        //        else if ([elementname isEqualToString:@"discount_description"])
        //        {
        //            [dataDic setObject:currentNodeContent forKey:@"pointUsed"];
        //        }
        else if ([elementname isEqualToString:@"rewardpoints_quantity"])
        {
            [dataDic setObject:currentNodeContent forKey:@"pointUsed"];
        }
        
        else if ([elementname isEqualToString:@"points_gathered"])
        {
            [dataDic setObject:currentNodeContent forKey:@"pointGathered"];
        }
        
    }
    
    
    /************************** Loyalty points *******************************************/
    else if ([myDelegate.methodName isEqualToString: @"generalApiUserLoyaltiPointsRequestParam"])
    {
        
        if ([elementname isEqualToString:@"loyaly_points"])
        {
            [dataDic setObject:currentNodeContent forKey:@"loyaly_points"];
        }
        
        
        else if ([elementname isEqualToString:@"loyaly_points_amout"])
        {
            [dataDic setObject:currentNodeContent forKey:@"loyaly_points_amout"];
            
        }
        
        
    }
    
    /************************** Reward points *******************************************/
    else if ([myDelegate.methodName isEqualToString: @"generalApiLoyalityPageRequestParam"])
    {
        if ([elementname isEqualToString:@"min_first_base_spent"])
        {
            [dataDic setObject:currentNodeContent forKey:@"min_first_base_spent"];
        }
        
        else if ([elementname isEqualToString:@"min_first_base_earn"])
        {
            [dataDic setObject:currentNodeContent forKey:@"min_first_base_earn"];
        }
        
        else if ([elementname isEqualToString:@"min_first_base"])
        {
            [dataDic setObject:currentNodeContent forKey:@"min_first_base"];
        }
        
        else if ([elementname isEqualToString:@"min_first_base_bonus"])
        {
            [dataDic setObject:currentNodeContent forKey:@"min_first_base_bonus"];
        }
        
        else if ([elementname isEqualToString:@"min_second_base"])
        {
            [dataDic setObject:currentNodeContent forKey:@"min_second_base"];
        }
        
        
        else if ([elementname isEqualToString:@"second_base_bonus"])
        {
            [dataDic setObject:currentNodeContent forKey:@"second_base_bonus"];
            
        }
        
        else if ([elementname isEqualToString:@"min_third_base"])
        {
            [dataDic setObject:currentNodeContent forKey:@"min_third_base"];
            
        }
        
        else if ([elementname isEqualToString:@"third_base_bonus"])
        {
            [dataDic setObject:currentNodeContent forKey:@"third_base_bonus"];
            
        }
        
        else if ([elementname isEqualToString:@"register_points"])
        {
            [dataDic setObject:currentNodeContent forKey:@"register_points"];
            
        }
        
        else if ([elementname isEqualToString:@"refer_points"])
        {
            [dataDic setObject:currentNodeContent forKey:@"refer_points"];
            
        }
        
    }
    
    /************************** Checkout - Add coupon *******************************************/
    
    else if ([myDelegate.methodName isEqualToString: @"shoppingCartCouponAddRequestParam"])
    {
        if ([elementname isEqualToString:@"result"])
        {
            [dataDic setObject:currentNodeContent forKey:@"result"];
        }
        
        else if ([elementname isEqualToString:@"faultstring"])
        {
            
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            if ([currentNodeContent isEqualToString:@"Session expired. Try to relogin."]) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                
                myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
                
                myDelegate.window.rootViewController = myDelegate.navigationController;
                [UserDefaultManager removeValue:@"customer_id"];
                [UserDefaultManager removeValue:@"customer_name"];
                [UserDefaultManager removeValue:@"userEmail"];
                [UserDefaultManager removeValue:@"profiePicture"];
                
            }
            else{
                [self showAlertMessage:responseString];
                
                
            }
        }
        
        
        
    }
    /************************** Checkout - Redeem points *******************************************/
    
    else if ([myDelegate.methodName isEqualToString: @"generalApiShoppingCartRewardPointAddRequestParam"])
    {
        if ([elementname isEqualToString:@"status"])
        {
            [dataDic setObject:currentNodeContent forKey:@"status"];
        }
        
        else if ([elementname isEqualToString:@"faultstring"])
        {
            
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            if ([currentNodeContent isEqualToString:@"Session expired. Try to relogin."]) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                
                myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
                
                myDelegate.window.rootViewController = myDelegate.navigationController;
                [UserDefaultManager removeValue:@"customer_id"];
                [UserDefaultManager removeValue:@"customer_name"];
                [UserDefaultManager removeValue:@"userEmail"];
                [UserDefaultManager removeValue:@"profiePicture"];
                
            }
            else{
                [self showAlertMessage:responseString];
                
                
            }
        }
    }
    /************************** Checkout - Cart totals *******************************************/
    
    else if ([myDelegate.methodName isEqualToString: @"shoppingCartTotalsRequestParam"])
    {
        if ([elementname isEqualToString:@"title"])
        {
            key = currentNodeContent;
            if ([key containsString:@"Discount"])
            {
                [dataDic setObject:currentNodeContent forKey:@"DiscountTitle"];
            }
        }
        else if ([elementname isEqualToString:@"amount"])
        {
            if ([key containsString:@"Discount"])
            {
                key=@"discount";
            }
            if ([key containsString:@"Shipping"])
            {
                key=@"Shipping";
            }
            
            if ([key isEqualToString:@"Subtotal"])
            {
                [dataDic setObject:currentNodeContent forKey:@"subTotal"];
            }
            else  if ([key isEqualToString:@"Grand Total"])
            {
                [dataDic setObject:currentNodeContent forKey:@"Grand Total"];
                
            }
            else  if ([key isEqualToString:@"Tax"])
            {
                [dataDic setObject:currentNodeContent forKey:@"Tax"];
            }
            else  if ([key isEqualToString:@"discount"])
            {
                [dataDic setObject:currentNodeContent forKey:@"discount"];
            }
            else  if ([key isEqualToString:@"Shipping"])
            {
                [dataDic setObject:currentNodeContent forKey:@"Shipping"];
                
            }
        }
    }
    /************************** Checkout - Cart totals *******************************************/
    else if ([myDelegate.methodName isEqualToString: @"shoppingCartCustomerAddressesRequestParam"])
    {
        if ([elementname isEqualToString:@"result"])
        {
            [dataDic setObject:currentNodeContent forKey:@"result"];
        }
    }
    
    /************************** Remove coupon *******************************************/
    else if ([myDelegate.methodName isEqualToString: @"shoppingCartCouponRemoveRequestParam"])
    {
        if ([elementname isEqualToString:@"result"])
        {
            [dataDic setObject:currentNodeContent forKey:@"result"];
        }
    }
    /************************** Remove redeem points *******************************************/
    else if ([myDelegate.methodName isEqualToString: @"generalApiShoppingCartRewardPointRemoveRequestParam"])
    {
        if ([elementname isEqualToString:@"status"])
        {
            [dataDic setObject:currentNodeContent forKey:@"status"];
        }
    }
    
    
    
    
    /************************** Message *******************************************/
    
    else if ([elementname isEqualToString:@"message"])
    {
        NSLog(@"status **** %@",status );
        
        if (![status isEqual:@"1"] && status!=nil)
        {
            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            responseString = currentNodeContent;
            
        }
    }
    else if ([elementname isEqualToString:@"faultstring"])
    {
        
        NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        responseString = currentNodeContent;
        if ([currentNodeContent isEqualToString:@"Session expired. Try to relogin."]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            
            myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
            
            myDelegate.window.rootViewController = myDelegate.navigationController;
            [UserDefaultManager removeValue:@"customer_id"];
            [UserDefaultManager removeValue:@"customer_name"];
            [UserDefaultManager removeValue:@"userEmail"];
            [UserDefaultManager removeValue:@"profiePicture"];
            
        }
        else{
            [self showAlertMessage:responseString];
            
            
        }
    }
    currentNodeContent=nil;
    
}


-(void)showAlertMessage:(NSString *)message
{
    if ([myDelegate.methodName isEqualToString: @"shoppingCartCouponAddRequestParam"])
    {
        
//        CheckoutReviewViewController * checkoutView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CheckoutReviewViewController"];
//
//        [checkoutView.ViewControllerView makeToast:message image:[UIImage imageNamed:@"excl.png"] color:[UIColor blackColor]];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        });
    }
}

-(void)dealloc
{
    parser = nil;
    currentNodeContent =nil;
    
}


@end
