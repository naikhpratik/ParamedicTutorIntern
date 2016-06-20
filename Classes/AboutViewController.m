//
//  AboutViewController.m
//  Quiz
//
//  Created by Zorro on 3/14/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController

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
	self.navigationItem.title = @"About";
	
	/*NSString *filePath = [[NSBundle mainBundle] pathForResource: @"About" ofType:@"htm"];
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	
	//NSString *myHTML = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
	//NSLog(@"html=%@", myHTML);
	
	webView.delegate = self;
	//[webView loadHTMLString:myHTML baseURL:baseURL];
	
    NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];
    [webView loadRequest:request];*/
    
    NSString 
	*mainBundleDirectory = [[NSBundle mainBundle] bundlePath];
	NSString 
	*path = [mainBundleDirectory  stringByAppendingPathComponent:@"About.htm"];
	NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[webView setOpaque:NO];
	webView.backgroundColor= [UIColor clearColor];
	webView.delegate = self;
	
    [webView loadRequest:request];
    
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	//NSLog(@"%@", request.URL.relativePath);
	NSString *mainBundleDirectory = [[NSBundle mainBundle] bundlePath];
	NSString *path = [mainBundleDirectory  stringByAppendingPathComponent:@"About.htm"];
	NSURL *url = [NSURL fileURLWithPath:path];
	//NSLog(@"%@", url.relativePath);
	
	if (![request.URL.relativePath isEqualToString: url.relativePath]) {
		[[UIApplication sharedApplication] openURL:[request URL]];
		return NO;
	}
	return YES;
}

@end
