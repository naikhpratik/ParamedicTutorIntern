//
//  CardChapterViewController.h
//  Quiz
//
//  Created by perry on 9/25/13.
//
//

#import <UIKit/UIKit.h>
#import "SqlMB.h"
#import "ChapterBean.h"

@interface CardChapterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    NSMutableArray *arrayChapters;
}

@property (retain, nonatomic) IBOutlet UITableView *tbView;


@end
