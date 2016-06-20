//
//  CardiologyViewController-iPad.m
//  Paramedic
//
//  Created by Asad Tkxel on 30/01/2015.
//
//

#import "CardiologyViewController-iPad.h"
#import "CardiologyQuestionViewController-iPad.h"


@interface CardiologyViewController_iPad ()

@end

@implementation CardiologyViewController_iPad

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set navigation bar title
    self.navigationItem.title = kCardiologyNanigationBarTitle;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSMutableArray *bookmarkedQuestionIndexArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempBookmarkedIndexArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *data = [[NSUserDefaults standardUserDefaults] objectForKey:kTempCardiologyBookmarkedQuestionsKey];
    if ([data isKindOfClass:[NSMutableArray class]] && data.count > 0) {
        tempBookmarkedIndexArray = [data mutableCopy];
    }
    
    data = [[NSUserDefaults standardUserDefaults] objectForKey:kCardiologyBookmarkedQuestionsKey];
    if ([data isKindOfClass:[NSMutableArray class]] && data.count > 0) {
        bookmarkedQuestionIndexArray = [data mutableCopy];
    }
    
    for (id obj in tempBookmarkedIndexArray) {
        if ([bookmarkedQuestionIndexArray containsObject:obj]) {
            [bookmarkedQuestionIndexArray removeObject:obj];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kTempCardiologyBookmarkedQuestionsKey];
    [[NSUserDefaults standardUserDefaults] setObject:bookmarkedQuestionIndexArray forKey:kCardiologyBookmarkedQuestionsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions

- (IBAction)comprehensiveReviewButtonTapped:(id)sender{
    
    NSString *data = [[NSUserDefaults standardUserDefaults] objectForKey:kSavedCardiologyCardIndexKey];
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
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kSavedCardiologyCardIndexKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self pushControllerWithIndexNumber:0 AndWithBookmarkSelected:NO];
    }
    else if(buttonIndex == 1){
        NSString *data = [[NSUserDefaults standardUserDefaults] objectForKey:kSavedCardiologyCardIndexKey];
        if ([data isKindOfClass:[NSString class]] && ![data isEqualToString:@""]) {
            [self pushControllerWithIndexNumber:[data intValue] AndWithBookmarkSelected:NO];
        }
    }
}


#pragma mark - Helper Methods

- (void) pushControllerWithIndexNumber:(int)index AndWithBookmarkSelected:(BOOL)isBookmark{
    
    CardiologyQuestionViewController_iPad *questionsViewController = [[CardiologyQuestionViewController_iPad alloc] initWithNibName:kiPadCardiologyQuestionControllerNibName bundle:nil];
    questionsViewController.isBookmarkSelected = isBookmark;
    questionsViewController.generalQuestionCounter = index;
    [self.navigationController pushViewController:questionsViewController animated:YES];
}

@end