//
//  FlashCardViewController.m
//  Quiz
//
//  Created by Arthur on 13-9-13.
//
//

#import "FlashCardViewController.h"
#import "CardBean.h"
#import "SqlMB.h"


#define kQuestionViewWidth 575
#define kCenterPointY_4   614
#define kCenterPointX_4   384 
#define kRightCenterX     1152


@interface FlashCardViewController () {
    BOOL againFlashcard;
}

@end

@implementation FlashCardViewController

@synthesize iChapter,sChapter, mode, bookquizID;
@synthesize hadPreviousData;


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
    _lbTitle.text = sChapter;
    tfAnswer.delegate = self;
    tfQuestion.delegate = self;
    tfQuestionInAnswerView.delegate = self;
    arrayCards = [[NSMutableArray alloc] init];
    [_superView addSubview:_questionView];
    UIBarButtonItem *_leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
	self.navigationItem.leftBarButtonItem = _leftBarButtonItem;
	[_leftBarButtonItem release];
    
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
        if (self.fromComprehensive == YES) {
            _fc_index = 0;
        }
        else{
            for (int i =0; i<[arrayCards count]; i++) {
                CardBean *cBean = [arrayCards objectAtIndex:i];
                if (cBean.cardID == bookquizID) {
                    _fc_index = i;
                    break;
                }
            }
        }
	}
    
    // initial the card title.
    _lbCurrentIndex.text = [NSString stringWithFormat:@"%d",_fc_index+1];
    _lbTotalCount.text = [NSString stringWithFormat:@"%d",[arrayCards count]];
    
	[self updateArrow];
	if ([arrayCards count] != 0) {
		CardBean *cBean = [arrayCards objectAtIndex:_fc_index];
		tfQuestion.text =  cBean.question;
		tfAnswer.text = cBean.answer;
        tfQuestionInAnswerView.text = cBean.question;
	}else {
		tfQuestion.text = @"";
        tfQuestionInAnswerView.text = @"";
		tfAnswer.text = @"";
		self.view.userInteractionEnabled = NO;
	}
    
    _card_page_index = 0;  //centered

//    _questionView.center = CGPointMake(kCenterPointX_4, 409);
//    _answerView.center = CGPointMake(kCenterPointX_4, 409);
    _questionView.frame = CGRectMake(97, 46, 575, 725);
    _answerView.frame = CGRectMake(97, 46, 575, 725);
    
//    NSLog(@"_superView.center = %@",NSStringFromCGPoint(_superView.center));
//    NSLog(@"_superview.frame = %@",NSStringFromCGRect(_superView.frame));
//    NSLog(@"_questionView = %@",NSStringFromCGPoint(_questionView.center));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationItem.title = @"Flashcards";
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_lbTitle release];
    [_superView release];
    [_theLeftView release];
    [_theRightView release];
    [_activityView release];
    [_lbCurrentIndex release];
    [_lbTotalCount release];
    [tfQuestion release];
    [_questionView release];
    [_answerView release];
    [_btBookimg release];
    [_btBook release];
    [tfAnswer release];
    [tfQuestionInAnswerView release];
    [_btLeft release];
    [_btRight release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLbTitle:nil];
    [self setSuperView:nil];
    [self setTheLeftView:nil];
    [self setTheRightView:nil];
    [self setActivityView:nil];
    [self setLbCurrentIndex:nil];
    [self setLbTotalCount:nil];
    [self setQuestionView:nil];
    [self setAnswerView:nil];
    [self setBtBookimg:nil];
    [self setBtBook:nil];
    [tfAnswer release];
    tfAnswer = nil;
    [tfQuestionInAnswerView release];
    tfQuestionInAnswerView = nil;
    [self setBtLeft:nil];
    [self setBtRight:nil];
    [super viewDidUnload];
}


