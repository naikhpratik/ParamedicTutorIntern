//
//  BookmarkListViewController.m
//  Quiz
//
//  Created by Zorro on 2/27/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import "BookmarkListViewController.h"
#import "QuizAppDelegate.h"
#import "ChapterBean.h"
#import "BookmarkViewController.h"
#import "QuizViewController.h"
#import "CardViewController.h"
#import "SqlMB.h"
@implementation BookmarkListViewController

@synthesize bookType;
@synthesize tbView = _tbView;
@synthesize imgView_Title = _imgView_Title;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	tbView.backgroundColor = [UIColor clearColor];
	self.navigationItem.title = @"Bookmarks";
	if (bookType == 0) {
        if (iPhone5) {
            bgImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Quizzes-bookmarks-5" ofType:@"png"]];
        } else {
            bgImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Quizzes-bookmarks" ofType:@"png"]];
        }
        self.imgView_Title.image = [UIImage imageNamed:@"quiz_bar"];
	}else if (bookType == 1) {
        if (iPhone5) {
            bgImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"flashcardsbookmarks" ofType:@"png"]];
        } else {
            bgImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"flashcardsbookmarks" ofType:@"png"]];
        }
        self.imgView_Title.image = [UIImage imageNamed:@"fcard_bar"];
	}
	
	chapterArray = [[NSMutableArray alloc] init];
    mArrBookmarkChapter = [[NSMutableArray alloc]init];
//	[self getChaptersfromDB];
//	[self getBookmarks];
//    [[SqlMB getInstance] getAllChapterFromDB:bookType data:chapterArray];
//	[[SqlMB getInstance] getAllBookmarksFromDB:bookType data:chapterArray];
    [[SqlMB getInstance] getAllChapterFromDB:bookType data:chapterArray];
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [mArrBookmarkChapter removeAllObjects];
    if (bookType == 0) {
        [[SqlMB getInstance] getBookmarkChapter:mArrBookmarkChapter];
    } else {
        [[SqlMB getInstance] getBookmarkChapterForFlashcard:mArrBookmarkChapter];
    }
    [self.tbView reloadData];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [self setImgView_Title:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[chapterArray release];
	//[chapters release];
	[tbView release];
	[bgImageView release];
    [mArrBookmarkChapter release];
    [_imgView_Title release];
    [super dealloc];
}

#pragma mark UITableView methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [mArrBookmarkChapter count] + 1; 
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    if (section == 0) {                       // the title of section 0 is null
        sectionName = @"";
    } else {                                  // other section with Bookmarks
        int ID = [[mArrBookmarkChapter objectAtIndex:section - 1] intValue]; // the object is NSNumber type that in the mArrBookmarkChapter
        ChapterBean *chapterBean = [chapterArray objectAtIndex:ID - 1];
        sectionName = chapterBean.name;
    }
    return sectionName;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//	BookmarkViewController *bookmarkViewController = [[BookmarkViewController alloc] initWithNibName:@"BookmarkViewController" bundle:nil];
//	if (indexPath.row == 0) {
//		bookmarkViewController.chapterID = 0;
//		switch (bookType) {
//		case 0:
//			bookmarkViewController.name = @"Comprehensive Quiz";
//			break;
//		case 1:
//			bookmarkViewController.name = @"All Chapters";
//			break;
//		default:
//			break;
//		}
//	}else {
//		ChapterBean *bBean = [chapterArray objectAtIndex:(indexPath.row-1)];
//		bookmarkViewController.chapterID = bBean.chapterID;
//		bookmarkViewController.name = bBean.name;
//	}
//    bookmarkViewController.bookType = bookType;
//	[self.navigationController pushViewController:bookmarkViewController animated:YES];
//	[bookmarkViewController release];
    
