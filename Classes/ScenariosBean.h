//
//  ScenariosBean.h
//  Quiz
//
//  Created by Zorro on 3/10/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ScenariosBean : NSObject {
    int sID;
	NSString *name;
	NSString *filename;
	BOOL b_bookmark;
    BOOL b_others;
}

@property (nonatomic, assign) int sID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *filename;
@property (nonatomic, assign) BOOL b_bookmark;
@property (nonatomic, assign) BOOL b_others;

@end
