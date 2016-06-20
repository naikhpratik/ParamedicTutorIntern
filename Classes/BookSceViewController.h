//
//  BookSceViewController.h
//  Quiz
//
//  Created by Zorro on 3/12/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BookSceViewController : UIViewController {
    IBOutlet UITableView *tbView;
	IBOutlet UIImageView *backImage;
	NSMutableArray *arrayScenarios;
	int _type;   //0: Scenarioes    1: Skill Sheet
}

-(void)getScenariosfromDB;

@property (retain, nonatomic) IBOutlet UILabel *lbl_emptyMsg;
@property (nonatomic, assign) int _type;   //0: Scenarioes    1: Skill Sheet
@property (retain, nonatomic) IBOutlet UIImageView *imgView_header;


@end
