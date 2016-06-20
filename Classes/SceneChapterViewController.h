//
//  SceneChapterViewController.h
//  Quiz
//
//  Created by perry on 9/27/13.
//
//

#import <UIKit/UIKit.h>
#import "SqlMB.h"
#import "ScenariosBean.h"

@interface SceneChapterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *arrScnarios;
}

@property (retain, nonatomic) IBOutlet UITableView *tbView_content;


@end
