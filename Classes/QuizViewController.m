//
//  QuizViewController.m
//  Quiz
//
//  Created by Zorro on 2/15/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>

#import "QuizViewController.h"
#import "QuizAppDelegate.h"
#import "QuizBean.h"
#import "StringHelper.h"
#import "SqlMB.h"
#import "DEFacebookComposeViewController.h"
#import "UIDevice+DEFacebookComposeViewController.h"

#define kTextViewBoldFontSize		16.0
#define kTextViewFontSize		14.0
#define kTextViewWidth		250.0

#define kAlertTag_completeTest 100
#define kAlertTag_backToMain 200

@implementation QuizViewController {
    
    BOOL isNOTFistTest;  // mark the quiz if the first time or not.
}

@synthesize iChapter, sChapter, mode, bookquizID;
@synthesize hasPreviousData;
@synthesize tv_quizContent = _tv_quizContent;
@synthesize lbl_QuizChapter = _lbl_QuizChapter;
@synthesize lbl_QuizIndex = _lbl_QuizIndex;
@synthesize lbl_QuizPercent = _lbl_QuizPercent;
@synthesize lbl_QuizProcess = _lbl_QuizProcess;
@synthesize lbl_QuizTotal = _lbl_QuizTotal;
@synthesize imgView_QuizBg = _imgView_QuizBg;
@synthesize fromComprehensive;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

int randomSort(id obj1, id obj2, void *context ) {
	// returns random number -1 0 1
	return (arc4random()%3 - 1);
}

- (void)shuffle:(NSInteger) ins {
	//int i=0;
	// call custom sort function
	switch (ins) {
		case 0:
			[arrayQuiz sortUsingFunction:randomSort context:nil];
			break;
		case 1:
		{
			QuizBean *qBean = [arrayQuiz objectAtIndex:_currentIndex];
			correctAns = [qBean.answers objectAtIndex:0];
			//NSLog(@"correct= %@", correctAns);
			[qBean.answers sortUsingFunction:randomSort context:nil];
		}
			break;
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
	tfCorrect.backgroundColor = [UIColor clearColor];
	UIBarButtonItem *_leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
	self.navigationItem.leftBarButtonItem = _leftBarButtonItem;
	[_leftBarButtonItem release];
	
	self.navigationItem.title = @"Quizzes";
	arrayQuiz = [[NSMutableArray alloc] init];
//    arrCorrectNums = [[NSMutableArray alloc] init];
//    arrWrongNums = [[NSMutableArray alloc] init];
	quizOri = [[NSMutableDictionary alloc] init];
//	arrayNums = [[NSMutableArray alloc] initWithObjects: @"A", @"B", @"C", @"D", @"E", nil];
    
    arrayNums = [[NSMutableArray alloc] initWithObjects:@"quizA_grey_n",@"quizB_grey_n",@"quizC_grey_n",@"quizD_grey_n",@"quizE_grey_n", nil];
    arrCorrectNums = [[NSMutableArray alloc] initWithObjects:@"quizA_green_n",@"quizB_green_n",@"quizC_green_n",@"quizD_green_n",@"quizE_green_n", nil];
    arrWrongNums = [[NSMutableArray alloc] initWithObjects:@"quizA_red_n",@"quizB_red_n",@"quizC_red_n",@"quizD_red_n",@"quizE_red_n", nil];
    
    
    //Scrollbar for question textview shows always
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(flashIndicator) userInfo:nil repeats:YES]; // set time interval as per your requirement.
    
}

//Scrollbar for question text shows always
- (void) flashIndicator{
    [self.tv_quizContent flashScrollIndicators];
}


-(void)initQiz
{
	QuizBean *qBean = [arrayQuiz objectAtIndex:_currentIndex];
	if ([qBean.answers count] != segControl.numberOfSegments) {
		[segControl removeAllSegments];
		for (int i=0; i<[qBean.answers count]; i++) {
			[segControl insertSegmentWithTitle:[arrayNums objectAtIndex:i] atIndex:i animated:NO];
		}
	}
    self.lbl_QuizChapter.text = sChapter;
    self.lbl_QuizIndex.text = [NSString stringWithFormat:@"%d.",_currentIndex+1];
    self.lbl_QuizTotal.text = [NSString stringWithFormat:@"of %d",[arrayQuiz count]];
    
    
    
    self.tv_quizContent.text = qBean.question;
    
    // set content offset for text starting from top
    [self.tv_quizContent setContentOffset:CGPointZero animated:NO];
    
	correctAns = @"";
	//[self shuffle:1];
	correctAns = [quizOri objectForKey:[NSString stringWithFormat:@"%d", qBean.quizID]];
    
	//correctAns = [qBean.answers objectAtIndex:0];
	//NSLog(@"correct= %@", correctAns);
    
    if (mode == 0) {
        if (iAlldoneNum == 0) {
            self.lbl_QuizProcess.text = [NSString stringWithFormat:@"%d/%d",iCorrectNum, iAlldoneNum];
            self.lbl_QuizPercent.text = [NSString stringWithFormat:@"%d%%",0];
        } else {
            self.lbl_QuizProcess.text = [NSString stringWithFormat:@"%d/%d",iCorrectNum, iAlldoneNum];
            self.lbl_QuizPercent.text = [NSString stringWithFormat:@"%d%%",iCorrectNum*100/iAlldoneNum];
        }
    } else {
        self.lbl_QuizProcess.text = [NSString stringWithFormat:@""];
        self.lbl_QuizPercent.text = [NSString stringWithFormat:@""];
    }
    
	[qBean.answers shuffled];
}

