//
//  RefDetailViewController.h
//  Firefighter
//
//  Created by sandra on 11/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextView.h"
#import "CardBean.h"

@interface RefDetailViewController : UIViewController {
	IBOutlet UIView *superView;
	
	IBOutlet UIView *questionView;
	IBOutlet UIView *answerView;
	IBOutlet MyTextView *tfAnswer;
	IBOutlet MyTextView *tfQuestion;
	
	CardBean *cardBean;
	
	float _tmp_x;
	float _tmp_y;
}

-(IBAction)flipViewAction;
-(IBAction)back: (id)sender;

@property (retain, nonatomic) IBOutlet UITextView *tv_BackQiz;
@property (nonatomic, retain) CardBean *cardBean;
@property (retain, nonatomic) IBOutlet UIImageView *imgView_ques;
@property (retain, nonatomic) IBOutlet UIImageView *imgView_answer;

@end
