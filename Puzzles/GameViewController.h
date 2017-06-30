//
//  GameViewController.h
//  Puzzles
//
//  Created by Nver Abgaryan on 5/24/17.
//  Copyright © 2017 Nver Abgaryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController <UICollectionViewDataSource,
UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>
{
    CGPoint locationPoint;
    NSInteger puzzlesNumberInPlace;
    BOOL firstStartOrReset;
}

@property (nonatomic, strong) IBOutlet UICollectionView *puzzlesCollectionView;
@property (nonatomic, strong) UIImageView *mainImageView;

- (void)createPuzzlesWithMatrixSize:(NSInteger)matrixSize;
- (void)setupMainImageViewWithImage:(UIImage*)image;

@end
