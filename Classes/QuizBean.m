//
//  QuizBean.m
//  Quiz
//
//  Created by Zorro on 2/16/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import "QuizBean.h"


@implementation QuizBean

@synthesize quizID, question, chapter, answers, explanation, b_bookmark;

- (void)dealloc {
	[answers release];
	[super dealloc];
}

@end
