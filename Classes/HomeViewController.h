//
//  HomeViewController.h
//  Quiz
//
//  Created by Zorro on 2/15/11.
//  Copyright 2011 TeagleSoft. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HomeViewController : UIViewController {

}
@property (retain, nonatomic) IBOutlet UIImageView *home_bg_imageView;

-(IBAction)startQuiz: (id)sender;
-(IBAction)scenarios: (id)sender;
-(IBAction)flashcards: (id)sender;
//-(IBAction)cardio: (id)sender;
//-(IBAction)dosing: (id)sender;
-(IBAction)toolbox: (id)sender;
-(IBAction)about: (id)sender;
-(IBAction)follow: (id)sender;

@end
