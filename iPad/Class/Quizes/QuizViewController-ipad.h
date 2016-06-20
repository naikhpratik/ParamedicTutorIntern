//
//  QuizViewController-ipad.h
//  Quiz
//
//  Created by Arthur on 13-9-10.
//
//

#import <UIKit/UIKit.h>
#import "NSArray+Helpers.h"

@interface QuizViewController_ipad : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UITextViewDelegate, UIAlertViewDelegate> {

    NSMutableArray *arrayQuiz;
	NSMutableDictionary *quizOri;
	NSMutableArray *mArr_alphabet;
	int _currentIndex;
	NSString *correctAns;
	
    BOOL hasPreviousData;
    
	int iChapter;
	NSString *sChapter;
	
	BOOL b_FirstTouch;
	int iCorrectNum;
	int iAlldoneNum;
	
	int mode; //0: Enter normally, not from bookmark;  1: Enter from bookmark
	int bookquizID;
	
	BOOL b_Return;
    
    

}

@property (retain, nonatomic) IBOutlet UILabel *lbChapter;

@property (retain, nonatomic) IBOutlet UILabel *lbIndex;

@property (retain, nonatomic) IBOutlet UILabel *lbTotalCount;

@property (retain, nonatomic) IBOutlet UITextView *tfQuestion;


@property (retain, nonatomic) IBOutlet UITableView *tbView;
@property (retain, nonatomic) IBOutlet UILabel *lbIndexCount;


@property (retain, nonatomic) IBOutlet UITextView *tfCorrect;
@property (retain, nonatomic) IBOutlet UILabel *label_score;
@property (retain, nonatomic) IBOutlet UIButton *btBookimg;
@property (retain, nonatomic) IBOutlet UIButton *btBook;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityView;


@property (retain, nonatomic) IBOutlet UIView *overlayView;

@property (nonatomic, assign) int iChapter;
@property (nonatomic, retain) NSString *sChapter;
@property (nonatomic, assign) int mode;
@property (nonatomic, assign) int bookquizID;
@property (assign, nonatomic) BOOL hasPreviousData;
@property (assign, nonatomic) BOOL fromComprehensive;

- (IBAction)bookQuestion:(id)sender;

- (IBAction)returnQuestion:(id)sender;

- (IBAction)nextQuestion:(id)sender;

- (void)judge: (int)answer;


@end
