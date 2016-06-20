//
//  DosingQuestionsViewController-iPad.h
//  Paramedic
//
//  Created by Asad Tkxel on 29/01/2015.
//
//

#import <UIKit/UIKit.h>

@interface DosingQuestionsViewController_iPad : UIViewController <UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UIView *equationContainerView;
@property (retain, nonatomic) IBOutlet UITextView *questionTextview;
@property (retain, nonatomic) IBOutlet UILabel *questionNumberLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalQuestionCountLabel;
@property (retain, nonatomic) IBOutlet UILabel *equationOrAnswerLabel;
@property (retain, nonatomic) IBOutlet UILabel *addToBookmarkLabelInEquationView;
@property (retain, nonatomic) IBOutlet UILabel *addToBookmarkLabelInAnswerView;
@property (retain, nonatomic) IBOutlet UILabel *noBookmarkLabel;
@property BOOL isBookmarkSelected;
@property (nonatomic) int generalQuestionCounter;

- (IBAction)leftButtonTapped:(id)sender;
- (IBAction)rightButtonTapped:(id)sender;
- (IBAction)bookmarkButtonTapped:(id)sender;
- (IBAction)answerBottonFromEquationTapped:(id)sender;

@end
