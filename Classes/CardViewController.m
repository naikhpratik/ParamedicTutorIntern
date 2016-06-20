//
//  CardViewController.m
//  Quiz
//
//  Created by Zorro on 3/2/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import "CardViewController.h"
#import "QuizAppDelegate.h"
#import "CardBean.h"
#import "SqlMB.h"
#define kQuestionViewWidth 300
#define kCenterPointY_4  iPhone5 ? 287 : 240//216//331:284

#define kAlertEndCards 100

//#define kCenterPointY_5 200

@implementation CardViewController {
    float popViewHeight;
}


@synthesize iChapter, sChapter, mode, bookquizID;
@synthesize hadPreviousData;
@synthesize activityView,fromfromComprehensive;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    NSLog(@"kCenterPointY_4 = %d",kCenterPointY_4);
 
    //fromfromComprehensive = NO;
    // set background with all view( questionView, answerView, superView, leftView, rightView).

	self.navigationItem.title = @"Flashcards";
    
//    if (iPhone5) {
//        self.cardView_head_imageView.image = [UIImage imageNamed:@"flashcards-header-5"];
//    }else {
//        self.cardView_head_imageView.image = [UIImage imageNamed:@"flashcards-header"];
//
//    }
	lbTitle.text = sChapter;
	
	arrayCards = [[NSMutableArray alloc] init];
	theLeftView.backgroundColor = [UIColor clearColor];
	theRightView.backgroundColor = [UIColor clearColor];
	superView.backgroundColor = [UIColor clearColor];
	
	questionView.opaque = NO;
	questionView.backgroundColor = [UIColor clearColor];
	answerView.opaque = NO;
	answerView.backgroundColor = [UIColor clearColor];
	tfAnswer.backgroundColor = [UIColor clearColor];
	tfQuestion.backgroundColor = [UIColor clearColor];
	
	[superView addSubview:questionView];
    
    UIBarButtonItem *_leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
	self.navigationItem.leftBarButtonItem = _leftBarButtonItem;
	[_leftBarButtonItem release];
    _fc_index = 0;
    if (hadPreviousData) {
        NSMutableDictionary *valueDic = [[NSMutableDictionary alloc] initWithCapacity:10];
        [[SqlMB getInstance] getLastProcessForCards:arrayCards Chapter:iChapter valueDic:valueDic];
        _fc_index = [[valueDic objectForKey:INDEXCARD_LAST] intValue];
    } else {
        [[SqlMB getInstance] getCardsFromDB:arrayCards chapter:iChapter mode:mode];
        [arrayCards shuffled];
        _fc_index = 0;
    }

	
	if (mode == 1) {
        if (fromfromComprehensive == YES) {
            _fc_index = 0;
        } else {
            for (int i =0; i<[arrayCards count]; i++) {
                CardBean *cBean = [arrayCards objectAtIndex:i];
                if (cBean.cardID == bookquizID) {
                    _fc_index = i;
                    break;
                }
            }
        }
	}

    
	lbChapter.text = [NSString stringWithFormat:@"of %d",[arrayCards count]];
    self.lbl_indexContent.text = [NSString stringWithFormat:@"%d",_fc_index+1];
	[self updateArrow];
	if ([arrayCards count] != 0) {
		CardBean *cBean = [arrayCards objectAtIndex:_fc_index];
		tfQuestion.text =  cBean.question;
		tfAnswer.text = cBean.answer;
	}else {
		tfQuestion.text = @"";
		tfAnswer.text = @"";
		self.view.userInteractionEnabled = NO;
	}

	//tfQuestion.text= @"11111111111111112222222222222   3333333333333333444444444444444444444555555555555555666666666666666   7890 ABCDEF 34567890  45678 111111122222245679798797897987";
	//tfAnswer.text = @"2345678 11111111111111112222222222222   3333333333333333444444444444444444444555555555555555666666666666666   7890 ABCDEF 345  6788  QWERTYUIOPLKJHGFDSAZXCVBN";
	
	_card_page_index = 0;  //centered
	
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
//    NSLog(@"the view frame is %@",NSStringFromCGRect(self.view.frame));
    popViewHeight = self.view.frame.size.height - self.cardView_head_imageView.frame.size.height - 100;
