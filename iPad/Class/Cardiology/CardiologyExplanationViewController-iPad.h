//
//  CardiologyExplanationViewController-iPad.h
//  Paramedic
//
//  Created by Asad Tkxel on 30/01/2015.
//
//

#import <UIKit/UIKit.h>
#import "CardiologyBean.h"


@protocol CardiologyExplanationViewControllerDelegate <NSObject>

@optional
- (void) reloadQuestionScreen:(id)sender WithQuestionNumber:(int)questionNumber;

@end


@interface CardiologyExplanationViewController_iPad : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *hintOrExplanationLabel;
@property (retain, nonatomic) IBOutlet UILabel *addToBookmarkLabel;
@property (retain, nonatomic) IBOutlet UITextView *explanationOrHintTextView;
@property (retain, nonatomic) IBOutlet UIView *containerView;
@property (retain, nonatomic) IBOutlet UIButton *backQuestionButton;
@property (retain, nonatomic) IBOutlet UIButton *nextQuestionButton;
@property (retain, nonatomic) IBOutlet UIButton *previousQuestionButton;
@property (retain, nonatomic) IBOutlet UIView *buttonsContainerView;

@property (nonatomic) BOOL isHintButtonTapped;
@property (nonatomic) BOOL isBookmarked;
@property (nonatomic) int questionNumber;
@property (nonatomic) int totalQuestionsCount;
@property (retain, nonatomic) NSString *bookmarkQuestionIndex;
@property (retain, nonatomic) CardiologyBean *cardiologyBean;
@property (retain, nonatomic) NSMutableArray *bookmarkedQuestionIndexArray;
@property (retain, nonatomic) NSMutableArray *tempBookmarkedIndexArray;
@property (retain, nonatomic) id <CardiologyExplanationViewControllerDelegate> delegate;

- (IBAction)backButtonTapped:(id)sender;
- (IBAction)nextButtonTapped:(id)sender;
- (IBAction)previousButtonTapped:(id)sender;
- (IBAction)bookmarkButtonTapped:(id)sender;

@end
