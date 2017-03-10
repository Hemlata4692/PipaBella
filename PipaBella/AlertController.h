//
//  AlertController.h
//  PipaBella
//
//  Created by Ranosys on 21/10/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import <Foundation/Foundation.h>

// Protocol definition starts here
@protocol AlertControllerDelegate ;// Protocol Definition ends here

@interface AlertController : NSObject
{
    // Delegate to respond back
    id <AlertControllerDelegate> _delegate;
    
}
@property (nonatomic,strong) id delegate;
@property (nonatomic,assign) int Tag;
@property (nonatomic,assign) UIAlertActionStyle alertViewStyle;

+ (id)sharedManager;
-(void) alertControllerWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle alertTag:(id)Tag preferredStyle:(UIAlertControllerStyle)preferredStyle;
-(void) show:(UIViewController *)view;

@end

@protocol AlertControllerDelegate <NSObject>
@optional
- (void) alertAction:(int)alertTag  clickedButtonAtIndex:(NSInteger)buttonIndex;
@end



