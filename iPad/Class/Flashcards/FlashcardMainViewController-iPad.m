//
//  QuizesMainViewController-iPad.m
//  Quiz
//
//  Created by Arthur on 13-9-10.
//
//


#import <QuartzCore/QuartzCore.h>
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import "DEFacebookComposeViewController.h"
#import "UIDevice+DEFacebookComposeViewController.h"

#import "SqlMB.h"
#import "ScoreBean.h"
#import "CustomCellScore.h"
#import "CustomCellQuiz.h"
#import "QuizViewController-ipad.h"
#import "FlashcardMainViewController-iPad.h"
#import "FlashCardViewController.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"



@interface FlashcardMainViewController_iPad () {
     NSInteger chapterIndex;
     NSMutableArray *mArrBookmarkChapter;  //  Storage the bookmark chapter.
    
}

@end

@implementation FlashcardMainViewController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"flash_page"];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    [[GAI sharedInstance] dispatch];
    [_tableView_item setBackgroundView:nil];
    chapterIndex = 0;
     bookType = 1;             // Flashcard bookmark
    _tableView_item.delegate = self;
    _imv_narrow_bookmark.hidden = YES;
    [_btn_chapters setSelected:YES];
    [_btn_chapters setImage:[UIImage imageNamed:@"chapter_iPad_press"] forState:UIControlStateSelected];
    
   
    // get the chapter data from DB
    arrayChapters = [[NSMutableArray alloc] init];
    mArrBookmarkChapter = [[NSMutableArray alloc]init];
    arrayBookmarkData = [[NSMutableArray alloc]init];
   [[SqlMB getInstance] getAllChapterFromDB:1 data:arrayChapters];
    [_tableView_item reloadData];  // chapters tableView default
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationItem.title = @"Flashcards Home";
    [mArrBookmarkChapter removeAllObjects];
    [[SqlMB getInstance] getBookmarkChapterForFlashcard:mArrBookmarkChapter];
    
    if (_tableView_item.tag == TABLE_TAG_BOOKMARK_FLASHCARD) {
        [_tableView_item reloadData];  // If the bookmark data was null, we need refresh the tableview. 
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView_item release];
    [_imv_narrow_chapter release];
    [_imv_narrow_bookmark release];
    [_btn_chapters release];
    [_btn_bookmarks release];
    [mArrBookmarkChapter release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setTableView_item:nil];
    [self setImv_narrow_chapter:nil];
    [self setImv_narrow_bookmark:nil];
    [self setBtn_chapters:nil];
    [self setBtn_bookmarks:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark - Button tap action methods

- (IBAction)comprehensiveFlashcards:(id)sender {                  // Comprehensive quiz
    
    if ([[SqlMB getInstance] shouldCOntinueForCards:0]) {         // All flashcards
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want to continue where you left off, or delete and start over?" delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Continue", nil];
        alert.tag = kAlertViewTagCompFlashCard;
        [alert show];
        [alert release];
    } else {
        FlashCardViewController *cardViewController = [[FlashCardViewController alloc] initWithNibName:@"FlashCardViewController" bundle:nil];
        cardViewController.sChapter = @"All Chapters";
        cardViewController.iChapter = 0;
        cardViewController.mode = 0;
        cardViewController.hadPreviousData = NO;
        [self.navigationController pushViewController:cardViewController animated:YES];
        [cardViewController release];
        
    }
}

- (IBAction)chapters:(id)sender {                           //  Chapters
    
    _imv_narrow_chapter.hidden = NO;
    _imv_narrow_bookmark.hidden = YES;
    [_btn_chapters setSelected:YES];
    [_btn_bookmarks setSelected:NO];
    [_btn_chapters setImage:[UIImage imageNamed:@"chapter_iPad_press"] forState:UIControlStateSelected];
    _tableView_item.tag = TABLE_TAG_CHAPTER_FLASHCARD;
    [_tableView_item reloadData];
    
}

- (IBAction)bookmarks:(id)sender {                          //  Bookmarks
    
    _imv_narrow_bookmark.hidden = NO;
    _imv_narrow_chapter.hidden = YES;
    [_btn_bookmarks setSelected:YES];
    [_btn_chapters setSelected:NO];
    [_btn_bookmarks setImage:[UIImage imageNamed:@"bookmarks_iPad_flashcards_press"] forState:UIControlStateSelected];
    
    
    // initial the bookmark data
    

    
    _tableView_item.tag = TABLE_TAG_BOOKMARK_FLASHCARD;
    [_tableView_item reloadData];
}