-(void) viewWillAppear:(BOOL)animated
{
    if (iPhone5) {
        self.imgView_QuizBg.image = [UIImage imageNamed:@"quizquestion_bgn4"];
    } else {
        self.imgView_QuizBg.image = [UIImage imageNamed:@"quizquestion_bgn5"];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    isNOTFistTest = [defaults boolForKey:@"IS_FIRST_TEST"];
	b_Return = NO;
	lbChapter.text = sChapter;
//	self.fromComprehensive = NO;
	iCorrectNum = 0;
	iAlldoneNum = 0;
	_currentIndex = 0;
    //	[self getQuizfromDB];
    if (self.hasPreviousData) {
        overlayView.alpha = 0;
        NSMutableDictionary *valueDic = [[NSMutableDictionary alloc] initWithCapacity:10];
        [[SqlMB getInstance] getLastProcessForQuiz:arrayQuiz OriQuiz:quizOri chapter:iChapter QuizStatus:valueDic];
//        [[SqlMB getInstance] getProcessFromQiz:arrayQuiz OriQuiz:quizOri chapter:iChapter];
//        [[SqlMB getInstance] getLastStatusIDFromQiz:iChapter Data:valueDic];
        
        iCorrectNum = [[valueDic objectForKey:SAVEQIZ_RIGHTCOUNT] intValue];
        iAlldoneNum = [[valueDic objectForKey:SAVEQIZ_DONECOUNT] intValue];
        _currentIndex = [[valueDic objectForKey:INDEXQIZ_LAST] intValue];
        b_FirstTouch = [[valueDic objectForKey:FIRSTTOUCH_LAST] boolValue];
    } else {
        [[SqlMB getInstance] getQizFromDB:arrayQuiz OriQuiz:quizOri chapter:iChapter mode:mode];
        overlayView.alpha = 0;
        //[self shuffle:0];
        [arrayQuiz shuffled];
        b_FirstTouch = YES;
    }
    
	if (mode == 1) {   //Bookmark mode, find the quiz ID and start from that
        if (self.fromComprehensive == YES) {
            _currentIndex = 0;
        } else {
            for (int i=0; i<[arrayQuiz count]; i++) {
                QuizBean *tempQuiz = [arrayQuiz objectAtIndex:i];
                if (bookquizID == tempQuiz.quizID) {
                    _currentIndex = i;
                    NSLog(@"find!");
                    break;
                }
            }
            NSLog(@"the quiz id %d",_currentIndex);
        }
	}
    
    [self initQiz];}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

-(IBAction)back: (id)sender
{
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

-(IBAction)chooseAnswer: (id)sender
{
	//NSLog(@"sel=%d", [segControl selectedSegmentIndex]);
	[self judge:[segControl selectedSegmentIndex]];
}

-(void)judge: (int)answer
{
	QuizBean *qBean = [arrayQuiz objectAtIndex:_currentIndex];
	NSString *clickAnswer = [qBean.answers objectAtIndex:answer];
    NSString *imgStr = @"";
	if ([clickAnswer isEqualToString:correctAns]) {
		overlayView.alpha = 1;
        self.navigationController.navigationBar.userInteractionEnabled = NO;
        NSString *indexStr = @"";
        switch (answer) {
            case 0:
                indexStr = @"A";
                break;
            case 1:
                indexStr = @"B";
                break;
            case 2:
                indexStr = @"C";
                break;
            case 3:
                indexStr = @"D";
                break;
            case 4:
                indexStr = @"E";
                break;
            default:
                break;
        }
		tfCorrect.text = [NSString stringWithFormat:@"%@. %@", indexStr, qBean.explanation];
		if (b_FirstTouch) {
			iAlldoneNum++;
			iCorrectNum++;
			b_FirstTouch = NO;
		}
		if (qBean.b_bookmark) {
			[btBook setTitle:@"Bookmarked!" forState:UIControlStateNormal];
			[btBook setTitle:@"Bookmarked!" forState:UIControlStateHighlighted];
			[btBook setTitle:@"Bookmarked!" forState:UIControlStateDisabled];
			[btBookimg setImage:[UIImage imageNamed:@"heart_marked_n.png"] forState:UIControlStateNormal];
			[btBookimg setImage:[UIImage imageNamed:@"heart_marked_n.png"] forState:UIControlStateHighlighted];
			[btBookimg setImage:[UIImage imageNamed:@"heart_marked_n.png"] forState:UIControlStateDisabled];
		}else {
			[btBook setTitle:@"Add to Bookmarks" forState:UIControlStateNormal];
			[btBook setTitle:@"Add to Bookmarks" forState:UIControlStateHighlighted];
			[btBook setTitle:@"Add to Bookmarks" forState:UIControlStateDisabled];
			[btBookimg setImage:[UIImage imageNamed:@"heart_n.png"] forState:UIControlStateNormal];
			[btBookimg setImage:[UIImage imageNamed:@"heart_n.png"] forState:UIControlStateHighlighted];
			[btBookimg setImage:[UIImage imageNamed:@"heart_n.png"] forState:UIControlStateDisabled];
		}
        imgStr = [arrCorrectNums objectAtIndex:answer];
	}else {
		if (b_FirstTouch) {
			iAlldoneNum++;
			b_FirstTouch = NO;
		}
        imgStr = [arrWrongNums objectAtIndex:answer];
	}
    NSIndexPath *inPath = [NSIndexPath indexPathForRow:(answer) inSection:0];
    UITableViewCell *tbCell = [tbView cellForRowAtIndexPath:inPath];
    UIImageView *imgView = (UIImageView*)[tbCell viewWithTag:answer+1];
    imgView.image = [UIImage imageNamed:imgStr];
}

-(IBAction)bookQuestion: (id)sender
{
	QuizBean *qBean = [arrayQuiz objectAtIndex:_currentIndex];
	QuizAppDelegate *appDelegate = (QuizAppDelegate*)[[UIApplication sharedApplication] delegate];

	
	if (qBean.b_bookmark) {  //unbook
		[btBook setTitle:@"Add to Bookmarks" forState:UIControlStateNormal];
		[btBook setTitle:@"Add to Bookmarks" forState:UIControlStateHighlighted];
		[btBook setTitle:@"Add to Bookmarks" forState:UIControlStateDisabled];
		[btBookimg setImage:[UIImage imageNamed:@"heart_n.png"] forState:UIControlStateNormal];
		[btBookimg setImage:[UIImage imageNamed:@"heart_n.png"] forState:UIControlStateHighlighted];
		[btBookimg setImage:[UIImage imageNamed:@"heart_n.png"] forState:UIControlStateDisabled];
        [[SqlMB getInstance] bookmarkQiz:qBean.quizID BookMark:NO];
        qBean.b_bookmark = 0;
	}else {   //book it
		[btBook setTitle:@"Bookmarked!" forState:UIControlStateNormal];
		[btBook setTitle:@"Bookmarked!" forState:UIControlStateHighlighted];
		[btBook setTitle:@"Bookmarked!" forState:UIControlStateDisabled];
		[btBookimg setImage:[UIImage imageNamed:@"heart_marked_n.png"] forState:UIControlStateNormal];
		[btBookimg setImage:[UIImage imageNamed:@"heart_marked_n.png"] forState:UIControlStateHighlighted];
		[btBookimg setImage:[UIImage imageNamed:@"heart_marked_n.png"] forState:UIControlStateDisabled];
		[[SqlMB getInstance] bookmarkQiz:qBean.quizID BookMark:YES];
        qBean.b_bookmark = 1;
	}
}

-(IBAction)returnQuestion: (id)sender
{
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
	
	[tbView reloadData];
	overlayView.alpha = 0;
}

-(IBAction)nextQuestion: (id)sender
{
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
	[tbView reloadData];
	overlayView.alpha = 0;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [self setQuiz_header_imageView:nil];
    [self setActivityView:nil];
    [self setTv_quizContent:nil];
    [self setLbl_QuizChapter:nil];
    [self setLbl_QuizProcess:nil];
    [self setLbl_QuizPercent:nil];
    [self setLbl_QuizIndex:nil];
    [self setLbl_QuizTotal:nil];
    [self setImgView_QuizBg:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[quizOri release];
	[arrayNums release];
	[arrayQuiz release];
	[segControl release];
	[tbView release];
	[overlayView release];
	[tfCorrect release];
	[btNext release];
    [_quiz_header_imageView release];
    [_activityView release];
    [_tv_quizContent release];
    [_lbl_QuizChapter release];
    [_lbl_QuizProcess release];
    [_lbl_QuizPercent release];
    [_lbl_QuizIndex release];
    [_lbl_QuizTotal release];
    [_imgView_QuizBg release];
    [super dealloc];
}



#pragma mark UITableView methods

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self judge:indexPath.row];
}

-(UITableViewCell *) tableView:(UITableView *) tv cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
    
    QuizBean *quizBean = [arrayQuiz objectAtIndex:_currentIndex];
    CGFloat height = [[quizBean.answers objectAtIndex:indexPath.row] RAD_textHeightForSystemFontOfSize:kTextViewFontSize width:kTextViewWidth];
 
    if (height < 25.0f) {
        height = 25.0f;
    }
    UILabel *lbAnswer = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, kTextViewWidth, height+20.0f)];
    lbAnswer.text = [quizBean.answers objectAtIndex:indexPath.row];
    lbAnswer.numberOfLines = 0;
    lbAnswer.font = [UIFont systemFontOfSize:14.0];
    lbAnswer.textColor = [UIColor grayColor];
