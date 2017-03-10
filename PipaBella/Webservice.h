

#import <Foundation/Foundation.h>


//Developement Link
//#define BASE_URL            @"http://ranosys.net/client/pipabella/beta/index.php/api/v2_soap/index/"

//Client link
//#define BASE_URL            @"http://ranosys.net/client/pipabella/index.php/api/v2_soap/index"

//New instance
#define BASE_URL              @"http://ec2-54-169-138-245.ap-southeast-1.compute.amazonaws.com/index.php/api/v2_soap/index?user=Ranosys"

@interface Webservice : NSObject
@property(nonatomic,retain)NSMutableData *webResponseData;
//Singleton instance
+ (id)sharedManager;
//end

//Global webservice method

- (void )fireWebservice:(NSDictionary *)parameters methodName:(NSString *)methodName success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end
//Global service for complex array objects
- (void )fireWebserviceForArray:(NSString *)parameters methodName:(NSString *)methodName success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

- (void )fireWebserviceForArr:(NSDictionary *)parameters methodName:(NSString *)methodName success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

@end