#pragma mark -
#pragma mark - IBAction methods
- (IBAction)addtoBookmark:(id)sender {
    
    CardBean *cBean = [arrayCards objectAtIndex:_fc_index];
    
	if (cBean.b_bookmark) {  //unbook
		[_btBook setTitle:@"Add to Bookmarks" forState:UIControlStateNormal];
		[_btBook setTitle:@"Add to Bookmarks" forState:UIControlStateHighlighted];
		[_btBook setTitle:@"Add to Bookmarks" forState:UIControlStateDisabled];
		[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad_flashcard.png"] forState:UIControlStateNormal];
		[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad_flashcard.png"] forState:UIControlStateHighlighted];
		[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad_flashcard.png"] forState:UIControlStateDisabled];
        [[SqlMB getInstance] bookmarkCard:cBean.cardID BookMark:NO];
        
        cBean.b_bookmark = 0;

	}else {   //book it
		[_btBook setTitle:@"Bookmarked!" forState:UIControlStateNormal];
		[_btBook setTitle:@"Bookmarked!" forState:UIControlStateHighlighted];
		[_btBook setTitle:@"Bookmarked!" forState:UIControlStateDisabled];
		[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad_bookmarked_flashcard.png"] forState:UIControlStateNormal];
		[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad_bookmarked_flashcard.png"] forState:UIControlStateHighlighted];
		[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad_bookmarked_flashcard.png"] forState:UIControlStateDisabled];
        [[SqlMB getInstance] bookmarkCard:cBean.cardID BookMark:YES];
        
        cBean.b_bookmark = 1;
	}
}

- (IBAction)next:(id)sender {
    [self turnMenuToLeft];
}

- (IBAction)previous:(id)sender {
    [self turnMenuToRight];
}

-(IBAction)back: (id)sender
{
	if (mode == 0) {
		NSString *Message = @"Do you want to save your place in this flashcard deck?";//@"Do you want to quit and save your score?";
		UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Quit Cards" message:Message delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        alert.tag = alert_tag_back;
		[alert show];
		[alert release];
	}else {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

#pragma mark -
#pragma mark - Flashcard methods
-(void)flipViewAction: (int)c_index {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	UIView *_superViewTemp;
	switch (c_index) {
		case 0:
			_superViewTemp = _superView;
			break;
		case 1:
			_superViewTemp = _theRightView;
			break;
		case 2:
			_superViewTemp = _theLeftView;
		default:
			break;
	}
	BOOL b_AnswerView = NO;
	if ([_superViewTemp.subviews objectAtIndex:0] == _answerView) {
		b_AnswerView = YES;
	}
    
    
	[UIView setAnimationTransition:(b_AnswerView ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) forView:_superViewTemp cache:YES];
	
	if (b_AnswerView) {
		[[_superViewTemp.subviews objectAtIndex:0] removeFromSuperview];
		[_superViewTemp addSubview:_questionView];
	} else {
		[[_superViewTemp.subviews objectAtIndex:0] removeFromSuperview];
		CardBean *cBean = [arrayCards objectAtIndex:_fc_index];
		if (cBean.b_bookmark) {
			[_btBook setTitle:@"Bookmarked!" forState:UIControlStateNormal];
			[_btBook setTitle:@"Bookmarked!" forState:UIControlStateHighlighted];
			[_btBook setTitle:@"Bookmarked!" forState:UIControlStateDisabled];
			[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad_bookmarked_flashcard.png"] forState:UIControlStateNormal];
			[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad_bookmarked_flashcard.png"] forState:UIControlStateHighlighted];
			[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad_bookmarked_flashcard.png"] forState:UIControlStateDisabled];
		}else {
			[_btBook setTitle:@"Add to Bookmarks" forState:UIControlStateNormal];
			[_btBook setTitle:@"Add to Bookmarks" forState:UIControlStateHighlighted];
			[_btBook setTitle:@"Add to Bookmarks" forState:UIControlStateDisabled];
			[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad_flashcard.png"] forState:UIControlStateNormal];
			[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad_flashcard.png"] forState:UIControlStateHighlighted];
			[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad_flashcard.png"] forState:UIControlStateDisabled];
		}
		tfAnswer.text = cBean.answer;
        tfQuestionInAnswerView.text = cBean.question;
		[_superViewTemp addSubview:_answerView];
        
       
        
	}
	[UIView commitAnimations];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint tempPos = [touch locationInView:self.view];
   CGPoint currentTouchPosition =  CGPointMake(tempPos.x, tempPos.y - 140);
	
	
	if (currentTouchPosition.x-_tmp_x>12) {    //turn right
		[self turnMenuToRight];
	}else if (currentTouchPosition.x-_tmp_x<-12) {    //turn left
		[self turnMenuToLeft];
	}else if(CGRectContainsPoint(_questionView.frame, currentTouchPosition) || CGRectContainsPoint(_answerView.frame, currentTouchPosition)) { //flip to answer/question view
		[self flipViewAction: _card_page_index];
	}
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//	UITouch *touch = (UITouch *)[touches anyObject];
    UITouch *touch = [[event allTouches] anyObject];
//	CGPoint location = [touch locationInView:self.view];
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
			_theRightView.center = CGPointMake(-kCenterPointX_4, kCenterPointY_4);
			break;
		case 1:
			_theLeftView.center = CGPointMake(-kCenterPointX_4, kCenterPointY_4);
			break;
		case 2:
			_superView.center = CGPointMake(-kCenterPointX_4, kCenterPointY_4);
			break;
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.6];
	
	switch (_card_page_index) {
		case 0:
			_theRightView.center = CGPointMake(kCenterPointX_4, kCenterPointY_4);
			[self.view bringSubviewToFront:_theRightView];
			_card_page_index = 1;
			break;
		case 1:
			_theLeftView.center = CGPointMake(kCenterPointX_4, kCenterPointY_4);
			[self.view bringSubviewToFront:_theLeftView];
			_card_page_index = 2;
			break;
		case 2:
			_superView.center = CGPointMake(kCenterPointX_4, kCenterPointY_4);
			[self.view bringSubviewToFront:_superView];
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
        alert.tag = alert_tag_end_flashcard;
        [alert show];
        [alert release];
        
        return;
        
    }
	_fc_index++;
    //    theRightView.hidden = YES;
    //    theLeftView.hidden = YES;
    //    superView.hidden = YES;
	[self updateCard];
    
	switch (_card_page_index) {
		case 0:
			_theRightView.center = CGPointMake(kRightCenterX,kCenterPointY_4 );
			break;
		case 1:
			_theLeftView.center = CGPointMake(kRightCenterX, kCenterPointY_4);
			break;
		case 2:
			_superView.center = CGPointMake(kRightCenterX, kCenterPointY_4);
			break;
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.6];
	
	switch (_card_page_index) {
		case 0:
			_theRightView.center = CGPointMake(kCenterPointX_4, kCenterPointY_4);
			[self.view bringSubviewToFront:_theRightView];
			_card_page_index = 1;
			break;
		case 1:
			_theLeftView.center = CGPointMake(kCenterPointX_4, kCenterPointY_4);
//            _theLeftView.frame = CGRectMake(0, 142, 768, 818);
//             NSLog(@"_theLeftView.frame (end) = %@",NSStringFromCGRect(_theLeftView.frame));
			[self.view bringSubviewToFront:_theLeftView];
			_card_page_index = 2;
			break;
		case 2:
			_superView.center = CGPointMake(kCenterPointX_4, kCenterPointY_4);
//            _superView.frame = CGRectMake(0, 142, 768, 818);
//             NSLog(@"_superView.frame (end) = %@",NSStringFromCGRect(_superView.frame));
			[self.view bringSubviewToFront:_superView];
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
	_btLeft.enabled = YES;
	_btRight.enabled = YES;
	if (_fc_index == 0) {
		_btLeft.enabled = NO;
	}
}

-(void)updateCard
{
	switch (_card_page_index) {
		case 0:
		{
			NSArray *views = [_theRightView subviews];
			for (int i=0; i<[views count]; i++) {
				UIView *subView = [views objectAtIndex:i];
				[subView removeFromSuperview];
			}
//             NSLog(@"_theRightView.frame = %@",NSStringFromCGRect(_theRightView.frame));
			[_theRightView addSubview:_questionView];
		}
			break;
		case 1:
		{
			NSArray *views = [_theLeftView subviews];
			for (int i=0; i<[views count]; i++) {
				UIView *subView = [views objectAtIndex:i];
				[subView removeFromSuperview];
			}
//			 NSLog(@"__theLeftView.frame = %@",NSStringFromCGRect(_theLeftView.frame));
			[_theLeftView addSubview:_questionView];
		}
			break;
		case 2:
		{
			NSArray *views = [_superView subviews];
			for (int i=0; i<[views count]; i++) {
				UIView *subView = [views objectAtIndex:i];
				[subView removeFromSuperview];
			}
//             NSLog(@"__superView.frame = %@",NSStringFromCGRect(_superView.frame));
			[_superView addSubview:_questionView];
		}
			break;
	}
    
//    NSLog(@"_questionView.frame = %@",NSStringFromCGRect(_questionView.frame));
	CardBean *cBean = [arrayCards objectAtIndex:_fc_index];
	tfQuestion.text =  cBean.question;
//    tfQuestionInAnswerView.text = cBean.question;
//	lbChapter.text = [NSString stringWithFormat:@"%d of %d", _fc_index+1, [arrayCards count]];
    
    _lbCurrentIndex.text = [NSString stringWithFormat:@"%d",_fc_index+1];
    _lbTotalCount.text = [NSString stringWithFormat:@"%d",[arrayCards count]];
   

	//tfAnswer.text = cBean.answer;
}


#pragma mark -
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
   
    if (alertView.tag == alert_tag_end_flashcard) { // End of flashcards, would you like to review them again?
        if (buttonIndex == 0) {// no
            [self.navigationController popViewControllerAnimated:YES];
            return;
        } else {
            
            _fc_index = -1;
            _fc_index++;
            
            [self updateCard];
            
            switch (_card_page_index) {
                case 0:
                    _theRightView.center = CGPointMake(kRightCenterX,kCenterPointY_4 );
                    break;
                case 1:
                    _theLeftView.center = CGPointMake(kRightCenterX, kCenterPointY_4);
                    break;
                case 2:
                    _superView.center = CGPointMake(kRightCenterX, kCenterPointY_4);
                    break;
            }
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.6];
            
            switch (_card_page_index) {
                case 0:
                    _theRightView.center = CGPointMake(kCenterPointX_4, kCenterPointY_4);
                    [self.view bringSubviewToFront:_theRightView];
                    _card_page_index = 1;
                    break;
                case 1:
                    _theLeftView.center = CGPointMake(kCenterPointX_4, kCenterPointY_4);
                    //            _theLeftView.frame = CGRectMake(0, 142, 768, 818);
                    //                    NSLog(@"_theLeftView.frame (end) = %@",NSStringFromCGRect(_theLeftView.frame));
                    [self.view bringSubviewToFront:_theLeftView];
                    _card_page_index = 2;
                    break;
                case 2:
                    _superView.center = CGPointMake(kCenterPointX_4, kCenterPointY_4);
                    //            _superView.frame = CGRectMake(0, 142, 768, 818);
                    //                    NSLog(@"_superView.frame (end) = %@",NSStringFromCGRect(_superView.frame));
                    [self.view bringSubviewToFront:_superView];
                    _card_page_index = 0;
                    break;
            }
            [self updateArrow];
            [UIView commitAnimations];
            return;
        }
    } else if (alertView.tag == alert_tag_back)
    {
        [self.activityView startAnimating];
        self.navigationController.navigationBar.userInteractionEnabled = NO;
        self.view.userInteractionEnabled = NO;
        [self.view bringSubviewToFront:self.activityView];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            if (alertView.tag == alert_tag_back) {
                if (buttonIndex==0) {
                    //Save score
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
            }
        });
    }
    
    
//    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    //    [textView resignFirstResponder];
    return NO;
}
@end
