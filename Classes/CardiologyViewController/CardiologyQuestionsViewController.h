//
//  CardiologyQuestionsViewController.h
//  Paramedic
//
//  Created by Asad Tkxel on 26/01/2015.
//
//

#import <UIKit/UIKit.h>

@interface CardiologyQuestionsViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet UIImageView *questionImageView;
@property (nonatomic, retain) IBOutlet UIView *questionView;
@property (retain, nonatomic) IBOutlet UILabel *questionNumberLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalQuestionCountLabel;
@property (retain, nonatomic) IBOutlet UILabel *noBookmarkLabel;

@property (nonatomic, retain) NSArray* questionsArray;
@property (nonatomic, retain) NSMutableArray *bookmarkedQuestionIndexArray;
@property (nonatomic, retain) NSMutableArray *tempBookmarkedIndexArray;
@property (nonatomic) int generalQuestionCounter;
@property (nonatomic) int questionsCount;
@property BOOL isBookmarkSelected;


- (IBAction)hintOrExplanationButtonTapped:(id)sender;

@end
