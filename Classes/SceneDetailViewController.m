//
//  SceneDetailViewController.m
//  Quiz
//
//  Created by Zorro on 2/27/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import "SceneDetailViewController.h"
#import "SceneImageViewController.h"
#import "ScenariosBean.h"
#import "QuizAppDelegate.h"
#import "SqlMB.h"

#define kWebViewCenterY iPhone5 ? 287:246//256 : 215

@implementation SceneDetailViewController

@synthesize _current_index, array_Scenearios, mode, _type;
@synthesize view_Header = _view_Header;
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
	superView.backgroundColor = [UIColor clearColor];
	theLeftView.backgroundColor = [UIColor clearColor];
	theRightView.backgroundColor = [UIColor clearColor];
	_card_page_index = 0;
	[superView addSubview:webView];
	
	//CGPoint pt = superView.center;
	if (_type == 0) {
		bgImageHeader.image = [UIImage imageNamed:@"scenario_bar.png"];
		self.navigationItem.title = @"Scenarios";
	}else if (_type == 1){
		bgImageHeader.image = [UIImage imageNamed:@"toolbox_bar.png"];
		self.navigationItem.title = @"Skill Sheets";
	}else {
		bgImageHeader.image = [UIImage imageNamed:@"toolbox_bar.png"];
		self.navigationItem.title = @"Differential Rule Outs";
//        webView.scrollView.bounces = NO;
	}

	NSString *filename;
	if (_type == 2) {
		filename = @"Differential Rule Outs";
		lbTitle.text = @"Differential Rule Outs";
		tBar.hidden = YES;
		superView.frame = CGRectMake(superView.frame.origin.x, superView.frame.origin.y, superView.frame.size.width, superView.frame.size.width+tBar.frame.size.height);
        webView.frame = CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, self.view.bounds.size.height - bgImageHeader.frame.size.height- self.view_Header.frame.size.height);
	}else {
        webView.frame = CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, self.view.bounds.size.height - bgImageHeader.frame.size.height- self.view_Header.frame.size.height-tBar.frame.size.height);
        
		ScenariosBean *sBean = [array_Scenearios objectAtIndex:_current_index];
		lbTitle.text = sBean.name;
		filename = sBean.filename;
	}   
    
	NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"html"];
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	
	NSString *myHTML = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
	[webView loadHTMLString:myHTML baseURL:baseURL];
	
    
    viewCenterHeight = superView.center.y + 8;
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:kDeviceOrientationKey];
    
    //viewCenterHeight = superView.center.y;
}

// Override to allow orientations other than the default portrait orientation.
/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //return ((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft));
}*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [self setView_Header:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[lbTitle release];
	[webView release];
    [_view_Header release];
    [super dealloc];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.view];
	
    if (_type == 2) { // if Differential, cannot need flip 
        return;
    }else {
        if (currentTouchPosition.x-_tmp_x>5) {    //turn right
            [self turnMenuToRight];
        }else if (currentTouchPosition.x-_tmp_x<-5) {    //turn left
            [self turnMenuToLeft];
        }
    }
    
	
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = (UITouch *)[touches anyObject];
	CGPoint location = [touch locationInView:self.view];
	_tmp_x =location.x;
	_tmp_y = location.y;
}

-(void)turnMenuToRight
{
	if (_current_index == 0) {
		_current_index = [array_Scenearios count];
	}
	_current_index--;
	[self updateCard];
	switch (_card_page_index) {
		case 0:
			theRightView.center = CGPointMake(-160.0, viewCenterHeight);
			break;
		case 1:
			theLeftView.center = CGPointMake(-160.0, viewCenterHeight);
			break;
		case 2:
			superView.center = CGPointMake(-160.0, viewCenterHeight);
			break;	
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.6];
	
	switch (_card_page_index) {
		case 0:
			theRightView.center = CGPointMake(160.0, viewCenterHeight);
			[self.view bringSubviewToFront:theRightView];
			_card_page_index = 1;
			break;
		case 1:
			theLeftView.center = CGPointMake(160.0, viewCenterHeight);
			[self.view bringSubviewToFront:theLeftView];
			_card_page_index = 2;
			break;
		case 2:
			superView.center = CGPointMake(160.0, viewCenterHeight);
			[self.view bringSubviewToFront:superView];
			_card_page_index = 0;
			break;	
	}
	//[self updateArrow];
	[UIView commitAnimations];
}

