//
//  SceneDetailViewController-ipad.m
//  Quiz
//
//  Created by Arthur on 13-9-14.
//
//

#import "SceneDetailViewController-ipad.h"
#import "SceneImageViewController-iPad.h"
#import "ScenariosBean.h"
#import "SqlMB.h"



#define kWebViewOriginalX 27
#define kWebViewOriginalY 235
#define kWebViewWidth 715
#define kWebViewHeight 735
#define kWebViewCenterY 610
#define kHideCenterX 384
#define kHideCenterRightX 1152
@interface SceneDetailViewController_ipad ()

@end

@implementation SceneDetailViewController_ipad
@synthesize _current_index, array_Scenearios, mode, _type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _card_page_index = 0;
    [_superView addSubview:_webView];
    
    if (_type == 0) {
		_bgImageHeader.image = [UIImage imageNamed:@"scenarios_bar_iPad_mini.png"];
		self.navigationItem.title = @"Scenarios";
	}else if (_type == 1){
		_bgImageHeader.image = [UIImage imageNamed:@"toolbox_bar_iPad_mini.png"];
		self.navigationItem.title = @"Skill Sheets";
	}else {
		_bgImageHeader.image = [UIImage imageNamed:@"toolbox_bar_iPad_mini.png"];
		self.navigationItem.title = @"Differential Rule Outs";
        //        webView.scrollView.bounces = NO;
	}

    NSString *filename;
    _webView.frame = CGRectMake(0, 0, kWebViewWidth, kWebViewHeight);

	if (_type == 2) {
		filename = @"Differential Rule Outs";
		_lbTitle.text = @"Differential Rule Outs";
		_tBar.hidden = YES;
		
	}else {
        ScenariosBean *sBean = [array_Scenearios objectAtIndex:_current_index];
		_lbTitle.text = sBean.name;
		filename = sBean.filename;
	}
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource: filename ofType:@"html"];
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	
	NSString *myHTML = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:myHTML baseURL:baseURL];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_bgImageHeader release];
    [_lbTitle release];
    [_superView release];
    [_theRightView release];
    [_theLeftView release];
    [_webView release];
    [_tBar release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBgImageHeader:nil];
    [self setLbTitle:nil];
    [self setSuperView:nil];
    [self setTheRightView:nil];
    [self setTheLeftView:nil];
    [self setWebView:nil];
    [self setTBar:nil];
    [super viewDidUnload];
}

#pragma mark - 
#pragma mark - Touch methods

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
			_theRightView.center = CGPointMake(-kHideCenterX, kWebViewCenterY);
			break;
		case 1:
			_theLeftView.center = CGPointMake(-kHideCenterX, kWebViewCenterY);
			break;
		case 2:
			_superView.center = CGPointMake(-kHideCenterX, kWebViewCenterY);
			break;
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.6];
	
	switch (_card_page_index) {
		case 0:
			_theRightView.center = CGPointMake(kHideCenterX, kWebViewCenterY);
			[self.view bringSubviewToFront:_theRightView];
			_card_page_index = 1;
			break;
		case 1:
			_theLeftView.center = CGPointMake(kHideCenterX, kWebViewCenterY);
			[self.view bringSubviewToFront:_theLeftView];
			_card_page_index = 2;
			break;
		case 2:
			_superView.center = CGPointMake(kHideCenterX, kWebViewCenterY);
			[self.view bringSubviewToFront:_superView];
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
			_theRightView.center = CGPointMake(kHideCenterRightX, kWebViewCenterY);
			break;
		case 1:
			_theLeftView.center = CGPointMake(kHideCenterRightX, kWebViewCenterY);
			break;
		case 2:
			_superView.center = CGPointMake(kHideCenterRightX, kWebViewCenterY);
			break;
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.6];
	
	switch (_card_page_index) {
		case 0:
			_theRightView.center = CGPointMake(kHideCenterX, kWebViewCenterY);
			[self.view bringSubviewToFront:_theRightView];
			_card_page_index = 1;
			break;
		case 1:
			_theLeftView.center = CGPointMake(kHideCenterX, kWebViewCenterY);
			[self.view bringSubviewToFront:_theLeftView];
			_card_page_index = 2;
			break;
		case 2:
			_superView.center = CGPointMake(kHideCenterX, kWebViewCenterY);
			[self.view bringSubviewToFront:_superView];
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
			NSArray *views = [_theRightView subviews];
			for (int i=0; i<[views count]; i++) {
				UIView *subView = [views objectAtIndex:i];
				[subView removeFromSuperview];
			}
			[_theRightView addSubview:_webView];
		}
			break;
		case 1:
		{
			NSArray *views = [_theLeftView subviews];
			for (int i=0; i<[views count]; i++) {
				UIView *subView = [views objectAtIndex:i];
				[subView removeFromSuperview];
			}
			
			[_theLeftView addSubview:_webView];
		}
			break;
		case 2:
		{
			NSArray *views = [_superView subviews];
			for (int i=0; i<[views count]; i++) {
				UIView *subView = [views objectAtIndex:i];
				[subView removeFromSuperview];
			}
			[_superView addSubview:_webView];
		}
			break;
	}
	
    NSLog(@"webview frame = %@",NSStringFromCGRect(_webView.frame));
	ScenariosBean *sBean = [array_Scenearios objectAtIndex:_current_index];
	_lbTitle.text = sBean.name;
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource: sBean.filename ofType:@"html"];
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	
	NSString *myHTML = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
	//NSLog(@"html=%@", myHTML);
	
	//webView.delegate = self;
	//[webView loadRequest:[NSURLRequest requestWithURL:fileURL]];
	[_webView loadHTMLString:myHTML baseURL:baseURL];
}


#pragma mark -
#pragma mark - IBAction methods


- (IBAction)previous:(id)sender {
    [self turnMenuToRight];
}

- (IBAction)next:(id)sender {
    [self turnMenuToLeft];
}

- (IBAction)addtoBookmark:(id)sender {
    
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
        SceneImageViewController_iPad *scenarionImageViewController = [[SceneImageViewController_iPad alloc] initWithNibName:kiPadScenarioImageControllerNibName bundle:nil];
        scenarionImageViewController.ekgImageName = [tokenArray objectAtIndex:tokenArray.count - 1];
        [self.navigationController pushViewController:scenarionImageViewController animated:YES];
        
        return NO;
    }
    
    return YES;
}

@end
