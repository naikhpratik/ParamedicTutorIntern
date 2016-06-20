//
//  FlashcardMainViewController.m
//  Quiz
//
//  Created by Zorro on 2/27/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import "FlashcardMainViewController.h"
#import "QuizAppDelegate.h"
#import "ChapterBean.h"
#import "CardViewController.h"
#import "BookmarkListViewController.h"
#import "CardChapterViewController.h"
#import "SqlMB.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
@implementation FlashcardMainViewController

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
    
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"flash_page"];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    [[GAI sharedInstance] dispatch];
    // set backgroung
    if (iPhone5) {
        self.flashcard_bg_imageView.image = [UIImage imageNamed:@"flashcards-menubg-5"];
    } else {
        self.flashcard_bg_imageView.image = [UIImage imageNamed:@"flashcards-menubg"];
        
    }
    //	arrayChapters = [[NSMutableArray alloc] init];
	tbView.backgroundColor = [UIColor clearColor];
    //	[self getChaptersfromDB];
    //    [[SqlMB getInstance] getAllChapterFromDB:1 data:arrayChapters];
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
	self.navigationItem.title = @"Flashcards";
}

- (void)viewWillDisappear:(BOOL)animated
{
	self.navigationItem.title = @"Back";
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

-(IBAction)bookMark: (id)sender
{
	BookmarkListViewController *bookmarkListViewController = [[BookmarkListViewController alloc] initWithNibName:@"BookmarkListViewController" bundle:nil];
	bookmarkListViewController.bookType = 1;
	[self.navigationController pushViewController:bookmarkListViewController animated:YES];
	[bookmarkListViewController release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [self setFlashcard_bg_imageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    //	[arrayChapters release];
    [_flashcard_bg_imageView release];
    [super dealloc];
}

//-(void)getChaptersfromDB
//{
//	if([arrayChapters count] != 0)
//	{
//		[arrayChapters removeAllObjects];
//	}
//	QuizAppDelegate *app = (QuizAppDelegate *)[[UIApplication sharedApplication] delegate];
//	sqlite3 *database = [app getDatabase];
//	sqlite3_stmt * statements=nil;
//
//	//get default category first
//	if (statements == nil) {
//		char *sql = "select id, name from chapterFcard";
//        if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
//            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
//        }else{
//			while(sqlite3_step(statements) == SQLITE_ROW){
//				ChapterBean *chapterBean = [[ChapterBean alloc] init];
//				chapterBean.chapterID = sqlite3_column_int(statements, 0);
//			    if (sqlite3_column_text(statements, 1)) {
//					chapterBean.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 1)];
//				}else {
//					chapterBean.name = @"";
//				}
//
//				[arrayChapters addObject:chapterBean];
//				[chapterBean release];
//			}
//			sqlite3_finalize(statements);
//			statements = nil;
//		}
//	}
//}

#pragma mark UITableView methods
- (void)gotoChapter
{
    CardChapterViewController *cchapterView = [[CardChapterViewController alloc] initWithNibName:@"CardChapterViewController" bundle:nil];
    [self.navigationController pushViewController:cchapterView animated:YES];
    [cchapterView release];
}

- (void)gotoComprehensive
{
    if ([[SqlMB getInstance] shouldCOntinueForCards:0]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want to continue where you left off, or delete and start over?" delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Continue", nil];
        alert.tag = 1;
        [alert show];
        [alert release];
    } else {
        CardViewController *cardViewController = [[CardViewController alloc] initWithNibName:@"CardViewController" bundle:nil];
        cardViewController.sChapter = @"All Chapters";
        cardViewController.iChapter = 0;
        cardViewController.mode = 0;
        cardViewController.hadPreviousData = NO;
        [self.navigationController pushViewController:cardViewController animated:YES];
        [cardViewController release];
    }
}

- (void)btnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if (btn.tag == 1) {
        [self gotoComprehensive];
    } else if (btn.tag == 2) {
        [self gotoChapter];
    } else if (btn.tag == 3) {
        [self bookMark:nil];
    }
}


- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        if ([[SqlMB getInstance] shouldCOntinueForCards:indexPath.row]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want to continue where you left off, or delete and start over?" delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Continue", nil];
            alert.tag = indexPath.row+1;
            [alert show];
            [alert release];
        } else {
            [self gotoComprehensive];
        }
    }else if (indexPath.row == 1){
        [self gotoChapter];
    } else if (indexPath.row == 2) {
        [self bookMark:nil];
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
        [cell.btn_content setImage:[UIImage imageNamed:@"comp_fcards_n"] forState:UIControlStateNormal];
    } else if (indexPath.row == 1) {
        [cell.btn_content setImage:[UIImage imageNamed:@"chapters_n"] forState:UIControlStateNormal];
    } else if (indexPath.row == 2) {
        [cell.btn_content setImage:[UIImage imageNamed:@"bookmarks_n"] forState:UIControlStateNormal];
    }
	cell.btn_content.tag = indexPath.row + 1;
    [cell.btn_content addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
	return cell;
}

-(NSInteger) tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger) section
{
    //	return [arrayChapters count]+1;
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 85.0;
}

#pragma mark - UIAlertView Methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        CardViewController *cardViewController = [[CardViewController alloc] initWithNibName:@"CardViewController" bundle:nil];
        
        if (alertView.tag-1 == 0) {
            cardViewController.sChapter = @"All Chapters";
            cardViewController.iChapter = 0;
        }else {
            //            ChapterBean *cBean = [arrayChapters objectAtIndex:(alertView.tag-2)];
            //            cardViewController.sChapter = cBean.name;
            //            cardViewController.iChapter = cBean.chapterID;
        }
        cardViewController.mode = 0;
        cardViewController.hadPreviousData = YES;
        [self.navigationController pushViewController:cardViewController animated:YES];
        [cardViewController release];
    } else {
        [[SqlMB getInstance] clearProcessForCards:alertView.tag-1];
        CardViewController *cardViewController = [[CardViewController alloc] initWithNibName:@"CardViewController" bundle:nil];
        
        if (alertView.tag-1 == 0) {
            cardViewController.sChapter = @"All Chapters";
            cardViewController.iChapter = 0;
        }else {
            //            ChapterBean *cBean = [arrayChapters objectAtIndex:(alertView.tag-2)];
            //            cardViewController.sChapter = cBean.name;
            //            cardViewController.iChapter = cBean.chapterID;
        }
        cardViewController.mode = 0;
        cardViewController.hadPreviousData = NO;
        [self.navigationController pushViewController:cardViewController animated:YES];
        [cardViewController release];
    }
}

@end
