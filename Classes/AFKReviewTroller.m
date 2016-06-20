//
//  AFKReviewTroller.m
//  AFKReviewTroller
//
//  Created by Marco Tabini on 11-02-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AFKReviewTroller.h"

#define kAppStartCountDefault @"kAppStartCountDefault"


@implementation AFKReviewTroller

+ (void) load {
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
        
    int numberOfExecutions = [standardDefaults integerForKey:kAppStartCountDefault] + 1;
    
    [[[AFKReviewTroller alloc] initWithNumberOfExecutions:numberOfExecutions] performSelector:@selector(setup) withObject:Nil afterDelay:1.0];
    
    [standardDefaults setInteger:numberOfExecutions forKey:kAppStartCountDefault];
    [standardDefaults synchronize];

    [pool release];
}


+ (int) numberOfExecutions {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kAppStartCountDefault];
}


- (id) initWithNumberOfExecutions:(int) executionCount {
    if ((self = [super init])) {
        numberOfExecutions = executionCount;
    }
    
    return self;
}


- (void) setup {
    NSDictionary *bundleDictionary = [[NSBundle mainBundle] infoDictionary];
    
    if (numberOfExecutions == [[bundleDictionary objectForKey:kAppStartCount] intValue]) {
        NSString *title = NSLocalizedString([bundleDictionary objectForKey:kQuizRateTitle], Nil);
        NSString *message = NSLocalizedString([bundleDictionary objectForKey:kRateAlertMessage], Nil);
        
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:title 
                                                             message:message 
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"Cancel", Nil) 
                                                   otherButtonTitles:NSLocalizedString(@"Rate", Nil), Nil] 
                                  autorelease];
        [alertView show];
    }
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
//        NSString *appId = [[[NSBundle mainBundle] infoDictionary] objectForKey:kAppID];

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/emt-tutor/id427516922?l=en&mt=8"]]];
    }
}


- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self release];
}


@end
