//
//  CardiologyBean.m
//  Paramedic
//
//  Created by Asad Tkxel on 26/01/2015.
//
//

#import "CardiologyBean.h"

@implementation CardiologyBean

@synthesize question;
@synthesize hint;
@synthesize explanation;


-(void)dealloc
{
    [question release];
    [hint release];
    [explanation release];
    
    [super dealloc];
}

@end
