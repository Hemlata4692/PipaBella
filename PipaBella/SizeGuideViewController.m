//
//  SizeGuideViewController.m
//  PipaBella
//
//  Created by Sumit on 15/01/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "SizeGuideViewController.h"
#define kCellsPerRow 3

@interface SizeGuideViewController ()<UIGestureRecognizerDelegate>
{
    __weak IBOutlet UILabel *guideTitle;

    __weak IBOutlet UIImageView *guideImageview;
    __weak IBOutlet UILabel *guideSubtitle;
    __weak IBOutlet UIPageControl *pageController;
    
    int imageIndex;
    NSMutableArray * uploadedImages;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *sizeCollectionView;

@end

@implementation SizeGuideViewController
@synthesize sizeGuideArray,sizeCollectionView;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"SIZE GUIDE";
    uploadedImages = [[NSMutableArray alloc]init];
    imageIndex = 0;
    
    for (int i=0; i<sizeGuideArray.count; i++)
    {
        [uploadedImages addObject:[UIImage imageNamed:@"placeholder.png"]];
    }
    guideImageview.image = [UIImage imageNamed:@"placeholder.png"];
    pageController.numberOfPages = uploadedImages.count;
    
    NSMutableDictionary *tempDict =[sizeGuideArray objectAtIndex:0];
    guideTitle.text = [tempDict objectForKey:@"title"];
    guideSubtitle.text = [tempDict objectForKey:@"subtitle"];
    
    for (int i=0; i<uploadedImages.count; i++)
    {
        
        [self downloadImages:i];
    }
    guideImageview.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *swipeImageLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBannerImageLeft)];
    swipeImageLeft.delegate=self;
    UISwipeGestureRecognizer *swipeImageRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBannerImageRight)];
    swipeImageRight.delegate=self;
   
    // Setting the swipe direction.
    [swipeImageLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeImageRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [guideImageview addGestureRecognizer:swipeImageLeft];
    [guideImageview addGestureRecognizer:swipeImageRight];
    
    
    //setting collection view cell size according to iPhone screens
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.sizeCollectionView.collectionViewLayout;
    CGFloat availableWidthForCells = CGRectGetWidth(self.view.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow -1);
    CGFloat cellWidth = (availableWidthForCells / kCellsPerRow)-5;
    flowLayout.itemSize = CGSizeMake(cellWidth, flowLayout.itemSize.height);

    
  //  [self createScrollMenu];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Collection view methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
   // cell.backgroundColor = [UIColor redColor];
    UIButton *sizeBtn = (UIButton  *)[cell viewWithTag:100];
    if (self.view.frame.size.width<=320)
    {
        sizeBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    }
    else
    {
        sizeBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    }
    
    NSLog(@"%@",[[sizeGuideArray objectAtIndex:indexPath.row] objectForKey:@"title"]);
    [sizeBtn setTitle:[[sizeGuideArray objectAtIndex:indexPath.row] objectForKey:@"title"] forState:UIControlStateNormal];
    
    if (imageIndex==indexPath.row)
    {
        sizeBtn.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:0.0/255.0 blue:137.0/255.0 alpha:1.0];
        [sizeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        sizeBtn.backgroundColor = [UIColor clearColor];
        [sizeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    
    [[sizeBtn layer] setBorderWidth:1.0f];
    [[sizeBtn layer] setBorderColor:[UIColor colorWithRed:169.0/255.0 green:169.0/255.0 blue:169.0/255.0 alpha:1.0].CGColor];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (imageIndex>indexPath.row) {
        imageIndex = (int )indexPath.row+1;
        [self swipeBannerImageRight ];
    }
    else if (imageIndex<indexPath.row){
        imageIndex = (int )indexPath.row-1;
        [self swipeBannerImageLeft ];
    }
}




#pragma mark - end
#pragma mark - Size guide image display methods
-(void)downloadImages :(int)index
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSMutableDictionary * imgDict = [sizeGuideArray objectAtIndex:index];
    [manager downloadWithURL:[imgDict objectForKey:@"image"] 
                     options:0
                    progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
         
     }
      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
     {
         if (image)
         {
             [uploadedImages replaceObjectAtIndex:index withObject:image];
             guideImageview.image =[uploadedImages objectAtIndex:0];
             
         } else {
             
             NSLog(@"error is %@", error);
         }
     }];
    
}
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

-(void) swipeBannerImageLeft
{
    
    imageIndex++;
    if (imageIndex<uploadedImages.count)
    {
        NSMutableDictionary *tempDict =[sizeGuideArray objectAtIndex:imageIndex];
        guideTitle.text = [tempDict objectForKey:@"title"];
        guideSubtitle.text = [tempDict objectForKey:@"subtitle"];
        // productSliderImageView.image=[swipeProductImages objectAtIndex:imageIndex];
        guideImageview.image =[uploadedImages objectAtIndex:imageIndex];
        UIImageView *moveIMageView = guideImageview;
        [self addLeftAnimationPresentToView:moveIMageView];
        int page=imageIndex;
        pageController.currentPage=page;
        
        
        
        BOOL flag = NO;
        for (UICollectionViewCell *cell in [self.sizeCollectionView visibleCells]) {
            NSIndexPath *indexPath = [self.sizeCollectionView indexPathForCell:cell];
            if (indexPath.row != imageIndex) {
                flag = YES;
            }
            else{
                flag = NO;
                break;
            }
            NSLog(@"%@",indexPath);
        }
        
        if (flag) {
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:imageIndex inSection:0];
            [self.sizeCollectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
    }
    else
    {
        imageIndex--;
    }
    [sizeCollectionView reloadData];
}

-(void) swipeBannerImageRight
{
    imageIndex--;
    if (imageIndex<uploadedImages.count)
    {
        NSMutableDictionary *tempDict =[sizeGuideArray objectAtIndex:imageIndex];
        guideTitle.text = [tempDict objectForKey:@"title"];
        guideSubtitle.text = [tempDict objectForKey:@"subtitle"];
        guideImageview.image =[uploadedImages objectAtIndex:imageIndex];
        UIImageView *moveIMageView = guideImageview;
        [self addRightAnimationPresentToView:moveIMageView];
        int page=imageIndex;
        pageController.currentPage=page;
        
        BOOL flag = NO;
        for (UICollectionViewCell *cell in [self.sizeCollectionView visibleCells]) {
            NSIndexPath *indexPath = [self.sizeCollectionView indexPathForCell:cell];
            if (indexPath.row != imageIndex) {
                flag = YES;
            }
            else{
                flag = NO;
                break;
            }
            NSLog(@"%@",indexPath);
        }
        
        if (flag)
        {
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:imageIndex inSection:0];
            [self.sizeCollectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }

    }
    else
    {
        imageIndex++;
    }
    [sizeCollectionView reloadData];
}
- (IBAction)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
