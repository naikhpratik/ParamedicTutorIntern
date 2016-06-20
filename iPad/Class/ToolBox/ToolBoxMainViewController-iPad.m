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
#import "ToolBoxMainViewController-iPad.h"
#import "SceneDetailViewController-ipad.h"
#import "CheckDetailViewController-ipad.h"
#import "RefViewController-ipad.h"


#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"


@interface ToolBoxMainViewController_iPad () {
    NSInteger chapterIndex;
    NSMutableArray *mArrBookmarkChapter;  //  Storage the bookmark chapter.
    
}

@end

@implementation ToolBoxMainViewController_iPad
@synthesize _type;
@synthesize _id;

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
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"tool_page"];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    [[GAI sharedInstance] dispatch];
    [_tableView_item setBackgroundView:nil];
    chapterIndex = 0;
    _type = 1;
    _id = 2;
    _tableView_item.delegate = self;
    _mySearchBar.delegate = self;
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  [UIColor grayColor],
                                                                                                  UITextAttributeTextColor,
                                                                                                  [UIColor darkGrayColor],
                                                                                                  UITextAttributeTextShadowColor,
                                                                                                  [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                                                                                                  UITextAttributeTextShadowOffset,
                                                                                                  nil]
                                                                                        forState:UIControlStateNormal];
    _imv_narrow_bookmark.hidden = YES;
    _imv_narrow_different.hidden = YES;
    _imv_narrow_Reference.hidden = YES;
    _imv_narrow_medical.hidden = YES;
    
    [_btn_chapters setSelected:YES];
    [_btn_chapters setImage:[UIImage imageNamed:@"skillsheets_iPad_mini_press"] forState:UIControlStateSelected];
    
    
    // get the chapter data from DB
    arrayChapters = [[NSMutableArray alloc] init];
    mArrBookmarkChapter = [[NSMutableArray alloc]init];
    arrayBookmarkData = [[NSMutableArray alloc]init];
    arrayChaptersForMedical = [[NSMutableArray alloc]init];
    arrayScenarios = [[NSMutableArray alloc] init];
    
    // get the references data
    arr_References = [[NSMutableArray alloc] init];
	filterArray = [[NSMutableArray alloc] init];
    
    if ([filterArray count] != 0) {
		[filterArray removeAllObjects];
	}
	if([arr_References count] != 0)
	{
		[arr_References removeAllObjects];
	}
    [[SqlMB getInstance] getAllCardsFromReference:arr_References filtered:filterArray];
    
    [[SqlMB getInstance] getAllSkillSheetFromDBForToolBox:arrayChapters];  // get the chapters data from DB
    NSLog(@"arrayChapters = %@",arrayChapters);
    //[_tableView_item reloadData];  // chapters tableView default
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationItem.title = @"Tool Box Home";
    [mArrBookmarkChapter removeAllObjects];
    [[SqlMB getInstance] getBookmarkChapter:mArrBookmarkChapter];
    [[SqlMB getInstance] getScenariosFromDB:arrayScenarios bookType:YES isSkillSheet:YES];  // Skill Sheets
    [[SqlMB getInstance] getChaptersFromDBForCheckList:arrayChaptersForMedical withPID:_id];
    
    if (_tableView_item.tag == TABLE_TAG_BOOKMARK_TOOLBOX) {  // prevent the data with Bookmark is null.
      //  [_tableView_item reloadData];
    }
    
    if (_tableView_item.tag != TABLE_TAG_BOOKMARK_TOOLBOX) {
        _imv_noData.hidden = YES;
    }else {
        if ([arrayScenarios count] != 0 ) {
            _imv_noData.hidden = YES;
        }else {
            _imv_noData.hidden = NO;
        }
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
    [_btn_different release];
    [_imv_narrow_different release];
    [_imv_narrow_medical release];
    [_imv_narrow_Reference release];
    [_btn_medical release];
    [_btn_reference release];
    [arrayChapters release];
    [arrayChaptersForMedical release];
    [filterArray release];
	[arr_References release];
    [_mySearchBar release];
    [_imv_noData release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView_item:nil];
    [self setImv_narrow_chapter:nil];
    [self setImv_narrow_bookmark:nil];
    [self setBtn_chapters:nil];
    [self setBtn_bookmarks:nil];
    [self setBtn_different:nil];
    [self setImv_narrow_different:nil];
    [self setImv_narrow_medical:nil];
    [self setImv_narrow_Reference:nil];
    [self setBtn_medical:nil];
    [self setBtn_reference:nil];
    [self setMySearchBar:nil];
    [self setImv_noData:nil];
    [super viewDidUnload];
}


#pragma mark -
#pragma mark - Button tap action methods



