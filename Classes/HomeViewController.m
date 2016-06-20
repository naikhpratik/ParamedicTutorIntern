//
//  HomeViewController.m
//  Quiz
//
//  Created by Zorro on 2/15/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import "HomeViewController.h"
#import "QuizMainViewController.h"
#import "SceneMainViewController.h"
#import "FlashcardMainViewController.h"
#import "ToolMainViewController.h"
#import "AboutViewController.h"
#import "FollowViewController.h"
#import "AFKReviewTroller.h"
#import "DosingViewController.h"
#import "CardiologyViewController.h"
//#import "DosingMainViewController.h"
//#import "CarioMainViewController.h"

#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@implementation HomeViewController

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
    
    // set background
    if (iPhone5) {
        self.home_bg_imageView.image = [UIImage imageNamed:@"home_iP5"];
        
    } else {
        self.home_bg_imageView.image = [UIImage imageNamed:@"home_iP4"];
    }
    
	UIBarButtonItem *_rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStyleBordered target:self action:@selector(about:)];
	self.navigationItem.rightBarButtonItem = _rightBarButtonItem;
	[_rightBarButtonItem release];
	
	UIBarButtonItem *_leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Follow" style:UIBarButtonItemStyleBordered target:self action:@selector(follow:)];
	self.navigationItem.leftBarButtonItem = _leftBarButtonItem;
	[_leftBarButtonItem release];
	
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
	self.navigationItem.title = @"Paramedic Tutor";
    
    
}


- (void)viewDidAppear:(BOOL)animated {
// rate app in 3rd times.
//    if ([AFKReviewTroller numberOfExecutions] == 3) { 
//        
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	self.navigationItem.title = @"Home";
}

-(IBAction)about: (id)sender
{
	AboutViewController *abViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
	[self.navigationController pushViewController:abViewController animated:YES];
	[abViewController release];
}

-(IBAction)startQuiz: (id)sender
{
    
//    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"quizzes"
                                                          action:@"quizzes_clicked"  
                                                           label:@"quizzes"         
                                                           value:[NSNumber numberWithInt:1]] build]];
    [[GAI sharedInstance] dispatch];
	QuizMainViewController *quizMainViewController = [[QuizMainViewController alloc] initWithNibName:@"QuizMainViewController" bundle:nil];
	[self.navigationController pushViewController:quizMainViewController animated:YES];
	[quizMainViewController release];
}

-(IBAction)scenarios: (id)sender
{
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"scenarios"
                                                                                        action:@"scenarios_clicked"
                                                                                         label:@"scenarios"
                                                                                         value:[NSNumber numberWithInt:1]] build]];
    [[GAI sharedInstance] dispatch];
	SceneMainViewController *sceneMainViewController = [[SceneMainViewController alloc] initWithNibName:@"SceneMainViewController" bundle:nil];
	[self.navigationController pushViewController:sceneMainViewController animated:YES];
	[sceneMainViewController release];
}

-(IBAction)flashcards: (id)sender
{
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"flashcards"
                                                                                        action:@"flashcards_clicked"
                                                                                         label:@"flashcards"
                                                                                         value:[NSNumber numberWithInt:1]] build]];
    [[GAI sharedInstance] dispatch];
	FlashcardMainViewController *flashcardMainViewController = [[FlashcardMainViewController alloc] initWithNibName:@"FlashcardMainViewController" bundle:nil];
	[self.navigationController pushViewController:flashcardMainViewController animated:YES];
	[flashcardMainViewController release];
}
- (IBAction)dosingTapped:(id)sender {
    
    DosingViewController *dosingViewController = [[DosingViewController alloc] initWithNibName:@"DosingViewController" bundle:nil];
    [self.navigationController pushViewController:dosingViewController animated:YES];
    [dosingViewController release];
    
    
}
- (IBAction)cardiologyTapped:(id)sender {
    
    CardiologyViewController *cardiologyViewController = [[CardiologyViewController alloc] initWithNibName:@"CardiologyViewController" bundle:nil];
    [self.navigationController pushViewController:cardiologyViewController animated:YES];
    [cardiologyViewController release];
    
}

//-(IBAction)dosing: (id)sender
//{
 //   [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"dosing"
//                                                                                        action:@"dosing_clicked"
//                                                                                         label:@"dosing"
//                                                                                         value:[NSNumber numberWithInt:1]] build]];
//    [[GAI sharedInstance] dispatch];
//    DosingMainViewController *DosingMainViewController = [[DosingMainViewController alloc] initWithNibName:@"DosingMainViewController" bundle:nil];
//    [self.navigationController pushViewController:DosingMainViewController animated:YES];
//    [DosingMainViewController release];
//}

//-(IBAction)cardio: (id)sender
//{
//    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"cardio"
//                                                                                        action:@"cardio_clicked"
//                                                                                         label:@"cardio"
//                                                                                         value:[NSNumber numberWithInt:1]] build]];
//    [[GAI sharedInstance] dispatch];
//    CardioMainViewController *CardioMainViewController = [[CardioMainViewController alloc] initWithNibName:@"CardioMainViewController" bundle:nil];
//    [self.navigationController pushViewController:CarioMainViewController animated:YES];
//    [CardioMainViewController release];
//}

-(IBAction)toolbox: (id)sender
{
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"toolbox"
                                                                                        action:@"toolbox_clicked"
                                                                                         label:@"toolbox"
                                                                                         value:[NSNumber numberWithInt:1]] build]];
    [[GAI sharedInstance] dispatch];
	ToolMainViewController *tMain = [[ToolMainViewController alloc] initWithNibName:@"ToolMainViewController" bundle:nil];
	[self.navigationController pushViewController:tMain animated:YES];
	[tMain release];
}

-(IBAction)follow: (id)sender
{
	FollowViewController *fMain = [[FollowViewController alloc] initWithNibName:@"FollowViewController" bundle:nil];
	[self.navigationController pushViewController:fMain animated:YES];
	[fMain release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [self setHome_bg_imageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [_home_bg_imageView release];
    [super dealloc];
}


@end
