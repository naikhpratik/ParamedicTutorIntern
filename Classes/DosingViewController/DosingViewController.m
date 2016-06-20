//
//  DosingViewController.m
//  Paramedic
//
//  Created by Abdul Rehman on 1/14/15.
//
//

#import "DosingViewController.h"
#import "CustomMainViewCell.h"
#import "DosingQuestionsViewController.h"

@interface DosingViewController ()

@end

@implementation DosingViewController


#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:YES];
    
    //set navigation bar title
    self.navigationItem.title = kDosingNaviagtionBarTitle;
    
    self.buttonsArray = [NSArray arrayWithObjects:@"comp_question",@"bookmarks_n", nil];
    [self.optionsTable reloadData];
    
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- Tableview Delegate && Datasource

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
    [cell.btn_content addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn_content.tag = indexPath.row + 1;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewRowHeight;
}



#pragma mark - Helper Methods

-(void) btnClicked : (UIButton*) object
{
    //if comprehensive review button is tapped
    if (object.tag == 1) {
        
        NSString *data = [[NSUserDefaults standardUserDefaults] objectForKey:kSavedDosingCardIndexKey];
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

- (void)dealloc {
    //[_dosingViewController release];
    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
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
    
    DosingQuestionsViewController *questionsViewController = [[DosingQuestionsViewController alloc] initWithNibName:kDosingQuestionControllerNibName bundle:nil];
    questionsViewController.isBookmarkSelected = isBookmark;
    questionsViewController.generalQuestionCounter = index;
    [self.navigationController pushViewController:questionsViewController animated:YES];
}

@end
