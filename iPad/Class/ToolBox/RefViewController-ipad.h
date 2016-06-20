//
//  RefViewController-ipad.h
//  Quiz
//
//  Created by Arthur on 13-9-16.
//
//

#import <UIKit/UIKit.h>
#import "MyTextView.h"
#import "CardBean.h"
@interface RefViewController_ipad : UIViewController <UITextViewDelegate> {

	CardBean *cardBean;
	
	float _tmp_x;
	float _tmp_y;
}
@property (retain, nonatomic) IBOutlet UIView *superView;
@property (retain, nonatomic) IBOutlet UIView *questionView;
@property (retain, nonatomic) IBOutlet UIView *answerView;
@property (retain, nonatomic) IBOutlet MyTextView *tfAnswer;
@property (retain, nonatomic) IBOutlet MyTextView *tfQuestion;
@property (retain, nonatomic) IBOutlet MyTextView *tfQuestionForAnsView;


@property (nonatomic, retain) CardBean *cardBean;

- (void)flipViewAction;
- (IBAction)back:(id)sender;

@end
