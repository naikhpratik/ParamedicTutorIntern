//
//  DosingBean.h
//  Paramedic
//
//  Created by Abdul Rehman on 1/14/15.
//
//

#import <Foundation/Foundation.h>

@interface DosingBean : NSObject{

    
    NSString* question;
    NSString* answer;
    NSString* equation;
    

}

@property (strong, nonatomic) NSString* question;
@property (strong, nonatomic) NSString* answer;
@property (strong, nonatomic) NSString* equation;

@end
