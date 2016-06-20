//
//  ReferenceViewController.m
//  Firefighter
//
//  Created by sandra on 11/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReferenceViewController.h"
//#import "FirefighterAppDelegate.h"
#import "SqlMB.h"
#import "CardBean.h"
#import "StringHelper.h"
#import "RefDetailViewController.h"

@implementation ReferenceViewController
@synthesize imgView_Reference = _imgView_Reference;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"References";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"Back";
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  [UIColor grayColor],
                                                                                                  UITextAttributeTextColor,
                                                                                                  [UIColor darkGrayColor],
                                                                                                  UITextAttributeTextShadowColor,
                                                                                                  [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                                                                                                  UITextAttributeTextShadowOffset,
                                                                                                  nil]
                                                                                        forState:UIControlStateNormal];
	arr_References = [[NSMutableArray alloc] init];
	filterArray = [[NSMutableArray alloc] init];
	[self getDatafromDB];
    if (iPhone5) {
//        self.imgView_Reference.image = [UIImage imageNamed:@"toolbox-menu-background-5"];
    } else {
//        self.imgView_Reference.image = [UIImage imageNamed:@"toolbox-menu-background"];
    }
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
    [self setImgView_Reference:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[filterArray release];
	[arr_References release];
	
    [_imgView_Reference release];
    [super dealloc];
}

-(void)getDatafromDB
{
	if ([filterArray count] != 0) {
		[filterArray removeAllObjects];
	}
	if([arr_References count] != 0)
	{
		[arr_References removeAllObjects];
	}
    [[SqlMB getInstance] getAllCardsFromReference:arr_References filtered:filterArray];
}


#pragma mark UITableView methods

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	CardBean *cBean = [filterArray objectAtIndex:indexPath.row];
	RefDetailViewController *refDetail = [[RefDetailViewController alloc] initWithNibName:@"RefDetailViewController" bundle:nil];
	refDetail.cardBean = cBean;
	[self.navigationController pushViewController:refDetail animated:YES];
	[refDetail release];
}

-(UITableViewCell *) tableView:(UITableView *) tv cellForRowAtIndexPath:(NSIndexPath *) indexPath
{

    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
	CardBean *cBean = [filterArray objectAtIndex:indexPath.row];
	cell.textLabel.text = cBean.question;
    
//	CGFloat height = [cBean.question RAD_textHeightForFontOfSize:[UIFont fontWithName:@"Helvetica-Bold" size:20.0] width:300]+10;
	
//    UILabel *lbHeader = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, height)];
//	lbHeader.text = cBean.question;
//	lbHeader.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
//	lbHeader.numberOfLines = 0;
//	lbHeader.textColor = [UIColor blackColor];
//	lbHeader.backgroundColor = [UIColor clearColor];
//    lbHeader.textAlignment = NSTextAlignmentCenter;
//	[cell addSubview:lbHeader];
//	[lbHeader release];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
}

-(NSInteger) tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger) section
{
	return [filterArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{	
//	CardBean *sBean = [filterArray objectAtIndex:indexPath.row];
//	CGFloat height = [sBean.question RAD_textHeightForFontOfSize:[UIFont fontWithName:@"Helvetica-Bold" size:20.0] width:300]+10;
//		
//	return height;
    return 44.0f;
}

#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	// only show the status bar's cancel button while in edit mode
	mySearchBar.showsCancelButton = YES;
	[tbView setAlpha:0.7f];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	mySearchBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[tbView setAlpha:1.0f];
	
	// search the table content for cell titles that match "searchText"
	// if found add to the mutable array and force the table to reload
	//
	if([searchText length] == 0)
	{
		[filterArray removeAllObjects];
		[filterArray addObjectsFromArray:arr_References];
	}else 
	{
		[filterArray removeAllObjects];
		for(int i=0; i<[arr_References count]; i++)
		{
			CardBean *cbean = [arr_References objectAtIndex:i];
			
			NSRange nameRange = [cbean.question rangeOfString:searchText options:NSCaseInsensitiveSearch];
			if(!(nameRange.location == NSNotFound || nameRange.length == 0)) {
				[filterArray addObject:cbean];
			}
		}
	}
	[tbView reloadData];
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[tbView setAlpha:1.0f];
	// if a valid search was entered but the user wanted to cancel, bring back the saved list content
	if (searchBar.text.length > 0)
	{
		[filterArray removeAllObjects];
		[filterArray addObjectsFromArray:arr_References];
	}
	
	[tbView reloadData];
	
	[mySearchBar resignFirstResponder];
	mySearchBar.text = @"";
}

// called when Search (in our case "Done") button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[tbView setAlpha:1.0f];
	[mySearchBar resignFirstResponder];
}

@end
