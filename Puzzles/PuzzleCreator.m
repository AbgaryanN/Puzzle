//
//  PuzzleCreator.m
//  Puzzles
//
//  Created by Nver Abgaryan on 5/25/17.
//  Copyright © 2017 Nver Abgaryan. All rights reserved.
//

#import "PuzzleCreator.h"
#import "UIImage+masking.h"

@interface PuzzleCreator ()

@property (nonatomic, strong) NSMutableArray *arrayOfRects;
@property (nonatomic, assign) NSInteger matrixSize;
@property (nonatomic, assign) NSInteger insets;
@end

@implementation PuzzleCreator

- (id)initWithImage:(UIImage *)image matrixSize:(NSInteger)size {
    self = [super init];
    if (self) {
        self.matrixSize = size;
        self.mainImageViewSize = image.size;
        [self createPuzzlesFromSourceImage:image];
    }
    return self;
}

- (void)createPuzzlesFromSourceImage:(UIImage*)sourceImage {
    self.arrayOfMasks = [[NSMutableArray alloc] init];
    self.arrayOfRects = [[NSMutableArray alloc] init];
    
    NSArray *masksArray = [self masksArrayForMatrixSize:self.matrixSize];

    CGFloat xCoordinate = 0;
    CGFloat yCoordinate = 0;
    NSInteger i = 1;
    for(NSString *maskName in masksArray) {
        
        UIImage *maskImage = [UIImage imageNamed:maskName];
        if (maskImage) {
            //NSInteger newSizefor3 = 128 * 1.5 ;
            NSInteger newSize = [self generateCorrectSizeWithMaskImageSize:maskImage.size];
            maskImage = [UIImage imageWithImage:maskImage convertToSize:
                         CGSizeMake(newSize, newSize)];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:
                                      CGRectMake(0, 0, newSize, newSize)];
            imageView.image = maskImage;
            
            CGFloat width = maskImage.size.width;
            CGFloat height = maskImage.size.height;
            
            UIImage *newCroppedImage = [UIImage imageByCropping:sourceImage toRect:
                                        CGRectMake(xCoordinate - self.insets, sourceImage.size.height - height + self.insets - yCoordinate , width, height)];
            
            UIImage *image = [UIImage maskImage:newCroppedImage withMaskImage:maskImage];
            UIImageView *iv = [[UIImageView alloc] initWithImage:image];
            //[self.view addSubview:iv];
            // creating array of mask
            [self.arrayOfMasks addObject:iv];
            iv.frame = CGRectMake(xCoordinate - self.insets, yCoordinate - self.insets, imageView.image.size.width, imageView.image.size.height);
            iv.userInteractionEnabled = YES;
            // creating array of rect
            CGRect rect = CGRectMake(xCoordinate - self.insets, yCoordinate - self.insets, imageView.image.size.width, imageView.image.size.height);
            NSValue *rectValue = [NSValue valueWithCGRect:rect];
            [self.arrayOfRects addObject:rectValue];
            if (i % self.matrixSize == 0) {
                xCoordinate = 0;
                yCoordinate += CGRectGetHeight(imageView.frame) - 2 * self.insets;
            } else {
                xCoordinate += CGRectGetWidth(imageView.frame) - 2 * self.insets;
            }
            ++i;
        }
    }
}
- (NSArray*)masksArrayForMatrixSize:(NSInteger)matrixSize {
    NSArray *masksArray;
    switch (matrixSize) {
        case 3:
            masksArray = [NSArray arrayWithObjects:@"0_0_1_2", @"0_1_2_2", @"0_0_2_2",
                          @"0_1_1_2", @"1_1_2_2", @"0_2_2_1",
                          @"0_0_1_1", @"0_2_1_1", @"0_0_2_1_n",nil];
            break;
        case 4:
            masksArray = [NSArray arrayWithObjects:@"0_0_1_2", @"0_1_2_2", @"0_1_2_2", @"0_0_2_2",
                          @"0_1_1_2", @"1_1_2_2", @"1_1_2_2", @"0_2_2_1",
                          @"0_1_1_2", @"1_1_2_2", @"1_1_2_2", @"0_2_2_1",
                          @"0_0_1_1", @"0_2_1_1", @"0_2_1_1" , @"0_0_2_1_n",nil];
            break;
        case 5:
            masksArray = [NSArray arrayWithObjects:@"0_0_1_2", @"0_1_2_2", @"0_1_2_2", @"0_1_2_2",   @"0_0_2_2",
                          @"0_1_1_2", @"1_1_2_2", @"1_1_2_2", @"1_1_2_2", @"0_2_2_1",
                          @"0_1_1_2", @"1_1_2_2", @"1_1_2_2", @"1_1_2_2", @"0_2_2_1",
                          @"0_1_1_2", @"1_1_2_2", @"1_1_2_2", @"1_1_2_2", @"0_2_2_1",
                          @"0_0_1_1", @"0_2_1_1", @"0_2_1_1", @"0_2_1_1", @"0_0_2_1_n",nil];

            break;
        case 6:
            masksArray = [NSArray arrayWithObjects:@"0_0_1_2", @"0_1_2_2", @"0_1_2_2",@"0_1_2_2",   @"0_1_2_2", @"0_0_2_2",
                          @"0_1_1_2", @"1_1_2_2", @"1_1_2_2", @"1_1_2_2", @"1_1_2_2", @"0_2_2_1",
                          @"0_1_1_2", @"1_1_2_2", @"1_1_2_2", @"1_1_2_2", @"1_1_2_2", @"0_2_2_1",
                          @"0_1_1_2", @"1_1_2_2", @"1_1_2_2", @"1_1_2_2", @"1_1_2_2", @"0_2_2_1",
                          @"0_1_1_2", @"1_1_2_2", @"1_1_2_2", @"1_1_2_2", @"1_1_2_2", @"0_2_2_1",
                          @"0_0_1_1", @"0_2_1_1", @"0_2_1_1", @"0_2_1_1", @"0_2_1_1", @"0_0_2_1_n",nil];

            break;
        default:
            break;
           
    }
    return masksArray;
}
- (NSInteger)generateCorrectSizeWithMaskImageSize:(CGSize)maskImageSize {
    
    NSInteger size = 0 ;
    
    switch (self.matrixSize) {
        case 3:
            size = maskImageSize.width*self.mainImageViewSize.height / 250;
            self.insets = size / 6;
            break;
        case 4:
            size = maskImageSize.width*self.mainImageViewSize.height / 335;
            self.insets = size / 5.7;
            break;
        case 5:
            size = maskImageSize.width*self.mainImageViewSize.height / 415;
            self.insets = size / 6;
            break;
        case 6:
            size = maskImageSize.width*self.mainImageViewSize.height / 500;
            self.insets = size / 6;
            break;
        
        default:
            break;
    }
    return size;
}

@end
