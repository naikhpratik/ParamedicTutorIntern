//
//  CardiologyViewController.m
//  Paramedic
//
//  Created by Asad Tkxel on 26/01/2015.
//
//

#import "CardiologyViewController.h"
#import "CustomMainViewCell.h"
#import "CardiologyQuestionsViewController.h"

@interface CardiologyViewController ()

@end

@implementation CardiologyViewController


#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set navigation bar title
    self.navigationItem.title = kCardiologyNanigationBarTitle;
    
    [self.navigationController.navigationBar setTranslucent:YES];
    self.buttonsArray = [NSArray arrayWithObjects:@"comp_question",@"bookmarks_n", nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:kDeviceOrientationKey];
    
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


#pragma mark- Tableview delegate

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kTableViewNumberOfRows;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return kTableViewNumberOfSections;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomMainViewCell *cell = (CustomMainViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellReuseableIdentifier];
    if (cell == nil) {
        cell = (CustomMainViewCell *)[[[NSBundle mainBundle]loadNibNamed:kCellNibName owner:self options:nil]objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.btn_content setImage:[UIImage imageNamed:[self.buttonsArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
    [cell.btn_content addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn_content.tag = indexPath.row + 1;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewRowHeight;
}


#pragma mark - Button Actions

-(void) buttonTapped : (UIButton*) object
{
    //if comprehensive review button is tapped
    if (object.tag == 1) {
        
        NSString *data = [[NSUserDefaults standardUserDefaults] objectForKey:kSavedCardiologyCardIndexKey];
        if ([data isKindOfClass:[NSString class]] && ![data isEqualToString:@""]) {
            
            // Show UIAlertView for countinue from the saved index or delete the saved index
            [[[UIAlertView alloc] initWithTitle:@"" message:kShowCardMessage delegate:self cancelButtonTitle:kShowCardCancelButtonTitle otherButtonTitles:kShowCardOtherButtonTitle, nil] show];
        }
        else{
            [self pushControllerWithIndexNumber:0 AndWithBookmarkSelected:NO];
        }
    }
    //if bookmark button is tapped
    else if(object.tag == 2){
        [self pushControllerWithIndexNumber:0 AndWithBookmarkSelected:YES];
    }
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
    
    CardiologyQuestionsViewController *cardiologyQuestionsViewController = [[CardiologyQuestionsViewController alloc] initWithNibName:kCardiologyNibName bundle:nil];
    cardiologyQuestionsViewController.isBookmarkSelected = isBookmark;
    cardiologyQuestionsViewController.generalQuestionCounter = index;
    [self.navigationController pushViewController:cardiologyQuestionsViewController animated:YES];
}

@end
