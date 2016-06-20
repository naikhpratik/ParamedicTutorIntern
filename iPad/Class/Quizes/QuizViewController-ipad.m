//
//  QuizViewController-ipad.m
//  Quiz
//
//  Created by Arthur on 13-9-10.
//
//


#import <QuartzCore/QuartzCore.h>
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>

#import "QuizViewController-ipad.h"
#import "QuizAppDelegate.h"
#import "QuizBean.h"
#import "StringHelper.h"
#import "SqlMB.h"
#import "DEFacebookComposeViewController.h"
#import "UIDevice+DEFacebookComposeViewController.h"
#import "CustomCellQuiz.h"

#define kTextViewBoldFontSize		16.0
#define kTextViewFontSize		16.0
#define kTextViewWidth		340.0

#define kAlertTag_completeTest 100
#define kAlertTag_backToMain 200
#define kAlertViewTagOther 300

@interface QuizViewController_ipad ()

@end

@implementation QuizViewController_ipad {
    BOOL isNOTFistTest;  // mark the quiz if the first time or not.
}
@synthesize iChapter, sChapter, mode, bookquizID;
@synthesize hasPreviousData;


int randomSort1(id obj1, id obj2, void *context ) {
	// returns random number -1 0 1
	return (arc4random()%3 - 1);
}

- (void)shuffle:(NSInteger) ins {
	//int i=0;
	// call custom sort function
	switch (ins) {
		case 0:
			[arrayQuiz sortUsingFunction:randomSort1 context:nil];
			break;
		case 1:
		{
			QuizBean *qBean = [arrayQuiz objectAtIndex:_currentIndex];
			correctAns = [qBean.answers objectAtIndex:0];
			//NSLog(@"correct= %@", correctAns);
			[qBean.answers sortUsingFunction:randomSort1 context:nil];
		}
			break;
	}
}



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
//    _tfCorrect.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *_leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
	self.navigationItem.leftBarButtonItem = _leftBarButtonItem;
	[_leftBarButtonItem release];
    
    arrayQuiz = [[NSMutableArray alloc] init];
	quizOri = [[NSMutableDictionary alloc] init];
    
    // A, B, C, D, E images.
    mArr_alphabet = [[NSMutableArray alloc]initWithObjects:
                     @"quiz_A_grey_iPad",
                     @"quiz_B_grey_iPad",
                     @"quiz_C_grey_iPad",
                     @"quiz_D_grey_iPad",
                     @"quiz_E_grey_iPad", nil];
    
    _tbView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tfCorrect.delegate = self;
    _tfQuestion.delegate = self;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    isNOTFistTest = [defaults boolForKey:@"NOT_FIRST_TEST"];
	b_Return = NO;
	_lbChapter.text = sChapter;
    self.navigationItem.title = [NSString stringWithFormat:@"Quizzes: %@",sChapter];
	iCorrectNum = 0;
	iAlldoneNum = 0;
	_currentIndex = 0;
    //	[self getQuizfromDB];
    if (self.hasPreviousData) {
        _overlayView.alpha = 0;
//        [[SqlMB getInstance] getProcessFromQiz:arrayQuiz OriQuiz:quizOri chapter:iChapter];
        NSMutableDictionary *valueDic = [[NSMutableDictionary alloc] initWithCapacity:10];
        [[SqlMB getInstance] getLastProcessForQuiz:arrayQuiz OriQuiz:quizOri chapter:iChapter QuizStatus:valueDic];
//        [[SqlMB getInstance] getLastStatusIDFromQiz:iChapter Data:valueDic];
        iCorrectNum = [[valueDic objectForKey:SAVEQIZ_RIGHTCOUNT] intValue];
        iAlldoneNum = [[valueDic objectForKey:SAVEQIZ_DONECOUNT] intValue];
        _currentIndex = [[valueDic objectForKey:INDEXQIZ_LAST] intValue];
         b_FirstTouch = [[valueDic objectForKey:FIRSTTOUCH_LAST] boolValue];
    } else {
        [[SqlMB getInstance] getQizFromDB:arrayQuiz OriQuiz:quizOri chapter:iChapter mode:mode];
        _overlayView.alpha = 0;
        //[self shuffle:0];
        [arrayQuiz shuffled];
        b_FirstTouch = YES;

    }
    
    if (mode == 1) {   //Bookmark mode, find the quiz ID and start from that
        if (self.fromComprehensive == YES) {
            _currentIndex = 0;
        }
        else{
            for (int i=0; i<[arrayQuiz count]; i++) {
                QuizBean *tempQuiz = [arrayQuiz objectAtIndex:i];
                if (bookquizID == tempQuiz.quizID) {
                    _currentIndex = i;
                    NSLog(@"find!");
                    break;
                }
            }
        }
    }
    [self initQiz];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_lbChapter release];
    [_tfCorrect release];
    [_label_score release];
    [_btBookimg release];
    [_btBook release];
    [_activityView release];
    [_lbIndex release];
    [_lbTotalCount release];
    [_tfQuestion release];
    [_tbView release];
    [_overlayView release];
    [mArr_alphabet release];
    [_lbIndexCount release];
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLbChapter:nil];
    [self setTfCorrect:nil];
    [self setLabel_score:nil];
    [self setBtBookimg:nil];
    [self setBtBook:nil];
    [self setActivityView:nil];
    [self setLbIndex:nil];
    [self setLbTotalCount:nil];
    [self setTfQuestion:nil];
    [self setTbView:nil];
    [self setOverlayView:nil];
    [self setLbIndexCount:nil];
    [self setTfQuestion:nil];
    [super viewDidUnload];
}


