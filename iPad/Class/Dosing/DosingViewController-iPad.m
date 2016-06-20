//
//  DosingViewController-iPad.m
//  Paramedic
//
//  Created by Asad Tkxel on 29/01/2015.
//
//

#import "DosingViewController-iPad.h"
#import "DosingQuestionsViewController-iPad.h"


@interface DosingViewController_iPad ()

@end

@implementation DosingViewController_iPad


#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set navigation bar title
    self.navigationItem.title = kDosingNaviagtionBarTitle;
}


#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions

- (IBAction)comprehensiveReviewButtonTapped:(id)sender{
    
    NSString *data = [[NSUserDefaults standardUserDefaults] objectForKey:kSavedDosingCardIndexKey];
    if ([data isKindOfClass:[NSString class]] && ![data isEqualToString:@""]) {
        
        // Show UIAlertView for countinue from the saved index or delete the saved index
        [[[UIAlertView alloc] initWithTitle:@"" message:kShowCardMessage delegate:self cancelButtonTitle:kShowCardCancelButtonTitle otherButtonTitles:kShowCardOtherButtonTitle, nil] show];
    }
    else{
        [self pushControllerWithIndexNumber:0 AndWithBookmarkSelected:NO];
    }
}

- (IBAction)bookmarkButtonTapped:(id)sender{
    
    [self pushControllerWithIndexNumber:0 AndWithBookmarkSelected:YES];
}



#pragma mark - UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kSavedDosingCardIndexKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self pushControllerWithIndexNumber:0 AndWithBookmarkSelected:NO];
    }
    else if(buttonIndex == 1){
        NSString *data = [[NSUserDefaults standardUserDefaults] objectForKey:kSavedDosingCardIndexKey];
        if ([data isKindOfClass:[NSString class]] && ![data isEqualToString:@""]) {
            [self pushControllerWithIndexNumber:[data intValue] AndWithBookmarkSelected:NO];
        }
    }
}


#pragma mark - Helper Methods

- (void) pushControllerWithIndexNumber:(int)index AndWithBookmarkSelected:(BOOL)isBookmark{
    
    DosingQuestionsViewController_iPad *questionsViewController = [[DosingQuestionsViewController_iPad alloc] initWithNibName:kiPadDosingQuestionControllerNibName bundle:nil];
    questionsViewController.isBookmarkSelected = isBookmark;
    questionsViewController.generalQuestionCounter = index;
    [self.navigationController pushViewController:questionsViewController animated:YES];
}

@end