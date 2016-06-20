//
//  FlashcardMainViewController.h
//  Quiz
//
//  Created by Zorro on 2/27/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMainViewCell.h"

@interface FlashcardMainViewController : UIViewController<UIAlertViewDelegate> {
	IBOutlet UITableView *tbView;
//	NSMutableArray *arrayChapters;
}
@property (retain, nonatomic) IBOutlet UIImageView *flashcard_bg_imageView;

-(void)getChaptersfromDB;
-(IBAction)bookMark: (id)sender;

@end
