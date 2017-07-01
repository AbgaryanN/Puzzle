//
//  GameViewController.m
//  Puzzles
//
//  Created by Nver Abgaryan on 5/24/17.
//  Copyright © 2017 Nver Abgaryan. All rights reserved.
//

#import "GameViewController.h"
#import "UIImage+masking.h"
#import "PuzzleCreator.h"
#import "MaskViewCell.h"
#import "NSMutableArray+NSMutableArray_Shuffling.h"

#define OFFSET 20

@interface GameViewController ()

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *rightPanelWidthContraint;

@property (nonatomic, strong) PuzzleCreator *masksObject;
@property (nonatomic, strong) NSIndexPath* selectedIndexPath;
@property (nonatomic, assign) CGSize actualPuzzleSize;
@property (nonatomic, assign) NSInteger matrixSize;
@property (nonatomic, strong) NSMutableArray *puzzlesArrayforReset;
@property (nonatomic, strong) UILabel *congratulationLabel;
/// test
@property (nonatomic, assign) CGRect startFrame;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCongratulationLabel];
    self.puzzlesCollectionView.backgroundColor =
    [UIColor colorWithPatternImage:[UIImage imageNamed:@"gameBg"]];
    self.puzzlesCollectionView.clipsToBounds = NO;
    firstStartOrReset = YES;
    self.puzzlesArrayforReset = [[NSMutableArray alloc] init];
    
}

- (void)setupMainImageViewWithImage:(UIImage*)image {
    CGRect frame = CGRectMake(0, 0, CGRectGetHeight(self.view.frame), CGRectGetHeight(self.view.frame));
    self.mainImageView = [[UIImageView alloc] initWithImage:image];
    self.mainImageView.frame = frame;
    [self.view addSubview:self.mainImageView];
    [self.view insertSubview:self.mainImageView atIndex:1];
    self.rightPanelWidthContraint.constant = CGRectGetWidth(self.view.frame) - CGRectGetWidth(self.mainImageView.frame);
}

- (void)createPuzzlesWithMatrixSize:(NSInteger)matrixSize {
    self.mainImageView.image = [UIImage imageWithImage:self.mainImageView.image convertToSize:
                                CGSizeMake(self.mainImageView.frame.size.width, self.mainImageView.frame.size.height)];
    self.masksObject = [[PuzzleCreator alloc] initWithImage:self.mainImageView.image
                                                 matrixSize:matrixSize];
    //making image darker
    [self makeDarkerImage];
    self.actualPuzzleSize = CGSizeZero;
    self.matrixSize = matrixSize;
    // shuffling array
    [self.masksObject.arrayOfMasks shuffle];
    [self.puzzlesCollectionView reloadData];
}

#pragma mark - Actions

