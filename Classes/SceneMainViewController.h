//
//  SceneMainViewController.h
//  Quiz
//
//  Created by Zorro on 2/27/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMainViewCell.h"

@interface SceneMainViewController : UIViewController {
	IBOutlet UITableView *tbView;
	NSMutableArray *arrayScenarios;
}
@property (retain, nonatomic) IBOutlet UIImageView *scenarios_bg_imageView;

-(IBAction)bookMark: (id)sender;
-(void)getScenariosfromDB;

@end
