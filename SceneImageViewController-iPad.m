//
//  SceneImageViewController-iPad.m
//  Paramedic
//
//  Created by Asad Tkxel on 03/02/2015.
//
//

#import "SceneImageViewController-iPad.h"

@interface SceneImageViewController_iPad ()

@end

@implementation SceneImageViewController_iPad


#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *imageNameTokens = [self.ekgImageName componentsSeparatedByString:@".png"];
    [self.ekgImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_ipad.png",[imageNameTokens objectAtIndex:0]]]];
    
}


#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
