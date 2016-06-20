//
//  BookmarkListViewController.h
//  Quiz
//
//  Created by Zorro on 2/27/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BookmarkListViewController : UIViewController<UITableViewDelegate ,UITableViewDataSource> {
	IBOutlet UITableView *tbView;
	IBOutlet UIImageView *bgImageView;
    NSMutableArray *mArrBookmarkChapter;
	NSMutableArray *chapterArray;
	int bookType; //0: quiz    1: flashcard   
}

-(void)getChaptersfromDB;
-(void)getBookmarks;

@property (retain, nonatomic) IBOutlet UIImageView *imgView_Title;
@property (nonatomic, assign) int bookType;
@property (nonatomic, assign) UITableView *tbView;
@end
