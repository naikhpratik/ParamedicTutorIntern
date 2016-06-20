//
//  HomeViewController-ipad.m
//  Quiz
//
//  Created by Arthur on 13-9-10.
//
//

#import "HomeViewController-ipad.h"
#import "QuizesMainViewController-iPad.h"
#import "FlashcardMainViewController-iPad.h"
#import "ScenariosMainViewController-iPad.h"
#import "ToolBoxMainViewController-iPad.h"
#import "DosingViewController-iPad.h"
#import "CardiologyViewController-iPad.h"
#import "AboutViewController.h"
#import "FollowViewController-ipad.h"

#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface HomeViewController_ipad ()

@end

@implementation HomeViewController_ipad

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
    UIBarButtonItem *_rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStyleBordered target:self action:@selector(about:)];
	self.navigationItem.rightBarButtonItem = _rightBarButtonItem;
	[_rightBarButtonItem release];
	
	UIBarButtonItem *_leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Follow" style:UIBarButtonItemStyleBordered target:self action:@selector(follow:)];
	self.navigationItem.leftBarButtonItem = _leftBarButtonItem;
	[_leftBarButtonItem release];
	

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Button click methods

// Quizzes button has been clicked
- (IBAction)startQuizes:(id)sender {
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"quizzes"
                                                                                        action:@"quizzes_clicked"
                                                                                         label:@"quizzes"
                                                                                         value:[NSNumber numberWithInt:1]] build]];
    [[GAI sharedInstance] dispatch];
    QuizesMainViewController_iPad *quizesMainView = [[QuizesMainViewController_iPad alloc]initWithNibName:@"QuizesMainViewController-iPad" bundle:nil];
    [self.navigationController pushViewController:quizesMainView animated:YES];
    [quizesMainView release];
}

// Flashcards button has been clicked
- (IBAction)startFlashcards:(id)sender {
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"flashcards"
                                                                                        action:@"flashcards_clicked"
                                                                                         label:@"flashcards"
                                                                                         value:[NSNumber numberWithInt:1]] build]];
    [[GAI sharedInstance] dispatch];
    FlashcardMainViewController_iPad *flashcardMainView = [[FlashcardMainViewController_iPad alloc]initWithNibName:@"FlashcardMainViewController-iPad" bundle:nil];
    [self.navigationController pushViewController:flashcardMainView animated:YES];
    [flashcardMainView release];
}

// ToolBox button has been clicked
- (IBAction)startToolBox:(id)sender {
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"toolbox"
                                                                                        action:@"toolbox_clicked"
                                                                                         label:@"toolbox"
                                                                                         value:[NSNumber numberWithInt:1]] build]];
    [[GAI sharedInstance] dispatch];
    ToolBoxMainViewController_iPad *toolMainView = [[ToolBoxMainViewController_iPad alloc]initWithNibName:@"ToolBoxMainViewController-iPad" bundle:nil];
    [self.navigationController pushViewController:toolMainView animated:YES];
    [toolMainView release];
}

// Scenarios button has been clicked
- (IBAction)startScena:(id)sender {
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"scenarios"
                                                                                        action:@"scenarios_clicked"
                                                                                         label:@"scenarios"
                                                                                         value:[NSNumber numberWithInt:1]] build]];
    [[GAI sharedInstance] dispatch];
    ScenariosMainViewController_iPad *scenariosMainView = [[ScenariosMainViewController_iPad alloc]initWithNibName:@"ScenariosMainViewController-iPad" bundle:nil];
    [self.navigationController pushViewController:scenariosMainView animated:YES];
    [scenariosMainView release];
}



// Dosing button has been clicked
- (IBAction)startDosing:(id)sender{
    
    DosingViewController_iPad *dosingViewController = [[DosingViewController_iPad alloc] initWithNibName:kiPadDosingControllerNibName bundle:nil];
    [self.navigationController pushViewController:dosingViewController animated:YES];
}

// Cardiology button has been clicked
- (IBAction)startCardiology:(id)sender{
    
    CardiologyViewController_iPad *cardiologyController = [[CardiologyViewController_iPad alloc] initWithNibName:kiPadCardiologyControllerNibName bundle:nil];
    [self.navigationController pushViewController:cardiologyController animated:YES];
}


-(IBAction)about: (id)sender
{
	AboutViewController *abViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
	[self.navigationController pushViewController:abViewController animated:YES];
	[abViewController release];
}



-(IBAction)follow: (id)sender
{
	FollowViewController_ipad *fMain = [[FollowViewController_ipad alloc] initWithNibName:@"FollowViewController-ipad" bundle:nil];
	[self.navigationController pushViewController:fMain animated:YES];
	[fMain release];
}
@end