-(void)turnMenuToLeft
{
	if (_current_index+1 == [array_Scenearios count]) {
		//return;
		_current_index = -1;
	}
	_current_index++;
	[self updateCard];
	switch (_card_page_index) {
		case 0:
			theRightView.center = CGPointMake(480, viewCenterHeight);
			break;
		case 1:
			theLeftView.center = CGPointMake(480, viewCenterHeight);
			break;
		case 2:
			superView.center = CGPointMake(480, viewCenterHeight);
			break;	
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.6];
	
	switch (_card_page_index) {
		case 0:
			theRightView.center = CGPointMake(160.0, viewCenterHeight);
			[self.view bringSubviewToFront:theRightView];
			_card_page_index = 1;
			break;
		case 1:
			theLeftView.center = CGPointMake(160.0, viewCenterHeight);
			[self.view bringSubviewToFront:theLeftView];
			_card_page_index = 2;
			break;
		case 2:
			superView.center = CGPointMake(160.0, viewCenterHeight);
			[self.view bringSubviewToFront:superView];
			_card_page_index = 0;
			break;	
	}
	//[self updateArrow];
	[UIView commitAnimations];
}

-(void)updateCard
{
	switch (_card_page_index) {
		case 0:
		{
			NSArray *views = [theRightView subviews];
			for (int i=0; i<[views count]; i++) {
				UIView *subView = [views objectAtIndex:i];
				[subView removeFromSuperview];
			}
			[theRightView addSubview:webView];
		}
			break;
		case 1:
		{
			NSArray *views = [theLeftView subviews];
			for (int i=0; i<[views count]; i++) {
				UIView *subView = [views objectAtIndex:i];
				[subView removeFromSuperview];
			}
			
			[theLeftView addSubview:webView];
		}
			break;
		case 2:
		{
			NSArray *views = [superView subviews];
			for (int i=0; i<[views count]; i++) {
				UIView *subView = [views objectAtIndex:i];
				[subView removeFromSuperview];
			}
			[superView addSubview:webView];
		}
			break;	
	}
	
	ScenariosBean *sBean = [array_Scenearios objectAtIndex:_current_index];
	lbTitle.text = sBean.name;
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource: sBean.filename ofType:@"html"];
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	
	NSString *myHTML = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
	//NSLog(@"html=%@", myHTML);
	
	//webView.delegate = self;
	//[webView loadRequest:[NSURLRequest requestWithURL:fileURL]];
	[webView loadHTMLString:myHTML baseURL:baseURL];
}

-(IBAction)previous: (id)sender
{
	[self turnMenuToRight];
}

-(IBAction)next: (id)sender
{
	[self turnMenuToLeft];
}

-(IBAction)addtoBookmark: (id)sender
{
	ScenariosBean *sBean = [array_Scenearios objectAtIndex:_current_index];
	NSString *strMessage;
	switch (_type) {
		case 0:
		{
			if (sBean.b_bookmark) {  //unbook
				strMessage = @"Do you want to unbookmark this scenario?";
			}else {   //book
				strMessage = @"Do you want to bookmark this scenario?";
			}
		}
			break;
		case 1:
		{
			if (sBean.b_bookmark) {  //unbook
				strMessage = @"Do you want to unbookmark this skill sheet?";
			}else {   //book
				strMessage = @"Do you want to bookmark this skill sheet?";
			}
		}
			break;
		default:
			break;
	}
	
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BOOKMARK" message:strMessage
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
	[alert show];
	[alert release];
}


