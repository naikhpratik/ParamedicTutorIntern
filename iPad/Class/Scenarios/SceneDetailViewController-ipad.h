//
//  SceneDetailViewController-ipad.h
//  Quiz
//
//  Created by Arthur on 13-9-14.
//
//

#import <UIKit/UIKit.h>
#import "MyWebView.h"

@interface SceneDetailViewController_ipad : UIViewController {

    int _current_index;
	int _card_page_index;
	NSMutableArray *array_Scenearios;
	
	int mode; //0: Enter normally, not from bookmark;  1: Enter from bookmark
	
	float _tmp_x;
	float _tmp_y;
	
	int _type;   //0: Scenarioes    1: Skill Sheet    2: DOC
}
@property (retain, nonatomic) IBOutlet UIImageView *bgImageHeader;
@property (retain, nonatomic) IBOutlet UILabel *lbTitle;
@property (retain, nonatomic) IBOutlet MyWebView *webView;
@property (retain, nonatomic) IBOutlet UIToolbar *tBar;
@property (retain, nonatomic) IBOutlet UIView *superView;
@property (retain, nonatomic) IBOutlet UIView *theRightView;
@property (retain, nonatomic) IBOutlet UIView *theLeftView;


@property (nonatomic, assign) int _current_index;
@property (nonatomic, assign) int mode;
@property (nonatomic, retain) NSMutableArray *array_Scenearios;
@property (nonatomic, assign) int _type;   //0: Scenarioes    1: Skill Sheet

- (IBAction)previous:(id)sender;
- (IBAction)next:(id)sender;
- (IBAction)addtoBookmark:(id)sender;

-(void)unbook: (int)sID;
-(void)book: (int)sID;
-(void)turnMenuToRight;
-(void)turnMenuToLeft;
-(void)updateCard;
@end
