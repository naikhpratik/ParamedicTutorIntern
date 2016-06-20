//
//  QuizMainViewController.h
//  Quiz
//
//  Created by Zorro on 2/15/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMainViewCell.h"

@interface QuizMainViewController : UIViewController<UIAlertViewDelegate> {
	IBOutlet UITableView *tbView;
	NSArray *arrayList;
}

@property (retain, nonatomic) IBOutlet UIImageView *quiz_bg_imageView;
-(void)startQuiz;
-(void)score;
-(void)chapter;
-(IBAction)bookMark: (id)sender;

@end
