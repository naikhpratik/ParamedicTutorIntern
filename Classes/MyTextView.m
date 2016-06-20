//
//  MyTextView.m
//  Quiz
//
//  Created by Zorro on 3/4/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import "MyTextView.h"


@implementation MyTextView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject]; //assume just 1 touch
	CGPoint currentTouchPosition = [touch locationInView:self];
	//NSLog(@"End %d", touch.tapCount);

	if(touch.tapCount == 1) {
		//single tap occurred
		[self.nextResponder touchesEnded :touches withEvent:event];
	}
	
	if ((currentTouchPosition.x-_tmp_x>5) || (currentTouchPosition.x-_tmp_x<-5)) {    //turn right
		[self.nextResponder touchesEnded :touches withEvent:event];
	}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = (UITouch *)[touches anyObject];
	CGPoint location = [touch locationInView:self];
	_tmp_x =location.x;
	_tmp_y = location.y;
	
	[self.nextResponder touchesBegan :touches withEvent:event];
}

@end
