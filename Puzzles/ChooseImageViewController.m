//
//  ChooseImageViewController.m
//  Puzzles
//
//  Created by Nver Abgaryan on 5/24/17.
//  Copyright © 2017 Nver Abgaryan. All rights reserved.
//

#import "ChooseImageViewController.h"
#import "PatternViewCell.h"
#import "GameViewController.h"

@interface ChooseImageViewController ()

@property (nonatomic, strong) NSArray *patternImagesArray;
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) GameViewController *gameViewControler;
@property (weak, nonatomic) IBOutlet UIButton *defalutButton;
@property (weak, nonatomic) IBOutlet UIButton *button3x3;
@property (weak, nonatomic) IBOutlet UIButton *button4x4;
@property (weak, nonatomic) IBOutlet UIButton *button5x5;
@property (weak, nonatomic) IBOutlet UIButton *button6x6;
@property (assign, nonatomic) NSInteger matrixSizePicked;

@end

@implementation ChooseImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.patternImagesArray = @[@"Image01",@"Image02",@"Image03",@"Image04",@"Image05"
                                ,@"Image06",@"Image07",@"Image08",@"Image09"];
    // for default value
    self.matrixSizePicked = 3;
    self.button3x3.alpha = 1;
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.patternImagesArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PatternViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"patternCell" forIndexPath:indexPath];
    NSString *myPatternStr = [self.patternImagesArray objectAtIndex:indexPath.row];
    UIImage *img = [UIImage imageNamed:myPatternStr];
    cell.patternImageView.image = img;
    return cell;
}
#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PatternViewCell *selectedCell = (PatternViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    self.selectedImageView = selectedCell.patternImageView;
    UIStoryboard *storyBoard = self.storyboard;
    GameViewController * vc = (GameViewController*)[storyBoard instantiateViewControllerWithIdentifier:
                                                    @"gameViewControlerID"];
    self.gameViewControler = vc;
    [self.gameViewControler setupMainImageViewWithImage:self.selectedImageView.image];
    [self.gameViewControler createPuzzlesWithMatrixSize:self.matrixSizePicked];
    [self presentViewController:self.gameViewControler animated:YES completion:nil];
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat size = CGRectGetHeight(self.imagesCollectionView.frame);
    return CGSizeMake(size, size);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(20, 5, 20, 5);
}
#pragma mark - Action
- (IBAction)defaultAction:(UIButton *)sender {
    sender.alpha = 1;
    self.matrixSizePicked = 3;
}
- (IBAction)action3x3:(UIButton *)sender {
    sender.alpha = 1;
    _button4x4.alpha = _button5x5.alpha = _button6x6.alpha = 0.5;
    self.matrixSizePicked = 3;
}
- (IBAction)action4x4:(UIButton *)sender {
    sender.alpha = 1;
    _button3x3.alpha = _button5x5.alpha = _button6x6.alpha = 0.5;
    self.matrixSizePicked = 4;
}

- (IBAction)action5x5:(UIButton *)sender {
    sender.alpha = 1;
    _button3x3.alpha = _button4x4.alpha = _button6x6.alpha = 0.5;
    self.matrixSizePicked = 5;
}
- (IBAction)action6x6:(UIButton *)sender {
    sender.alpha = 1;
    _button3x3.alpha = _button4x4.alpha = _button5x5.alpha = 0.5;
    self.matrixSizePicked = 6;

}

@end
