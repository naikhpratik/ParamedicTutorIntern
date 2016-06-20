//
//  BookSceViewController.m
//  Quiz
//
//  Created by Zorro on 3/12/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import "BookSceViewController.h"
#import "SceneDetailViewController.h"
#import "ScenariosBean.h"
#import "QuizAppDelegate.h"
#import "SqlMB.h"

@implementation BookSceViewController

@synthesize _type;
@synthesize imgView_header = _imgView_header;

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
	arrayScenarios = [[NSMutableArray alloc] init];
	tbView.backgroundColor = [UIColor clearColor];
	if (_type == 0) {
        if (iPhone5) {
//            backImage.image = [UIImage imageNamed:@"Sce-bookmarks.png"];
            
        } else {
//            backImage.image = [UIImage imageNamed:@"Sce-bookmarks.png"];
            
        }
        self.imgView_header.image = [UIImage imageNamed:@"scenario_bar.png"];
	}else {
        if (iPhone5) {
//            backImage.image = [UIImage imageNamed:@"Skillsheetbook-5.png"];
        } else {
//            backImage.image = [UIImage imageNamed:@"Skillsheetbook.png"];
        }
        self.imgView_header.image = [UIImage imageNamed:@"toolbox_bar.png"];
    }
    
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
	if (_type == 0) {
		self.navigationItem.title = @"Scenarios";
        [[SqlMB getInstance] getScenariosFromDB:arrayScenarios bookType:YES isSkillSheet:NO];
	}else {
		self.navigationItem.title = @"Skill Sheets";
        [[SqlMB getInstance] getScenariosFromDB:arrayScenarios bookType:YES isSkillSheet:YES];
	}
    if ([arrayScenarios count] == 0) {
        tbView.hidden = YES;
        self.lbl_emptyMsg.hidden = NO;
    } else {
        tbView.hidden = NO;
        self.lbl_emptyMsg.hidden = YES;
        [tbView reloadData];
    }
//	
//	[self getScenariosfromDB];
	
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

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [self setLbl_emptyMsg:nil];
    [self setImgView_header:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[arrayScenarios release];
    [_lbl_emptyMsg release];
    [_imgView_header release];
    [super dealloc];
}

//-(void)getScenariosfromDB
//{
//	if([arrayScenarios count] != 0)
//	{
//		[arrayScenarios removeAllObjects];
//	}
//	QuizAppDelegate *app = (QuizAppDelegate *)[[UIApplication sharedApplication] delegate];
//	sqlite3 *database = [app getDatabase];
//	sqlite3_stmt * statements=nil;
//	
//	//get default category first
//	if (statements == nil) {
//		char *sql;
//		if (_type == 0) {
//			sql = "select id, name, file, book from scenarios WHERE book=1";
//		}else {
//			sql = "select id, name, file, book from skillsheet WHERE book=1 ORDER by s_order";
//		}
//		
//        if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
//            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
//        }else{
//			while(sqlite3_step(statements) == SQLITE_ROW){
//				ScenariosBean *sBean = [[ScenariosBean alloc] init];
//				sBean.sID = sqlite3_column_int(statements, 0);
//			    if (sqlite3_column_text(statements, 1)) {
//					sBean.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 1)];
//				}else {
//					sBean.name = @"";
//				}
//				if (sqlite3_column_text(statements, 2)) {
//					sBean.filename = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 2)];
//				}else {
//					sBean.filename = @"";
//				}
//				sBean.b_bookmark = sqlite3_column_int(statements, 3);
//				
//				[arrayScenarios addObject:sBean];
//				[sBean release];
//			}
//			sqlite3_finalize(statements);
//			statements = nil;
//		}
//	}
//}

#pragma mark UITableView methods

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	SceneDetailViewController *sdViewController = [[SceneDetailViewController alloc] initWithNibName:@"SceneDetailViewController" bundle:nil];
	sdViewController._current_index = indexPath.row;
	sdViewController._type = _type;
	sdViewController.array_Scenearios = arrayScenarios;
	[self.navigationController pushViewController:sdViewController animated:YES];
	[sdViewController release];
}

-(UITableViewCell *) tableView:(UITableView *) tv cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
	
	ScenariosBean *sBean = [arrayScenarios objectAtIndex:indexPath.row];
	cell.textLabel.text = sBean.name;
	
	cell.textLabel.textAlignment = UITextAlignmentCenter;
	cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
}

-(NSInteger) tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger) section
{
	return [arrayScenarios count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40.0;
}

@end
