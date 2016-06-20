//
//  CardViewController.h
//  Quiz
//
//  Created by Zorro on 3/2/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextView.h"
#import "NSArray+Helpers.h"

@interface CardViewController : UIViewController<UIAlertViewDelegate> {
	IBOutlet UILabel *lbTitle;
	IBOutlet UIView *superView;
	IBOutlet UIView *theRightView;
	IBOutlet UIView *theLeftView;
	
	IBOutlet UIView *questionView;
	IBOutlet UIView *answerView;
	IBOutlet MyTextView *tfAnswer;
	IBOutlet UILabel *lbChapter;
	IBOutlet MyTextView *tfQuestion;
	
	IBOutlet UIBarButtonItem *btLeft;
	IBOutlet UIBarButtonItem *btRight;
	IBOutlet UIButton *btBook;
	IBOutlet UIButton *btBookimg;
	
    BOOL hadPreviousData;
    BOOL fromfromComprehensive;
    
    IBOutlet UIActivityIndicatorView *activityView;
	NSMutableArray *arrayCards;
	
	int iChapter;
	NSString *sChapter;
	
	int mode; //0: Enter normally, not from bookmark;  1: Enter from bookmark
	
	float _tmp_x;
	float _tmp_y;
	int _card_page_index;
	
	int _fc_index;
    
	int bookquizID;
}
@property (assign, nonatomic) BOOL fromfromComprehensive;

@property (retain, nonatomic) UIActivityIndicatorView *activityView;
@property (assign, nonatomic) BOOL hadPreviousData;
@property (retain, nonatomic) IBOutlet UIImageView *pop_question_bg_imageview;
@property (retain, nonatomic) IBOutlet UIImageView *pop_answer_bg_imageView;

@property (retain, nonatomic) IBOutlet UIImageView *cardView_head_imageView;
@property (retain, nonatomic) IBOutlet UILabel *lbl_indexContent;
@property (retain, nonatomic) IBOutlet UIImageView *imgView_cardBackBlueBar;
@property (retain, nonatomic) IBOutlet UIButton *btn_backToLastCard;

-(void)getCardsfromDB;
-(IBAction)answerAction:(id)sender;
-(void)flipViewAction: (int)c_index;
-(IBAction)addtoBookmark: (id)sender;
-(IBAction)nextCard: (id)sender;

-(IBAction)previous: (id)sender;
-(IBAction)next: (id)sender;


-(void)turnMenuToRight;
-(void)turnMenuToLeft;
-(void)updateCard;
-(void)updateArrow;

@property (nonatomic, assign) int iChapter;
@property (nonatomic, retain) NSString *sChapter;
@property (nonatomic, assign) int mode;
@property (nonatomic, assign) int bookquizID;

@end
