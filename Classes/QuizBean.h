//
//  QuizBean.h
//  Quiz
//
//  Created by Zorro on 2/16/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QuizBean : NSObject {
    int quizID;
	NSString *question;
	int chapter;
	NSMutableArray *answers;
	NSString *explanation;
	BOOL b_bookmark;
}

@property (nonatomic, assign) int quizID;
@property (nonatomic, retain) NSString *question;
@property (nonatomic, assign) int chapter;
@property (nonatomic, retain) NSMutableArray *answers;
@property (nonatomic, retain) NSString *explanation;
@property (nonatomic, assign) BOOL b_bookmark;

@end