//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:YES];
//    
//}
#pragma mark - quiz method

-(void)initQiz
{
    
	
	QuizBean *qBean = [arrayQuiz objectAtIndex:_currentIndex];
    //	if ([qBean.answers count] != segControl.numberOfSegments) {
    //		[segControl removeAllSegments];
    //		for (int i=0; i<[qBean.answers count]; i++) {
    //			[segControl insertSegmentWithTitle:[arrayNums objectAtIndex:i] atIndex:i animated:NO];
    //		}
    //	}
    
	correctAns = @"";
	//[self shuffle:1];
	correctAns = [quizOri objectForKey:[NSString stringWithFormat:@"%d", qBean.quizID]];
    _tfQuestion.text = qBean.question;
    _lbIndex.text = [NSString stringWithFormat:@"%d.",_currentIndex + 1];
    
    _lbTotalCount.text = [NSString stringWithFormat:@"%d",[arrayQuiz count]];
    if (mode == 0) {
        if (iAlldoneNum ==0) {
            // 90%
            _label_score.text = [NSString stringWithFormat:@"%d%%", 0];
            // 15 / 20
            _lbIndexCount.text = [NSString stringWithFormat:@"%d/%d", iCorrectNum, iAlldoneNum];
        } else {
            _label_score.text = [NSString stringWithFormat:@"%d%%", iCorrectNum* 100/iAlldoneNum];
            _lbIndexCount.text = [NSString stringWithFormat:@"%d/%d",iCorrectNum, iAlldoneNum];
        }
    } else {
        _label_score.text = @"";
        _lbIndexCount.text = [NSString stringWithFormat:@"%d/%d", _currentIndex+1, [arrayQuiz count]];
    }
    
    
	//correctAns = [qBean.answers objectAtIndex:0];
	//NSLog(@"correct= %@", correctAns);
	[qBean.answers shuffled];
}


