//
//  CardiologyExplanationVieControllerViewController.m
//  Paramedic
//
//  Created by Asad Tkxel on 27/01/2015.
//
//

#import "CardiologyExplanationVieControllerViewController.h"

@interface CardiologyExplanationVieControllerViewController ()

{
    UISwipeGestureRecognizer* leftswipeGesture;
    UISwipeGestureRecognizer* rightswipeGesture;
}

@end

@implementation CardiologyExplanationVieControllerViewController


#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //set navigation bar title
    if (self.isBookmarked) {
        self.navigationItem.title = kBookmarkNavigationBarTitle;
    }
    else{
        self.navigationItem.title = kCardiologyNanigationBarTitle;
    }
    
    self.bookmarkedQuestionIndexArray = [[NSMutableArray alloc] init];
    self.tempBookmarkedIndexArray = [[NSMutableArray alloc] init];
    
    
    // set corner radius for hint and explanation container view
    self.containerView.layer.cornerRadius = kCornerRadiusPoints;
    self.containerView.clipsToBounds = YES;
    
    
    if (self.isHintButtonTapped) {
        //hide prvious and next button if hint button is tapped
        [self.previousQuestionButton setHidden:YES];
        [self.nextQuestionButton setHidden:YES];
        
        //resize frame for buttons container view if hint button is tapped
        CGRect buttonsContainerFrame = self.buttonsContainerView.frame;
        buttonsContainerFrame.origin.x = self.backQuestionButton.frame.origin.x - 10;
        buttonsContainerFrame.size.width = self.backQuestionButton.frame.size.width + 20;
        self.buttonsContainerView.frame = buttonsContainerFrame;
        
        //set corner radius for buttons container view
        self.buttonsContainerView.layer.cornerRadius = 5;
        self.buttonsContainerView.clipsToBounds = YES;
    }
    else{
        // adding left and right gestures for whole view
        leftswipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
        leftswipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        rightswipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
        rightswipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
        [self.containerView addGestureRecognizer:leftswipeGesture];
        [self.containerView addGestureRecognizer:rightswipeGesture];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    //Force device orientation in landscape mode only
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:kDeviceOrientationKey];
    
    
    //Get data from NSUserDefaults
    NSMutableArray *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCardiologyBookmarkedQuestionsKey];
    if ([data isKindOfClass:[NSMutableArray class]] && data.count > 0) {
        self.bookmarkedQuestionIndexArray = [data mutableCopy];
    }
    
    data = [[NSUserDefaults standardUserDefaults] objectForKey:kTempCardiologyBookmarkedQuestionsKey];
    if ([data isKindOfClass:[NSMutableArray class]] && data.count > 0) {
        self.tempBookmarkedIndexArray = [data mutableCopy];
    }
    
    [self updateContainerView];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.bookmarkedQuestionIndexArray forKey:kCardiologyBookmarkedQuestionsKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.tempBookmarkedIndexArray forKey:kTempCardiologyBookmarkedQuestionsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - IBActions

- (IBAction)backButtonTapped:(id)sender{
    
    [self popControllerUsingFlipAnimation];
}

- (IBAction)nextButtonTapped:(id)sender{
    
    // return if index out of bound
    if (self.questionNumber >= self.totalQuestionsCount -1) {
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(reloadQuestionScreen:WithQuestionNumber:)]) {
        [_delegate reloadQuestionScreen:self WithQuestionNumber:self.questionNumber+1];
    }
    [self popControllerUsingFlipAnimation];
}

- (IBAction)previousButtonTapped:(id)sender{
    
    // return if index out of bound
    if (self.questionNumber <= 0) {
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(reloadQuestionScreen:WithQuestionNumber:)]) {
        [_delegate reloadQuestionScreen:self WithQuestionNumber:self.questionNumber-1];
    }
    [self popControllerUsingFlipAnimation];
}

- (IBAction)bookmarkButtonTapped:(id)sender{
    
    
    if (self.isBookmarked) {
        if ([self.bookmarkedQuestionIndexArray containsObject:self.bookmarkQuestionIndex]) {
            
            if ([self.tempBookmarkedIndexArray containsObject:self.bookmarkQuestionIndex]) {
                [self.tempBookmarkedIndexArray removeObject:self.bookmarkQuestionIndex];
                self.addToBookmarkLabel.text = kUnbookmarkText;
            }
            else{
                [self.tempBookmarkedIndexArray addObject:self.bookmarkQuestionIndex];
                self.addToBookmarkLabel.text = kAddToBookMarkText;
            }
        }
        else{
            [self.bookmarkedQuestionIndexArray addObject:self.bookmarkQuestionIndex];
            self.addToBookmarkLabel.text = kUnbookmarkText;
        }
    }
    else{
        if ([self.bookmarkedQuestionIndexArray containsObject:self.bookmarkQuestionIndex]) {
            [self.bookmarkedQuestionIndexArray removeObject:self.bookmarkQuestionIndex];
            self.addToBookmarkLabel.text = kAddToBookMarkText;
        }
        else{
            [self.bookmarkedQuestionIndexArray addObject:self.bookmarkQuestionIndex];
            self.addToBookmarkLabel.text = kUnbookmarkText;
        }
    }
}


#pragma mark - Helper Methods

-(void) swiped: (UISwipeGestureRecognizer*) recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self previousButtonTapped:self];
    }
    else if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft){
        [self nextButtonTapped:self];
    }
}

-(void) updateContainerView
{
    if (self.isHintButtonTapped) {
        self.explanationOrHintTextView.text = self.cardiologyBean.hint;
        self.hintOrExplanationLabel.text = kHintText;
    }
    else{
        self.explanationOrHintTextView.text = self.cardiologyBean.explanation;
        self.hintOrExplanationLabel.text = kExplanationText;
    }
    
    self.explanationOrHintTextView.textColor = [UIColor whiteColor];
    [self.explanationOrHintTextView setFont:[UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:kTextViewFontSize]];
    
    
    if (self.isBookmarked) {
        if ([self.bookmarkedQuestionIndexArray containsObject:self.bookmarkQuestionIndex]) {
            if ([self.tempBookmarkedIndexArray containsObject:self.bookmarkQuestionIndex]) {
                self.addToBookmarkLabel.text = kAddToBookMarkText;
            }
            else{
                self.addToBookmarkLabel.text = kUnbookmarkText;
            }
        }
        else{
            self.addToBookmarkLabel.text = kAddToBookMarkText;
        }
    }
    else{
        if ([self.bookmarkedQuestionIndexArray containsObject:self.bookmarkQuestionIndex]) {
            self.addToBookmarkLabel.text = kUnbookmarkText;
        }
        else{
            self.addToBookmarkLabel.text = kAddToBookMarkText;
        }
    }
    
}

-(void) popControllerUsingFlipAnimation{
    
    [UIView beginAnimations:kFlipAnimationKey context:nil];
    [UIView setAnimationDuration:kCardiologyFlipAnimationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
    [UIView commitAnimations];
}

@end