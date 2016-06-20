//
//  SceneMainViewController.m
//  Quiz
//
//  Created by Zorro on 2/27/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import "SceneMainViewController.h"
#import "SceneDetailViewController.h"
#import "ScenariosBean.h"
#import "QuizAppDelegate.h"
#import "BookSceViewController.h"
#import "SceneChapterViewController.h"
#import "SqlMB.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation SceneMainViewController

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
    
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"scen_page"];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    [[GAI sharedInstance] dispatch];
    if (iPhone5) {
        self.scenarios_bg_imageView.image = [UIImage imageNamed:@"ScenariosMenu-5"];
    } else {
        self.scenarios_bg_imageView.image = [UIImage imageNamed:@"ScenariosMenu"];
    }
	arrayScenarios = [[NSMutableArray alloc] init];
	tbView.backgroundColor = [UIColor clearColor];
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
	self.navigationItem.title = @"Scenarios";
    [[SqlMB getInstance] getScenariosFromDB:arrayScenarios bookType:NO isSkillSheet:NO];
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
    [self setScenarios_bg_imageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[arrayScenarios release];
    [_scenarios_bg_imageView release];
    [super dealloc];
}

- (void)gotoChapter:(id)sender
{
    SceneChapterViewController *chapterView = [[SceneChapterViewController alloc] initWithNibName:@"SceneChapterViewController" bundle:nil];
    [self.navigationController pushViewController:chapterView animated:YES];
    [chapterView release];
}

-(IBAction)bookMark: (id)sender
{
	BookSceViewController *bookmarkListViewController = [[BookSceViewController alloc] initWithNibName:@"BookSceViewController" bundle:nil];
	bookmarkListViewController._type = 0;
	[self.navigationController pushViewController:bookmarkListViewController animated:YES];
	[bookmarkListViewController release];
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
//		char *sql = "select id, name, file, book from scenarios";
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
- (void)btnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if (btn.tag == 1) {
        [self gotoChapter:nil];
    } else if (btn.tag == 2) {
        [self bookMark:nil];
    }
}
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self gotoChapter:nil];
    } else if (indexPath.row == 1) {
        [self bookMark:nil];
    }
    /*
	SceneDetailViewController *sdViewController = [[SceneDetailViewController alloc] initWithNibName:@"SceneDetailViewController" bundle:nil];
	sdViewController._current_index = indexPath.row;
	sdViewController._type = 0;
	sdViewController.array_Scenearios = arrayScenarios;
	[self.navigationController pushViewController:sdViewController animated:YES];
	[sdViewController release];
     */
}

-(UITableViewCell *) tableView:(UITableView *) tv cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
	CustomMainViewCell *cell = (CustomMainViewCell *)[tv dequeueReusableCellWithIdentifier:@"mainQuizCell"];
	if (cell == nil) {
        cell = (CustomMainViewCell *)[[[NSBundle mainBundle]loadNibNamed:@"CustomMainViewCell" owner:self options:nil]objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0) {
        [cell.btn_content setImage:[UIImage imageNamed:@"scenarios_n"] forState:UIControlStateNormal];
    } else if (indexPath.row == 1) {
        [cell.btn_content setImage:[UIImage imageNamed:@"bookmarks_n"] forState:UIControlStateNormal];
    }
	cell.btn_content.tag = indexPath.row + 1;
    [cell.btn_content addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
	return cell;
}

-(NSInteger) tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger) section
{
	return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	return 85.0;
}

@end
