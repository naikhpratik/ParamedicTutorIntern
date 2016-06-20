//
//  ScoreBean.h
//  Quiz
//
//  Created by Zorro on 2/18/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ScoreBean : NSObject {
    int scoreID;
	NSString *chapter;
	NSString *result;
}

@property (nonatomic, assign) int scoreID;
@property (nonatomic, retain) NSString *chapter;
@property (nonatomic, retain) NSString *result;

@end
