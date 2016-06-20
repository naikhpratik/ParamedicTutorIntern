//
//  CardChapterViewController.m
//  Quiz
//
//  Created by perry on 9/25/13.
//
//

#import "CardChapterViewController.h"
#import "ChapterBean.h"
#import "CardViewController.h"


@interface CardChapterViewController ()
{
    NSInteger chapterIndex;
}
@end

@implementation CardChapterViewController

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
    chapterIndex = 0;
    self.navigationItem.title = @"Chapters";
	self.tbView.backgroundColor = [UIColor clearColor];
    arrayChapters = [[NSMutableArray alloc] init];
    [[SqlMB getInstance] getAllChapterFromDB:1 data:arrayChapters];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tbView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTbView:nil];
    [super viewDidUnload];
}


#pragma mark - UITableViewMethods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
	ChapterBean *cBean = [arrayChapters objectAtIndex:indexPath.row];
    cell.textLabel.text = cBean.name;
	cell.textLabel.textAlignment = UITextAlignmentCenter;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayChapters count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)gotoDetailCards:(NSInteger)_arrIndex hasPreviosData:(BOOL)_hasPreviousData
{
    ChapterBean *cBean = [arrayChapters objectAtIndex:_arrIndex];
    CardViewController *cardView = [[CardViewController alloc] initWithNibName:@"CardViewController" bundle:nil];
    cardView.sChapter = cBean.name;
    cardView.iChapter = cBean.chapterID;
    cardView.mode = 0;
    cardView.hadPreviousData = _hasPreviousData;
    [self.navigationController pushViewController:cardView animated:YES];
    [cardView release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChapterBean *cBean = [arrayChapters objectAtIndex:indexPath.row];
    if ([[SqlMB getInstance] shouldCOntinueForCards:cBean.chapterID]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want to continue where you left off, or delete and start over?" delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Continue", nil];
        alert.tag = indexPath.row+1;
        [alert show];
        [alert release];
    } else {
        [self gotoDetailCards:indexPath.row hasPreviosData:NO];
    }
}

#pragma mark - UIAlertView methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self gotoDetailCards:alertView.tag-1 hasPreviosData:YES];
    } else {
        ChapterBean *cBean = [arrayChapters objectAtIndex:alertView.tag-1];
        [[SqlMB getInstance] clearProcessForCards:cBean.chapterID];
        [self gotoDetailCards:alertView.tag-1 hasPreviosData:NO];
    }
}

@end
