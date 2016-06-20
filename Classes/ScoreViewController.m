    //
//  ScoreViewController.m
//  Quiz
//
//  Created by Zorro on 2/18/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>

#import "ScoreViewController.h"
#import "QuizAppDelegate.h"
#import "ScoreBean.h"
#import "SqlMB.h"
#import "DEFacebookComposeViewController.h"
#import "UIDevice+DEFacebookComposeViewController.h"

@implementation ScoreViewController {
    NSString *scoreStr;
}

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
	arrayScores = [[NSMutableArray alloc] init];
	array_Del = [[NSMutableArray alloc] init];
	self.navigationItem.title = @"Score History";
	//_rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTable:)];
//	self.navigationItem.rightBarButtonItem = _rightBarButtonItem;
//	[_rightBarButtonItem release];
	
//	[self getScoresfromDB];
    [[SqlMB getInstance] getScoreFromDB:arrayScores];
    [super viewDidLoad];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[array_Del release];
	//[_rightBarButtonItem release];
	[arrayScores release];
    [super dealloc];
}

//-(void)editTable:(id)sender{
//	if (tbView.editing) {
//		_rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTable:)];
//		self.navigationItem.rightBarButtonItem = _rightBarButtonItem;
//		[_rightBarButtonItem release];
//		[self delScoresfromDB];
//		[tbView setEditing:NO];
//		[tbView reloadData];
//	}else {
//		_rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editTable:)];
//		self.navigationItem.rightBarButtonItem = _rightBarButtonItem;
//		[_rightBarButtonItem release];
//		[tbView setEditing:YES];
//		[tbView reloadData];
//	}
//}

//-(void)getScoresfromDB
//{
//	if([arrayScores count] != 0)
//	{
//		[arrayScores removeAllObjects];
//	}
//	QuizAppDelegate *app = (QuizAppDelegate *)[[UIApplication sharedApplication] delegate];
//	sqlite3 *database = [app getDatabase];
//	sqlite3_stmt * statements=nil;
//	
//	//get default category first
//	if (statements == nil) {
//		char *sql = "select id, chapter,result from quizScore";
//		
//        if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
//            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
//        }else{
//			//sqlite3_bind_int(statements, 1, cateID-1);
//			
//			while(sqlite3_step(statements) == SQLITE_ROW){
//				ScoreBean *scoreBean = [[ScoreBean alloc] init];
//				scoreBean.scoreID = sqlite3_column_int(statements, 0);
//			    if (sqlite3_column_text(statements, 1)) {
//					scoreBean.chapter = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 1)];
//				}else {
//					scoreBean.chapter = @"";
//				}
//				if (sqlite3_column_text(statements, 2)) {
//					scoreBean.result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 2)];
//				}else {
//					scoreBean.result = @"";
//				}
//				[arrayScores addObject:scoreBean];
//				[scoreBean release];
//			}
//			sqlite3_finalize(statements);
//			statements = nil;
//		}	
//	}	
//}

//-(void)delScoresfromDB: (int)scoreID;
//{	
//	QuizAppDelegate *app = (QuizAppDelegate *)[[UIApplication sharedApplication] delegate];
//	sqlite3 *database = [app getDatabase];
//	sqlite3_stmt *delete_statement = nil;	
//	//delete from image where id = id
//	if (delete_statement == nil) {
//		const char *sql = "DELETE FROM quizScore WHERE id=?";
//		if (sqlite3_prepare_v2(database, sql, -1, &delete_statement, NULL) != SQLITE_OK) {
//			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
//		}
//	}
//	sqlite3_bind_int(delete_statement, 1, scoreID);
//	int success1 = sqlite3_step(delete_statement);
//	sqlite3_reset(delete_statement);
//	if (success1 != SQLITE_DONE) {
//		NSAssert1(0, @"Error: failed to delete from database with message '%s'.", sqlite3_errmsg(database));
//	}
//	sqlite3_finalize(delete_statement);
//	delete_statement = nil;
//}

#pragma mark UITableView methods

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    scoreStr = @"";
    [tv deselectRowAtIndexPath:indexPath animated:NO];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Share your score" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Post to Facebook", @"Post to Twitter",nil];
    [actionSheet showInView:self.view];
    
    ScoreBean *sBean = [arrayScores objectAtIndex:indexPath.row];
    NSLog(@"sBean.result = %@",sBean.result);
    scoreStr = sBean.result;
    [actionSheet release];
    
    
}

-(UITableViewCell *) tableView:(UITableView *) tv cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];

	ScoreBean *sBean = [arrayScores objectAtIndex:indexPath.row];
	UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(35, 2, 275, 22)];
	lbTitle.text = sBean.chapter;
	lbTitle.font = [UIFont boldSystemFontOfSize:16.0];
	[cell addSubview:lbTitle];
	[lbTitle release];
	
	UILabel *lbRel = [[UILabel alloc] initWithFrame:CGRectMake(35, 24, 275, 18)];
	lbRel.text = sBean.result;
	lbRel.font = [UIFont systemFontOfSize:14.0];
	lbRel.textColor = [UIColor grayColor];
	[cell addSubview:lbRel];
	[lbRel release];
	
	return cell;
}

-(NSInteger) tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger) section
{
	return [arrayScores count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	return 45.0;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableViews commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		ScoreBean *sBean = [arrayScores objectAtIndex:indexPath.row];
//		[self delScoresfromDB:sBean.scoreID];
        [[SqlMB getInstance] delScoreFromDB:sBean.scoreID];
		[arrayScores removeObjectAtIndex:indexPath.row];
		[tbView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
////        [self dismissModalViewControllerAnimated:YES];
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
//        alert.tag = kAlertViewTagOther;
        [alert release];
        
        
    }}
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
