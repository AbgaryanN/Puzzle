//
//  UIImage+masking.h
//  Puzzles
//
//  Created by Nver Abgaryan on 5/23/17.
//  Copyright © 2017 Nver Abgaryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (masking)

+ (instancetype)colorizeImage:(UIImage *)image withColor:(UIColor *)color;

+ (instancetype)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect;

+ (instancetype)maskImage:(UIImage *)image withMaskImage:(UIImage*)maskImage;

+ (instancetype)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;

+ (instancetype)MergeImage:(UIImage*)img1 withImage:(UIImage*)img2;

@end
