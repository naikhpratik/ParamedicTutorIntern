//
//  BookmarkViewController.h
//  Quiz
//
//  Created by Zorro on 2/18/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BookmarkViewController : UIViewController {
	IBOutlet UITableView *tbView;
	NSMutableArray *arrayBookmark;
	int chapterID;
	NSString *name;
	int bookType; //0: quiz    1: flashcard
}

-(void)getBookmarkfromDB;

@property (nonatomic, assign) int chapterID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) int bookType;

@end
