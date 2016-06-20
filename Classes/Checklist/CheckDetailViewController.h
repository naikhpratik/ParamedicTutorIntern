//
//  CheckDetailViewController.h
//  Firefighter
//
//  Created by sandra on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChapterBean.h"

@interface CheckDetailViewController : UIViewController {
	IBOutlet UITableView *tbView;
	IBOutlet UILabel *lbTitle;
	
	ChapterBean *chapterBean;
	
	NSMutableArray *_arr_checks;
}

-(void)getDatafromDB;
-(IBAction)checkChange: (id)sender;
-(IBAction)clearAll: (id)sender;

@property(nonatomic, retain) ChapterBean *chapterBean;

@end
