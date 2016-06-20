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
#import "QuizesMainViewController-iPad.h"


#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"


@interface QuizesMainViewController_iPad () {
     NSInteger chapterIndex;
     NSMutableArray *mArrBookmarkChapter;  //  Storage the bookmark chapter.
     NSString *scoreStr;
}

@end

@implementation QuizesMainViewController_iPad

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
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"quiz_page"];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    [[GAI sharedInstance] dispatch];
    chapterIndex = 0;
     bookType = 0;
    _tableView_item.delegate = self;
    [_tableView_item setBackgroundView:nil];
    _imv_narrow_bookmark.hidden = YES;
    _imv_narrow_score.hidden = YES;
    [_btn_chapters setSelected:YES];
    [_btn_chapters setImage:[UIImage imageNamed:@"chapter_iPad_press"] forState:UIControlStateSelected];
    
   
    // get the chapter data from DB
    arrayChapters = [[NSMutableArray alloc] init];
    mArrBookmarkChapter = [[NSMutableArray alloc]init];
    arrayBookmarkData = [[NSMutableArray alloc]init];
    arrayScores = [[NSMutableArray alloc]init];
    [[SqlMB getInstance] getChaptersFromDB:arrayChapters];
    [_tableView_item reloadData];  // chapters tableView default
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationItem.title = @"Quizzes Home";
    [mArrBookmarkChapter removeAllObjects];
    [[SqlMB getInstance] getBookmarkChapter:mArrBookmarkChapter];
    
    if (_tableView_item.tag == TABLE_TAG_BOOKMARK) {
        [_tableView_item reloadData];  // refresh tableview data 
    }
      NSLog(@"_tableView_item.tag = %d",_tableView_item.tag);
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
    [_imv_narrow_score release];
    [_btn_chapters release];
    [_btn_bookmarks release];
    [_btn_scoreHistory release];
    [mArrBookmarkChapter release];
    [arrayScores release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView_item:nil];
    [self setImv_narrow_chapter:nil];
    [self setImv_narrow_bookmark:nil];
    [self setImv_narrow_score:nil];
    [self setBtn_chapters:nil];
    [self setBtn_bookmarks:nil];
    [self setBtn_scoreHistory:nil];
    [super viewDidUnload];
}


#pragma mark - 
#pragma mark - Button tap action methods

- (IBAction)comprehensiveQuiz:(id)sender {                  // Comprehensive quiz
    
    if ([[SqlMB getInstance] shouldContinueForQuiz:0]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want to continue where you left off, or delete and start over?" delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Continue", nil];
        alert.tag = kAlertViewTagComp;
        [alert show];
        [alert release];
    } else {
        QuizViewController_ipad *quizViewController = [[QuizViewController_ipad alloc] initWithNibName:@"QuizViewController-ipad" bundle:nil];
        
        quizViewController.sChapter = @"Comprehensive Quiz";
        quizViewController.iChapter = 0;
        quizViewController.mode = 0;
        [self.navigationController pushViewController:quizViewController animated:YES];
        [quizViewController release];

    }
}

- (IBAction)chapters:(id)sender {                           //  Chapters
    
    _imv_narrow_chapter.hidden = NO;
    _imv_narrow_bookmark.hidden = YES;
    _imv_narrow_score.hidden = YES;
    [_btn_chapters setSelected:YES];
    [_btn_bookmarks setSelected:NO];
    [_btn_scoreHistory setSelected:NO];
    [_btn_chapters setImage:[UIImage imageNamed:@"chapter_iPad_press"] forState:UIControlStateSelected];
    _tableView_item.tag = TABLE_TAG_CHAPTER;
    [_tableView_item reloadData];
    
}

- (IBAction)bookmarks:(id)sender {                          //  Bookmarks
    
    _imv_narrow_bookmark.hidden = NO;
    _imv_narrow_chapter.hidden = YES;
    _imv_narrow_score.hidden = YES;
    [_btn_bookmarks setSelected:YES];
    [_btn_chapters setSelected:NO];
    [_btn_scoreHistory setSelected:NO];
    [_btn_bookmarks setImage:[UIImage imageNamed:@"bookmarks_iPad_press"] forState:UIControlStateSelected];
    
    
    // initial the bookmark data
    

    
    _tableView_item.tag = TABLE_TAG_BOOKMARK;
    [_tableView_item reloadData];
}

