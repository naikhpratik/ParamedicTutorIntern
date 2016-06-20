//
//  NSArray+Helpers.m
//  Qusic
//
//  Created by Oliver on 22.04.09.
//  Copyright 2009 TeagleSoft. All rights reserved.
//

#import "NSArray+Helpers.h"


@implementation NSMutableArray (Helpers)

- (void) shuffled
{
	NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; i++) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (arc4random() % nElements) + i;
		//NSLog(@"n=%d", n);
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