- (IBAction)resetAction:(UIButton *)sender {
    firstStartOrReset = YES;
    [self.masksObject.arrayOfMasks addObjectsFromArray:self.puzzlesArrayforReset];
    [self.puzzlesArrayforReset removeAllObjects];
    
    for (UIImageView *subView in self.mainImageView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    puzzlesNumberInPlace = 0;
    [self.puzzlesCollectionView reloadData];
    [self makeDarkerImage];
    
}

- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.masksObject.arrayOfMasks.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MaskViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MasksCell" forIndexPath:indexPath];
    UIImageView *imgView = [self.masksObject.arrayOfMasks objectAtIndex:indexPath.row];
    cell.maskImageView.image = imgView.image;
    
    UIPanGestureRecognizer *lpgr = [[UIPanGestureRecognizer alloc]
                                    initWithTarget:self action:@selector(handlePan:)];
    lpgr.delegate = self;
    lpgr.delaysTouchesBegan = YES;
    //lpgr.minimumPressDuration = 0.1 ;
    [cell addGestureRecognizer:lpgr];
    if(firstStartOrReset){
        CGRect finalCellFrame = cell.frame;
        //check the scrolling direction to verify from which side of the screen the cell should come.
        CGPoint translation = [collectionView.panGestureRecognizer translationInView:collectionView.superview];
        
        if (translation.x > 0) {
            cell.frame = CGRectMake(finalCellFrame.origin.x - 1000, - 500.0f, 0, 0);
        } else {
            cell.frame = CGRectMake(finalCellFrame.origin.x + 1000, - 500.0f, 0, 0);
        }
        
        [UIView animateWithDuration:0.5f animations:^(void){
            cell.frame = finalCellFrame;
        }];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    firstStartOrReset = NO;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // return collectionViewLayout.collectionViewContentSize;
    return CGSizeMake(110, 110);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark - Gesture

- (void)handlePan:(UIPanGestureRecognizer *)panGesture {
    [self.view bringSubviewToFront:self.puzzlesCollectionView];
    NSIndexPath *indexPath;
    firstStartOrReset = NO;
    if(panGesture.state == UIGestureRecognizerStateBegan){
        CGPoint point = [panGesture locationInView:panGesture.view];
        indexPath = [self.puzzlesCollectionView indexPathForItemAtPoint:point];
    }
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        locationPoint = [panGesture locationInView:panGesture.view];
        return;
    } else if (panGesture.state == UIGestureRecognizerStateEnded) {
        UIImageView *img = nil;
        for (UIImageView* puzzle in self.masksObject.arrayOfMasks) {
            UIImageView *mvc = ((MaskViewCell*)(panGesture.view)).maskImageView;
            if ([puzzle.image isEqual:mvc.image]) {
                img = puzzle;
            }
        }
        if (img) {
            CGRect frame = [self.view convertRect:panGesture.view.frame fromView:self.puzzlesCollectionView];
            CGFloat x = frame.origin.x;
            CGFloat y = frame.origin.y;
            if (((x < img.frame.origin.x + OFFSET) && (x > img.frame.origin.x - OFFSET)) &&
                ((y < img.frame.origin.y + OFFSET) && (y > img.frame.origin.y - OFFSET))) {
                puzzlesNumberInPlace++;
                [self.mainImageView addSubview:img];
                [self.puzzlesArrayforReset addObject:img];
                [self.masksObject.arrayOfMasks removeObject:img];
                [UIView animateWithDuration:3 animations:^{
                    [self.puzzlesCollectionView reloadData];
                } completion:^(BOOL finished) {
                    if(puzzlesNumberInPlace == self.matrixSize*self.matrixSize){
                        [self makeBlureImage];
                        [self showCongratulationLabel:YES];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self dismissViewControllerAnimated:YES completion:nil];
                        });
                    }
                }];
            } else {
                [UIView animateWithDuration:0.3 animations:^{
                    [self.puzzlesCollectionView reloadData];
                } completion:nil];
                [self.view bringSubviewToFront:panGesture.view];
            }
        }
    }
    if (CGSizeEqualToSize(self.actualPuzzleSize, CGSizeZero)) {
        UIImageView *imgV = (UIImageView*)[self.masksObject.arrayOfMasks objectAtIndex:0];
        self.actualPuzzleSize = imgV.frame.size;
    } else if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint newCoord = [panGesture locationInView:panGesture.view];
        float dX = newCoord.x - locationPoint.x;
        float dY = newCoord.y - locationPoint.y;
        
        panGesture.view.center = CGPointMake(panGesture.view.center.x + dX, //+ CGRectGetWidth(self.mainImageView.frame),
                                             panGesture.view.center.y + dY);
        CGFloat scaleW = self.actualPuzzleSize.width / panGesture.view.frame.size.width;
        CGFloat scaleY = self.actualPuzzleSize.height / panGesture.view.frame.size.height;
        [UIView animateWithDuration:0.1 animations:^{
            
            panGesture.view.transform = CGAffineTransformScale(panGesture.view.transform, scaleW, scaleY);
            
        }];
        [self.puzzlesCollectionView bringSubviewToFront:panGesture.view];
        
    }
}

- (void)setupCongratulationLabel {
    self.congratulationLabel = [[UILabel alloc] initWithFrame:self.view.frame];
    [self.congratulationLabel setCenter:self.view.center];
    self.congratulationLabel.backgroundColor = [UIColor clearColor];
    self.congratulationLabel.textColor = [UIColor colorWithRed:189 / 255.0 green:144 / 255.0 blue:100 /255.0 alpha:1];
    self.congratulationLabel.font = [UIFont fontWithName:@"Verdana" size:40.0];
    self.congratulationLabel.text = @"Congratulation";
    self.congratulationLabel.textAlignment = NSTextAlignmentCenter;
    self.congratulationLabel.shadowColor = [UIColor darkGrayColor];
    self.congratulationLabel.shadowOffset = CGSizeMake(2.0,2.0);
    self.congratulationLabel.alpha = 0.0;
    [self.view addSubview:self.congratulationLabel];
}

- (void)showCongratulationLabel:(BOOL)show {
    if (show) {
        [UIView animateWithDuration:1.0
                              delay:0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void) {
                             [self.congratulationLabel setAlpha:1.0];
                         }
                         completion:^(BOOL finished) {
             if(finished) {
                 [UIView animateWithDuration:1.5
                                       delay:4
                                     options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                                  animations:^(void) {
                                      [self.congratulationLabel setAlpha:0.0];
                                  } completion:nil];
             }
         }];
    }
}
- (void)makeBlureImage {
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.view.backgroundColor = [UIColor clearColor];
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.view.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        blurEffectView.alpha = 0;
        [self.view addSubview:blurEffectView];
        [self.view bringSubviewToFront:self.congratulationLabel];
        [UIView animateWithDuration:1 animations:^{
            blurEffectView.alpha = 1;
        }];
    } else {
        self.view.backgroundColor = [UIColor blackColor];
    }
}

- (void)makeDarkerImage {
    UIImageView *coverImage = [[UIImageView alloc] initWithImage:self.mainImageView.image];
    coverImage.image = [UIImage colorizeImage:self.mainImageView.image withColor:[UIColor darkGrayColor]];
    [self.mainImageView addSubview:coverImage];
}
@end
