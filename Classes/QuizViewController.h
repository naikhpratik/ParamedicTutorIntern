//
//  QuizViewController.h
//  Quiz
//
//  Created by Zorro on 2/15/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSArray+Helpers.h"

@interface QuizViewController : UIViewController <UIActionSheetDelegate> {
    IBOutlet UISegmentedControl *segControl;
	IBOutlet UITableView *tbView;
	IBOutlet UIView *overlayView;
	IBOutlet UITextView *tfCorrect;
	IBOutlet UIButton *btNext;
	IBOutlet UIButton *btBook;
	IBOutlet UIButton *btBookimg;
	IBOutlet UILabel *lbChapter;
	
	NSMutableArray *arrayQuiz;
	NSMutableDictionary *quizOri;
    NSMutableArray *arrCorrectNums;
    NSMutableArray *arrWrongNums;
	NSMutableArray *arrayNums;
	int _currentIndex;
	NSString *correctAns;
	
    BOOL hasPreviousData;
    BOOL fromComprehensive;
    
	int iChapter;
	NSString *sChapter;
	
	BOOL b_FirstTouch;
	int iCorrectNum;
	int iAlldoneNum;
	
	int mode; //0: Enter normally, not from bookmark;  1: Enter from bookmark
	int bookquizID;
	
	BOOL b_Return;
}
@property (assign, nonatomic) BOOL fromComprehensive;
@property (assign, nonatomic) BOOL hasPreviousData;
@property (retain, nonatomic) IBOutlet UIImageView *quiz_header_imageView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

-(IBAction)chooseAnswer: (id)sender;
-(IBAction)back: (id)sender;
-(void)getQuizfromDB;
-(void)saveScore;
-(IBAction)bookQuestion: (id)sender;
-(IBAction)returnQuestion: (id)sender;
-(IBAction)nextQuestion: (id)sender;
-(void)judge: (int)answer;

@property (retain, nonatomic) IBOutlet UILabel *lbl_QuizChapter;
@property (retain, nonatomic) IBOutlet UILabel *lbl_QuizProcess;
@property (retain, nonatomic) IBOutlet UILabel *lbl_QuizPercent;
@property (retain, nonatomic) IBOutlet UILabel *lbl_QuizIndex;
@property (retain, nonatomic) IBOutlet UILabel *lbl_QuizTotal;
@property (retain, nonatomic) IBOutlet UITextView *tv_quizContent;
@property (retain, nonatomic) IBOutlet UIImageView *imgView_QuizBg;
@property (nonatomic, assign) int iChapter;
@property (nonatomic, retain) NSString *sChapter;
@property (nonatomic, assign) int mode;
@property (nonatomic, assign) int bookquizID;

@end
