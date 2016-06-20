//
//  RefDetailViewController.m
//  Firefighter
//
//  Created by sandra on 11/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RefDetailViewController.h"
#define kQuestionViewWidth 288
#define kCenterPointY_4  iPhone5 ? 260 : 215

@implementation RefDetailViewController
{
    float popViewHeight;
}

@synthesize cardBean;
@synthesize imgView_answer,imgView_ques,tv_BackQiz = _tv_BackQiz;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	

	
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Reference";
    popViewHeight = self.view.frame.size.height - 121;
//    superView.frame = CGRectMake(superView.frame.origin.x, superView.frame.origin.y, superView.frame.size.width, popViewHeight);
    questionView.frame = CGRectMake(0, 0, superView.frame.size.width, superView.frame.size.height);
    answerView.frame = CGRectMake(0, 0, superView.frame.size.width, superView.frame.size.height);
    
    if (iPhone5) {
        // set question frame
        
//        questionView.frame = CGRectMake(0, 0, superView.frame.size.width, popViewHeight);
        //        self.pop_question_bg_imageview.image = [UIImage imageNamed:@"flashcards-5"];
        //        tfQuestion.frame = CGRectMake(5, 55, kQuestionViewWidth-10, 140);
//        self.imgView_ques.image = [UIImage imageNamed:@"flashcard-front_5"];
        //        self.pop_answer_bg_imageView.image = [UIImage imageNamed:@"flashcardsnext-5"];
//        answerView.frame = CGRectMake(0, 0, superView.frame.size.width, popViewHeight);
//        self.imgView_answer.image = [UIImage imageNamed:@"Reference card_5"];
        //        tfAnswer.frame = CGRectMake(25, 23, kQuestionViewWidth-50, 160);
        
    } else {
        // set the questionView background.
        //        self.pop_question_bg_imageview.image = [UIImage imageNamed:@"flashcards"];
        //        self.pop_answer_bg_imageView.image = [UIImage imageNamed:@"flashcardsnext"];
        //        questionView.frame = CGRectMake(0, 0, questionView.frame.size.width, 311);
        //        answerView.frame = CGRectMake(0, 0, answerView.frame.size.width , 311);
        
    }
	tfQuestion.text = cardBean.question;
	tfAnswer.text = cardBean.answer;
    self.tv_BackQiz.text = cardBean.question;
	[superView addSubview:questionView];
    [self setAllViewBackground];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationItem.title = @""
}

- (void)setAllViewBackground {
    
    

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self setImgView_ques:nil];
    [self setImgView_answer:nil];
    [self setTv_BackQiz:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)dealloc {

    
    [_tv_BackQiz release];
    [super dealloc];
}

-(IBAction)flipViewAction {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	BOOL b_AnswerView = NO;
	if ([superView.subviews objectAtIndex:0] == answerView) {
		b_AnswerView = YES;
	}
	[UIView setAnimationTransition:(b_AnswerView ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) forView:superView cache:YES];
	
	if (b_AnswerView) {
		[[superView.subviews objectAtIndex:0] removeFromSuperview];
		[superView addSubview:questionView];
	} else {
		[[superView.subviews objectAtIndex:0] removeFromSuperview];
		[superView addSubview:answerView];
	}
	[UIView commitAnimations];	
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = (UITouch *)[touches anyObject];
	CGPoint location = [touch locationInView:self.view];
	if(CGRectContainsPoint(superView.frame, location) ) { //flip to answer/question view
		[self flipViewAction];
	}
}

-(IBAction)back: (id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}


@end
