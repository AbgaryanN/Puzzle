//
//  PuzzleCreator.h
//  Puzzles
//
//  Created by Nver Abgaryan on 5/25/17.
//  Copyright © 2017 Nver Abgaryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PuzzleCreator : NSObject

@property (nonatomic, strong) NSMutableArray *arrayOfMasks;
@property (nonatomic, assign) CGSize mainImageViewSize;

- (id)initWithImage:(UIImage *)image matrixSize:(NSInteger)size;

@end
