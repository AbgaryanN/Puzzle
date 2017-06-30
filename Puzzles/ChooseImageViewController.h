//
//  ChooseImageViewController.h
//  Puzzles
//
//  Created by Nver Abgaryan on 5/24/17.
//  Copyright © 2017 Nver Abgaryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseImageViewController : UIViewController <UICollectionViewDataSource,
                                  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) IBOutlet UICollectionView *imagesCollectionView;

@end
