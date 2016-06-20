//
//  FollowViewController-ipad.m
//  Quiz
//
//  Created by Arthur on 13-9-16.
//
//

#import "FollowViewController-ipad.h"

@interface FollowViewController_ipad ()

@end

@implementation FollowViewController_ipad

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
    self.navigationItem.title = @"Follow";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)linkWeb: (id)sender
{
	NSString *sURL = nil;
	switch ([sender tag]) {
		case 1:  //Facebook
			sURL = @"http://www.facebook.com/pages/Code-3-Apps/180948875248863";
			break;
		case 2: //twitter
			sURL = @"http://twitter.com/#!/Code3Apps";
			break;
		case 3:  //blog
		    sURL = @"http://code3-apps.com/";
			break;
        case 4:  //FFBP
		    sURL = @"http://itunes.apple.com/us/app/firefighter-pocketbook/id483659354?mt=8";
			break;
            
		default:
			break;
	}
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: sURL]];
}

@end
