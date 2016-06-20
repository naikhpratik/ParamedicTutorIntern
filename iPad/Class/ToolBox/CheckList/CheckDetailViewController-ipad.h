//
//  CheckDetailViewController-ipad.h
//  Quiz
//
//  Created by Arthur on 13-9-14.
//
//

#import <UIKit/UIKit.h>
#import "ChapterBean.h"

@interface CheckDetailViewController_ipad : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    ChapterBean *chapterBean;
	
	NSMutableArray *_arr_checks;
}
@property (retain, nonatomic) IBOutlet UILabel *lbTitle;
@property (retain, nonatomic) IBOutlet UITableView *tbView;
@property (retain, nonatomic) ChapterBean *chapterBean;

@end