-(void)judge: (int)answer {
    QuizBean *qBean = [arrayQuiz objectAtIndex:_currentIndex];
	NSString *clickAnswer = [qBean.answers objectAtIndex:answer];
    NSString *tempStrAnswer = @"";
    
    NSIndexPath *inPath = [NSIndexPath indexPathForRow:answer inSection:0];
    CustomCellQuiz *tbCell = (CustomCellQuiz *)[_tbView cellForRowAtIndexPath:inPath];
    
    if ([clickAnswer isEqualToString:correctAns]) {  // This answer is right
		_overlayView.alpha = 1;
//        self.navigationController.navigationBar.userInteractionEnabled = NO;
        NSString *alphabet = @"";
        
        switch (answer) {
            case 0:
                alphabet = @"A";
                tempStrAnswer = @"quiz_A_green_iPad";
                break;
            case 1:
                alphabet = @"B";
                tempStrAnswer = @"quiz_B_green_iPad";
                break;
            case 2:
                alphabet = @"C";
                tempStrAnswer = @"quiz_C_green_iPad";
                break;
            case 3:
                alphabet = @"D";
                tempStrAnswer = @"quiz_D_green_iPad";
                break;
            case 4:
                alphabet = @"E";
                tempStrAnswer = @"quiz_E_green_iPad";
                break;
            default:
                break;
        }
        
		_tfCorrect.text = [NSString stringWithFormat:@"%@. %@", alphabet, qBean.explanation];
		if (b_FirstTouch) {
			iAlldoneNum++;
			iCorrectNum++;
			b_FirstTouch = NO;
		}
		if (qBean.b_bookmark) {
			[_btBook setTitle:@"Bookmarked!" forState:UIControlStateNormal];
			[_btBook setTitle:@"Bookmarked!" forState:UIControlStateHighlighted];
			[_btBook setTitle:@"Bookmarked!" forState:UIControlStateDisabled];
			[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad_bookmarked.png"] forState:UIControlStateNormal];
			[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad_bookmarked.png"] forState:UIControlStateHighlighted];
			[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad_bookmarked.png"] forState:UIControlStateDisabled];
		}else {
			[_btBook setTitle:@"Add to Bookmarks" forState:UIControlStateNormal];
			[_btBook setTitle:@"Add to Bookmarks" forState:UIControlStateHighlighted];
			[_btBook setTitle:@"Add to Bookmarks" forState:UIControlStateDisabled];
			[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad.png"] forState:UIControlStateNormal];
			[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad.png"] forState:UIControlStateHighlighted];
			[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad.png"] forState:UIControlStateDisabled];
		}
        
	}else {  // wrong
        
		if (b_FirstTouch) {
			iAlldoneNum++;
			b_FirstTouch = NO;
		}
	    
        switch (answer) {
            case 0:
                tempStrAnswer = @"quiz_A_red_iPad";
                break;
            case 1:
                tempStrAnswer = @"quiz_B_red_iPad";
                break;
            case 2:
                tempStrAnswer = @"quiz_C_red_iPad";
                break;
            case 3:
                tempStrAnswer = @"quiz_D_red_iPad";
                break;
            case 4:
                tempStrAnswer = @"quiz_E_red_iPad";
                break;
            default:
                break;
        }
        
        

	}
    // the answer image was been changed.
    tbCell.img_answer_.image = [UIImage imageNamed:tempStrAnswer];
}

//- (void)answersTap {
//
//}

# pragma mark - IBAction

- (IBAction)bookQuestion:(id)sender {
    QuizBean *qBean = [arrayQuiz objectAtIndex:_currentIndex];
	if (qBean.b_bookmark) {  //unbook
		[_btBook setTitle:@"Add to Bookmarks" forState:UIControlStateNormal];
		[_btBook setTitle:@"Add to Bookmarks" forState:UIControlStateHighlighted];
		[_btBook setTitle:@"Add to Bookmarks" forState:UIControlStateDisabled];
		[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad.png"] forState:UIControlStateNormal];
		[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad.png"] forState:UIControlStateHighlighted];
		[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad.png"] forState:UIControlStateDisabled];
        [[SqlMB getInstance] bookmarkQiz:qBean.quizID BookMark:NO];
        qBean.b_bookmark = 0;
	}
    else {   //book it
		[_btBook setTitle:@"Bookmarked!" forState:UIControlStateNormal];
		[_btBook setTitle:@"Bookmarked!" forState:UIControlStateHighlighted];
		[_btBook setTitle:@"Bookmarked!" forState:UIControlStateDisabled];
		[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad_bookmarked.png"] forState:UIControlStateNormal];
		[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad_bookmarked.png"] forState:UIControlStateHighlighted];
		[_btBookimg setImage:[UIImage imageNamed:@"heart_iPad_bookmarked.png"] forState:UIControlStateDisabled];
		[[SqlMB getInstance] bookmarkQiz:qBean.quizID BookMark:YES];
        qBean.b_bookmark = 1;
        
	}
}

- (IBAction)returnQuestion:(id)sender {
    
    self.navigationController.navigationBar.userInteractionEnabled = YES;
	if (_currentIndex+1 == [arrayQuiz count]) {
		if (mode == 0) {
			b_Return = NO;
			NSString *Message = @"Do you want to save your score?";
			UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Quit Quiz" message:Message delegate:self cancelButtonTitle:@"Save Score" otherButtonTitles:@"Don't Save Score", nil];
			[alert show];
			[alert release];
            
		}
	}
	
	[_tbView reloadData];
    [self initQiz];
	_overlayView.alpha = 0;
    
}

- (IBAction)nextQuestion:(id)sender {
    
    self.navigationController.navigationBar.userInteractionEnabled = YES;
	if (_currentIndex+1 == [arrayQuiz count]) {
		if (mode == 0) {
			b_Return = YES;
			NSString *Message = @"Do you want to save your score?";
			UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Quit Quiz" message:Message delegate:self cancelButtonTitle:@"Save Score" otherButtonTitles:@"Don't Save Score", nil];
            
            alert.tag = kAlertTag_completeTest;
			[alert show];
			[alert release];
           
			return;
		}else {
			_currentIndex = -1;
		}
	}
	_currentIndex++;
	b_FirstTouch = YES;
    
    [self initQiz];
	[_tbView reloadData];
	_overlayView.alpha = 0;
}

-(IBAction)back: (id)sender
{
    if (_overlayView.alpha == 1) {
        // if the Correct View was show, CorrectNUm and AlldoneNum must been tally down
        iCorrectNum --;
        iAlldoneNum --;
    }
	if (mode == 0) {
		b_Return = YES;
		NSString *Message = @"Do you want to save this test to continue at a later time?";//@"Do you want to quit and save your score?";
		UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Quit Quiz" message:Message delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        alert.tag = kAlertTag_backToMain;
		[alert show];
		[alert release];
	}else {
		[self.navigationController popViewControllerAnimated:YES];
	}
}


#pragma mark UITableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    QuizBean *quizBean = [arrayQuiz objectAtIndex:_currentIndex];
    return [quizBean.answers count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QuizBean *quizBean = [arrayQuiz objectAtIndex:_currentIndex];
    CustomCellQuiz *cell = (CustomCellQuiz *)[tableView dequeueReusableCellWithIdentifier:@"answerCell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellQuiz" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.img_answer_.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[mArr_alphabet objectAtIndex:indexPath.row]]];
    cell.tfAnswer.text = [quizBean.answers objectAtIndex:indexPath.row];
    //    [cell.btn_answer addTarget:self action:@selector(answersTap) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    
    
    //cell.backgroundColor = [UIColor yellowColor];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    QuizBean *quizBean = [arrayQuiz objectAtIndex:_currentIndex];
    NSString *headers = [quizBean.answers objectAtIndex:indexPath.row];
    CGFloat height = [headers RAD_textHeightForSystemFontOfSize:kTextViewFontSize width:kTextViewWidth] + 40.0;
    NSLog(@"row=%d, height=%f", indexPath.row, height);
    return height;
    
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //	if (indexPath.row >= 2) {
    [self judge:(indexPath.row)];
    //	}
}

#pragma mark UIAlertView methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAlertTag_completeTest) {
        if (buttonIndex == 0) {  // save
            [[SqlMB getInstance] saveScore:sChapter CorrectNum:iCorrectNum AllDoneNum:iAlldoneNum];
        } else {
            
        }
        
//        if (!isNOTFistTest) { //  After the first completed exam, we'd like the pop-up to show, share FB & Twitter.
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:@"NOT_FIRST_TEST"];
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Like our app, tell your friends about us" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Post to Facebook",@"Post to Twitter",@"Cancel", nil];
            [actionSheet showInView:self.view];
            [actionSheet release];
            return;
//        }
        
        if (b_Return) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    } else if (alertView.tag == kAlertTag_backToMain){
        [self.view bringSubviewToFront:self.activityView];
        self.navigationController.navigationBar.userInteractionEnabled = NO;
        self.view.userInteractionEnabled = NO;
        [self.activityView startAnimating];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            if (buttonIndex==0) {
                //Save score
                //        [[SqlMB getInstance] setProcessForCards:arrayQuiz Process:_currentIndex Chapter:iChapter];
                NSString *sequenceStr = @"";
                NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:10];
                for (int i = 0 ; i< [arrayQuiz count]; i++) {
                    QuizBean *bean = [arrayQuiz objectAtIndex:i];
                    [tempArr addObject:[NSString stringWithFormat:@"%d",bean.quizID]];
                }
                sequenceStr = [tempArr componentsJoinedByString:@","];
                [[SqlMB getInstance] saveProcessForQuiz:iChapter Sequence:sequenceStr CorrectNum:iCorrectNum DoneNum:iAlldoneNum isFirstTouch:b_FirstTouch isFinished:b_Return ChapterName:sChapter CurrentIndex:_currentIndex];
                [[SqlMB getInstance] saveScore:sChapter CorrectNum:iCorrectNum AllDoneNum:iAlldoneNum];

                //		[self saveScore];
            } else {
                [[SqlMB getInstance] clearProcessForQuiz:iChapter];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activityView stopAnimating];
                self.view.userInteractionEnabled = YES;
                self.navigationController.navigationBar.userInteractionEnabled = YES;
                if (b_Return) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            });
        });
    }
    else if (alertView.tag == kAlertViewTagOther) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
	
	
	//if ([alertView.message isEqualToString:@"Do you want to quit and save your score?"]) {
    //	    [self.navigationController popViewControllerAnimated:YES];
    //	}else {
    //		if (buttonIndex==0) {
    //			overlayView.alpha = 0;
    //		}else {
    //			[self.navigationController popViewControllerAnimated:YES];
    //		}
    //
    //	}
}


#pragma mark - share methods
- (void)shareToFacebook {
//    NSLog(@"share to fb");
//    
//    DEFacebookComposeViewController *facebookComposer = [[DEFacebookComposeViewController alloc]init];
//    self.modalPresentationStyle = UIModalPresentationCurrentContext;
//    NSString *htmlContent = [self getShareBody];
//    
//    [facebookComposer setInitialText:htmlContent];
//    [facebookComposer addURL:[NSURL URLWithString:kUrlForSharing]];
//    [facebookComposer setCompletionHandler: ^(DEFacebookComposeViewControllerResult result){
//        
//        switch (result) {
//            case DEFacebookComposeViewControllerResultCancelled:
//                
//                break;
//                
//            case DEFacebookComposeViewControllerResultDone:
//                break;
//                
//            default:
//                break;
//        }
//        //        [self dismissModalViewControllerAnimated:YES];
//        [self dismissViewControllerAnimated:YES completion:nil];
//        if (b_Return) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//
//    }];
//    
//    if ([UIDevice de_isIOS4]) {
//        [self presentModalViewController:facebookComposer animated:YES];
//    } else {
//        [self presentViewController:facebookComposer animated:YES completion:^{ }];
//    }
//    [facebookComposer release];
    NSString *htmlContent = [self getShareBody];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<6.0f) {
        NSString *sURL = @"http://www.facebook.com/pages/Code-3-Apps/180948875248863";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: sURL]];
    }else{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        NSLog(@"1");
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [mySLComposerSheet setInitialText:htmlContent];
        
         [mySLComposerSheet addImage:[UIImage imageNamed:@"share_img.png"]];
        
        [mySLComposerSheet addURL:[NSURL URLWithString:kUrlForSharing]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
            if (b_Return) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    } else {
        NSLog(@"2");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Facebook Account" message:@"There are no Facebook accounts configured. You can add or create a Facebook account in Settings. " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        alert.tag = kAlertViewTagOther;
        [alert release];
    }}
}

