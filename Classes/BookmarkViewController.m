//
//  BookmarkViewController.m
//  Quiz
//
//  Created by Zorro on 2/18/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import "BookmarkViewController.h"
#import "QuizAppDelegate.h"
#import "BookmarkBean.h"
#import "QuizViewController.h"
#import "CardViewController.h"
#import "SqlMB.h"

@implementation BookmarkViewController

@synthesize chapterID, name, bookType;

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
	arrayBookmark = [[NSMutableArray alloc] init];
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
	self.navigationItem.title = @"Back";
}

-(void) viewWillAppear:(BOOL)animated
{
	self.navigationItem.title = name;
//	[self getBookmarkfromDB];
    [[SqlMB getInstance] getBookmarkFromDB:bookType Chapter:chapterID data:arrayBookmark];
	[tbView reloadData];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[arrayBookmark release];
    [super dealloc];
}

//-(void)getBookmarkfromDB
//{
//	if([arrayBookmark count] != 0)
//	{
//		[arrayBookmark removeAllObjects];
//	}
//	QuizAppDelegate *app = (QuizAppDelegate *)[[UIApplication sharedApplication] delegate];
//	sqlite3 *database = [app getDatabase];
//	sqlite3_stmt * statements=nil;
//	
//	//get default category first
//	if (statements == nil) {
//		char *sql;
//		switch (bookType) {
//			case 0:
//			{
//				if (chapterID == 0) {
//					sql = "select id, question from quiz WHERE bookmark=? ORDER by bookTime ASC";  //AND bookinComp=?
//				}else {
//					sql = "select id, question from quiz WHERE bookmark=? AND bookinComp=? AND chapter=? ORDER by bookTime ASC";
//				}
//			}
//				break;
//			case 1:
//			{
//				if (chapterID == 0) {
//					sql = "select id, question from flashcard WHERE bookmark=? ORDER by bookTime ASC"; //AND bookinAll=?
//				}else {
//					sql = "select id, question from flashcard WHERE bookmark=? AND bookinAll=? AND chapter=? ORDER by bookTime ASC";
//				}
//			}
//				break;
//			default:
//				break;
//		}
//		
//        if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
//            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
//        }else{
//			sqlite3_bind_int(statements, 1, 1);
//			if (chapterID != 0) {
//				sqlite3_bind_int(statements, 2, 0);
//				sqlite3_bind_int(statements, 3, chapterID);
//			}
//			
//			while(sqlite3_step(statements) == SQLITE_ROW){
//				BookmarkBean *bookmarkBean = [[BookmarkBean alloc] init];
//				bookmarkBean.quizID = sqlite3_column_int(statements, 0);
//			    if (sqlite3_column_text(statements, 1)) {
//					bookmarkBean.strQuiz = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 1)];
//				}else {
//					bookmarkBean.strQuiz = @"";
//				}
//				bookmarkBean.chapterID = sqlite3_column_int(statements, 2);
//				bookmarkBean.bookinComp = sqlite3_column_int(statements, 3);
//				
//				[arrayBookmark addObject:bookmarkBean];
//				[bookmarkBean release];
//			}
//			sqlite3_finalize(statements);
//			statements = nil;
//		}	
//	}	
//}

#pragma mark UITableView methods

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	BookmarkBean *bookmarkBean = [arrayBookmark objectAtIndex:indexPath.row];
	switch (bookType) {
		case 0:
		{
			QuizViewController *quizViewController = [[QuizViewController alloc] initWithNibName:@"QuizViewController" bundle:nil];
			quizViewController.sChapter = name;
			quizViewController.iChapter = chapterID;
			quizViewController.mode = 1;
			quizViewController.bookquizID = bookmarkBean.quizID;
			quizViewController.hasPreviousData = NO;
			[self.navigationController pushViewController:quizViewController animated:YES];
			[quizViewController release];
		}
			break;
		case 1:
		{
			CardViewController *cardViewController = [[CardViewController alloc] initWithNibName:@"CardViewController" bundle:nil];
			cardViewController.sChapter = name;
			cardViewController.iChapter = chapterID;
			cardViewController.mode = 1;
			cardViewController.bookquizID = bookmarkBean.quizID;
			
			[self.navigationController pushViewController:cardViewController animated:YES];
			[cardViewController release];
		}
			break;
		default:
			break;
	}
}

-(UITableViewCell *) tableView:(UITableView *) tv cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
	
    BookmarkBean *bookmarkBean = [arrayBookmark objectAtIndex:indexPath.row];
	UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 275, 22)];
	lbTitle.text = bookmarkBean.strQuiz;
	lbTitle.font = [UIFont boldSystemFontOfSize:16.0];
	[cell addSubview:lbTitle];
	[lbTitle release];
	
	//UILabel *lbRel = [[UILabel alloc] initWithFrame:CGRectMake(35, 24, 275, 16)];
//	if (bookmarkBean.bookinComp) {
//		lbRel.text = @"Comprehensive Quiz";
//	}else {
//		lbRel.text = [NSString stringWithFormat:@"chapter %d", bookmarkBean.chapterID];
//	}
//	
//	lbRel.font = [UIFont systemFontOfSize:14.0];
//	lbRel.textColor = [UIColor grayColor];
//	[cell addSubview:lbRel];
//	[lbRel release];
	
	return cell;
}

-(NSInteger) tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger) section
{
	return [arrayBookmark count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	return 40.0;
}


@end
