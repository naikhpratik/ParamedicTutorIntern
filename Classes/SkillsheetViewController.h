//
//  SkillsheetViewController.h
//  Quiz
//
//  Created by Zorro on 3/9/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SkillsheetViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *tbView;
	NSMutableArray *arrayChapters;
}

-(IBAction)bookMark: (id)sender;
-(void)getScenariosfromDB;
@property (retain, nonatomic) IBOutlet UIImageView *imgView_skillSheet;

@end
