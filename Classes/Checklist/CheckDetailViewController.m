//
//  CheckDetailViewController.m
//  Firefighter
//
//  Created by sandra on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CheckDetailViewController.h"
#import "CheckBean.h"
#import "StringHelper.h"
#import "QuizAppDelegate.h"
#import "SqlMB.h"

@implementation CheckDetailViewController

@synthesize chapterBean;

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
	self.navigationItem.title = @"Checklist";
	
	UIBarButtonItem *_rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear All" style:UIBarButtonItemStyleBordered target:self action:@selector(clearAll:)];
	self.navigationItem.rightBarButtonItem = _rightBarButtonItem;
	[_rightBarButtonItem release];
	
	lbTitle.text = chapterBean.name;
	_arr_checks = [[NSMutableArray alloc] init];
	[self getDatafromDB];
	
    [super viewDidLoad];
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
	[_arr_checks release];
	
    [super dealloc];
}

-(void)getDatafromDB
{
    [[SqlMB getInstance] getCheckListFromDBForToolBox:_arr_checks ChapterId:chapterBean.chapterID];

}

-(IBAction)checkChange: (id)sender {
	UIButton *btCheck = (UIButton *)sender;
	NSString *sTitle = [btCheck titleForState:UIControlStateNormal];
	BOOL b_check = YES;
	if ([sTitle isEqualToString:@"Checked"]) {
		b_check = NO;
		[btCheck setTitle:@"Unchecked" forState:UIControlStateNormal];
		[btCheck setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"box-Blank" ofType:@"png"]] forState:UIControlStateNormal];
		[btCheck setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"box-Blank" ofType:@"png"]] forState:UIControlStateHighlighted];
	}else {
		[btCheck setTitle:@"Checked" forState:UIControlStateNormal];
		[btCheck setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"box-Checked" ofType:@"png"]] forState:UIControlStateNormal];
		[btCheck setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"box-Checked" ofType:@"png"]] forState:UIControlStateHighlighted];
	}
	
	CheckBean *cBean = [_arr_checks objectAtIndex:[btCheck tag]];
	QuizAppDelegate *appDelegate = (QuizAppDelegate*)[[UIApplication sharedApplication] delegate];
	sqlite3 *db = [appDelegate getDatabase];
    cBean.b_check = b_check;
    [[SqlMB getInstance] updateCheckWithChapterID:cBean._id Checked:b_check];
//	sqlite3_stmt * statements=nil;
//	if (statements == nil) {
//		static char *sql = "update checklist set checked=? where _id=?";
//		if (sqlite3_prepare_v2(db, sql, -1, &statements, NULL) != SQLITE_OK) {
//			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
//		}
//		sqlite3_bind_int(statements, 1, b_check);
//		sqlite3_bind_int(statements, 2, cBean._id);
//	}
//	int success = sqlite3_step(statements);
//	if (success == SQLITE_ERROR) {
//		NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(db));
//	}    	
//	cBean.b_check = b_check;
//	sqlite3_finalize(statements);
//	statements = nil;
}

-(IBAction)clearAll: (id)sender {
//	QuizAppDelegate *appDelegate = (QuizAppDelegate*)[[UIApplication sharedApplication] delegate];
//	sqlite3 *db = [appDelegate getDatabase];
//	sqlite3_stmt * statements=nil;
//	if (statements == nil) {
//		const char *sql = "update checklist set checked=0 WHERE chapter_id =?";
//		if (sqlite3_prepare_v2(db, sql, -1, &statements, NULL) != SQLITE_OK) {
//			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
//		}
//	}
//	sqlite3_bind_int(statements, 1, chapterBean.chapterID);
//	int success = sqlite3_step(statements);
//	if (success == SQLITE_ERROR) {
//		NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(db));
//	}    	
//	sqlite3_finalize(statements);
//	statements = nil;
    [[SqlMB getInstance] clearCheckedFromDBForToolBoxWithCharpterID:chapterBean.chapterID];
	
	[self getDatafromDB];
	[tbView reloadData];
}

#pragma mark UITableView methods

