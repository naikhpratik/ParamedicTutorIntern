//
//  ToolMainViewController.h
//  Quiz
//
//  Created by Zorro on 3/9/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMainViewCell.h"

@interface ToolMainViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {

}
@property (retain, nonatomic) IBOutlet UIImageView *tool_bg_imageView;
@property (retain, nonatomic) IBOutlet UITableView *tbView;

-(IBAction)skillsheets: (id)sender;
-(IBAction)DCO: (id)sender;
-(IBAction)checkOff:(id)sender;
- (IBAction)btnpressed_reference:(id)sender;

@end
