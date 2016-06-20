//
//  DosingQuestionsViewController.h
//  Paramedic
//
//  Created by Abdul Rehman on 1/14/15.
//
//

#import <UIKit/UIKit.h>

@interface DosingQuestionsViewController : UIViewController <UIAlertViewDelegate>
 
@property (retain, nonatomic) IBOutlet UIView *equationContainerView;
@property (retain, nonatomic) IBOutlet UITextView *questionTextview;
@property (retain, nonatomic) IBOutlet UILabel *questionNumberLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalQuestionCountLabel;
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