-(UITableViewCell *) tableView:(UITableView *) tv cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
	CheckBean *cBean = [_arr_checks objectAtIndex:indexPath.row];
	
	CGFloat heightInfo1 = 0.0;
	CGFloat heightInfo2 = 0.0;
	CGFloat heightInfo3 = 0.0;
	
	CGFloat hPreHead = 0;
	if (![cBean.precheck isEqualToString:@""]) {
		hPreHead = [cBean.precheck RAD_textHeightForFontOfSize:[UIFont fontWithName:@"Helvetica-Bold" size:22.0] width:310]+10; 
		UILabel *lbPreCheck = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 310, hPreHead)];
		lbPreCheck.text = cBean.precheck;
		lbPreCheck.font = [UIFont fontWithName:@"Helvetica-Bold" size:22.0];
		lbPreCheck.numberOfLines = 0;
		lbPreCheck.textColor = [UIColor blackColor];
		lbPreCheck.backgroundColor = [UIColor clearColor];
		[cell addSubview:lbPreCheck];
		[lbPreCheck release];
	}
	
	CGFloat height = [cBean.name RAD_textHeightForFontOfSize:[UIFont fontWithName:@"Helvetica-Bold" size:20.0] width:257]+10;
	//NSLog(@"%d--%@--%.0f", indexPath.row,cBean.name, height);
	UILabel *lbHeader = [[UILabel alloc] initWithFrame:CGRectMake(55, hPreHead, 257, height)];
	lbHeader.text = cBean.name;
	lbHeader.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
	lbHeader.numberOfLines = 0;
	lbHeader.textColor = [UIColor darkGrayColor];
	lbHeader.backgroundColor = [UIColor clearColor];
	[cell addSubview:lbHeader];
	[lbHeader release];	
	
	UIButton *btCheck = [[UIButton alloc]initWithFrame:CGRectMake(5, hPreHead, 42, 42)];
	if (height < 40) {
		btCheck.frame = CGRectMake(5, hPreHead-5, 42, 42);
	}
	if (cBean.b_check) {
		[btCheck setTitle:@"Checked" forState:UIControlStateNormal];
		[btCheck setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"box-Checked" ofType:@"png"]] forState:UIControlStateNormal];
		[btCheck setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"box-Checked" ofType:@"png"]] forState:UIControlStateHighlighted];
	}else {
		[btCheck setTitle:@"Unchecked" forState:UIControlStateNormal];
		[btCheck setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"box-Blank" ofType:@"png"]] forState:UIControlStateNormal];
		[btCheck setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"box-Blank" ofType:@"png"]] forState:UIControlStateHighlighted];
	}
	btCheck.tag = indexPath.row;
	[btCheck addTarget:self action:@selector(checkChange:) forControlEvents:UIControlEventTouchUpInside];
	[cell addSubview:btCheck];
	[btCheck release];

	
	if (![cBean.informaiton1 isEqualToString:@""]) {
		heightInfo1 = [cBean.informaiton1 RAD_textHeightForFontOfSize:[UIFont fontWithName:@"Helvetica" size:18.0] width:250]+10;
		UILabel *lbInfo1 = [[UILabel alloc] initWithFrame:CGRectMake(60, hPreHead+height, 250, heightInfo1)];
		lbInfo1.text = cBean.informaiton1;
		lbInfo1.font = [UIFont fontWithName:@"Helvetica" size:18.0];
		lbInfo1.numberOfLines = 0;
		lbInfo1.textColor = [UIColor darkGrayColor];
		lbInfo1.backgroundColor = [UIColor clearColor];
		[cell addSubview:lbInfo1];
		[lbInfo1 release];
	}
	if (![cBean.informaiton2 isEqualToString:@""]) {
		heightInfo2 = [cBean.informaiton2 RAD_textHeightForFontOfSize:[UIFont fontWithName:@"Helvetica" size:18.0] width:250]+10;
		UILabel *lbInfo2 = [[UILabel alloc] initWithFrame:CGRectMake(60, hPreHead+height+heightInfo1, 250, heightInfo2)];
		lbInfo2.text = cBean.informaiton2;
		lbInfo2.font = [UIFont fontWithName:@"Helvetica" size:18.0];
		lbInfo2.numberOfLines = 0;
		lbInfo2.textColor = [UIColor darkGrayColor];
		lbInfo2.backgroundColor = [UIColor clearColor];
		[cell addSubview:lbInfo2];
		[lbInfo2 release];
	}
	if (![cBean.informaiton3 isEqualToString:@""]) {
		heightInfo3 = [cBean.informaiton3 RAD_textHeightForFontOfSize:[UIFont fontWithName:@"Helvetica" size:18.0] width:250]+10;
		UILabel *lbInfo3 = [[UILabel alloc] initWithFrame:CGRectMake(60, hPreHead+height+heightInfo1+heightInfo2, 250, heightInfo3)];
		lbInfo3.text = cBean.informaiton3;
		lbInfo3.font = [UIFont fontWithName:@"Helvetica" size:18.0];
		lbInfo3.numberOfLines = 0;
		lbInfo3.textColor = [UIColor darkGrayColor];
		lbInfo3.backgroundColor = [UIColor clearColor];
		[cell addSubview:lbInfo3];
		[lbInfo3 release];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
}

-(NSInteger) tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger) section
{
	return [_arr_checks count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	CheckBean *cBean = [_arr_checks objectAtIndex:indexPath.row];
	
	CGFloat hPreHead = 0;
	if (![cBean.precheck isEqualToString:@""]) {
		hPreHead = [cBean.precheck RAD_textHeightForFontOfSize:[UIFont fontWithName:@"Helvetica-Bold" size:22.0] width:310]+10; 
	}

	CGFloat height = hPreHead+ [cBean.name RAD_textHeightForFontOfSize:[UIFont fontWithName:@"Helvetica-Bold" size:20.0] width:257]+10;
	
	if (![cBean.informaiton1 isEqualToString:@""]) {
		height+= [cBean.informaiton1 RAD_textHeightForFontOfSize:[UIFont fontWithName:@"Helvetica" size:18.0] width:250]+10;
	}
	if (![cBean.informaiton2 isEqualToString:@""]) {
		height+= [cBean.informaiton2 RAD_textHeightForFontOfSize:[UIFont fontWithName:@"Helvetica" size:18.0] width:250]+10;
	}
	if (![cBean.informaiton3 isEqualToString:@""]) {
		height+= [cBean.informaiton3 RAD_textHeightForFontOfSize:[UIFont fontWithName:@"Helvetica" size:18.0] width:250]+10;
	}

	//NSLog(@"%d: %.0f--%.0f--%.0f", indexPath.row,hPreHead, [cBean.name RAD_textHeightForFontOfSize:[UIFont fontWithName:@"Helvetica-Bold" size:20.0] width:257]+10,
		 // height);
	
	return height;
}

@end
