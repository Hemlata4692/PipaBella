//
//  AlertController.m
//  PipaBella
//
//  Created by Ranosys on 21/10/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "AlertController.h"


@interface AlertController()
{
    UIAlertController *alertController;
    
}
@end

@implementation AlertController
@synthesize alertViewStyle,Tag;

//Shared instance init
+ (id)sharedManager
{
    static AlertController *sharedMyManager = nil;
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

-(void) alertControllerWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle alertTag:(id)Tag1 preferredStyle:(UIAlertControllerStyle)preferredStyle
{
    
    alertController = [UIAlertController
                       alertControllerWithTitle:title
                       message:message
                       preferredStyle:preferredStyle];
    if (!(cancelButtonTitle == nil || cancelButtonTitle == NULL)) {
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:cancelButtonTitle
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           //NSLog(@"Cancel action");
                                           [_delegate alertAction:Tag clickedButtonAtIndex:0];
                                           Tag = -1;
                                           
                                       }];
         [alertController addAction:cancelAction];
        
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:okButtonTitle
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       // NSLog(@"OK action");
                                        [_delegate alertAction:Tag clickedButtonAtIndex:1];
                                       Tag = -1;
                                   }];
        
        
        [alertController addAction:okAction];

    }
    else{
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:okButtonTitle
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [_delegate alertAction:Tag clickedButtonAtIndex:0];
                                   Tag = -1;
                               }];
    
   
    [alertController addAction:okAction];
    }
    
}

-(void) show:(UIViewController *)view{
    [view presentViewController:alertController animated:YES completion:nil];
}

@end