//    BookmarkBean *bookmarkBean = [mArrBookmarkChapter objectAtIndex:indexPath.row];
	switch (bookType) {
		case 0:
		{
			QuizViewController *quizViewController = [[QuizViewController alloc] initWithNibName:@"QuizViewController" bundle:nil];
            NSMutableArray *arrayTempBookmardData = [[NSMutableArray alloc] initWithCapacity:10];
            NSInteger tempChapterId = 0;
            if (indexPath.section == 0) {
                quizViewController.sChapter = @"Comprehensive Quiz";
                quizViewController.iChapter = 0;
                quizViewController.mode = 1;
                quizViewController.fromComprehensive = YES;
                if ([mArrBookmarkChapter count] != 0) {    // have bookmark data
                    tempChapterId = [[mArrBookmarkChapter objectAtIndex:indexPath.section] intValue];
                    [[SqlMB getInstance] getBookmarkFromDB:bookType Chapter:tempChapterId data:arrayTempBookmardData];
                    BookmarkBean *bookmarkBean = [arrayTempBookmardData objectAtIndex:indexPath.row];
                    quizViewController.bookquizID = bookmarkBean.quizID;
                    quizViewController.hasPreviousData = NO;
                    [self.navigationController pushViewController:quizViewController animated:YES];
                    [quizViewController release];
                }
                else {                             // have no bookmark data
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Sorry there is no data." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                }
            } else {
                tempChapterId = [[mArrBookmarkChapter objectAtIndex:indexPath.section - 1] intValue];
                [[SqlMB getInstance] getBookmarkFromDB:bookType Chapter:tempChapterId data:arrayTempBookmardData];
                BookmarkBean *bookmarkBean = [arrayTempBookmardData objectAtIndex:indexPath.row];
                ChapterBean *chapterBean = [chapterArray objectAtIndex:tempChapterId - 1];
                quizViewController.sChapter = chapterBean.name;
                quizViewController.iChapter = chapterBean.chapterID;
                quizViewController.fromComprehensive = NO;
                quizViewController.mode = 1;
                quizViewController.bookquizID = bookmarkBean.quizID;
                quizViewController.hasPreviousData = NO;
                [self.navigationController pushViewController:quizViewController animated:YES];
                [quizViewController release];
            }
		}
			break;
		case 1:
		{
            CardViewController *cardViewController = [[CardViewController alloc] initWithNibName:@"CardViewController" bundle:nil];
            NSMutableArray *arrTempBookmark = [[NSMutableArray alloc] initWithCapacity:10];
            NSInteger tempChapterId = 0;
            if (indexPath.section == 0) {                                   // All bookmark
                cardViewController.sChapter = @"Flashcards";
                cardViewController.iChapter = 0;
                cardViewController.fromfromComprehensive = YES;
                cardViewController.mode = 1; // bookmark
                
                if ([mArrBookmarkChapter count] != 0) {  // have bookmark data
                    tempChapterId = [[mArrBookmarkChapter objectAtIndex:indexPath.section]intValue];
                    [[SqlMB getInstance] getBookmarkFromDB:bookType Chapter:tempChapterId data:arrTempBookmark];
                    BookmarkBean *bookmarkBean = [arrTempBookmark objectAtIndex:indexPath.row];
                    cardViewController.bookquizID = bookmarkBean.quizID;
                    cardViewController.hadPreviousData = NO;
                    [self.navigationController pushViewController:cardViewController animated:YES];
                    [cardViewController release];
                } else {                                // have no bookmark data
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Sorry there is no data." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                }
            } else {                                                        // Chapters bookmark
                tempChapterId = [[mArrBookmarkChapter objectAtIndex:indexPath.section - 1] intValue];
                [[SqlMB getInstance] getBookmarkFromDB:bookType Chapter:tempChapterId data:arrTempBookmark];
                BookmarkBean *bookmarkBean = [arrTempBookmark objectAtIndex:indexPath.row];
                ChapterBean *chapterBean = [chapterArray objectAtIndex:tempChapterId - 1];
                cardViewController.sChapter = chapterBean.name;
                cardViewController.iChapter = chapterBean.chapterID;
                cardViewController.mode = 1;
                cardViewController.fromfromComprehensive = NO;
                cardViewController.bookquizID = bookmarkBean.quizID;
                cardViewController.hadPreviousData = NO;
                [self.navigationController pushViewController:cardViewController animated:YES];
                [cardViewController release];
            }
		}
			break;
		default:
			break;
	}
}

-(UITableViewCell *) tableView:(UITableView *) tv cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];//[[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
    if (bookType == 0) {
        if (indexPath.section == 0) {
            cell.textLabel.text = @"Comprehensive Quiz";
        } else {
            NSMutableArray *arrayTempBookmardData = [[NSMutableArray alloc] initWithCapacity:10];
            NSInteger tempChapterId = 0;
            [arrayTempBookmardData removeAllObjects];     //  remove old data when init the new section.
            tempChapterId = [[mArrBookmarkChapter objectAtIndex:indexPath.section - 1] intValue]; // the object is NSNumber type that in the mArrBookmarkChapter
            [[SqlMB getInstance] getBookmarkFromDB:bookType Chapter:tempChapterId data:arrayTempBookmardData];
            BookmarkBean *bookmarkBean = [arrayTempBookmardData objectAtIndex:indexPath.row];
            cell.textLabel.text = bookmarkBean.strQuiz;
        }
    } else {
        if (indexPath.section == 0) {
            cell.textLabel.text = @"Flashcards (All Bookmarks)";
        } else {
            
            NSMutableArray *arrTempBookmark = [[NSMutableArray alloc] initWithCapacity:10];
            NSInteger tempChapterId = 0;     //  remove old data when init the new section.
            tempChapterId = [[mArrBookmarkChapter objectAtIndex:indexPath.section - 1] intValue]; // the object is NSNumber type that in the mArrBookmarkChapter
            [[SqlMB getInstance] getBookmarkFromDB:bookType Chapter:tempChapterId data:arrTempBookmark];
            BookmarkBean *bookmarkBean = [arrTempBookmark objectAtIndex:indexPath.row];
            cell.textLabel.text = bookmarkBean.strQuiz;
            
        }
    }
    
	return cell;
}

-(NSInteger) tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger) section
{
    if (section == 0) {
        return 1;
    }else {
        NSMutableArray *arrayTempBookmardData = [[NSMutableArray alloc] initWithCapacity:10];
        NSInteger tempChapterId = 0;
        [arrayTempBookmardData removeAllObjects];     //  remove old data when init the new section.
        tempChapterId = [[mArrBookmarkChapter objectAtIndex:section - 1] intValue]; // the object is NSNumber type that in the mArrBookmarkChapter
        [[SqlMB getInstance] getBookmarkFromDB:bookType Chapter:tempChapterId data:arrayTempBookmardData];
        NSLog(@"arrayBookmarkData = %@",arrayTempBookmardData);
        return [arrayTempBookmardData count];
    }
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	return 35.0;
}

@end