- (void)shareToTwitter {
    NSLog(@"share to twitter");
    NSString *htmlContent = [self getShareBody];
    
    if (![htmlContent isEqualToString:@""]) { //no content to share
        TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
        [tweetViewController setInitialText:htmlContent];
        [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
            NSString *output;
            
            switch (result) {
                case TWTweetComposeViewControllerResultCancelled:
                    // The cancel button was tapped.
                    output = @"Tweet cancelled.";
                    break;
                case TWTweetComposeViewControllerResultDone:
                    // The tweet was sent.
                    output = @"Tweet done.";
                    break;
                default:
                    break;
            }
            //[activityIndicator startAnimating];
            //self.navigationController.view.userInteractionEnabled = YES;
            //            if ([output isEqualToString:@"Tweet done."]) {
            //                [self performSelectorOnMainThread:@selector(shareTwitterAction) withObject:output waitUntilDone:NO];
            //            }
            
            // Dismiss the tweet composition view controller.
            [self dismissModalViewControllerAnimated:YES];
            if (b_Return) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
        [tweetViewController addURL:[NSURL URLWithString:kUrlForSharing]];
        [self presentModalViewController:tweetViewController animated:YES];
        [tweetViewController release];
    }
    
    
}


- (NSString *)getShareBody {
    
    
    NSString *shareBody = [NSString stringWithFormat:@"Great app, study for your Nationally Registered Paramedic. Check it out."];
    
    return shareBody;
    
}


#pragma mark - UITextView delegate


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    //    [textView resignFirstResponder];
    return NO;
}


#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // buttonIndex
    // 0 facebook
    // 1 twitter
    // 2 cancel
    
    if (buttonIndex == 0) {
        
        [self shareToFacebook];
        
    } else if (buttonIndex == 1) {
        
        [self shareToTwitter];
        
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Oberver


//  keep the answer center in the vertical direction
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *tv = object;
    //Center vertical alignment
    //CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    //topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    //tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    //Bottom vertical alignment
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height - 17);
    topCorrect = (topCorrect <0.0 ? 0.0 : topCorrect);
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

@end