- (IBAction)scoreHistory:(id)sender {                       //  Score History
    
     _imv_narrow_score.hidden = NO;
    _imv_narrow_chapter.hidden = YES;
    _imv_narrow_bookmark.hidden = YES;
    [_btn_scoreHistory setSelected:YES];
    [_btn_chapters setSelected:NO];
    [_btn_bookmarks setSelected:NO];
    [_btn_scoreHistory setImage:[UIImage imageNamed:@"scorehistory_iPad_press"] forState:UIControlStateSelected];
    
    if (arrayScores != nil) {
        [arrayScores removeAllObjects];
    }
    [[SqlMB getInstance] getScoreFromDB:arrayScores];
    
    _tableView_item.tag = TABLE_TAG_SCORE;
    [_tableView_item reloadData];
}


#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView.tag == TABLE_TAG_BOOKMARK) {        //  Bookmarks
        return [mArrBookmarkChapter count] + 1;       //  the section 0 is comprehensive(AllBookmarks)
    }
    
    else if(tableView.tag == TABLE_TAG_SCORE) {             // Score History
        return 1;
    }else {                                                 // Chapters  default
        return 1;
    }
    
    return 1;

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if (tableView.tag == TABLE_TAG_BOOKMARK) {        //  Bookmarks
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
    else if(tableView.tag == TABLE_TAG_SCORE) {             // Score History
        return [arrayScores count];
    }
    else {                                                 // Chapters  default
        return [arrayChapters count];
    }
  
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"quizCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
//    UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
    if (tableView.tag == TABLE_TAG_BOOKMARK) {        //  Bookmarks
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

        if (indexPath.section == 0) {
            cell.textLabel.text = @"Comprehensive (All Bookmarks)";
        } else {
        
            [arrayBookmarkData removeAllObjects];     //  remove old data when init the new section.
            chapterID = [[mArrBookmarkChapter objectAtIndex:indexPath.section - 1] intValue]; // the object is NSNumber type that in the mArrBookmarkChapter
            [[SqlMB getInstance] getBookmarkFromDB:bookType Chapter:chapterID data:arrayBookmarkData];
            BookmarkBean *bookmarkBean = [arrayBookmarkData objectAtIndex:indexPath.row];
            cell.textLabel.text = bookmarkBean.strQuiz;
        
        }
        
        return cell;
    }
    
    else if(tableView.tag == TABLE_TAG_SCORE) {             // Score History
        CustomCellScore *cell = (CustomCellScore *)[tableView dequeueReusableCellWithIdentifier:@"quizScoreCell"];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CustomCellScore" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        ScoreBean *sBean = [arrayScores objectAtIndex:indexPath.row];
//        cell.textLabel.text = sBean.chapter;
        
        cell.lab_title.text = sBean.chapter;
        cell.lab_result.text = sBean.result;
        return cell;
        
    }else {                                                 // Chapters  default
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

        if (cell ==  nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        ChapterBean *cBean = [arrayChapters objectAtIndex:indexPath.row];
        cell.textLabel.text = cBean.name;
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *sectionName;
    if (tableView.tag == TABLE_TAG_BOOKMARK) {                              //  Bookmarks have section title
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

    if (tableView.tag == TABLE_TAG_SCORE) {
        return 70;
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}
#pragma mark -
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == TABLE_TAG_BOOKMARK) {        //  Bookmarks
        QuizViewController_ipad *quizViewController = [[QuizViewController_ipad alloc]initWithNibName:@"QuizViewController-ipad" bundle:nil];
        //[arrayBookmarkData removeAllObjects];     //  remove old data when init the new section.
        
        if (indexPath.section == 0) {            // Comprehensive (All Bookmarks)
            quizViewController.sChapter =  @"Comprehensive (All Bookmarks)";
            quizViewController.iChapter = 0;     // All Bookmarks
            quizViewController.mode = 1;         // bookmark 
            if ([mArrBookmarkChapter count] != 0) {    // have bookmark data
                chapterID = [[mArrBookmarkChapter objectAtIndex:indexPath.section] intValue];
                
                [[SqlMB getInstance] getBookmarkFromDB:bookType Chapter:chapterID data:arrayBookmarkData];
                
                if(arrayBookmarkData.count > 0)
                {
                    BookmarkBean *bookmarkBean = [arrayBookmarkData objectAtIndex:indexPath.row];
                    quizViewController.bookquizID = bookmarkBean.quizID;
                    quizViewController.hasPreviousData = NO;
                    quizViewController.fromComprehensive = YES;
                    [self.navigationController pushViewController:quizViewController animated:YES];
                    [quizViewController release];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Sorry there is no data." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                }
                
                
            }else {                             // have no bookmark data
            
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Sorry there is no data." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
        } else {                                // Chapter bookmarks
            chapterID = [[mArrBookmarkChapter objectAtIndex:indexPath.section - 1] intValue];
            [[SqlMB getInstance] getBookmarkFromDB:bookType Chapter:chapterID data:arrayBookmarkData];
            BookmarkBean *bookmarkBean = [arrayBookmarkData objectAtIndex:indexPath.row];
            ChapterBean *chapterBean = [arrayChapters objectAtIndex:chapterID - 1];
            quizViewController.sChapter = chapterBean.name;
            quizViewController.iChapter = chapterBean.chapterID;
            quizViewController.mode = 1;
            quizViewController.bookquizID = bookmarkBean.quizID;
            quizViewController.hasPreviousData = NO;
            quizViewController.fromComprehensive = NO;
            [self.navigationController pushViewController:quizViewController animated:YES];
            [quizViewController release];
        }
    }
    else if(tableView.tag == TABLE_TAG_SCORE) {             // Score History
        scoreStr = @"";
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Share your score" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Post to Facebook", @"Post to Twitter",@"Cancel",nil];
        [actionSheet showInView:self.view];
        
        ScoreBean *sBean = [arrayScores objectAtIndex:indexPath.row];
        NSLog(@"sBean.result = %@",sBean.result);
        scoreStr = sBean.result;
        [actionSheet release];
    } else {                                                 // Chapters  default
        ChapterBean *cBean = [arrayChapters objectAtIndex:indexPath.row];
        chapterIndex = indexPath.row;
        if ([[SqlMB getInstance] shouldContinueForQuiz:cBean.chapterID]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want to continue where you left off, or delete and start over?" delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Continue", nil];
            [alert show];
            alert.tag = kAlertViewTagChapters;
            [alert release];
        } else {
            QuizViewController_ipad *quizViewController = [[QuizViewController_ipad alloc] initWithNibName:@"QuizViewController-ipad" bundle:nil];
            quizViewController.sChapter = cBean.name;
            quizViewController.iChapter = cBean.chapterID;
            quizViewController.mode = 0;
            [self.navigationController pushViewController:quizViewController animated:YES];
            [quizViewController release];
        }

    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView.tag == TABLE_TAG_SCORE) {
        return YES;
    }else
        return NO;
}
- (void)tableView:(UITableView *)tableViews commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {


    if (tableViews.tag == TABLE_TAG_SCORE) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            ScoreBean *sBean = [arrayScores objectAtIndex:indexPath.row];
            //		[self delScoresfromDB:sBean.scoreID];
            [[SqlMB getInstance] delScoreFromDB:sBean.scoreID];
            [arrayScores removeObjectAtIndex:indexPath.row];
            [_tableView_item deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } 

    } else {
    
        return;
    }
    

}
#pragma mark -
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAlertViewTagComp) {  // Alert with Comprehensive Quiz
        if (buttonIndex == 1) {
            QuizViewController_ipad *quizViewController = [[QuizViewController_ipad alloc] initWithNibName:@"QuizViewController-ipad" bundle:nil];
            quizViewController.sChapter = @"Comprehensive Quiz";
            quizViewController.iChapter = 0;
            quizViewController.mode = 0;
            quizViewController.hasPreviousData = YES;
            [self.navigationController pushViewController:quizViewController animated:YES];
            [quizViewController release];
            
        } else {
            [[SqlMB getInstance] clearProcessForQuiz:0];
            QuizViewController_ipad *quizViewController = [[QuizViewController_ipad alloc] initWithNibName:@"QuizViewController-ipad" bundle:nil];
            quizViewController.sChapter = @"Comprehensive Quiz";
            quizViewController.iChapter = 0;
            quizViewController.mode = 0;
            quizViewController.hasPreviousData = NO;
            [self.navigationController pushViewController:quizViewController animated:YES];
            [quizViewController release];
        }
    }
    else if (alertView.tag == kAlertViewTagChapters) {  // Alert with Chapters
        ChapterBean *cBean = [arrayChapters objectAtIndex:chapterIndex];
        if (buttonIndex == 1) {
            QuizViewController_ipad *quizViewController = [[QuizViewController_ipad alloc] initWithNibName:@"QuizViewController-ipad" bundle:nil];
            quizViewController.sChapter = cBean.name;
            quizViewController.iChapter = cBean.chapterID;
            quizViewController.mode = 0;
            quizViewController.hasPreviousData = YES;
            [self.navigationController pushViewController:quizViewController animated:YES];
            [quizViewController release];
            
        } else {
            [[SqlMB getInstance] clearProcessForQuiz:cBean.chapterID];
            QuizViewController_ipad *quizViewController = [[QuizViewController_ipad alloc] initWithNibName:@"QuizViewController-ipad" bundle:nil];
            quizViewController.sChapter = cBean.name;
            quizViewController.iChapter = cBean.chapterID;
            quizViewController.mode = 0;
            quizViewController.hasPreviousData = NO;
            [self.navigationController pushViewController:quizViewController animated:YES];
            [quizViewController release];
        }

    
    }
    else if (alertView.tag == kAlertViewTagScore) {  // Alert with Score
        
        
    }else if(alertView.tag == kAlertViewTagShare){
//        NSLog(@"index = %d",buttonIndex);
//        if (buttonIndex == 1) { // setting
//            NSURL*url=[NSURL URLWithString:@"prefs:root=WIFI"];
//            [[UIApplication sharedApplication] openURL:url];
//            
//        }
    }
    else {                                           // Other alert.
    
    
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

    
//    DEFacebookComposeViewController *facebookComposer = [[DEFacebookComposeViewController alloc]init];
//    
//    self.modalPresentationStyle = UIModalPresentationCurrentContext;
  
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
//        [self dismissModalViewControllerAnimated:YES];
//         NSLog(@"4");
////        [self dismissViewControllerAnimated:YES completion:nil];
//    }];
//    
//    NSLog(@"facebookComposer 1 =%@",facebookComposer);
//    
//    if ([UIDevice de_isIOS4]) {
//        NSLog(@"1");
//        [self presentModalViewController:facebookComposer animated:YES];
//    } else {
//         NSLog(@"2");
//        [self presentViewController:facebookComposer animated:YES completion:^{ }];
//    }
//     NSLog(@"3");
//
//    [facebookComposer release];
//    if ([UIDevice de_isIOS4]) {
//        NSString *sURL = @"http://www.facebook.com/pages/Code-3-Apps/180948875248863";
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: sURL]];
//    } else {  //iOS 5 +
//        BOOL displayedNativeDialog = [FBNativeDialogs
//                                      presentShareDialogModallyFrom:self
//                                      initialText:htmlContent
//                                      image:nil
//                                      url:[NSURL URLWithString:kUrlForSharing]
//                                      handler:^(FBNativeDialogResult result, NSError *error) {
//                                          
//                                          NSString *alertText = @"";
//                                          if ([[error userInfo][FBErrorDialogReasonKey] isEqualToString:FBErrorDialogNotSupported]) {
//                                              alertText = @"iOS Share Sheet not supported.";
//                                          } else if (error) {
//                                              alertText = [NSString stringWithFormat:@"error: domain = %@, code = %d", error.domain, error.code];
//                                          } else if (result == FBNativeDialogResultSucceeded) {
//                                              alertText = @"Posted successfully.";
//                                          }
//                                          
//                                          if (![alertText isEqualToString:@""]) {
//                                              // Show the result in an alert
//                                              [[[UIAlertView alloc] initWithTitle:@"Result"
//                                                                          message:alertText
//                                                                         delegate:self
//                                                                cancelButtonTitle:@"OK!"
//                                                                otherButtonTitles:nil]
//                                               show];
//                                          }
//                                      }];
//        if (!displayedNativeDialog) {
//            /*
//             Fallback to web-based Feed dialog:
//             https://developers.facebook.com/docs/howtos/feed-dialog-using-ios-sdk/
//             */
//        }
//    }
    
