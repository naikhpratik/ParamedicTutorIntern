//
//  SceneDetailViewController.h
//  Quiz
//
//  Created by Zorro on 2/27/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyWebView.h"

@interface SceneDetailViewController : UIViewController <UIAlertViewDelegate> {
    IBOutlet MyWebView *webView;
	IBOutlet UILabel *lbTitle;
	IBOutlet UIImageView *bgImageHeader;
	IBOutlet UIToolbar *tBar;
	
	IBOutlet UIView *superView;
	IBOutlet UIView *theRightView;
	IBOutlet UIView *theLeftView;
	
	int _current_index;
	int _card_page_index;
	NSMutableArray *array_Scenearios;
	
	int mode; //0: Enter normally, not from bookmark;  1: Enter from bookmark
	
	float _tmp_x;
	float _tmp_y;
	
	int _type;   //0: Scenarioes    1: Skill Sheet    2: DOC
    
    
    // add by perry ,the view center
    CGFloat viewCenterHeight;
}

-(void)turnMenuToRight;
-(void)turnMenuToLeft;
-(void)updateCard;
-(IBAction)previous: (id)sender;
-(IBAction)next: (id)sender;
-(IBAction)addtoBookmark: (id)sender;
-(void)unbook: (int)sID;
-(void)book: (int)sID;

@property (retain, nonatomic) IBOutlet UIView *view_Header;
@property (nonatomic, assign) int _current_index;
@property (nonatomic, assign) int mode;
@property (nonatomic, retain) NSMutableArray *array_Scenearios;
@property (nonatomic, assign) int _type;   //0: Scenarioes    1: Skill Sheet

@end
