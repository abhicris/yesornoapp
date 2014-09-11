//
//  Validator.h
//  YesORNoApp
//
//  Created by nicholas on 14-9-11.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Validator : NSObject
+(BOOL)lengthShouldFit:(NSString *)text length:(NSInteger )length;
+(BOOL)emailValidate:(NSString *)text;
@end