//-(void)unbook: (int)sID
//{
//	QuizAppDelegate *appDelegate = (QuizAppDelegate*)[[UIApplication sharedApplication] delegate];
//	sqlite3 *db = [appDelegate getDatabase];
//	sqlite3_stmt * statements=nil;
//	if (statements == nil) {
//		char *sql;
//		if (_type == 0) {
//			sql = "update scenarios set book=? where id=?";
//		}else {
//			sql = "update skillsheet set book=? where id=?";
//		}
//		
//		if (sqlite3_prepare_v2(db, sql, -1, &statements, NULL) != SQLITE_OK) {
//			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
//		}
//		sqlite3_bind_int(statements, 1, 0);
//		sqlite3_bind_int(statements, 2, sID);
//	}
//	int success = sqlite3_step(statements);
//	if (success == SQLITE_ERROR) {
//		NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(db));
//	}    	
//	sqlite3_finalize(statements);
//	statements = nil;
//}
//
//-(void)book: (int)sID
//{
//	QuizAppDelegate *appDelegate = (QuizAppDelegate*)[[UIApplication sharedApplication] delegate];
//	sqlite3 *db = [appDelegate getDatabase];
//	sqlite3_stmt * statements=nil;
//	if (statements == nil) {
//		char *sql;
//		if (_type == 0) {
//			sql = "update scenarios set book=?,bookTime=? where id=?";
//		}else {
//			sql = "update skillsheet set book=?,bookTime=? where id=?";
//		}
//		
//		if (sqlite3_prepare_v2(db, sql, -1, &statements, NULL) != SQLITE_OK) {
//			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
//		}
//		sqlite3_bind_int(statements, 1, 1);
//		NSDate *date = [NSDate date];
//		int iInterval = [date timeIntervalSince1970];
//		sqlite3_bind_int(statements, 2, iInterval);
//		sqlite3_bind_int(statements, 3, sID);
//	}
//	int success = sqlite3_step(statements);
//	if (success == SQLITE_ERROR) {
//		NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(db));
//	}    	
//	sqlite3_finalize(statements);
//	statements = nil;
//}

#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {   //OK
		ScenariosBean *sBean = [array_Scenearios objectAtIndex:_current_index];
		if ([alertView.message isEqualToString:@"Do you want to unbookmark this skill sheet?"] || [alertView.message isEqualToString:@"Do you want to unbookmark this scenario?"]) {  //unbook
            if (_type == 0) {
                [[SqlMB getInstance] bookmarkScen:sBean.sID BookMark:NO isSkillSheet:NO];
            } else {
                [[SqlMB getInstance] bookmarkScen:sBean.sID BookMark:NO isSkillSheet:YES];
            }
            
//			[self unbook: sBean.sID];
			sBean.b_bookmark = NO;
		}else {    //book
//			[self book:sBean.sID];
            if (_type == 0) {
                [[SqlMB getInstance] bookmarkScen:sBean.sID BookMark:YES isSkillSheet:NO];
            } else {
                [[SqlMB getInstance] bookmarkScen:sBean.sID BookMark:YES isSkillSheet:YES];
            }
			sBean.b_bookmark = YES;
		}
	}
}


#pragma mark - UIWebView Delegate


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[request URL] absoluteString];
    
    if ([urlString rangeOfString:@".png"].location != NSNotFound) {
        
        NSArray *tokenArray = [urlString componentsSeparatedByString:@"/"];
        SceneImageViewController *scenarionImageViewController = [[SceneImageViewController alloc] initWithNibName:kScenarioImageControllerNibName bundle:nil];
        scenarionImageViewController.ekgImageName = [tokenArray objectAtIndex:tokenArray.count - 1];
        [self.navigationController pushViewController:scenarionImageViewController animated:YES];
        
        return NO;
    }
    
    return YES;
}

@end
