//
//  DosingBean.m
//  Paramedic
//
//  Created by Abdul Rehman on 1/14/15.
//
//

#import "DosingBean.h"

@implementation DosingBean

@synthesize answer;
@synthesize question;
@synthesize equation;


-(void)dealloc
{
    
    
    [answer release];
    [question release];
    [equation release];
    
    [super dealloc];
}



@end
