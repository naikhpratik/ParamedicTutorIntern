//
//  QuizesMainViewController-iPad.h
//  Quiz
//
//  Created by Arthur on 13-9-10.
//
//

#import <UIKit/UIKit.h>

// sign of tableView tag.
enum tableTagFlashCard{
    
    TABLE_TAG_CHAPTER_FLASHCARD = 200,
    TABLE_TAG_BOOKMARK_FLASHCARD
    
};

enum alertTagFlashCard {
    kAlertViewTagCompFlashCard = 200,
    kAlertViewTagBookmark,
    kAlertViewTagOther
};

@interface FlashcardMainViewController_iPad : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate> {
    NSMutableArray *arrayChapters;
    NSMutableArray *arrayBookmarkData;
   
    int bookType;  //0: quiz    1: flashcard
    int chapterID;
    NSString *name;
    
}

@property (retain, nonatomic) IBOutlet UITableView *tableView_item;

// if the button was been taped, that narrow was show immediately.
@property (retain, nonatomic) IBOutlet UIImageView *imv_narrow_chapter;
@property (retain, nonatomic) IBOutlet UIImageView *imv_narrow_bookmark;


@property (retain, nonatomic) IBOutlet UIButton *btn_chapters;
@property (retain, nonatomic) IBOutlet UIButton *btn_bookmarks;

- (IBAction)comprehensiveFlashcards:(id)sender;
- (IBAction)chapters:(id)sender;
- (IBAction)bookmarks:(id)sender;


@end
