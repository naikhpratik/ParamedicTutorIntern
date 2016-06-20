//
//  FlashCardViewController.h
//  Quiz
//
//  Created by Arthur on 13-9-13.
//
//

#import <UIKit/UIKit.h>
#import "MyTextView.h"
#import "NSArray+Helpers.h"

enum ALERT_TAG_FLASHCARD {
    alert_tag_back = 100,
    alert_tag_end_flashcard
    };

@interface FlashCardViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate> {
    IBOutlet MyTextView *tfQuestion;
    
    IBOutlet MyTextView *tfQuestionInAnswerView;
    IBOutlet MyTextView *tfAnswer;
    
    BOOL hadPreviousData;
    int iChapter;
    int mode; //0: Enter normally, not from bookmark;  1: Enter from bookmark
	int _card_page_index;
	int _fc_index;
	int bookquizID;
    float _tmp_x;
	float _tmp_y;
    NSString *sChapter;
    NSMutableArray *arrayCards;
}
@property (retain, nonatomic) IBOutlet UILabel *lbTitle;

@property (retain, nonatomic) IBOutlet UIView *superView;
@property (retain, nonatomic) IBOutlet UIView *theLeftView;
@property (retain, nonatomic) IBOutlet UIView *theRightView;

@property (retain, nonatomic) IBOutlet UIView *questionView;
@property (retain, nonatomic) IBOutlet UIView *answerView;
@property (retain, nonatomic) IBOutlet UIButton *btLeft;
@property (retain, nonatomic) IBOutlet UIButton *btRight;


@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (retain, nonatomic) IBOutlet UILabel *lbCurrentIndex;
@property (retain, nonatomic) IBOutlet UILabel *lbTotalCount;
@property (retain, nonatomic) IBOutlet UIButton *btBookimg;
@property (retain, nonatomic) IBOutlet UIButton *btBook;


@property (nonatomic, assign) int iChapter;
@property (nonatomic, retain) NSString *sChapter;
@property (nonatomic, assign) int mode;
@property (nonatomic, assign) int bookquizID;
@property (assign, nonatomic) BOOL hadPreviousData;
@property (assign, nonatomic) BOOL fromComprehensive;

- (IBAction)addtoBookmark:(id)sender;
- (IBAction)next:(id)sender;
- (IBAction)previous:(id)sender;


-(void)turnMenuToRight;
-(void)turnMenuToLeft;
-(void)updateCard;
-(void)updateArrow;



@end
