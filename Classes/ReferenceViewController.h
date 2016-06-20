//
//  ReferenceViewController.h
//  Firefighter
//
//  Created by sandra on 11/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReferenceViewController : UIViewController {
	IBOutlet UITableView *tbView;
	IBOutlet UISearchBar *mySearchBar;
	
	NSMutableArray *arr_References;
	NSMutableArray *filterArray;
}

-(void)getDatafromDB;
@property (retain, nonatomic) IBOutlet UIImageView *imgView_Reference;

@end
