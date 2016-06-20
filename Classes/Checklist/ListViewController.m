//
//  ListViewController.m
//  Firefighter
//
//  Created by sandra on 11/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ListViewController.h"
#import "QuizAppDelegate.h"
#import "ChapterBean.h"
#import "CheckDetailViewController.h"

#import "SqlMB.h"
@implementation ListViewController

@synthesize _id, chapter;

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
	lbTitle.text = chapter;
	
	UIBarButtonItem *_rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear All" style:UIBarButtonItemStyleBordered target:self action:@selector(clearAll:)];
	self.navigationItem.rightBarButtonItem = _rightBarButtonItem;
	[_rightBarButtonItem release];
	
	tbView.backgroundColor = [UIColor clearColor];
	arrayChapters = [[NSMutableArray alloc] init];
	
	[self getChaptersfromDB];
	
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
	self.navigationItem.title = @"Checklists";
}

- (void)viewWillDisappear:(BOOL)animated
{
	if (_id==1) {
		self.navigationItem.title = @"Fire Attack";
	}else if (_id ==2) {
		self.navigationItem.title = @"Medical";
	}else {
		self.navigationItem.title = @"Technical Rescue";
	}
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[arrayChapters release];
	
    [super dealloc];
}

-(void)getChaptersfromDB
{

    [[SqlMB getInstance] getChaptersFromDBForCheckList:arrayChapters withPID:_id];
}

-(IBAction)clearAll: (id)sender {
//	QuizAppDelegate *appDelegate = (QuizAppDelegate*)[[UIApplication sharedApplication] delegate];
//	sqlite3 *db = [appDelegate getDatabase];
//	sqlite3_stmt * statements=nil;
//	if (statements == nil) {
//		char *sql = "update checklist set checked=0 WHERE chapter_id <=12";
//		if (_id==2) {
//			sql = "update checklist set checked=0 WHERE chapter_id <=28 AND chapter_id>=13";
//		}else if (_id == 3) {
//			sql = "update checklist set checked=0 WHERE chapter_id >28";
//		}
//		if (sqlite3_prepare_v2(db, sql, -1, &statements, NULL) != SQLITE_OK) {
//			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
//		}
//	}
//	int success = sqlite3_step(statements);
//	if (success == SQLITE_ERROR) {
//		NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(db));
//	}    	
//	sqlite3_finalize(statements);
//	statements = nil;
    [[SqlMB getInstance] clearCheckedFromDBForToolBoxWithCharpterType:_id];
}


#pragma mark UITableView methods

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	CheckDetailViewController *checkDetail = [[CheckDetailViewController alloc] initWithNibName:@"CheckDetailViewController" bundle:nil];
	ChapterBean *cBean = [arrayChapters objectAtIndex:indexPath.row];
	checkDetail.chapterBean = cBean;
	[self.navigationController pushViewController:checkDetail animated:YES];
	[checkDetail release];
}

-(UITableViewCell *) tableView:(UITableView *) tv cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
	ChapterBean *cBean = [arrayChapters objectAtIndex:indexPath.row];
    cell.textLabel.text = cBean.name;
//	cell.textLabel.textAlignment = UITextAlignmentCenter;
//	cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
//	cell.textLabel.numberOfLines = 0;
//	cell.textLabel.textColor = [UIColor darkTextColor];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return chapter;
    }
    return @"";
}

-(NSInteger) tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger) section
{
	return [arrayChapters count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	return 44.0;
}

@end