//    
//    SLComposeViewController *composeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//    NSLog(@"copse = %@",composeVC);
//    if (composeVC) {
//        NSLog(@"1");
//        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
//            if (result == SLComposeViewControllerResultCancelled) {
//                
//                NSLog(@"Cancelled");
//                
//            } else
//                
//            {
//                NSLog(@"Post");
//            }
//            
//            [composeVC dismissViewControllerAnimated:YES completion:Nil];
//        };
//        
//        composeVC.completionHandler =myBlock;
//        BOOL success = [composeVC setInitialText:htmlContent];
//        
//      
//        if(success)
//        {
//            NSLog(@"2");
//            [self presentViewController: composeVC animated: YES completion: nil];
//        }
//
//    }
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
            alert.tag = kAlertViewTagShare;
            [alert release];
            
            
        }
    }
    
    
}

- (void)shareToTwitter {
    NSLog(@"share to twitter");
    NSString *htmlContent = [self getShareBody];
    
    if (![htmlContent isEqualToString:@""]) { //no content to share
        TWTweetComposeViewController *tweetViewController = [[[TWTweetComposeViewController alloc] init ]autorelease];
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
    
    NSArray *tempArr = [scoreStr componentsSeparatedByString:@")"];
    NSString *score = [tempArr objectAtIndex:0];
    NSString *shareBody = [NSString stringWithFormat:@"I just scored %@) on Medic Tutor practice quiz.", score];
    
    return shareBody;
    
}

- (void)shareTwitterAction
{
    self.navigationController.view.userInteractionEnabled = YES;
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Twitter" message:@"Your message has been posted." delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [alert show];
    [alert release];
}
@end