//-44
    [self setAllViewBackground];

}

-(IBAction)back: (id)sender
{
	if (mode == 0) {
		NSString *Message = @"Do you want to save this cards to continue at a later time?";//@"Do you want to quit and save your score?";
		UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Quit Cards" message:Message delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
		[alert show];
		[alert release];
	}else {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

#pragma Set all view background.
- (void)setAllViewBackground {
    if (iPhone5) {
        // set question frame
        
        self.pop_question_bg_imageview.image = [UIImage imageNamed:@"fcard_front_5n.png"];
        self.pop_answer_bg_imageView.image = [UIImage imageNamed:@"fcard_back_5n.png"];
//        self.imgView_cardBackBlueBar.image = [UIImage imageNamed:@"fcard_back_bluebar_5n.png"];
//        questionView.frame = CGRectMake((self.view.frame.size.width-kQuestionViewWidth) / 2 , 30, kQuestionViewWidth, 380);
//        answerView.frame = CGRectMake((self.view.frame.size.width-kQuestionViewWidth) / 2 , 30, kQuestionViewWidth, 380);
        questionView.frame = CGRectMake(0, 0, superView.frame.size.width, superView.frame.size.height);
        answerView.frame = CGRectMake(0, 0, superView.frame.size.width, superView.frame.size.height);
//        NSLog(@"the question view frame is %@, answer frame is %@",NSStringFromCGRect(questionView.frame), NSStringFromCGRect(answerView.frame));
//        tfQuestion.frame = CGRectMake(20, 55, kQuestionViewWidth-40, 140);
//        tfAnswer.frame = CGRectMake(20, 55, kQuestionViewWidth-40, 140);
    } else {
        // set the questionView background.
//        self.pop_question_bg_imageview.image = [UIImage imageNamed:@"flashcards"];
//        self.pop_answer_bg_imageView.image = [UIImage imageNamed:@"flashcardsnext"];
        questionView.frame = CGRectMake(0, 0, questionView.frame.size.width, 300);
        answerView.frame = CGRectMake(0, 0, answerView.frame.size.width , 300);
    }
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [self setCardView_head_imageView:nil];
    [self setPop_question_bg_imageview:nil];
    [self setPop_answer_bg_imageView:nil];
    [activityView release];
    activityView = nil;
    [self setLbl_indexContent:nil];
    [self setImgView_cardBackBlueBar:nil];
    [self setBtn_backToLastCard:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[arrayCards release];
	
	[lbTitle release];
	[superView release];
	[theRightView release];
	[theLeftView release];
	[questionView release];
	[answerView release];
	[tfAnswer release];
	[lbChapter release];
	[tfQuestion release];
	[btLeft release];
	[btRight release];
	[btBook release];
	[btBookimg release];
	
    [_cardView_head_imageView release];
    [_pop_question_bg_imageview release];
    [_pop_answer_bg_imageView release];
    [activityView release];
    [_lbl_indexContent release];
    [_imgView_cardBackBlueBar release];
    [_btn_backToLastCard release];
    [super dealloc];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAlertEndCards) {
        if (buttonIndex == 0) {// no
            [self.navigationController popViewControllerAnimated:YES];
            return;
        } else {
            _fc_index = -1;
            [self turnMenuToLeft];
        }
    } else
    {
        [self.activityView startAnimating];
        self.navigationController.navigationBar.userInteractionEnabled = NO;
        self.view.userInteractionEnabled = NO;
        [self.view bringSubviewToFront:self.activityView];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            if (buttonIndex==0) {
                //Save score
                //        [[SqlMB getInstance] setProcessForCards:arrayQuiz Process:_currentIndex Chapter:iChapter];
                NSString *sequenceStr = @"";
                NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:10];
                for (int i = 0; i<[arrayCards count]; i++) {
                    CardBean *bean = [arrayCards objectAtIndex:i];
                    [tempArr addObject:[NSString stringWithFormat:@"%d",bean.cardID]];
                }
                sequenceStr = [tempArr componentsJoinedByString:@","];
                [[SqlMB getInstance] saveProcessForCards:iChapter Sequence:sequenceStr CurrentIndex:_fc_index];
                NSLog(@"save success");
            } else {
                [[SqlMB getInstance] clearProcessForCards:iChapter];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                [self.activityView stopAnimating];
                self.view.userInteractionEnabled = YES;
                self.navigationController.navigationBar.userInteractionEnabled = YES;
                [self.navigationController popViewControllerAnimated:YES];
            });
        });
    }

}

