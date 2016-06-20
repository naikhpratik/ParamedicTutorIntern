//
//  RefViewController-ipad.m
//  Quiz
//
//  Created by Arthur on 13-9-16.
//
//

#import "RefViewController-ipad.h"

@interface RefViewController_ipad ()

@end

@implementation RefViewController_ipad
@synthesize cardBean;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _questionView.frame = CGRectMake(0, 0, 575, 725);
    _answerView.frame = CGRectMake(0, 0, 575, 725);
    _tfQuestion.text = cardBean.question;
    _tfQuestionForAnsView.text = cardBean.question;
    _tfAnswer.delegate = self;
    _tfQuestion.delegate = self;
	_tfAnswer.text = cardBean.answer;
	[_superView addSubview:_questionView];
    self.navigationItem.title = @"Reference";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_superView release];
    [_questionView release];
    [_answerView release];
    [_tfAnswer release];
    [_tfQuestion release];
    [_tfQuestionForAnsView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setSuperView:nil];
    [self setQuestionView:nil];
    [self setAnswerView:nil];
    [self setTfAnswer:nil];
    [self setTfQuestion:nil];
    [self setTfQuestionForAnsView:nil];
    [super viewDidUnload];
}

-(void)flipViewAction {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	BOOL b_AnswerView = NO;
	if ([_superView.subviews objectAtIndex:0] == _answerView) {
		b_AnswerView = YES;
	}
	[UIView setAnimationTransition:(b_AnswerView ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) forView:_superView cache:YES];
	
	if (b_AnswerView) {
		[[_superView.subviews objectAtIndex:0] removeFromSuperview];
		[_superView addSubview:_questionView];
	} else {
		[[_superView.subviews objectAtIndex:0] removeFromSuperview];
		[_superView addSubview:_answerView];
	}
	[UIView commitAnimations];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = (UITouch *)[touches anyObject];
	CGPoint location = [touch locationInView:self.view];
	if(CGRectContainsPoint(_superView.frame, location) ) { //flip to answer/question view
		[self flipViewAction];
	}
}

-(IBAction)back: (id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    //    [textView resignFirstResponder];
    return NO;
}
@end
