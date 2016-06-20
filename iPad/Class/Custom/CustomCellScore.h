//
//  CustomCell_quiz.h
//  Quiz
//
//  Created by Arthur on 13-9-10.
//
//

#import <UIKit/UIKit.h>

@interface CustomCellScore : UITableViewCell{
    
    IBOutlet UILabel *lab_title;
    IBOutlet UILabel *lab_result;
    
}

@property (nonatomic, retain) UILabel *lab_title;
@property (nonatomic, retain) UILabel *lab_result;
@end
