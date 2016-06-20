//
//  CustomCell_quiz.h
//  Quiz
//
//  Created by Arthur on 13-9-10.
//
//

#import <UIKit/UIKit.h>

@interface CustomCellQuiz : UITableViewCell{
    IBOutlet UIImageView *img_answer_;
    IBOutlet UITextView *tfAnswer;
    
}
//@property (retain, nonatomic) IBOutlet UIButton *btn_answer;

//
@property (nonatomic, retain) UIImageView *img_answer_;
@property (nonatomic, retain) UITextView *tfAnswer;
@end
