//
//  CardiologyViewController.h
//  Paramedic
//
//  Created by Asad Tkxel on 26/01/2015.
//
//

#import <UIKit/UIKit.h>

@interface CardiologyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *cardiologyOptionsTableView;
@property (retain, nonatomic) NSArray* buttonsArray;

@end