#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView.tag == TABLE_TAG_BOOKMARK_FLASHCARD) {        //  Bookmarks
        return [mArrBookmarkChapter count] + 1;       //  the section 0 is comprehensive(AllBookmarks)
    }
    else {                                                 // Chapters  default
        return 1;
    }
    
    
    return 1;

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if (tableView.tag == TABLE_TAG_BOOKMARK_FLASHCARD) {        //  Bookmarks
        if (section == 0) {
            return 1;
        }else {
            
            [arrayBookmarkData removeAllObjects];     //  remove old data when init the new section.
            chapterID = [[mArrBookmarkChapter objectAtIndex:section - 1] intValue]; // the object is NSNumber type that in the mArrBookmarkChapter
            [[SqlMB getInstance] getBookmarkFromDB:bookType Chapter:chapterID data:arrayBookmarkData];
            NSLog(@"arrayBookmarkData = %@",arrayBookmarkData);
            return [arrayBookmarkData count];
        }
        
    }
    else {                                                 // Chapters  default
        return [arrayChapters count];
    }
  
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"flashcardCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell ==  nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    if (tableView.tag == TABLE_TAG_BOOKMARK_FLASHCARD) {        //  Bookmarks
       
        if (indexPath.section == 0) {
            cell.textLabel.text = @"Flashcards (All Bookmarks)";
        } else {
        
            [arrayBookmarkData removeAllObjects];     //  remove old data when init the new section.
            chapterID = [[mArrBookmarkChapter objectAtIndex:indexPath.section - 1] intValue]; // the object is NSNumber type that in the mArrBookmarkChapter
            [[SqlMB getInstance] getBookmarkFromDB:bookType Chapter:chapterID data:arrayBookmarkData];
            BookmarkBean *bookmarkBean = [arrayBookmarkData objectAtIndex:indexPath.row];
            cell.textLabel.text = bookmarkBean.strQuiz;
        
        }
        
        return cell;
    }
    else {                                                 // Chapters  default
        
        ChapterBean *cBean = [arrayChapters objectAtIndex:(indexPath.row)];
		cell.textLabel.text = cBean.name;
        return cell;
    }
    
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *sectionName;
    if (tableView.tag == TABLE_TAG_BOOKMARK_FLASHCARD) {                              //  Bookmarks have section title
        if (section == 0) {                       // the title of section 0 is null
            sectionName = @"";
        } else {                                  // other section with Bookmarks
            int ID = [[mArrBookmarkChapter objectAtIndex:section - 1] intValue]; // the object is NSNumber type that in the mArrBookmarkChapter            
            ChapterBean *chapterBean = [arrayChapters objectAtIndex:ID - 1];
            sectionName = chapterBean.name;
        }
    }else {                                                                 // others cannot have section title
        sectionName = @"";
    }
    
    return sectionName;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}
