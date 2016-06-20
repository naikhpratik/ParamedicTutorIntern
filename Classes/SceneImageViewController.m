//
//  SceneImageViewController.m
//  Paramedic
//
//  Created by Asad Tkxel on 30/01/2015.
//
//

#import "SceneImageViewController.h"

@interface SceneImageViewController ()

@end

@implementation SceneImageViewController


#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *imageNameTokens = [self.ekgImageName componentsSeparatedByString:@".png"];
    [self.ekgImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_rotate.png",[imageNameTokens objectAtIndex:0]]]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:kDeviceOrientationKey];
}

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
