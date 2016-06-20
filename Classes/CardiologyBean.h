//
//  CardiologyBean.h
//  Paramedic
//
//  Created by Asad Tkxel on 26/01/2015.
//
//

#import <Foundation/Foundation.h>

@interface CardiologyBean : NSObject{
    
    NSString* question;
    NSString* hint;
    NSString* explanation;
    
}

@property (strong, nonatomic) NSString* question;
@property (strong, nonatomic) NSString* hint;
@property (strong, nonatomic) NSString* explanation;

@end
