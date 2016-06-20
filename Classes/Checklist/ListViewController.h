//
//  ListViewController.h
//  Firefighter
//
//  Created by sandra on 11/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView *tbView;
	IBOutlet UILabel *lbTitle;
	NSMutableArray *arrayChapters;
	
	NSInteger _id;
	NSString *chapter;
}

@property(nonatomic, assign) NSInteger _id;
@property(nonatomic, retain) NSString *chapter;

-(IBAction)clearAll: (id)sender;
-(void)getChaptersfromDB;

@end