//    lbAnswer.editable = NO;
    lbAnswer.userInteractionEnabled = NO;
    lbAnswer.backgroundColor = [UIColor clearColor];
    [cell addSubview:lbAnswer];
    
		
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[arrayNums objectAtIndex:indexPath.row]]];
    imgView.frame = CGRectMake(5.0f, 0.0f, 25.0f, 25.0f);
    
    imgView.center = CGPointMake(imgView.center.x, lbAnswer.center.y);
    imgView.tag = indexPath.row + 1;
    [cell addSubview:imgView];
    
    [lbAnswer release];
    [imgView release];
    
//    UILabel *lbIndex = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 30, 21)];
//    lbIndex.text = [NSString stringWithFormat:@"%@.", [arrayNums objectAtIndex:indexPath.row]];
//    lbIndex.font = [UIFont boldSystemFontOfSize:14.0];
//    lbIndex.textColor = [UIColor blueColor];
//    lbIndex.textAlignment = UITextAlignmentRight;
//    [cell addSubview:lbIndex];
//    [lbIndex release];
	
    cell.backgroundColor = [UIColor clearColor];
	//cell.backgroundColor = [UIColor yellowColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

-(NSInteger) tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger) section
{
	QuizBean *quizBean = [arrayQuiz objectAtIndex:_currentIndex];
	//NSLog(@"number of row = %d", 2+ [quizBean.answers count]);
	return [quizBean.answers count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuizBean *quizBean = [arrayQuiz objectAtIndex:_currentIndex];
    NSString *headers = [quizBean.answers objectAtIndex:indexPath.row];
    CGFloat height = [headers RAD_textHeightForSystemFontOfSize:kTextViewFontSize width:kTextViewWidth];
		//NSLog(@"%row=%d, height=0.0%f", indexPath.row, height);
    if (height < 25.0f) {
        height = 25.0f;
    }
    return height+20.0f;
}

#pragma mark UIAlertView methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAlertTag_completeTest) {
        if (buttonIndex == 0) {
            [[SqlMB getInstance] saveScore:sChapter CorrectNum:iCorrectNum AllDoneNum:iAlldoneNum];
        } else {
            
        }
        
//        if (!isNOTFistTest) { //  After the first completed exam, we'd like the pop-up to show, share FB & Twitter.
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Like our app, tell your friends about us" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Post to Facebook",@"Post to Twitter", nil];
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
}


#pragma mark - UIActionsheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"IS_FIRST_TEST"];
    if (buttonIndex == 0) {
        
        [self shareToFacebook];
        
    } else if (buttonIndex == 1) {
        
        [self shareToTwitter];
        
    } else {
        
        if (b_Return) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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
                        [self.navigationController popViewControllerAnimated:YES];
                        break;
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Post Sucessful");
                        [self.navigationController popViewControllerAnimated:YES];
                        break;
                        
                    default:
                        break;
                }
            }];
            
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        } else {
            NSLog(@"2");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Facebook Account" message:@"There are no Facebook accounts configured. You can add or create a Facebook account in Settings. " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            //        alert.tag = kAlertViewTagOther;
            [alert release];
        }
//        
    }
    
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

//- (void)shareTwitterAction
//{
//    self.navigationController.view.userInteractionEnabled = YES;
//    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Twitter" message:@"Your message has been posted." delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
//    [alert show];
//    [alert release];
//}
@end
