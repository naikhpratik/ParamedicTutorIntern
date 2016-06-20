//
//  QuizesMainViewController-iPad.h
//  Quiz
//
//  Created by Arthur on 13-9-10.
//
//

#import <UIKit/UIKit.h>

// sign of tableView tag.
enum tableTag{
    
    TABLE_TAG_CHAPTER = 100,
    TABLE_TAG_BOOKMARK,
    TABLE_TAG_SCORE
    
};

enum alertTag {
    kAlertViewTagComp = 100,
    kAlertViewTagChapters,
    kAlertViewTagScore,
    kAlertViewTagShare
};

@interface QuizesMainViewController_iPad : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate> {
    NSMutableArray *arrayChapters;
    NSMutableArray *arrayBookmarkData;
    NSMutableArray *arrayScores;   // storage the score with quiz

    int bookType;  //0: quiz    1: flashcard
    int chapterID;
    NSString *name;
    
}

@property (retain, nonatomic) IBOutlet UITableView *tableView_item;

// if the button was been taped, that narrow was show immediately.
@property (retain, nonatomic) IBOutlet UIImageView *imv_narrow_chapter;
@property (retain, nonatomic) IBOutlet UIImageView *imv_narrow_bookmark;
@property (retain, nonatomic) IBOutlet UIImageView *imv_narrow_score;

@property (retain, nonatomic) IBOutlet UIButton *btn_chapters;
@property (retain, nonatomic) IBOutlet UIButton *btn_bookmarks;
@property (retain, nonatomic) IBOutlet UIButton *btn_scoreHistory;

- (IBAction)comprehensiveQuiz:(id)sender;
- (IBAction)chapters:(id)sender;
- (IBAction)bookmarks:(id)sender;
- (IBAction)scoreHistory:(id)sender;

@end
