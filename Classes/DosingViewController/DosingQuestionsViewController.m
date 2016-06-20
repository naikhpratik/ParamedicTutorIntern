//
//  DosingQuestionsViewController.m
//  Paramedic
//
//  Created by Abdul Rehman on 1/14/15.
//
//

#import "DosingQuestionsViewController.h"
#import "SqlMB.h"
#import "DosingBean.h"


@interface DosingQuestionsViewController ()

{
    UISwipeGestureRecognizer* leftswipeGesture;
    UISwipeGestureRecognizer* rightswipeGesture;
}

@property (nonatomic, retain) NSArray* questionsArray;
@property (nonatomic, retain) NSMutableArray *bookmarkedQuestionIndexArray;
@property (nonatomic, retain) NSMutableArray *tempBookmarkedIndexArray;
@property (retain, nonatomic) IBOutlet UIView *parentView;
@property (retain, nonatomic) IBOutlet UIView *childView;
@property (nonatomic) BOOL flipFlag;
@property (nonatomic) int questionsCount;
@property (retain, nonatomic) IBOutlet UIView *containerView;
@end

@implementation DosingQuestionsViewController

#pragma mark - Synthesize properties

@synthesize flipFlag;


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:YES];
    
    //set title for navigation bar
    if (self.isBookmarkSelected) {
        self.navigationItem.title = kBookmarkNavigationBarTitle;
    }
    else{
        self.navigationItem.title = kDosingNaviagtionBarTitle;
    }
    
    //Create custom back button to pop view controller
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(popAlertAction:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    flipFlag = NO;
    self.questionsCount = 0;
    self.bookmarkedQuestionIndexArray = [[NSMutableArray alloc] init];
    self.tempBookmarkedIndexArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *data = [[NSUserDefaults standardUserDefaults] objectForKey:kDosingBookmarkedQuestionsKey];
    if ([data isKindOfClass:[NSMutableArray class]] && data.count > 0) {
        self.bookmarkedQuestionIndexArray = [data mutableCopy];
    }
    
    if (self.isBookmarkSelected) {
        if (self.bookmarkedQuestionIndexArray.count <= 0) {
            [self.noBookmarkLabel setHidden:NO];
            [self.containerView setHidden:YES];
            return;
        }
        else{
            [self.noBookmarkLabel setHidden:YES];
            [self.containerView setHidden:NO];
        }
    }
    else{
        [self.noBookmarkLabel setHidden:YES];
        [self.containerView setHidden:NO];
    }
    
    [[SqlMB getInstance] getDosingQuestionsWithBlock:^(BOOL success, NSArray *questions) {
        self.questionsArray = questions;
        [self updateQuestionView];
    }];
    
    // adding left and right gestures for whole view
    leftswipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    leftswipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    rightswipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    rightswipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.containerView addGestureRecognizer:leftswipeGesture];
    [self.containerView addGestureRecognizer:rightswipeGesture];
   
    
    // set corner radius for both question, answer and equation views
    self.childView.layer.cornerRadius = kCornerRadiusPoints;
    self.childView.clipsToBounds = YES;
    self.parentView.layer.cornerRadius = kCornerRadiusPoints;
    self.parentView.clipsToBounds = YES;
    self.equationContainerView.layer.cornerRadius = kCornerRadiusPoints;
    self.equationContainerView.clipsToBounds = YES;
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // Remove bookmarks dosing beans
    if (self.isBookmarkSelected) {
        for (id obj in self.tempBookmarkedIndexArray) {
            if ([self.bookmarkedQuestionIndexArray containsObject:obj]) {
                [self.bookmarkedQuestionIndexArray removeObject:obj];
            }
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.bookmarkedQuestionIndexArray forKey:kDosingBookmarkedQuestionsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- IBActions

- (IBAction)equationTapped:(id)sender {
    
    if (flipFlag == NO) {
        [UIView transitionFromView:self.childView toView:self.equationContainerView duration:kDosingFlipAnimationDuration options:UIViewAnimationOptionTransitionFlipFromLeft completion:NULL];
        flipFlag = YES;
         [self showResult:YES];
    }
    else {
        [UIView transitionFromView:self.equationContainerView toView:self.childView duration:kDosingFlipAnimationDuration options:UIViewAnimationOptionTransitionFlipFromRight completion:NULL];
        flipFlag = NO; 
    }
}
- (IBAction)answerTapped:(id)sender {
    
    if (flipFlag == NO) {
        [UIView transitionFromView:self.childView toView:self.parentView duration:kDosingFlipAnimationDuration options:UIViewAnimationOptionTransitionFlipFromLeft completion:NULL];
        flipFlag = YES;
        [self showResult:NO];
    }
    else {
        [UIView transitionFromView:self.parentView toView:self.childView duration:kDosingFlipAnimationDuration options:UIViewAnimationOptionTransitionFlipFromRight completion:NULL];
        flipFlag = NO;
    }
}

- (IBAction)answerBottonFromEquationTapped:(id)sender{
    
    [UIView transitionFromView:self.equationContainerView toView:self.parentView duration:kDosingFlipAnimationDuration options:UIViewAnimationOptionTransitionFlipFromLeft completion:NULL];
    [self showResult:NO];
}

- (IBAction)leftButtonTapped:(id)sender {
    
    [self swiped:rightswipeGesture];
}

- (IBAction)rightButtonTapped:(id)sender {
    
    [self swiped:leftswipeGesture];
}

- (IBAction)bookmarkButtonTapped:(id)sender {
    
    NSMutableString *bookmarkedQuestionIndex = nil;
    if (self.isBookmarkSelected) {
        bookmarkedQuestionIndex = [self.bookmarkedQuestionIndexArray objectAtIndex:self.generalQuestionCounter];
        if ([self.bookmarkedQuestionIndexArray containsObject:bookmarkedQuestionIndex]) {
            
            if ([self.tempBookmarkedIndexArray containsObject:bookmarkedQuestionIndex]) {
                [self.tempBookmarkedIndexArray removeObject:bookmarkedQuestionIndex];
                self.addToBookmarkLabelInAnswerView.text = kUnbookmarkText;
                self.addToBookmarkLabelInEquationView.text = kUnbookmarkText;
            }
            else{
                [self.tempBookmarkedIndexArray addObject:bookmarkedQuestionIndex];
                self.addToBookmarkLabelInAnswerView.text = kAddToBookMarkText;
                self.addToBookmarkLabelInEquationView.text = kAddToBookMarkText;
            }
        }
        else{
            [self.bookmarkedQuestionIndexArray addObject:bookmarkedQuestionIndex];
            self.addToBookmarkLabelInAnswerView.text = kUnbookmarkText;
            self.addToBookmarkLabelInEquationView.text = kUnbookmarkText;
        }
    }
    else{
        bookmarkedQuestionIndex = [NSMutableString stringWithFormat:@"%d", self.generalQuestionCounter];
        if ([self.bookmarkedQuestionIndexArray containsObject:bookmarkedQuestionIndex]) {
            [self.bookmarkedQuestionIndexArray removeObject:bookmarkedQuestionIndex];
            self.addToBookmarkLabelInAnswerView.text = kAddToBookMarkText;
            self.addToBookmarkLabelInEquationView.text = kAddToBookMarkText;
        }
        else{
            [self.bookmarkedQuestionIndexArray addObject:bookmarkedQuestionIndex];
            self.addToBookmarkLabelInAnswerView.text = kUnbookmarkText;
            self.addToBookmarkLabelInEquationView.text = kUnbookmarkText;
        }
    }
}


- (void)dealloc {

    [_questionTextview release];
    [_parentView release];
    [_childView release];
    [_containerView release];
    [_questionNumberLabel release];
    [_totalQuestionCountLabel release];
    [_noBookmarkLabel release];
    [_equationContainerView release];
    [super dealloc];
}
- (void)viewDidUnload {

    [self setQuestionTextview:nil];
    [self setParentView:nil];
    [self setChildView:nil];
    [self setContainerView:nil];
    [self setQuestionNumberLabel:nil];
    [self setTotalQuestionCountLabel:nil];
    [self setNoBookmarkLabel:nil];
    [self setEquationContainerView:nil];
    [super viewDidUnload];
}


#pragma mark - Helper Methods


-(void) swiped: (UISwipeGestureRecognizer*) recognizer
{
    // return if index out of bound
    if ((self.generalQuestionCounter <= 0 && recognizer.direction == UISwipeGestureRecognizerDirectionRight) || (self.generalQuestionCounter >= self.questionsCount -1 && recognizer.direction == UISwipeGestureRecognizerDirectionLeft)) {
        return;
    }
    
    
    if (flipFlag == YES) {
        
        [UIView transitionFromView:self.parentView toView:self.childView duration:0.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:NULL];
        [UIView transitionFromView:self.equationContainerView toView:self.childView duration:0.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:NULL];

        flipFlag = NO;
    }
    
    recognizer.direction == UISwipeGestureRecognizerDirectionLeft ? self.generalQuestionCounter++ : self.generalQuestionCounter--;
    recognizer.direction == UISwipeGestureRecognizerDirectionLeft ? [self animateContainerViewWithDirection:SwipeDirectionLeft] : [self animateContainerViewWithDirection:SwipeDirectionRight];
    [self updateQuestionView];
}

-(void) animateContainerViewWithDirection:(SwipeDirection )swipeDirection
{
    int containerViewOriginalX = self.containerView.frame.origin.x;
    int containerViewMovedX = 0;
    CGRect containerViewFrame = self.containerView.frame;
    
    if (swipeDirection == SwipeDirectionLeft) {
        containerViewMovedX = self.view.frame.size.width;
    }
    else if(swipeDirection == SwipeDirectionRight){
        containerViewMovedX = -self.view.frame.size.width;
    }
    
    containerViewFrame = CGRectMake(containerViewMovedX, containerViewFrame.origin.y, containerViewFrame.size.width, containerViewFrame.size.height);
    self.containerView.frame = containerViewFrame;
    
    [UIView animateWithDuration:kSwipAnimationDuration animations:^{
        self.containerView.frame = CGRectMake(containerViewOriginalX, containerViewFrame.origin.y, containerViewFrame.size.width, containerViewFrame.size.height);
    }];
}


-(void) updateQuestionView
{
    DosingBean* bean = nil;
    
    if (self.isBookmarkSelected) {
        bean = [self.questionsArray objectAtIndex:[[self.bookmarkedQuestionIndexArray objectAtIndex:self.generalQuestionCounter] intValue]];
        self.questionsCount = self.bookmarkedQuestionIndexArray.count;
    }
    else{
        bean = [self.questionsArray objectAtIndex:self.generalQuestionCounter];
        self.questionsCount = self.questionsArray.count;
    }
    
    UITextView* textview = (UITextView*)[self.childView viewWithTag:kTextviewtag];
    textview.text = bean.question;
    textview.textColor = [UIColor colorWithRed:78/255.0 green:180/255.0 blue:242/255.0 alpha:1.0f];
    textview.textAlignment = NSTextAlignmentCenter;
    [textview setFont:[UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:kTextViewFontSize]];
    self.questionNumberLabel.text = [NSString stringWithFormat:@"%d", self.generalQuestionCounter+1];
    self.totalQuestionCountLabel.text = [NSString stringWithFormat:@"of %d", self.questionsCount];
}


-(void) showResult:(BOOL) equation
{
    DosingBean* bean = nil;
    if (self.isBookmarkSelected) {
        bean = [self.questionsArray objectAtIndex:[[self.bookmarkedQuestionIndexArray objectAtIndex:self.generalQuestionCounter] intValue]];
    }
    else{
        bean = [self.questionsArray objectAtIndex:self.generalQuestionCounter];
    }
    
    if(equation)
    {
        if(flipFlag)
        {
            UITextView* textview = (UITextView*)[self.equationContainerView viewWithTag:kTextviewtag];
            textview.text = bean.equation;
            textview.textColor = [UIColor whiteColor];
            [textview setFont:[UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:kTextViewFontSize]];
            [textview setHidden:NO];
        }
    }
    else
    {
        UIImageView* imgView = (UIImageView*)[self.parentView viewWithTag:kImageViewTag];
        [imgView setImage:[UIImage imageNamed:bean.answer]];
        [imgView setHidden:NO];
    }
    
    
    //show "Add to bookmark" or "Unbookmark" text at the top of card
    NSString *bookmarkedQuestionIndex = nil;
    if (self.isBookmarkSelected) {
        bookmarkedQuestionIndex = [self.bookmarkedQuestionIndexArray objectAtIndex:self.generalQuestionCounter];
        if ([self.bookmarkedQuestionIndexArray containsObject:bookmarkedQuestionIndex]) {
            if ([self.tempBookmarkedIndexArray containsObject:bookmarkedQuestionIndex]) {
                self.addToBookmarkLabelInAnswerView.text = kAddToBookMarkText;
                self.addToBookmarkLabelInEquationView.text = kAddToBookMarkText;
            }
            else{
                self.addToBookmarkLabelInAnswerView.text = kUnbookmarkText;
                self.addToBookmarkLabelInEquationView.text = kUnbookmarkText;
            }
        }
        else{
            self.addToBookmarkLabelInAnswerView.text = kAddToBookMarkText;
            self.addToBookmarkLabelInEquationView.text = kAddToBookMarkText;
        }
    }
    else{
        bookmarkedQuestionIndex = [NSString stringWithFormat:@"%d", self.generalQuestionCounter];
        if ([self.bookmarkedQuestionIndexArray containsObject:bookmarkedQuestionIndex]) {
            self.addToBookmarkLabelInAnswerView.text = kUnbookmarkText;
            self.addToBookmarkLabelInEquationView.text = kUnbookmarkText;
        }
        else{
            self.addToBookmarkLabelInAnswerView.text = kAddToBookMarkText;
            self.addToBookmarkLabelInEquationView.text = kAddToBookMarkText;
        }
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
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", self.generalQuestionCounter] forKey:kSavedDosingCardIndexKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(buttonIndex == 1){
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kSavedDosingCardIndexKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
