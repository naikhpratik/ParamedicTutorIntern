//
//  SkillsheetViewController.m
//  Quiz
//
//  Created by Zorro on 3/9/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import "SkillsheetViewController.h"
#import "SceneDetailViewController.h"
#import "ScenariosBean.h"
#import "QuizAppDelegate.h"
#import "BookSceViewController.h"
#import "SqlMB.h"

@implementation SkillsheetViewController

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
	arrayChapters = [[NSMutableArray alloc] init];
	tbView.backgroundColor = [UIColor clearColor];
	//[self getChaptersfromDB];
//    if (iPhone5) {
//        self.imgView_skillSheet.image = [UIImage imageNamed:@"toolbox-menu-background-5"];
//    } else {
//        self.imgView_skillSheet.image = [UIImage imageNamed:@"toolbox-menu-background"];
//    }
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void) viewWillAppear:(BOOL)animated
{
	self.navigationItem.title = @"Skill Sheets";
//	[self getScenariosfromDB];
    [[SqlMB getInstance] getAllSkillSheetFromDBForToolBox:arrayChapters];
}


- (void)viewWillDisappear:(BOOL)animated
{
	self.navigationItem.title = @"Back";
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [self setImgView_skillSheet:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[arrayChapters release];
    [_imgView_skillSheet release];
    [super dealloc];
}

-(IBAction)bookMark: (id)sender
{
	BookSceViewController *bookmarkListViewController = [[BookSceViewController alloc] initWithNibName:@"BookSceViewController" bundle:nil];
	bookmarkListViewController._type = 1;
	[self.navigationController pushViewController:bookmarkListViewController animated:YES];
	[bookmarkListViewController release];
}

//-(void)getScenariosfromDB
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
//		char *sql = "select id, name, file, book, is_other from skillsheet ORDER by s_order";
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
//				sBean.b_others = sqlite3_column_int(statements, 4);
//                
//				[arrayChapters addObject:sBean];
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

	SceneDetailViewController *sceneDetailViewController = [[SceneDetailViewController alloc] initWithNibName:@"SceneDetailViewController" bundle:nil];
    if (indexPath.section == 0) {
        sceneDetailViewController._current_index = indexPath.row;
    } else {
        sceneDetailViewController._current_index = indexPath.row + 10;
    }
	sceneDetailViewController._type = 1;
    sceneDetailViewController.array_Scenearios = arrayChapters;
    
	
	[self.navigationController pushViewController:sceneDetailViewController animated:YES];
	[sceneDetailViewController release];
}

-(UITableViewCell *) tableView:(UITableView *) tv cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
    
    ScenariosBean *sBean;
    if (indexPath.section == 0) {
        sBean = [arrayChapters objectAtIndex:indexPath.row];
    }else {
        sBean = [arrayChapters objectAtIndex:indexPath.row + 10];
    }
    cell.textLabel.text = sBean.name;
        
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
//    cell.textLabel.numberOfLines = 0;

    
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName = @"";
    if (section == 0) {
        sectionName = @"  - NREMT Required Skill Sheets -";
    } else {
        sectionName = @"             - Other Skill Sheets -";
    }
    return sectionName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger) tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger) section
{
	if (section == 0) {
        return 10;
    } else {
        return [arrayChapters count] - 10;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	return 44.0f;
}

@end
