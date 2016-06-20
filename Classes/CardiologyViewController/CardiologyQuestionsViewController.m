//
//  CardiologyQuestionsViewController.m
//  Paramedic
//
//  Created by Asad Tkxel on 26/01/2015.
//
//

#import "CardiologyQuestionsViewController.h"
#import "CardiologyExplanationVieControllerViewController.h"
#import "CardiologyBean.h"
#import "SqlMB.h"


@interface CardiologyQuestionsViewController () <CardiologyExplanationViewControllerDelegate>
{
    UISwipeGestureRecognizer* leftswipeGesture;
    UISwipeGestureRecognizer* rightswipeGesture;
    CardiologyBean *bean;
}
@end

@implementation CardiologyQuestionsViewController


#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set navigation bar title
    if (self.isBookmarkSelected) {
        self.navigationItem.title = kBookmarkNavigationBarTitle;
    }
    else{
        self.navigationItem.title = kCardiologyNanigationBarTitle;
    }

    
    //Create custom back button to pop view controller
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(popAlertAction:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    self.questionsCount = 0;
    self.bookmarkedQuestionIndexArray = [[NSMutableArray alloc] init];
    self.tempBookmarkedIndexArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCardiologyBookmarkedQuestionsKey];
    if ([data isKindOfClass:[NSMutableArray class]] && data.count > 0) {
        self.bookmarkedQuestionIndexArray = [data mutableCopy];
    }
    
    if (self.isBookmarkSelected) {
        if (self.bookmarkedQuestionIndexArray.count <= 0) {
            [self.noBookmarkLabel setHidden:NO];
            [self.questionView setHidden:YES];
            return;
        }
        else{
            [self.noBookmarkLabel setHidden:YES];
            [self.questionView setHidden:NO];
        }
    }
    else{
        [self.noBookmarkLabel setHidden:YES];
        [self.questionView setHidden:NO];
    }
    
    [[SqlMB getInstance] getCardiologyQuestionsWithBlock:^(BOOL success, NSArray *questions) {
        self.questionsArray = questions;
        [self updateQuestionView];
    }];
    
    // adding left and right gestures for whole view
    leftswipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    leftswipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    rightswipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    rightswipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.questionView addGestureRecognizer:leftswipeGesture];
    [self.questionView addGestureRecognizer:rightswipeGesture];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:kDeviceOrientationKey];
}


#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Helper Methods

-(void) swiped: (UISwipeGestureRecognizer*) recognizer
{
    // return if index out of bound
    if ((self.generalQuestionCounter <= 0 && recognizer.direction == UISwipeGestureRecognizerDirectionRight) || (self.generalQuestionCounter >= self.questionsCount -1 && recognizer.direction == UISwipeGestureRecognizerDirectionLeft)) {
        return;
    }
    
    recognizer.direction == UISwipeGestureRecognizerDirectionLeft ? self.generalQuestionCounter++ : self.generalQuestionCounter--;
    recognizer.direction == UISwipeGestureRecognizerDirectionLeft ? [self animateQuestionViewWithDirection:SwipeDirectionLeft] : [self animateQuestionViewWithDirection:SwipeDirectionRight];
    [self updateQuestionView];
}

-(void) animateQuestionViewWithDirection:(SwipeDirection )swipeDirection
{
    int questionViewOriginalX = self.questionView.frame.origin.x;
    int questionViewMovedX = 0;
    CGRect questionViewFrame = self.questionView.frame;
    
    if (swipeDirection == SwipeDirectionLeft) {
        questionViewMovedX = self.view.frame.size.width;
    }
    else if(swipeDirection == SwipeDirectionRight){
        questionViewMovedX = -self.view.frame.size.width;
    }
    
    questionViewFrame = CGRectMake(questionViewMovedX, questionViewFrame.origin.y, questionViewFrame.size.width, questionViewFrame.size.height);
    self.questionView.frame = questionViewFrame;
    
    [UIView animateWithDuration:kSwipAnimationDuration animations:^{
        self.questionView.frame = CGRectMake(questionViewOriginalX, questionViewFrame.origin.y, questionViewFrame.size.width, questionViewFrame.size.height);
    }];
}


-(void) updateQuestionView
{
    bean = nil;
    
    if (self.isBookmarkSelected) {
        bean = [self.questionsArray objectAtIndex:[[self.bookmarkedQuestionIndexArray objectAtIndex:self.generalQuestionCounter] intValue]];
        self.questionsCount = (int)self.bookmarkedQuestionIndexArray.count;
    }
    else{
        bean = [self.questionsArray objectAtIndex:self.generalQuestionCounter];
        self.questionsCount = (int)self.questionsArray.count;
    }
    
    [self.questionImageView setImage:[UIImage imageNamed:bean.question]];
    self.questionNumberLabel.text = [NSString stringWithFormat:@"%d", self.generalQuestionCounter+1];
    self.totalQuestionCountLabel.text = [NSString stringWithFormat:@"of %d", self.questionsCount];
}


- (void) pushControllerUsingFlipAnimation:(UIViewController *)controller{
    
    [UIView beginAnimations:kFlipAnimationKey context:nil];
    [UIView setAnimationDuration:kCardiologyFlipAnimationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    
    [self.navigationController pushViewController:controller animated:YES];
    [UIView commitAnimations];
}

- (NSString *) indexOfBookmarkQuestion{
    
    if (self.isBookmarkSelected) {
        NSString *index =  [self.bookmarkedQuestionIndexArray objectAtIndex:self.generalQuestionCounter];
        return index;
    }
    else{
        return [NSString stringWithFormat:@"%d", self.generalQuestionCounter];
    }
}

-(void) popAlertAction:(UIBarButtonItem *)sender{
    
    if (self.isBookmarkSelected) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        // Show UIAlertView for saving card index
        [[[UIAlertView alloc] initWithTitle:kQuitCardTitle message:kQuitCardMessage delegate:self cancelButtonTitle:kQuitCardCancelButtonTitle otherButtonTitles:kQuitCardOtherButtonTitle, nil] show];
    }
}


#pragma mark - UIAlerView Delegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", self.generalQuestionCounter] forKey:kSavedCardiologyCardIndexKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(buttonIndex == 1){
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kSavedCardiologyCardIndexKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - IBActions

- (IBAction)hintOrExplanationButtonTapped:(id)sender{
    
    CardiologyExplanationVieControllerViewController *explanationViewController = [[CardiologyExplanationVieControllerViewController alloc] initWithNibName:kCardiologyExplanationControllerNibName bundle:nil];
    
    if ([sender tag] == 1) {
        explanationViewController.isHintButtonTapped = NO;
    }
    else if([sender tag] == 2) {
        explanationViewController.isHintButtonTapped = YES;
    }
    
    explanationViewController.cardiologyBean = bean;
    explanationViewController.isBookmarked = self.isBookmarkSelected;
    explanationViewController.bookmarkQuestionIndex = [self indexOfBookmarkQuestion];
    explanationViewController.questionNumber = self.generalQuestionCounter;
    explanationViewController.totalQuestionsCount = self.questionsCount;
    explanationViewController.delegate = self;
    [self pushControllerUsingFlipAnimation:explanationViewController];
}

#pragma mark - CardiologyExplanationViewControllerDelegate

-(void)reloadQuestionScreen:(id)sender WithQuestionNumber:(int)questionNumber{
    if (![sender isKindOfClass:[CardiologyExplanationVieControllerViewController class]]) {
        return;
    }
    
    self.generalQuestionCounter = questionNumber;
    [self updateQuestionView];
}

@end