- (IBAction)skillSheets:(id)sender {                           //  Chapters
    _mySearchBar.hidden = YES;
    self.navigationItem.rightBarButtonItem = nil;
    _tableView_item.hidden = NO;
    _imv_noData.hidden = YES;
    _imv_narrow_chapter.hidden = NO;
    _imv_narrow_bookmark.hidden = YES;
    _imv_narrow_different.hidden = YES;
    _imv_narrow_medical.hidden = YES;
    _imv_narrow_Reference.hidden = YES;
    
    _imv_noData.hidden = YES;
    [_btn_chapters setSelected:YES];
    [_btn_bookmarks setSelected:NO];
    [_btn_different setSelected:NO];
    [_btn_medical setSelected:NO];
    [_btn_reference setSelected:NO];
    [_btn_chapters setImage:[UIImage imageNamed:@"skillsheets_iPad_mini_press"] forState:UIControlStateSelected];
    _tableView_item.tag = TABLE_TAG_SKILL_SHEET;
    [_tableView_item reloadData];
    
}
- (IBAction)differentials:(id)sender {
    _mySearchBar.hidden = YES;
    _imv_noData.hidden = YES;
    self.navigationItem.rightBarButtonItem = nil;
    _imv_narrow_chapter.hidden = YES;
    _imv_narrow_bookmark.hidden = YES;
    _imv_narrow_different.hidden = NO;
    _imv_narrow_medical.hidden = YES;
    _imv_narrow_Reference.hidden = YES;
    [_btn_chapters setSelected:NO];
    [_btn_bookmarks setSelected:NO];
    [_btn_different setSelected:YES];
    [_btn_medical setSelected:NO];
    [_btn_reference setSelected:NO];
    [_btn_different setImage:[UIImage imageNamed:@"differentials_iPad_mini_press"] forState:UIControlStateSelected];
    _tableView_item.hidden = YES;
    //    _tableView_item.tag = TABLE_TAG_DIFFERENTIALS;
    //    [_tableView_item reloadData];
    
    SceneDetailViewController_ipad *sceneDetailViewController = [[SceneDetailViewController_ipad alloc] initWithNibName:@"SceneDetailViewController-ipad" bundle:nil];
	sceneDetailViewController._type = 2;
	[self.navigationController pushViewController:sceneDetailViewController animated:YES];
	[sceneDetailViewController release];
    
}
- (IBAction)bookmarks:(id)sender {                          //  Bookmarks
    _mySearchBar.hidden = YES;
    if ([arrayScenarios count] ==0 ) {
        _imv_noData.hidden = NO;
    }else{
        _imv_noData.hidden = YES;
    }
    self.navigationItem.rightBarButtonItem = nil;
    _tableView_item.hidden = NO;
    _imv_narrow_bookmark.hidden = NO;
    _imv_narrow_chapter.hidden = YES;
    _imv_narrow_different.hidden = YES;
    _imv_narrow_medical.hidden = YES;
    _imv_narrow_Reference.hidden = YES;
    [_btn_bookmarks setSelected:YES];
    [_btn_chapters setSelected:NO];
    [_btn_different setSelected:NO];
    [_btn_medical setSelected:NO];
    [_btn_reference setSelected:NO];
    [_btn_bookmarks setImage:[UIImage imageNamed:@"bookmarks_iPad_sheets_press"] forState:UIControlStateSelected];
    
    
    // initial the bookmark data
    
    
    
    _tableView_item.tag = TABLE_TAG_BOOKMARK_TOOLBOX;
    [_tableView_item reloadData];
}

- (IBAction)medical:(id)sender {
     _mySearchBar.hidden = YES;
    _tableView_item.hidden = NO;
    _imv_noData.hidden = YES;
    _imv_narrow_bookmark.hidden = YES;
    _imv_narrow_chapter.hidden = YES;
    _imv_narrow_different.hidden = YES;
    _imv_narrow_medical.hidden = NO;
    _imv_narrow_Reference.hidden = YES;
    
    [_btn_bookmarks setSelected:NO];
    [_btn_chapters setSelected:NO];
    [_btn_different setSelected:NO];
    [_btn_medical setSelected:YES];
    [_btn_reference setSelected:NO];
    [_btn_medical setImage:[UIImage imageNamed:@"MedScene_iPad_mini_press"] forState:UIControlStateSelected];
    
    
    // add the rightBarBtn for clear medical check off data
    UIBarButtonItem *_rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear All" style:UIBarButtonItemStyleBordered target:self action:@selector(clearAll:)];
	self.navigationItem.rightBarButtonItem = _rightBarButtonItem;
	[_rightBarButtonItem release];
    
    
    
    _tableView_item.tag = TABLE_TAG_MEDICAL;
    [_tableView_item reloadData];
    
}

