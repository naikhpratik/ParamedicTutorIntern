//
//  AFKReviewTroller.h
//  AFKReviewTroller
//
//  Created by Marco Tabini on 11-02-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAppStartCount @"AppStartCount"
#define kQuizRateTitle @"QuizRateTitle"
#define kRateAlertMessage @"RateAlertMessage"
#define kAppID @"AppID"


@interface AFKReviewTroller : NSObject <UIAlertViewDelegate> {
    
    int numberOfExecutions;
    
}


+ (int) numberOfExecutions;

- (id) initWithNumberOfExecutions:(int) executionCount;


@end