-(IBAction)answerAction:(id)sender
{
    [self flipViewAction:_card_page_index];
}

-(void)flipViewAction: (int)c_index {
    
//    NSLog(@"before rotate the qiz frame is %@, the answer frame is %@, the current card view is %@, left view is %@, right view is %@",NSStringFromCGRect(questionView.frame),NSStringFromCGRect(answerView.frame),NSStringFromCGRect(superView.frame),NSStringFromCGRect(theLeftView.frame),NSStringFromCGRect(theRightView.frame));
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	UIView *_superView;
	switch (c_index) {
		case 0:
			_superView = superView;
			break;
		case 1:
			_superView = theRightView;
			break;
		case 2:
			_superView = theLeftView;
		default:
			break;
	}
	BOOL b_AnswerView = NO;
	if ([_superView.subviews objectAtIndex:0] == answerView) {
		b_AnswerView = YES;
	}
	[UIView setAnimationTransition:(b_AnswerView ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) forView:_superView cache:YES];
	
	if (b_AnswerView) {
		[[_superView.subviews objectAtIndex:0] removeFromSuperview];
		[_superView addSubview:questionView];
	} else {
		[[_superView.subviews objectAtIndex:0] removeFromSuperview];
		CardBean *cBean = [arrayCards objectAtIndex:_fc_index];
		if (cBean.b_bookmark) {
			[btBook setTitle:@"Bookmarked!" forState:UIControlStateNormal];
			[btBook setTitle:@"Bookmarked!" forState:UIControlStateHighlighted];
			[btBook setTitle:@"Bookmarked!" forState:UIControlStateDisabled];
			[btBookimg setImage:[UIImage imageNamed:@"heart_bookmarked_flashcard_n.png"] forState:UIControlStateNormal];
			[btBookimg setImage:[UIImage imageNamed:@"heart_bookmarked_flashcard_n.png"] forState:UIControlStateHighlighted];
			[btBookimg setImage:[UIImage imageNamed:@"heart_bookmarked_flashcard_n.png"] forState:UIControlStateDisabled];
		}else {
			[btBook setTitle:@"Add to Bookmarks" forState:UIControlStateNormal];
			[btBook setTitle:@"Add to Bookmarks" forState:UIControlStateHighlighted];
			[btBook setTitle:@"Add to Bookmarks" forState:UIControlStateDisabled];
			[btBookimg setImage:[UIImage imageNamed:@"heart_flashcard_n.png"] forState:UIControlStateNormal];
			[btBookimg setImage:[UIImage imageNamed:@"heart_flashcard_n.png"] forState:UIControlStateHighlighted];
			[btBookimg setImage:[UIImage imageNamed:@"heart_flashcard_n.png"] forState:UIControlStateDisabled];
		}
		tfAnswer.text = cBean.answer;
//        if (iPhone5) {
//            _superView.frame = CGRectMake(_superView.frame.origin.x, _superView.frame.origin.y, _superView.frame.size.width, _superView.frame.size.height + 60);
//        }
//        NSLog(@"the answer view frame is %@, the super view frame is %@",NSStringFromCGRect(answerView.frame),NSStringFromCGRect(_superView.frame));
		[_superView addSubview:answerView];
	}
	[UIView commitAnimations];
//    NSLog(@"after rotate the qiz frame is %@, the answer frame is %@, the current card view is %@, left view is %@, right view is %@",NSStringFromCGRect(questionView.frame),NSStringFromCGRect(answerView.frame),NSStringFromCGRect(superView.frame),NSStringFromCGRect(theLeftView.frame),NSStringFromCGRect(theRightView.frame));
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.view];
	