- (IBAction)reference:(id)sender {
    _mySearchBar.hidden = NO;
    _imv_noData.hidden = YES;
    self.navigationItem.rightBarButtonItem = nil;
    _tableView_item.hidden = NO;
    _imv_narrow_bookmark.hidden = YES;
    _imv_narrow_chapter.hidden = YES;
    _imv_narrow_different.hidden = YES;
    _imv_narrow_medical.hidden = YES;
    _imv_narrow_Reference.hidden = NO;
    
    [_btn_bookmarks setSelected:NO];
    [_btn_chapters setSelected:NO];
    [_btn_different setSelected:NO];
    [_btn_medical setSelected:NO];
    [_btn_reference setSelected:YES];
    [_btn_reference setImage:[UIImage imageNamed:@"refterms_iPad_mini_press"] forState:UIControlStateSelected];
    
    
    // initial the bookmark data
    
    
    
    _tableView_item.tag = TABLE_TAG_REFERENCE;
    [_tableView_item reloadData];
}


-(IBAction)clearAll: (id)sender {
    [[SqlMB getInstance] clearCheckedFromDBForToolBoxWithCharpterType:_id];
}

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView.tag == TABLE_TAG_BOOKMARK_TOOLBOX) {                      // Bookmarks
        
        return 1;
    } else if (tableView.tag == TABLE_TAG_MEDICAL) {                    // Differentials
        return 1;
    } else if (tableView.tag == TABLE_TAG_REFERENCE) {                    // Differentials
        return 1;
    }else {                                                                // default Skill sheets
        
        return 0;
    }
    
    return 1;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == TABLE_TAG_BOOKMARK_TOOLBOX) {                      //  Bookmarks
        
        return [arrayScenarios count];
        
    } else if (tableView.tag == TABLE_TAG_MEDICAL){                    // Differentials
        
        return [arrayChaptersForMedical count];
    }else if (tableView.tag == TABLE_TAG_REFERENCE){                    // Differentials
        
        return [filterArray count];
    }
    else {                                                                  // Skill Sheets  default
        if (section == 0) {
            return 10;
        } else {
            return [arrayChapters count] - 10;
            
        }
    }
    
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"ToolBoxCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell ==  nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (tableView.tag == TABLE_TAG_BOOKMARK_TOOLBOX) {        //  Bookmarks
        ScenariosBean *sBean = [arrayScenarios objectAtIndex:indexPath.row];
        cell.textLabel.text = sBean.name;
        
    }
    else if (tableView.tag == TABLE_TAG_DIFFERENTIALS){                      // Differentials
        
    }
    else if (tableView.tag == TABLE_TAG_MEDICAL){                      // Differentials
        ChapterBean *cBean = [arrayChaptersForMedical objectAtIndex:indexPath.row];
        cell.textLabel.text = cBean.name;
    }
    else if (tableView.tag == TABLE_TAG_REFERENCE){                      // Differentials
        CardBean *cBean = [filterArray objectAtIndex:indexPath.row];
        cell.textLabel.text = cBean.question;
    }
    else {                                                                      // SkillSheet  default
        
        ScenariosBean *sBean;
        if (indexPath.section == 0) {
            sBean = [arrayChapters objectAtIndex:indexPath.row];
        }else {
            sBean = [arrayChapters objectAtIndex:indexPath.row + 10];
        }
        
        cell.textLabel.text = sBean.name;
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *sectionName;
    if (tableView.tag == TABLE_TAG_BOOKMARK_TOOLBOX) {                              //  Bookmarks have section title
        if (section == 0) {                       // the title of section 0 is null
            sectionName = @"";
        } else {                                  // other section with Bookmarks
            int ID = [[mArrBookmarkChapter objectAtIndex:section - 1] intValue]; // the object is NSNumber type that in the mArrBookmarkChapter
            ChapterBean *chapterBean = [arrayChapters objectAtIndex:ID - 1];
            sectionName = chapterBean.name;
        }
    } else if (tableView.tag == TABLE_TAG_DIFFERENTIALS) {
        
    }else if (tableView.tag == TABLE_TAG_MEDICAL){                      // Differentials
        sectionName = @"Medical";
    }
    else if (tableView.tag == TABLE_TAG_REFERENCE){                      // Differentials
        sectionName = @"";
    }
    
    
    else {                                                                 // others cannot have section title
        if (section == 0) {
            sectionName = @"    - NREMT Required Skill Sheets -";
        } else {
            sectionName = @"               - Other Skill Sheets -";
        }
    }
    
    return sectionName;
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (tableView.tag == TABLE_TAG_REFERENCE) {
//        mySearchBar = [[UISearchBar alloc]init];//WithFrame:CGRectMake(0, 0, 330, 44)];
//        mySearchBar.backgroundColor = [UIColor clearColor];
//        mySearchBar.tintColor = [UIColor whiteColor];
//        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                                                                      [UIColor blackColor],
//                                                                                                      UITextAttributeTextColor,
//                                                                                                      [UIColor darkGrayColor],
//                                                                                                      UITextAttributeTextShadowColor,
//                                                                                                      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
//                                                                                                      UITextAttributeTextShadowOffset,
//                                                                                                      nil]
//                                                                                            forState:UIControlStateNormal];
////        mySearchBar.delegate = self;
//        return mySearchBar;
//    }
//    return nil;
//
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (tableView.tag == TABLE_TAG_MEDICAL || tableView.tag == TABLE_TAG_SKILL_SHEET) {
//         return 50;
//    }
//    return 0;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}
#pragma mark -
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == TABLE_TAG_BOOKMARK_TOOLBOX) {        //  Bookmarks
        SceneDetailViewController_ipad *sdViewController = [[SceneDetailViewController_ipad alloc] initWithNibName:@"SceneDetailViewController-ipad" bundle:nil];
        sdViewController._current_index = indexPath.row;
        sdViewController._type = _type;
        sdViewController.array_Scenearios = arrayScenarios;
        [self.navigationController pushViewController:sdViewController animated:YES];
        [sdViewController release];
        
        
    } else if (tableView.tag == TABLE_TAG_DIFFERENTIALS) {
        
        
    }else if (tableView.tag == TABLE_TAG_MEDICAL){                      // Differentials
        CheckDetailViewController_ipad *checkDetail = [[CheckDetailViewController_ipad alloc] initWithNibName:@"CheckDetailViewController-ipad" bundle:nil];
        ChapterBean *cBean = [arrayChaptersForMedical objectAtIndex:indexPath.row];
        checkDetail.chapterBean = cBean;
        [self.navigationController pushViewController:checkDetail animated:YES];
        [checkDetail release];
    }
    else if (tableView.tag == TABLE_TAG_REFERENCE){                      // Differentials
        CardBean *cBean = [filterArray objectAtIndex:indexPath.row];
        RefViewController_ipad *refDetail = [[RefViewController_ipad alloc] initWithNibName:@"RefViewController-ipad" bundle:nil];
        refDetail.cardBean = cBean;
        [self.navigationController pushViewController:refDetail animated:YES];
        [refDetail release];
    }
    
    else {                                                 // Skill Sheets  default
        SceneDetailViewController_ipad *sceneDetailViewController = [[SceneDetailViewController_ipad alloc]initWithNibName:@"SceneDetailViewController-ipad" bundle:nil];
        if (indexPath.section == 0) {
            sceneDetailViewController._current_index = indexPath.row;
        } else {
            sceneDetailViewController._current_index = indexPath.row + 10;
        }
        
        sceneDetailViewController._type = 1;
        sceneDetailViewController.array_Scenearios = arrayChapters;
        
        
        [self.navigationController pushViewController:sceneDetailViewController animated:YES];
        [sceneDetailViewController release];
        
        
    }
}

#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	// only show the status bar's cancel button while in edit mode
	_mySearchBar.showsCancelButton = YES;
	[_tableView_item setAlpha:0.7f];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	_mySearchBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[_tableView_item setAlpha:1.0f];
	
	// search the table content for cell titles that match "searchText"
	// if found add to the mutable array and force the table to reload
	//
	if([searchText length] == 0)
	{
		[filterArray removeAllObjects];
		[filterArray addObjectsFromArray:arr_References];
	}else
	{
		[filterArray removeAllObjects];
		for(int i=0; i<[arr_References count]; i++)
		{
			CardBean *cbean = [arr_References objectAtIndex:i];
			
			NSRange nameRange = [cbean.question rangeOfString:searchText options:NSCaseInsensitiveSearch];
			if(!(nameRange.location == NSNotFound || nameRange.length == 0)) {
				[filterArray addObject:cbean];
			}
		}
	}
	[_tableView_item reloadData];
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[_tableView_item setAlpha:1.0f];
	// if a valid search was entered but the user wanted to cancel, bring back the saved list content
	if (searchBar.text.length > 0)
	{
		[filterArray removeAllObjects];
		[filterArray addObjectsFromArray:arr_References];
	}
	
	[_tableView_item reloadData];
	
	[_mySearchBar resignFirstResponder];
	_mySearchBar.text = @"";
}

// called when Search (in our case "Done") button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[_tableView_item setAlpha:1.0f];
	[_mySearchBar resignFirstResponder];
}


@end
