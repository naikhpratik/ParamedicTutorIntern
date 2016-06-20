//
//  QuizAppDelegate.h
//  Quiz
//
//  Created by Zorro on 2/15/11.
//  Copyright TeagleSoft 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "GAI.h"
@interface QuizAppDelegate : NSObject <UIApplicationDelegate>
{
    
    UIWindow *window;
    UINavigationController *navigationController;
	
	sqlite3 *database;
}


- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)initializeDatabase;
-(sqlite3 *) getDatabase;
- (void)upgradeDBVersionIfNeeded;
-(void)newDB;


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

