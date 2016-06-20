//
//  CardBean.h
//  Quiz
//
//  Created by Zorro on 3/3/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CardBean : NSObject {
	int cardID;
	NSString *question;
	NSString *answer;
	BOOL b_bookmark;
}

@property (nonatomic, assign) int cardID;
@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) NSString *answer;
@property (nonatomic, assign) BOOL b_bookmark;

@end
