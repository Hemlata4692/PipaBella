//
//  QuizLevel2ViewController.m
//  PipaBella
//
//  Created by Hema on 30/11/15.
//  Copyright © 2015 Shivendra. All rights reserved.
//

#import "QuizLevel2ViewController.h"
#import "QuizLevel3ViewController.h"
#import "QuizService.h"
#import "QuizTwoModel.h"

@interface QuizLevel2ViewController (){
    NSMutableDictionary *dataDic;
}

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabelOne;
@property (weak, nonatomic) IBOutlet UILabel *answerLabelTwo;

@end

@implementation QuizLevel2ViewController
@synthesize questionLabel,answerLabelOne,answerLabelTwo;
@synthesize userInfoDic;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //hide status bar
    [self prefersStatusBarHidden];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [myDelegate ShowIndicator];
    [self performSelector:@selector(quizListWebservice) withObject:nil afterDelay:.1];
    
}


//hide status bar
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark - end

#pragma mark - Webservice
-(void)quizListWebservice
{
    [[QuizService sharedManager] quizListing:^(id data)
     {
         //Handle fault cases
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            if (data != nil)
                            {
                                //code here
                                [myDelegate StopIndicator];
                                
                                questionLabel.text = [[data objectForKey:@"1"] question];
                                answerLabelOne.text = [[[[data objectForKey:@"1"] answerArray] objectAtIndex:0] objectForKey:@"text"];
                                answerLabelTwo.text = [[[[data objectForKey:@"1"] answerArray] objectAtIndex:1] objectForKey:@"text"];
                                dataDic =[NSMutableDictionary new];
                                dataDic = [data mutableCopy];
                                
                            }
                            else{
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, please try again." delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:nil, nil];
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

#pragma mark - Button actions
- (IBAction)answerButtonOneClicked:(id)sender {
    
    NSString *answer = answerLabelOne.text;
    [userInfoDic setObject:answer forKey:@"1"];
    
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    QuizLevel3ViewController *quiz2View =[storyboard instantiateViewControllerWithIdentifier:@"QuizLevel3ViewController"];
   quiz2View.userInfoDic = [userInfoDic mutableCopy];
   quiz2View.quiz2Information = [dataDic mutableCopy];
    [self.navigationController pushViewController:quiz2View animated:YES];

}


- (IBAction)answerButtonTwoClicked:(id)sender {
    
    NSString *answer = answerLabelTwo.text;
    [userInfoDic setObject:answer forKey:@"1"];
    
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    QuizLevel3ViewController *quiz2View =[storyboard instantiateViewControllerWithIdentifier:@"QuizLevel3ViewController"];
    quiz2View.userInfoDic = [userInfoDic mutableCopy];
    quiz2View.quiz2Information = [dataDic mutableCopy];
    [self.navigationController pushViewController:quiz2View animated:YES];

    
    
    
}
#pragma mark - end

@end
