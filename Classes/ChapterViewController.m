//
//  ChapterViewController.m
//  Quiz
//
//  Created by Zorro on 2/23/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import "ChapterViewController.h"
#import "QuizViewController.h"
#import "ChapterBean.h"
#import "SqlMB.h"
#import "QuizAppDelegate.h"

#import "SqlMB.h"
@implementation ChapterViewController
{
    NSInteger chapterIndex;
}
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
    chapterIndex = 0;
    //  set background.
    if (iPhone5) {
        self.chapter_bg_imageView.image = [UIImage imageNamed:@"Quizzes-background-5"];
    } else {
        self.chapter_bg_imageView.image = [UIImage imageNamed:@"Quizzes-background"];
    }
    
	self.navigationItem.title = @"Chapters";
	tbView.backgroundColor = [UIColor clearColor];
	arrayChapters = [[NSMutableArray alloc] init];
//	[self getChaptersfromDB];
    [[SqlMB getInstance] getChaptersFromDB:arrayChapters];
    [super viewDidLoad];
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
    [self setChapter_bg_imageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[arrayChapters release];
    [_chapter_bg_imageView release];
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
//		char *sql = "select id, name from quizChapter";
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

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChapterBean *cBean = [arrayChapters objectAtIndex:indexPath.row];
    chapterIndex = indexPath.row;
    if ([[SqlMB getInstance] shouldContinueForQuiz:cBean.chapterID]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want to continue where you left off, or delete and start over?" delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Continue", nil];
        [alert show];
        [alert release];
    } else {
        
        QuizViewController *quizViewController = [[QuizViewController alloc] initWithNibName:@"QuizViewController" bundle:nil];
        quizViewController.sChapter = cBean.name;
        quizViewController.iChapter = cBean.chapterID;
        quizViewController.mode = 0;
        [self.navigationController pushViewController:quizViewController animated:YES];
        [quizViewController release];
        
    }
//	QuizViewController *quizViewController = [[QuizViewController alloc] initWithNibName:@"QuizViewController" bundle:nil];
//	ChapterBean *cBean = [arrayChapters objectAtIndex:indexPath.row];
//	quizViewController.sChapter = cBean.name;
//	quizViewController.iChapter = cBean.chapterID;
//	quizViewController.mode = 0;
//	[self.navigationController pushViewController:quizViewController animated:YES];
//	[quizViewController release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    ChapterBean *cBean = [arrayChapters objectAtIndex:chapterIndex];
    if (buttonIndex == 1) {
        QuizViewController *quizViewController = [[QuizViewController alloc] initWithNibName:@"QuizViewController" bundle:nil];
        quizViewController.sChapter = cBean.name;
        quizViewController.iChapter = cBean.chapterID;
        quizViewController.mode = 0;
        quizViewController.hasPreviousData = YES;
        [self.navigationController pushViewController:quizViewController animated:YES];
        [quizViewController release];
        
    } else {
        [[SqlMB getInstance] clearProcessForQuiz:cBean.chapterID];
        QuizViewController *quizViewController = [[QuizViewController alloc] initWithNibName:@"QuizViewController" bundle:nil];
        quizViewController.sChapter = cBean.name;
        quizViewController.iChapter = cBean.chapterID;
        quizViewController.mode = 0;
        quizViewController.hasPreviousData = NO;
        [self.navigationController pushViewController:quizViewController animated:YES];
        [quizViewController release];
    }
}

-(UITableViewCell *) tableView:(UITableView *) tv cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];    
	ChapterBean *cBean = [arrayChapters objectAtIndex:indexPath.row];
    cell.textLabel.text = cBean.name;
	cell.textLabel.textAlignment = UITextAlignmentCenter;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

-(NSInteger) tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger) section
{
	return [arrayChapters count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	return 40.0;
}


@end
