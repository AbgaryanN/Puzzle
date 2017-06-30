//
//  PlayGameViewController.m
//  Puzzles
//
//  Created by Nver Abgaryan on 5/23/17.
//  Copyright © 2017 Nver Abgaryan. All rights reserved.
//
#define ROUND_BUTTON_WIDTH_HEIGHT 70

#import "PlayGameViewController.h"
#import "UIImage+masking.h"

@interface PlayGameViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *playButton;
@end

@implementation PlayGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playButton = [self creatRoundButton];
    [self.view addSubview:self.playButton];
    [UIView animateWithDuration:1
                          delay:0.5
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                    self.playButton.transform = CGAffineTransformScale(_playButton.transform, 1.2, 1.2 );
                     }
                     completion:NULL];
   
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(roundButtonDidTap:) forControlEvents:                 UIControlEventTouchUpInside];
    button.frame = self.playButton.frame;
    [self.view addSubview:button];
}

#pragma mark - Action 

- (void)roundButtonDidTap:(UIButton*)sender {
    
    [self performSegueWithIdentifier:@"chooseImage" sender:self];
}

- (UIButton*)creatRoundButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:@"playButtonForTest"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(roundButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    
    //width and height should be same value
    button.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 0.5*ROUND_BUTTON_WIDTH_HEIGHT,
                              CGRectGetMidY(self.view.frame) + ROUND_BUTTON_WIDTH_HEIGHT,
                              ROUND_BUTTON_WIDTH_HEIGHT, ROUND_BUTTON_WIDTH_HEIGHT);
    
    //Clip/Clear the other pieces whichever outside the rounded corner
    button.clipsToBounds = YES;
    
    //half of the width
    button.layer.cornerRadius = ROUND_BUTTON_WIDTH_HEIGHT/2.0f;
    button.layer.borderColor=[UIColor brownColor].CGColor;
    button.layer.borderWidth=3.0f;
    return button;
}

@end
