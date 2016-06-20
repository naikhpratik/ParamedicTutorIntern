//
//  QuizesMainViewController-iPad.m
//  Quiz
//
//  Created by Arthur on 13-9-10.
//
//



#import "SqlMB.h"
#import "ScoreBean.h"
#import "CustomCellScore.h"
#import "CustomCellQuiz.h"
#import "QuizViewController-ipad.h"
#import "ScenariosMainViewController-iPad.h"
#import "SceneDetailViewController-ipad.h"


#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"


@interface ScenariosMainViewController_iPad ()

@end

@implementation ScenariosMainViewController_iPad

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
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"scen_page"];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    [[GAI sharedInstance] dispatch];
    [_tableView_item setBackgroundView:nil];
    _tableView_item.delegate = self;
    _imv_narrow_bookmark.hidden = YES;
    [_btn_chapters setSelected:YES];
    [_btn_chapters setImage:[UIImage imageNamed:@"scenarios_iPad_mini_press"] forState:UIControlStateSelected];
    
   
    // get the chapter data from DB
    arrayScenarios = [[NSMutableArray alloc] init];
    arrayBookmark = [[NSMutableArray alloc]init];
       
    [_tableView_item reloadData];  // chapters tableView default
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationItem.title = @"Scenarios Home";
    
    [[SqlMB getInstance] getScenariosFromDB:arrayScenarios bookType:NO isSkillSheet:NO];
    [[SqlMB getInstance] getScenariosFromDB:arrayBookmark bookType:YES isSkillSheet:NO];
    if ([arrayBookmark count] != 0) {
        _imv_noData.hidden = YES;
    }else {
         _imv_noData.hidden = NO;
    }
    
    if ([arrayScenarios count] != 0) {
        _imv_noData.hidden = YES;
    }else {
        _imv_noData.hidden = NO;
    }
    
    [_tableView_item reloadData];
    


  
    
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
    [_imv_noData release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView_item:nil];
    [self setImv_narrow_chapter:nil];
    [self setImv_narrow_bookmark:nil];
    [self setBtn_chapters:nil];
    [self setBtn_bookmarks:nil];
    [self setImv_noData:nil];
    [super viewDidUnload];
}


#pragma mark - 
#pragma mark - Button tap action methods


- (IBAction)scenarios:(id)sender {                           //  Chapters
    
    _imv_narrow_chapter.hidden = NO;
    _imv_narrow_bookmark.hidden = YES;
    _imv_noData.hidden = YES;
    [_btn_chapters setSelected:YES];
    [_btn_bookmarks setSelected:NO];
    [_btn_chapters setImage:[UIImage imageNamed:@"scenarios_iPad_mini_press"] forState:UIControlStateSelected];
    _tableView_item.tag = TABLE_TAG_SCENARIOS;
    [_tableView_item reloadData];
    
}

- (IBAction)bookmarks:(id)sender {                          //  Bookmarks
    
    _imv_narrow_bookmark.hidden = NO;
    _imv_narrow_chapter.hidden = YES;
    [_btn_bookmarks setSelected:YES];
    [_btn_chapters setSelected:NO];
    [_btn_bookmarks setImage:[UIImage imageNamed:@"bookmarks_iPad_scenarios_press"] forState:UIControlStateSelected];
    
    if ([arrayBookmark count] == 0) {
        _imv_noData.hidden = NO;
    } else
        _imv_noData.hidden = YES;
    
    // initial the bookmark data
    

    
    _tableView_item.tag = TABLE_TAG_BOOKMARK_SCENARIOS;
    [_tableView_item reloadData];
}




#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if (tableView.tag == TABLE_TAG_BOOKMARK_SCENARIOS)         //  Bookmarks
        return [arrayBookmark count];
    return [arrayScenarios count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"quizCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell ==  nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (tableView.tag == TABLE_TAG_BOOKMARK_SCENARIOS) {        //  Bookmarks
        ScenariosBean *sBean = [arrayBookmark objectAtIndex:indexPath.row];
        cell.textLabel.text = sBean.name;
        return cell;
    }
    else {                                                 // Chapters  default
        ScenariosBean *sBean = [arrayScenarios objectAtIndex:indexPath.row];
        cell.textLabel.text = sBean.name;
        return cell;
    }
    
    
}



#pragma mark -
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == TABLE_TAG_BOOKMARK_SCENARIOS) {        //  Bookmarks
        SceneDetailViewController_ipad *sdViewController = [[SceneDetailViewController_ipad alloc] initWithNibName:@"SceneDetailViewController-ipad" bundle:nil];
        sdViewController._current_index = indexPath.row;
        sdViewController._type = 0;
        sdViewController.array_Scenearios = arrayBookmark;
        [self.navigationController pushViewController:sdViewController animated:YES];
        [sdViewController release];

    }
    else {                                                 // Chapters  default
        SceneDetailViewController_ipad *sdViewController = [[SceneDetailViewController_ipad alloc] initWithNibName:@"SceneDetailViewController-ipad" bundle:nil];
        sdViewController._current_index = indexPath.row;
        sdViewController._type = 0;
        sdViewController.array_Scenearios = arrayScenarios;
        [self.navigationController pushViewController:sdViewController animated:YES];
        [sdViewController release];

    }
}




@end
