//
//  NSMutableArray+NSMutableArray_Shuffling.m
//  Puzzles
//
//  Created by Nver Abgaryan on 5/29/17.
//  Copyright © 2017 Nver Abgaryan. All rights reserved.
//

#import "NSMutableArray+NSMutableArray_Shuffling.h"

@implementation NSMutableArray (NSMutableArray_Shuffling)

- (void)shuffle {
    
    static BOOL seeded = NO;
    if(!seeded) {
        seeded = YES;
    }
    
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (random() % nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}
@end
