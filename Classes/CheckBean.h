//
//  CheckBean.h
//  Firefighter
//
//  Created by sandra on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CheckBean : NSObject {
	NSInteger _id;
	NSString *precheck;
	NSString *name;
	NSString *informaiton1;
	NSString *informaiton2;
	NSString *informaiton3;
	BOOL b_check;
}

@property(nonatomic, assign) NSInteger _id;
@property(nonatomic, retain) NSString *precheck;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *informaiton1;
@property(nonatomic, retain) NSString *informaiton2;
@property(nonatomic, retain) NSString *informaiton3;
@property(nonatomic, assign) BOOL b_check;

@end
