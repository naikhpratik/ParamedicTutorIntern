//
//  QuizesMainViewController-iPad.h
//  Quiz
//
//  Created by Arthur on 13-9-10.
//
//

#import <UIKit/UIKit.h>

// sign of tableView tag.
enum tableTagScenarios{
    
    TABLE_TAG_SCENARIOS = 300,
    TABLE_TAG_BOOKMARK_SCENARIOS,
    
};

enum alertTagScenarios {
    kAlertViewTagCompScenarios = 300,
    kAlertViewTagChaptersScenarios,
};

@interface ScenariosMainViewController_iPad : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate> {
    NSMutableArray *arrayScenarios;
    NSMutableArray *arrayBookmark;
   
    
}

@property (retain, nonatomic) IBOutlet UITableView *tableView_item;

// if the button was been taped, that narrow was show immediately.
@property (retain, nonatomic) IBOutlet UIImageView *imv_narrow_chapter;
@property (retain, nonatomic) IBOutlet UIImageView *imv_narrow_bookmark;
@property (retain, nonatomic) IBOutlet UILabel *imv_noData;



@property (retain, nonatomic) IBOutlet UIButton *btn_chapters;
@property (retain, nonatomic) IBOutlet UIButton *btn_bookmarks;

- (IBAction)scenarios:(id)sender;
- (IBAction)bookmarks:(id)sender;


@end