//	NSLog(@"currentTouchPosition : %.1f, %.1f", currentTouchPosition.x, currentTouchPosition.y);
//	NSLog(@"questionView: %.1f, %.1f, %.1f, %.1f", questionView.frame.origin.x, questionView.frame.origin.y, questionView.frame.size.width, questionView.frame.size.height);
	
	if (currentTouchPosition.x-_tmp_x>12) {    //turn right
		[self turnMenuToRight];
	}else if (currentTouchPosition.x-_tmp_x<-12) {    //turn left
		[self turnMenuToLeft];
	}else if(CGRectContainsPoint(questionView.frame, currentTouchPosition) || CGRectContainsPoint(answerView.frame, currentTouchPosition)) { //flip to answer/question view
		[self flipViewAction: _card_page_index];
	}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = (UITouch *)[touches anyObject];
	CGPoint location = [touch locationInView:self.view];
	_tmp_x =location.x;
	_tmp_y = location.y;
}

-(void)turnMenuToRight
{
	if (_fc_index == 0) {
		return;
	}
	_fc_index--;
	[self updateCard];
	switch (_card_page_index) {
		case 0:
			theRightView.center = CGPointMake(-160.0, kCenterPointY_4);
			break;
		case 1:
			theLeftView.center = CGPointMake(-160.0, kCenterPointY_4);
			break;
		case 2:
			superView.center = CGPointMake(-160.0, kCenterPointY_4);
			break;	
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.6];
	
	switch (_card_page_index) {
		case 0:
			theRightView.center = CGPointMake(160.0, kCenterPointY_4);
			[self.view bringSubviewToFront:theRightView];
			_card_page_index = 1;
			break;
		case 1:
			theLeftView.center = CGPointMake(160.0, kCenterPointY_4);
			[self.view bringSubviewToFront:theLeftView];
			_card_page_index = 2;
			break;
		case 2:
			superView.center = CGPointMake(160.0, kCenterPointY_4);
			[self.view bringSubviewToFront:superView];
			_card_page_index = 0;
			break;	
	}
	[self updateArrow];
	[UIView commitAnimations];
}

-(void)turnMenuToLeft
{
	if (_fc_index+1 == [arrayCards count]) {
		//return;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"End of flashcards, would you like to review them again?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alert.tag = kAlertEndCards;
        [alert show];
        [alert release];
        
        return;
//		_fc_index = -1;
	}
	_fc_index++;
//    theRightView.hidden = YES;
//    theLeftView.hidden = YES;
//    superView.hidden = YES;
	[self updateCard];

	switch (_card_page_index) {
		case 0:
			theRightView.center = CGPointMake(480,kCenterPointY_4 );//219.5
			break;
		case 1:
			theLeftView.center = CGPointMake(480, kCenterPointY_4);
			break;
		case 2:
			superView.center = CGPointMake(480, kCenterPointY_4);
			break;	
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.6];
	
	switch (_card_page_index) {
		case 0:
			theRightView.center = CGPointMake(160.0, kCenterPointY_4);
			[self.view bringSubviewToFront:theRightView];
			_card_page_index = 1;
			break;
		case 1:
			theLeftView.center = CGPointMake(160.0, kCenterPointY_4);
			[self.view bringSubviewToFront:theLeftView];
			_card_page_index = 2;
			break;
		case 2:
			superView.center = CGPointMake(160.0, kCenterPointY_4);
			[self.view bringSubviewToFront:superView];
			_card_page_index = 0;
			break;	
	}
	[self updateArrow];
	[UIView commitAnimations];
    
//    theRightView.hidden = NO;
//    theLeftView.hidden = NO;
//    superView.hidden = NO;
}

