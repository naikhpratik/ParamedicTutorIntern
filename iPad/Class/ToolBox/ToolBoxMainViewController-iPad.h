//
//  QuizesMainViewController-iPad.h
//  Quiz
//
//  Created by Arthur on 13-9-10.
//
//

#import <UIKit/UIKit.h>

// sign of tableView tag.
enum tableTagToolBox{
    
    TABLE_TAG_SKILL_SHEET = 400,
    TABLE_TAG_DIFFERENTIALS,
    TABLE_TAG_BOOKMARK_TOOLBOX,
    TABLE_TAG_MEDICAL,
    TABLE_TAG_REFERENCE
    
};

//enum alertTagToolBox {
//    kAlertViewTagCompScenarios = 300,
//    kAlertViewTagChaptersScenarios,
//};

@interface ToolBoxMainViewController_iPad : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UISearchBarDelegate> {
    NSMutableArray *arrayChapters;     // chapter with Skill sheet 
    NSMutableArray *arrayChaptersForMedical;
    NSMutableArray *arrayBookmarkData;
    NSMutableArray *arrayScenarios;
    
    NSMutableArray *arr_References;
	NSMutableArray *filterArray;

    
    int chapterID;
    int _type;      //0: Scenarioes    1: Skill Sheet
    NSInteger _id;  //Medical scene check offs
    
    NSString *name;
    
}
@property (nonatomic, assign) int _type;   //0: Scenarioes    1: Skill Sheet
@property(nonatomic, assign) NSInteger _id;
@property (retain, nonatomic) IBOutlet UITableView *tableView_item;
@property (retain, nonatomic) IBOutlet UISearchBar *mySearchBar;

// if the button was been taped, that narrow was show immediately.
@property (retain, nonatomic) IBOutlet UIImageView *imv_narrow_chapter;
@property (retain, nonatomic) IBOutlet UIImageView *imv_narrow_different;


@property (retain, nonatomic) IBOutlet UIImageView *imv_narrow_bookmark;

@property (retain, nonatomic) IBOutlet UIImageView *imv_narrow_medical;
@property (retain, nonatomic) IBOutlet UIImageView *imv_narrow_Reference;

@property (retain, nonatomic) IBOutlet UILabel *imv_noData;

@property (retain, nonatomic) IBOutlet UIButton *btn_chapters;
@property (retain, nonatomic) IBOutlet UIButton *btn_different;
@property (retain, nonatomic) IBOutlet UIButton *btn_bookmarks;
@property (retain, nonatomic) IBOutlet UIButton *btn_medical;
@property (retain, nonatomic) IBOutlet UIButton *btn_reference;

- (IBAction)skillSheets:(id)sender;
- (IBAction)differentials:(id)sender;
- (IBAction)bookmarks:(id)sender;
- (IBAction)medical:(id)sender;
- (IBAction)reference:(id)sender;


@end
