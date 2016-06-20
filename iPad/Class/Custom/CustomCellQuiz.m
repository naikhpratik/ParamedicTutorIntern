//
//  CustomCell_quiz.m
//  Quiz
//
//  Created by Arthur on 13-9-10.
//
//

#import "CustomCellQuiz.h"

@interface CustomCellQuiz ()

@end

@implementation CustomCellQuiz
@synthesize img_answer_,tfAnswer;
//@synthesize tfAnswer;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
 
    }
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
	[super setSelected:selected animated:animated];
    img_answer_.userInteractionEnabled = NO;
    tfAnswer.editable = NO;
    tfAnswer.userInteractionEnabled = NO;
}


- (void)dealloc {
    [img_answer_ release];
    [tfAnswer release];
    [super dealloc];
}


@end
