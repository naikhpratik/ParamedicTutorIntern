//
//  QuizMainViewController.m
//  Quiz
//
//  Created by Zorro on 2/15/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import "QuizMainViewController.h"
#import "QuizViewController.h"
#import "BookmarkListViewController.h"
#import "ScoreViewController.h"
#import "ChapterViewController.h"
#import "SqlMB.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation QuizMainViewController

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
    
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"quiz_page"];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    [[GAI sharedInstance] dispatch];
    // set the background
    if (iPhone5) {
        self.quiz_bg_imageView.image = [UIImage imageNamed:@"Quizzes-background-5"];
    } else {
        self.quiz_bg_imageView.image = [UIImage imageNamed:@"Quizzes-background"];
    }
    
	tbView.backgroundColor = [UIColor clearColor];
	arrayList = [[NSArray alloc] initWithObjects:@"Comprehensive Quiz", @"Chapter Quizzes", @"Score History", nil];
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
	self.navigationItem.title = @"Quizzes";
}

- (void)viewWillDisappear:(BOOL)animated
{
	self.navigationItem.title = @"Back";
}

-(void)startQuiz
{
    if ([[SqlMB getInstance] shouldContinueForQuiz:0]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want to continue where you left off, or delete and start over?" delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Continue", nil];
        [alert show];
        [alert release];
    } else {
        QuizViewController *quizViewController = [[QuizViewController alloc] initWithNibName:@"QuizViewController" bundle:nil];
        quizViewController.sChapter = @"Comprehensive Quiz";
        quizViewController.iChapter = 0;
        quizViewController.mode = 0;
        [self.navigationController pushViewController:quizViewController animated:YES];
        [quizViewController release];
    }
//    if ([[SqlMB getInstance] haveStoredQiz:0]) {
//        
//    } else {
//        
//
//    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        QuizViewController *quizViewController = [[QuizViewController alloc] initWithNibName:@"QuizViewController" bundle:nil];
        quizViewController.sChapter = @"Comprehensive Quiz";
        quizViewController.iChapter = 0;
        quizViewController.mode = 0;
        quizViewController.hasPreviousData = YES;
        [self.navigationController pushViewController:quizViewController animated:YES];
        [quizViewController release];

    } else {
//        [[SqlMB getInstance] clearStatusForQiz:0];
        [[SqlMB getInstance] clearProcessForQuiz:0];
        QuizViewController *quizViewController = [[QuizViewController alloc] initWithNibName:@"QuizViewController" bundle:nil];
        quizViewController.sChapter = @"Comprehensive Quiz";
        quizViewController.iChapter = 0;
        quizViewController.mode = 0;
        quizViewController.hasPreviousData = NO;
        [self.navigationController pushViewController:quizViewController animated:YES];
        [quizViewController release];
    }
}

-(void)score
{
	ScoreViewController *scoreViewController = [[ScoreViewController alloc] initWithNibName:@"ScoreViewController" bundle:nil];
	[self.navigationController pushViewController:scoreViewController animated:YES];
	[scoreViewController release];
}

-(IBAction)bookMark: (id)sender
{
	BookmarkListViewController *bookmarkListViewController = [[BookmarkListViewController alloc] initWithNibName:@"BookmarkListViewController" bundle:nil];
	bookmarkListViewController.bookType = 0;
	[self.navigationController pushViewController:bookmarkListViewController animated:YES];
	[bookmarkListViewController release];
}

-(void)chapter
{
	ChapterViewController *chapterViewController = [[ChapterViewController alloc] initWithNibName:@"ChapterViewController" bundle:nil];
	[self.navigationController pushViewController:chapterViewController animated:YES];
	[chapterViewController release];
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
    [self setQuiz_bg_imageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[arrayList release];
    [_quiz_bg_imageView release];
    [super dealloc];
}

#pragma mark UITableView methods

- (void)btnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if (btn.tag == 1) {
        [self startQuiz];
    } else if (btn.tag == 2) {
        [self chapter];
    } else if (btn.tag == 3) {
        [self bookMark:nil];
    } else if (btn.tag == 4) {
        [self score];
    }
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row) {
		case 0:
			[self startQuiz];
			break;
		case 1:
			[self chapter];
			break;
        case 2:
            [self bookMark:nil];
            break;
		case 3:
			[self score];
			break;
		default:
			break;
	}
}

-(UITableViewCell *) tableView:(UITableView *) tv cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
	CustomMainViewCell *cell = (CustomMainViewCell *)[tv dequeueReusableCellWithIdentifier:@"mainQuizCell"];
	if (cell == nil) {
        cell = (CustomMainViewCell *)[[[NSBundle mainBundle]loadNibNamed:@"CustomMainViewCell" owner:self options:nil]objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (indexPath.row == 0) {
        [cell.btn_content setImage:[UIImage imageNamed:@"comp_quiz_n"] forState:UIControlStateNormal];
    } else if (indexPath.row == 1) {
        [cell.btn_content setImage:[UIImage imageNamed:@"chapters_n"] forState:UIControlStateNormal];
    } else if (indexPath.row == 2) {
        [cell.btn_content setImage:[UIImage imageNamed:@"bookmarks_n"] forState:UIControlStateNormal];
    } else if (indexPath.row == 3) {
        [cell.btn_content setImage:[UIImage imageNamed:@"scorehistory_n"] forState:UIControlStateNormal];
    }
	cell.btn_content.tag = indexPath.row + 1;
    [cell.btn_content addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
	return cell;
}

-(NSInteger) tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger) section
{
	return 4;//[arrayList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	return 85.0;
}

@end
