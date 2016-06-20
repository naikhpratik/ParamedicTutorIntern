//
//  FollowViewController.m
//  Quiz
//
//  Created by sandra on 5/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FollowViewController.h"


@implementation FollowViewController

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
	self.navigationItem.title = @"Follow";
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    if (iPhone5) {
        self.background_image.image = [UIImage imageNamed:@"home_iP5"];
        
    } else {
        self.background_image.image = [UIImage imageNamed:@"home_iP4"];
    }
    
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
    [self setBackground_image:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [_background_image release];
    [super dealloc];
}

-(IBAction)linkWeb: (id)sender
{
	NSString *sURL = nil;
	switch ([sender tag]) {
		case 1:  //Facebook
			sURL = kFacebookFollowLink;
			break;
		case 2: //twitter
			sURL = kTwitterFollowLink;
			break;
		case 3:  //blog
		    sURL = kBlogFollowLink;
			break;
        case 4:  //FFBP
		    sURL = kFireFighterFollowLink;
			break;

		default:
			break;
	}
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: sURL]];
}

@end
