//
//  CheckBean.m
//  Firefighter
//
//  Created by sandra on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CheckBean.h"


@implementation CheckBean

@synthesize _id, precheck, name, informaiton1,informaiton2,informaiton3,b_check;

- (void)dealloc {
	[precheck release];
	[name release];
	[informaiton1 release];
	[informaiton2 release];
	[informaiton3 release];
	
	[super dealloc];
}

@end