#pragma mark -
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == TABLE_TAG_BOOKMARK_FLASHCARD) {                                    //  Bookmarks
                
        FlashCardViewController *flashcardView = [[FlashCardViewController alloc]initWithNibName:@"FlashCardViewController" bundle:nil];
        [arrayBookmarkData removeAllObjects];                           //remove old data
        if (indexPath.section == 0) {                                   // All bookmark
            flashcardView.sChapter = @"Comprehensive Flashcards (All Bookmarks)";
            flashcardView.iChapter = 0;
            flashcardView.mode = 1; // bookmark
            
            if ([mArrBookmarkChapter count] != 0) {  // have bookmark data
                chapterID = [[mArrBookmarkChapter objectAtIndex:indexPath.section]intValue];
                [[SqlMB getInstance] getBookmarkFromDB:bookType Chapter:chapterID data:arrayBookmarkData];
                BookmarkBean *bookmarkBean = [arrayBookmarkData objectAtIndex:indexPath.row];
                flashcardView.bookquizID = bookmarkBean.quizID;
                flashcardView.hadPreviousData = NO;
                flashcardView.fromComprehensive = YES;
                [self.navigationController pushViewController:flashcardView animated:YES];
                [flashcardView release];             
            } else {                                // have no bookmark data
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Sorry there is no data." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                alert.tag = kAlertViewTagOther;
                [alert release];
            }
        } else {                                                        // Chapters bookmark
            chapterID = [[mArrBookmarkChapter objectAtIndex:indexPath.section - 1] intValue];
            [[SqlMB getInstance] getBookmarkFromDB:bookType Chapter:chapterID data:arrayBookmarkData];
            BookmarkBean *bookmarkBean = [arrayBookmarkData objectAtIndex:indexPath.row];
            ChapterBean *chapterBean = [arrayChapters objectAtIndex:chapterID - 1];
            flashcardView.sChapter = chapterBean.name;
            flashcardView.iChapter = chapterBean.chapterID;
            flashcardView.mode = 1;
            flashcardView.bookquizID = bookmarkBean.quizID;
            flashcardView.hadPreviousData = NO;
            flashcardView.fromComprehensive = NO;
            [self.navigationController pushViewController:flashcardView animated:YES];
            [flashcardView release];
        }
        
    }
    
    else {                                                 // Chapters  default
//        ChapterBean *cBean = [arrayChapters objectAtIndex:indexPath.row];
        if ([[SqlMB getInstance] shouldCOntinueForCards:indexPath.row + 1]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want to continue where you left off, or delete and start over?" delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Continue", nil];
            alert.tag = indexPath.row;
            [alert show];
            [alert release];
        } else {
            FlashCardViewController *cardViewController = [[FlashCardViewController alloc] initWithNibName:@"FlashCardViewController" bundle:nil];
            ChapterBean *cBean = [arrayChapters objectAtIndex:(indexPath.row)];
            cardViewController.sChapter = cBean.name;
            cardViewController.iChapter = cBean.chapterID;
            cardViewController.mode = 0;
            cardViewController.hadPreviousData = NO;
            [self.navigationController pushViewController:cardViewController animated:YES];
            [cardViewController release];
            
        }

    }
}

#pragma mark -
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAlertViewTagCompFlashCard) {  // Alert with Comprehensive flashcard button
        if (buttonIndex == 1) {
            FlashCardViewController *cardViewController = [[FlashCardViewController alloc] initWithNibName:@"FlashCardViewController" bundle:nil];
            cardViewController.sChapter = @"All Chapters";
            cardViewController.iChapter = 0;
            cardViewController.mode = 0;
            cardViewController.hadPreviousData = YES;
            [self.navigationController pushViewController:cardViewController animated:YES];
            [cardViewController release];
        } else {
            [[SqlMB getInstance] clearProcessForCards:0];
            FlashCardViewController *cardViewController = [[FlashCardViewController alloc] initWithNibName:@"FlashCardViewController" bundle:nil];
            cardViewController.sChapter = @"All Chapters";
            cardViewController.iChapter = 0;
            cardViewController.mode = 0;
            cardViewController.hadPreviousData = NO;
            [self.navigationController pushViewController:cardViewController animated:YES];
            [cardViewController release];
        }
    }
    else if (alertView.tag == kAlertViewTagBookmark){  // Alert with Bookmark
        
    
    }
    else if (alertView.tag == kAlertViewTagOther){  // 
        
        
    }
    else {                                              // Chapters alert.
        if (buttonIndex == 1) { // continue
            FlashCardViewController *cardViewController = [[FlashCardViewController alloc] initWithNibName:@"FlashCardViewController" bundle:nil];
            ChapterBean *cBean = [arrayChapters objectAtIndex:(alertView.tag)];
            cardViewController.sChapter = cBean.name;
            cardViewController.iChapter = cBean.chapterID;
            cardViewController.mode = 0;
            cardViewController.hadPreviousData = YES;
            [self.navigationController pushViewController:cardViewController animated:YES];
            [cardViewController release];

        } else {               // delete
            ChapterBean *cBean = [arrayChapters objectAtIndex:(alertView.tag)];
            [[SqlMB getInstance] clearProcessForCards:cBean.chapterID];
             FlashCardViewController *cardViewController = [[FlashCardViewController alloc] initWithNibName:@"FlashCardViewController" bundle:nil];
            
            cardViewController.sChapter = cBean.name;
            cardViewController.iChapter = cBean.chapterID;
            cardViewController.mode = 0;
            cardViewController.hadPreviousData = NO;
            [self.navigationController pushViewController:cardViewController animated:YES];
            [cardViewController release];
        }

    
    }
}

