//
//  BookmarkBean.h
//  Quiz
//
//  Created by Zorro on 2/18/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BookmarkBean : NSObject {
	//int bookID;
	int quizID;
	int chapterID;
	NSString *strQuiz;
	BOOL bookinComp;
}

//@property (nonatomic, assign) int bookID;
@property (nonatomic, assign) int quizID;
@property (nonatomic, assign) int chapterID;
@property (nonatomic, retain) NSString *strQuiz;
@property (nonatomic, assign) BOOL bookinComp;

@end
