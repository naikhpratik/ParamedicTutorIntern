//
//  ScoreViewController.h
//  Quiz
//
//  Created by Zorro on 2/18/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScoreViewController : UIViewController <UIActionSheetDelegate> {
	IBOutlet UITableView *tbView;
	NSMutableArray *arrayScores;
	NSMutableArray *array_Del;
	//UIBarButtonItem *_rightBarButtonItem;
}

-(void)getScoresfromDB;
-(void)delScoresfromDB: (int)scoreID;
//-(void) editTable:(id)sender;

@end
