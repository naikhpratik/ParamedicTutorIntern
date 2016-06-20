//
//  ChapterBean.h
//  Quiz
//
//  Created by Zorro on 2/27/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ChapterBean : NSObject {
    int chapterID;
	NSString *name;
}

@property (nonatomic, assign) int chapterID;
@property (nonatomic, retain) NSString *name;

@end
