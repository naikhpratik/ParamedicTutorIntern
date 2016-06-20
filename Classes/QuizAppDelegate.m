//
//  QuizAppDelegate.m
//  Quiz
//
//  Created by Zorro on 2/15/11.
//  Copyright TeagleSoft 2011. All rights reserved.
//

#import "QuizAppDelegate.h"
#import "Config.h"
#import "SqlMB.h"
#import "GAI.h"
#import "CardiologyQuestionsViewController.h"
#import "SceneImageViewController.h"
#import "CardiologyExplanationVieControllerViewController.h"

extern NSString *DATABASE_PATH;

@implementation QuizAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark - Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
//    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-35965898-2"];

    
    // Rate this app
    
    // Override point for customization after application launch.
    [self createEditableCopyOfDatabaseIfNeeded];
	//[self initializeDatabase];
	

	
    // Add the navigation controller's view to the window and display.
    //[window addSubview:navigationController.view];
    [window setRootViewController:navigationController];
    [window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


#pragma mark - datebase

- (void)upgradeDBVersionIfNeeded{
    CGFloat newVersion = 1.3f;
    NSLog(@"the version string is %f",[[SqlMB getInstance] getDBVersion]);
    if ([[SqlMB getInstance] getDBVersion] == 0.0f) {
        [self newDB];
        if ([[SqlMB getInstance] alterDBWithAddColumn]) {
            NSLog(@"alter success");
        } else {
            NSLog(@"alter failed");
        }
    } else if ([[SqlMB getInstance] getDBVersion]<newVersion){
        //[self newDB];
        if ([[SqlMB getInstance] alterDBWithAddColumn]) {
            NSLog(@"alter success");
        } else {
            NSLog(@"alter failed");
        }
    }
//	sqlite3_stmt * statements=nil;
//	static char *sql = "select version from Version WHERE id=1";
//	if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
//        
//	}else {
//        NSString *_version = @"";
//        if (sqlite3_step(statements) == SQLITE_ROW){
//            if (sqlite3_column_text(statements, 0)) {
//                _version = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 0)];
//            }
//            
//            if ([_version floatValue] < 1.3) { //[_version isEqualToString:@"1.1"]
//                [self newDB];
//                [self addReferenceToDB];
//            }
//        }
//        sqlite3_finalize(statements);
//        statements = nil;
//    }
}

- (void)addReferenceToDB
{
    
}

-(void)newDB {
    
    ////////////// 1.save the bookmark data
    NSLog(@"%s",__func__);
    NSMutableArray *bookmarkData_mArr = [[NSMutableArray alloc]init];
    
//    sqlite3_stmt * statements = nil;
//    static char *sql = "SELECT id FROM quiz WHERE bookmark = 1";
//    if (sqlite3_prepare(database, sql, -1, &statements, NULL) != SQLITE_OK) {
//        NSLog(@"Save the bookMark data faild!");
//    }else {
//        while (sqlite3_step(statements) == SQLITE_ROW) {
//            if (sqlite3_column_text(statements, 0)) {
//                
//                // add the bookmark ID to the array
//                [bookmarkData_mArr addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 0)]];
//            }
//        }
//    }
//    sqlite3_finalize(statements);
//    statements = nil;
    
    [[SqlMB getInstance] getBookMarksInPrevious:bookmarkData_mArr];
    
    /////////////// 2.replace the old DB
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //fileManager.delegate = self;
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"users.sqlite"];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"users.sqlite"];
    BOOL success = [fileManager removeItemAtPath:writableDBPath error:&error];
    if (!success) {
        NSLog(@"%@", [error localizedDescription]);
    }
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSLog(@"%@", [error localizedDescription]);
        //NSAssert1(0, @"Failed to overwrite database file with message '%@'.", [error localizedDescription]);
    }
    
    
    //////////////// 3.add the bookmark data to newer DB
    [self initializeDatabase];
    NSString *id_str = [[NSString alloc]init];
    id_str = [[bookmarkData_mArr valueForKey:@"description"] componentsJoinedByString:@","];
    NSLog(@"the array is %@, the string is %@",bookmarkData_mArr,id_str);

    [[SqlMB getInstance] updateBookMarksToNew:id_str];
//    sqlite3_stmt *statement_updateBookmark = nil;
//    NSString *sql_updateBookmark = [NSString stringWithFormat:@"update quiz set bookmark = 1 where id in (%@)",id_str];
//
//    
//    if (sqlite3_prepare(database, [sql_updateBookmark UTF8String], -1, &statement_updateBookmark, NULL) != SQLITE_OK) {
//        NSLog(@"Update bookmark data faild!");
//    } else {
//        sqlite3_bind_text(statement_updateBookmark, 1, [id_str UTF8String], -1, nil);
//
//        // excute sql
//        sqlite3_step(statement_updateBookmark) ;
//        
//        // free
//        sqlite3_finalize(statement_updateBookmark);
//        statement_updateBookmark = nil;
//        
//    }
    
    
    [bookmarkData_mArr release];
}

//- (BOOL)fileManager:(NSFileManager *)fileManager shouldCopyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath
//{
//	return YES;
//}
//
//- (BOOL)fileManager:(NSFileManager *)fileManager shouldProceedAfterError:(NSError *)error copyingItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath
//{
//	//NSLog(@"%@", [error localizedDescription]);
//	return YES;
//}



- (void)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"users.sqlite"];
    DATABASE_PATH = writableDBPath;
    success = [fileManager fileExistsAtPath:writableDBPath];
    NSLog(@"the write database path is %@",DATABASE_PATH);
    if (success)
	{
		[self initializeDatabase];
		[self upgradeDBVersionIfNeeded];
        
		return;
	}
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"users.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
	[self initializeDatabase];
    if ([[SqlMB getInstance] alterDBWithAddColumn]) {
        NSLog(@"alter success");
    } else {
        NSLog(@"alter failed");
    }
    
}
//fb427516922

- (void)initializeDatabase
{
//    // The database is stored in the application bundle.
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"users.sqlite"];
//    // Open the database. The database was prepared outside the application.
//    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
//		// "Finalize" the statement - releases the resources associated with the statement.
//		
//	} else {
//        // Even though the open failed, call close to properly clean up resources.
//        sqlite3_close(database);
//        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
//        // Additional error handling, as appropriate...
//    }
}

-(sqlite3 *) getDatabase
{
	return database;
}


#pragma mark - Device Orientation

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    if([self.navigationController.topViewController isKindOfClass:[CardiologyQuestionsViewController class]]){
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    else if([self.navigationController.topViewController isKindOfClass:[SceneImageViewController class]]){
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    else if([self.navigationController.topViewController isKindOfClass:[CardiologyExplanationVieControllerViewController class]]){
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    else{
        return UIInterfaceOrientationMaskPortrait;
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}


@end

