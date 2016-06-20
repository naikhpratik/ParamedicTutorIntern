//
//  ChapterViewController.h
//  Quiz
//
//  Created by Zorro on 2/23/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChapterViewController : UIViewController <UIAlertViewDelegate>{
	IBOutlet UITableView *tbView;
	NSMutableArray *arrayChapters;
}
@property (retain, nonatomic) IBOutlet UIImageView *chapter_bg_imageView;

-(void)getChaptersfromDB;

@end
