//
//  DosingViewController.h
//  Paramedic
//
//  Created by Abdul Rehman on 1/14/15.
//
//

#import <UIKit/UIKit.h>

@interface DosingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *optionsTable;
@property (retain, nonatomic) NSArray* buttonsArray;

@end
