//
//  ChecklistViewController.m
//  Firefighter
//
//  Created by sandra on 11/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChecklistViewController.h"
#import "ListViewController.h"
#import "QuizAppDelegate.h"
#import "SqlMB.h"
@implementation ChecklistViewController

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
	self.navigationItem.title = @"Checklists";
	
	UIBarButtonItem *_rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear All" style:UIBarButtonItemStyleBordered target:self action:@selector(clearAll:)];
	self.navigationItem.rightBarButtonItem = _rightBarButtonItem;
	[_rightBarButtonItem release];
	
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
    [super dealloc];
}

-(IBAction)list:(id)sender {
	UIButton *bt = (UIButton *)sender;
	ListViewController *listViewController = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
	listViewController.chapter = [bt titleForState:UIControlStateNormal];
	listViewController._id = [sender tag];
	[self.navigationController pushViewController:listViewController animated:YES];
	[listViewController release];
}

-(IBAction)clearAll: (id)sender {
//	QuizAppDelegate *appDelegate = (QuizAppDelegate*)[[UIApplication sharedApplication] delegate];
//	sqlite3 *db = [appDelegate getDatabase];
//	sqlite3_stmt * statements=nil;
//	if (statements == nil) {
//		static char *sql = "update checklist set checked=0";
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
    [[SqlMB getInstance] clearCheckedFromdbfORtoolBoxWithChecked];
}

@end
