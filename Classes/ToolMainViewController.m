//
//  ToolMainViewController.m
//  Quiz
//
//  Created by Zorro on 3/9/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import "ToolMainViewController.h"
#import "SkillsheetViewController.h"
#import "SceneDetailViewController.h"
#import "ListViewController.h"
#import "ReferenceViewController.h"
#import "BookSceViewController.h"
#import "SqlMB.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation ToolMainViewController
@synthesize tbView = _tbView;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"tool_page"];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    [[GAI sharedInstance] dispatch];
    if (iPhone5) {
        self.tool_bg_imageView.image = [UIImage imageNamed:@"toolbox-menu-background-5"];
    } else {
        self.tool_bg_imageView.image = [UIImage imageNamed:@"toolbox-menu-background"];
    }
}


-(void) viewWillAppear:(BOOL)animated
{
	self.navigationItem.title = @"Tool Box";
    [self.tbView reloadData];
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
    [self setTool_bg_imageView:nil];
    [self setTbView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [_tool_bg_imageView release];
    [_tbView release];
    [super dealloc];
}

-(IBAction)checkOff:(id)sender {
    ListViewController *listViewController = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
	listViewController.chapter = @"Medical";
	listViewController._id = 2;
	[self.navigationController pushViewController:listViewController animated:YES];
	[listViewController release];
}

- (IBAction)btnpressed_reference:(id)sender {
    ReferenceViewController *refView = [[ReferenceViewController alloc] initWithNibName:@"ReferenceViewController" bundle:nil];
    [self.navigationController pushViewController:refView animated:YES];
    [refView release];
}

-(IBAction)skillsheets: (id)sender
{
	SkillsheetViewController *skillsheetViewController = [[SkillsheetViewController alloc] initWithNibName:@"SkillsheetViewController" bundle:nil];
	[self.navigationController pushViewController:skillsheetViewController animated:YES];
	[skillsheetViewController release];
}

-(IBAction)DCO: (id)sender
{
	SceneDetailViewController *sceneDetailViewController = [[SceneDetailViewController alloc] initWithNibName:@"SceneDetailViewController" bundle:nil];
	sceneDetailViewController._type = 2;
	[self.navigationController pushViewController:sceneDetailViewController animated:YES];
	[sceneDetailViewController release];
}

-(IBAction)skillsheetBookmarks:(id)sender
{
    BookSceViewController *bookmarkListViewController = [[BookSceViewController alloc] initWithNibName:@"BookSceViewController" bundle:nil];
	bookmarkListViewController._type = 1;
	[self.navigationController pushViewController:bookmarkListViewController animated:YES];
	[bookmarkListViewController release];
}

#pragma mark - UITableView methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomMainViewCell *cell = (CustomMainViewCell *)[tableView dequeueReusableCellWithIdentifier:@"mainQuizCell"];
	if (cell == nil) {
        cell = (CustomMainViewCell *)[[[NSBundle mainBundle]loadNibNamed:@"CustomMainViewCell" owner:self options:nil]objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0) {
        [cell.btn_content setImage:[UIImage imageNamed:@"differentials_n"] forState:UIControlStateNormal];
    } else if (indexPath.row == 1) {
        [cell.btn_content setImage:[UIImage imageNamed:@"MedScene_n"] forState:UIControlStateNormal];
    } else if (indexPath.row == 2) {
        [cell.btn_content setImage:[UIImage imageNamed:@"refterms_n"] forState:UIControlStateNormal];
    } else if (indexPath.row == 3) {
        [cell.btn_content setImage:[UIImage imageNamed:@"bookmarks_n"] forState:UIControlStateNormal];
    } else if (indexPath.row == 4) {
        [cell.btn_content setImage:[UIImage imageNamed:@"bookmarks_n"] forState:UIControlStateNormal];
    }
	cell.btn_content.tag = indexPath.row + 1;
    [cell.btn_content addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0f;
}

- (void)btnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if (btn.tag == 1) {
        [self DCO:nil];
    } else if (btn.tag == 2) {
        [self checkOff:nil];
    } else if (btn.tag == 3) {
        [self btnpressed_reference:nil];
    } else if (btn.tag == 4) {
        [self skillsheets:nil];
    } else if (btn.tag == 5) {
        [self skillsheetBookmarks:nil];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self DCO:nil];
    } else if (indexPath.row == 1) {
        [self checkOff:nil];
    } else if (indexPath.row == 2) {
        [self btnpressed_reference:nil];
    } else if (indexPath.row == 3) {

        [self skillsheetBookmarks:nil];
    } else if (indexPath.row == 4) {
        [self skillsheetBookmarks:nil];
    }
}

@end