-(void)updateArrow
{
	btLeft.enabled = YES;
	btRight.enabled = YES;
	if (_fc_index == 0) {
		btLeft.enabled = NO;
	}
//	if (_fc_index+1 >= [arrayCards count]) {
//		btRight.enabled = NO;
//	}
}

-(void)updateCard
{
	switch (_card_page_index) {
		case 0:
		{
			NSArray *views = [theRightView subviews];
			for (int i=0; i<[views count]; i++) {
				UIView *subView = [views objectAtIndex:i];
				[subView removeFromSuperview];
			}
			[theRightView addSubview:questionView];
		}
			break;
		case 1:
		{
			NSArray *views = [theLeftView subviews];
			for (int i=0; i<[views count]; i++) {
				UIView *subView = [views objectAtIndex:i];
				[subView removeFromSuperview];
			}
			
			[theLeftView addSubview:questionView];
		}
			break;
		case 2:
		{
			NSArray *views = [superView subviews];
			for (int i=0; i<[views count]; i++) {
				UIView *subView = [views objectAtIndex:i];
				[subView removeFromSuperview];
			}
			[superView addSubview:questionView];
		}
			break;	
	}
	CardBean *cBean = [arrayCards objectAtIndex:_fc_index];
	tfQuestion.text =  cBean.question;
	lbChapter.text = [NSString stringWithFormat:@"of %d",[arrayCards count]];
    self.lbl_indexContent.text = [NSString stringWithFormat:@"%d",_fc_index+1];
	//tfAnswer.text = cBean.answer;
}

-(IBAction)addtoBookmark: (id)sender
{
	CardBean *cBean = [arrayCards objectAtIndex:_fc_index];
//	QuizAppDelegate *appDelegate = (QuizAppDelegate*)[[UIApplication sharedApplication] delegate];
//	sqlite3 *db = [appDelegate getDatabase];
	
	if (cBean.b_bookmark) {  //unbook
		[btBook setTitle:@"Add to Bookmarks" forState:UIControlStateNormal];
		[btBook setTitle:@"Add to Bookmarks" forState:UIControlStateHighlighted];
		[btBook setTitle:@"Add to Bookmarks" forState:UIControlStateDisabled];
		[btBookimg setImage:[UIImage imageNamed:@"heart_flashcard_n.png"] forState:UIControlStateNormal];
		[btBookimg setImage:[UIImage imageNamed:@"heart_flashcard_n.png"] forState:UIControlStateHighlighted];
		[btBookimg setImage:[UIImage imageNamed:@"heart_flashcard_n.png"] forState:UIControlStateDisabled];
        [[SqlMB getInstance] bookmarkCard:cBean.cardID BookMark:NO];
        cBean.b_bookmark = 0;
	}else {   //book it
		[btBook setTitle:@"Bookmarked!" forState:UIControlStateNormal];
		[btBook setTitle:@"Bookmarked!" forState:UIControlStateHighlighted];
		[btBook setTitle:@"Bookmarked!" forState:UIControlStateDisabled];
		[btBookimg setImage:[UIImage imageNamed:@"heart_bookmarked_flashcard_n.png"] forState:UIControlStateNormal];
		[btBookimg setImage:[UIImage imageNamed:@"heart_bookmarked_flashcard_n.png"] forState:UIControlStateHighlighted];
		[btBookimg setImage:[UIImage imageNamed:@"heart_bookmarked_flashcard_n.png"] forState:UIControlStateDisabled];
        [[SqlMB getInstance] bookmarkCard:cBean.cardID BookMark:YES];
        cBean.b_bookmark = 1;
	}
}

-(IBAction)nextCard: (id)sender
{
//if (_fc_index+1 == [arrayCards count]) {
//		_fc_index = 0;
//	}
	[self turnMenuToLeft];
}

-(IBAction)previous: (id)sender
{
	[self turnMenuToRight];
}

-(IBAction)next: (id)sender
{
	[self turnMenuToLeft];
}

@end
