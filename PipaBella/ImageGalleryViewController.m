//
//  ImageGalleryViewController.m
//  PipaBella
//
//  Created by Sumit on 02/03/16.
//  Copyright © 2016 Shivendra. All rights reserved.
//

#import "ImageGalleryViewController.h"
#import "GalleryCell.h"
#define kCellPerRow 5
@interface ImageGalleryViewController ()<UIGestureRecognizerDelegate>
{
    __weak IBOutlet UIScrollView *scrollView;

    __weak IBOutlet UIImageView *imageView;
    
    NSMutableArray * imgArray;
   
    __weak IBOutlet UIPageControl *pageControl;
    __weak IBOutlet UICollectionView *galleryCollectinView;
}

@end

@implementation ImageGalleryViewController
@synthesize productDetailDict;
@synthesize imageIndex;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    scrollView.scrollEnabled = YES;
    scrollView.userInteractionEnabled = YES;
    imageView.userInteractionEnabled = YES;
    // For supporting zoom,
    scrollView.minimumZoomScale = 1.0;
    scrollView.maximumZoomScale = 2.0;
    
    imgArray = [[NSMutableArray alloc]init];
    //setting collection view cell size according to iPhone screens
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)galleryCollectinView.collectionViewLayout;
    CGFloat availableWidthForCells = CGRectGetWidth(self.view.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellPerRow -1);
    CGFloat cellWidth = (availableWidthForCells / kCellPerRow);
    flowLayout.itemSize = CGSizeMake(cellWidth, flowLayout.itemSize.height);
    //Swipe gesture
    UISwipeGestureRecognizer *swipeImageLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBannerImageLeft)];
    swipeImageLeft.delegate=self;
    UISwipeGestureRecognizer *swipeImageRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBannerImageRight)];
    swipeImageRight.delegate=self;
    
    // Setting the swipe direction.
    [swipeImageLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeImageRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [scrollView addGestureRecognizer:swipeImageLeft];
    [scrollView addGestureRecognizer:swipeImageRight];
    // Do any additional setup after loading the view.
    pageControl.currentPage =0;
    for (int i=0; i<[[productDetailDict objectForKey:@"url"]count]; i++)
    {
        [imgArray addObject:[UIImage imageNamed:@"placeholder.png"]];
    }
    imageView.image = [UIImage imageNamed:@"placeholder.png"];
    pageControl.numberOfPages = imgArray.count;
    for (int i=0; i<imgArray.count; i++)
    {
        
        [self downloadImages:i];
    }
    
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
    
    NSLog(@"swipeBannerImageLeft");
    scrollView.zoomScale = scrollView.minimumZoomScale;
    imageIndex++;
    if (imageIndex<imgArray.count)
    {
        
        
        imageView.image = [imgArray objectAtIndex:imageIndex];
        UIImageView *moveIMageView = imageView;
        [self addLeftAnimationPresentToView:moveIMageView];
        int page=imageIndex;
        pageControl.currentPage=page;
        
    }
    else
    {
        imageIndex--;
    }
    [galleryCollectinView reloadData];
    
}

-(void) swipeBannerImageRight
{
    NSLog(@"swipeBannerImageRight");
    scrollView.zoomScale = scrollView.minimumZoomScale;
    imageIndex--;
    if (imageIndex<imgArray.count)
    {
        
        
        imageView.image = [imgArray objectAtIndex:imageIndex];
        UIImageView *moveIMageView = imageView;
        [self addRightAnimationPresentToView:moveIMageView];
        int page=imageIndex;
        pageControl.currentPage=page;
        
    }
    else
    {
        imageIndex++;
    }
    [galleryCollectinView reloadData];
}



#pragma mark - UIScrollViewDelegate

- (void)centerScrollViewContents {
    CGSize boundsSize = scrollView.bounds.size;
    CGRect contentsFrame = imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    imageView.frame = contentsFrame;
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
    [self centerScrollViewContents];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
             [imgArray replaceObjectAtIndex:index withObject:image];
             imageView.image =[imgArray objectAtIndex:imageIndex];
             
         } else {
             
             NSLog(@"error is %@", error);
         }
     }];
    
}
- (IBAction)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imgArray.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    GalleryCell *myCell = [galleryCollectinView
                                      dequeueReusableCellWithReuseIdentifier:@"GalleryCell"
                                      forIndexPath:indexPath];
    
    if (imageIndex==indexPath.row)
    {
        myCell.layer.borderWidth=1.0f;
        myCell.layer.borderColor=[UIColor colorWithRed:57.0/255.0 green:219.0/255.0 blue:176.0/255.0 alpha:1.0].CGColor;
    }
    else
    {
        myCell.layer.borderWidth=1.0f;
        myCell.layer.borderColor=[UIColor clearColor].CGColor;
    }
    
    [myCell.imageView sd_setImageWithURL:[NSURL URLWithString:[[productDetailDict objectForKey:@"url"] objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return myCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    scrollView.zoomScale = scrollView.minimumZoomScale;
    imageIndex = (int)indexPath.row;
    imageView.image = [imgArray objectAtIndex:imageIndex];
    [galleryCollectinView reloadData];
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