#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // buttonIndex
    // 0 facebook
    // 1 twitter
    // 2 cancel
    
    if (buttonIndex == 0) {
        
        [self shareToFacebook];
        
    } else if (buttonIndex == 1) {
        
        [self shareToTwitter];
        
    } else {
        
        return;
    }
    
}


#pragma mark - share methods
- (void)shareToFacebook {
//    NSLog(@"share to fb");
//    
//    DEFacebookComposeViewController *facebookComposer = [[DEFacebookComposeViewController alloc]init];
//    self.modalPresentationStyle = UIModalPresentationCurrentContext;
//    NSString *htmlContent = [self getShareBody];
//    
//    [facebookComposer setInitialText:htmlContent];
//    [facebookComposer addURL:[NSURL URLWithString:kUrlForSharing]];
//    [facebookComposer setCompletionHandler: ^(DEFacebookComposeViewControllerResult result){
//        
//        switch (result) {
//            case DEFacebookComposeViewControllerResultCancelled:
//                
//                break;
//                
//            case DEFacebookComposeViewControllerResultDone:
//                break;
//                
//            default:
//                break;
//        }
//        //        [self dismissModalViewControllerAnimated:YES];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }];
//    
//    if ([UIDevice de_isIOS4]) {
//        [self presentModalViewController:facebookComposer animated:YES];
//    } else {
//        [self presentViewController:facebookComposer animated:YES completion:^{ }];
//    }
//    
//    [facebookComposer release];
    NSString *htmlContent = [self getShareBody];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<6.0f) {
        NSString *sURL = @"http://www.facebook.com/pages/Code-3-Apps/180948875248863";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: sURL]];
    }else{
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            NSLog(@"1");
            SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [mySLComposerSheet setInitialText:htmlContent];
            
            [mySLComposerSheet addImage:[UIImage imageNamed:@"share_img.png"]];
            
            [mySLComposerSheet addURL:[NSURL URLWithString:kUrlForSharing]];
            
            [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Post Canceled");
                        break;
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Post Sucessful");
                        break;
                        
                    default:
                        break;
                }
            }];
            
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        } else {
            NSLog(@"2");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Facebook Account" message:@"There are no Facebook accounts configured. You can add or create a Facebook account in Settings. " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            alert.tag = kAlertViewTagOther;
            [alert release];
            
            
        }
    }

}

- (void)shareToTwitter {
    NSLog(@"share to twitter");
    NSString *htmlContent = [self getShareBody];
    
    if (![htmlContent isEqualToString:@""]) { //no content to share
        TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
        [tweetViewController setInitialText:htmlContent];
        [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
            NSString *output;
            
            switch (result) {
                case TWTweetComposeViewControllerResultCancelled:
                    // The cancel button was tapped.
                    output = @"Tweet cancelled.";
                    break;
                case TWTweetComposeViewControllerResultDone:
                    // The tweet was sent.
                    output = @"Tweet done.";
                    break;
                default:
                    break;
            }
            //[activityIndicator startAnimating];
            //self.navigationController.view.userInteractionEnabled = YES;
            if ([output isEqualToString:@"Tweet done."]) {
                [self performSelectorOnMainThread:@selector(shareTwitterAction) withObject:output waitUntilDone:NO];
            }
            
            // Dismiss the tweet composition view controller.
            [self dismissModalViewControllerAnimated:YES];
        }];
        
        [tweetViewController addURL:[NSURL URLWithString:kUrlForSharing]];
        [self presentModalViewController:tweetViewController animated:YES];
    }
}


- (NSString *)getShareBody {
    
//    NSArray *tempArr = [scoreStr componentsSeparatedByString:@")"];
//    NSString *score = [tempArr objectAtIndex:0];
//    NSString *shareBody = [NSString stringWithFormat:@"I just scored %@) on Medic Tutor practice quiz.", score];
    
//    return shareBody;
    return @"";
}

- (void)shareTwitterAction
{
    self.navigationController.view.userInteractionEnabled = YES;
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Twitter" message:@"Your message has been posted." delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [alert show];
    [alert release];
}
@end
