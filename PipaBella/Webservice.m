

#import "Webservice.h"
#import "SoapGenerator.h"


@implementation Webservice
@synthesize webResponseData;

//Shared instance init
+ (id)sharedManager
{
    static Webservice *sharedMyManager = nil;
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
        
    }
    return self;
}
//end

#pragma mark - Webservice method
- (void )fireWebserviceForArray:(NSString *)parameters methodName:(NSString *)methodName success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    NSString * str = [NSString stringWithFormat:@"%@%@%@",[SoapGenerator upperSoapPart:methodName],parameters,[SoapGenerator lowerSoapPart:methodName]];
    NSLog(@"SOAP request is %@",str);
    
    [self callSoapWebservice:str success:^(id data)
     {
         
         success(data);
         
     }
      failure:^(NSError *error)
     {
         
     }];
    
}
- (void )fireWebservice:(NSDictionary *)parameters methodName:(NSString *)methodName success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    NSString *str = [SoapGenerator getSoapString:parameters methodName:methodName];
    NSLog(@"SOAP request is %@",str);

    [self callSoapWebservice:str success:^(id data)
     {
      
        success(data);
         
     }
    failure:^(NSError *error)
    {
        
    }];
    
}

-(NSData *)callSoapWebservice :(NSString *)soapStr
{
 
    NSURL *sRequestURL = [NSURL URLWithString:BASE_URL];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:sRequestURL];
    NSString *sMessageLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapStr length]];
    [myRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [myRequest addValue: @"urn:Magento" forHTTPHeaderField:@"SOAPAction"];
    [myRequest addValue: sMessageLength forHTTPHeaderField:@"Content-Length"];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody: [soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"SOAP response is **%@",responseString);
    return responseData;
    
}

- (void )callSoapWebservice:(NSString *)soapStr success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURL *sRequestURL = [NSURL URLWithString:BASE_URL];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:sRequestURL];
    NSString *sMessageLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapStr length]];
    [myRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [myRequest addValue: @"urn:Magento" forHTTPHeaderField:@"SOAPAction"];
    [myRequest addValue: sMessageLength forHTTPHeaderField:@"Content-Length"];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody: [soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:myRequest completionHandler:^(NSData *responseData, NSURLResponse *response, NSError *error)
                                          {
                                              NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                                              NSLog(@"SOAP response is %@",responseString);
                                               success(responseData);
                                             
                                          }];
    
    [postDataTask resume];
}

#pragma mark - end

- (void )fireWebserviceForArr:(NSDictionary *)parameters methodName:(NSString *)methodName success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    NSString * str = [SoapGenerator getSoapStringWithArray:parameters methodName:methodName];
    NSLog(@"SOAP request is %@",str);
    
    [self callSoapWebservice:str success:^(id data)
     {
         
         success(data);
         
     }
       failure:^(NSError *error)
     {
         
     }] ;
    
}

@end
