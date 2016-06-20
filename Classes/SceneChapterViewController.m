//
//  SceneChapterViewController.m
//  Quiz
//
//  Created by perry on 9/27/13.
//
//

#import "SceneChapterViewController.h"
#import "SceneDetailViewController.h"

@interface SceneChapterViewController ()

@end

@implementation SceneChapterViewController
@synthesize tbView_content = _tbView_content;

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
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    arrScnarios = [[NSMutableArray alloc] initWithCapacity:10];
    [[SqlMB getInstance] getScenariosFromDB:arrScnarios bookType:NO isSkillSheet:NO];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Scenarios Home";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"Back";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tbView_content release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTbView_content:nil];
    [super viewDidUnload];
}

#pragma mark - UITableView methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"quizCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell ==  nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    ScenariosBean *sBean = [arrScnarios objectAtIndex:indexPath.row];
    cell.textLabel.text = sBean.name;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrScnarios count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SceneDetailViewController *sdViewController = [[SceneDetailViewController alloc] initWithNibName:@"SceneDetailViewController" bundle:nil];
	sdViewController._current_index = indexPath.row;
	sdViewController._type = 0;
	sdViewController.array_Scenearios = arrScnarios;
	[self.navigationController pushViewController:sdViewController animated:YES];
	[sdViewController release];
}

@end
