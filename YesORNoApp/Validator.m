//
//  Validator.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-11.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "Validator.h"

@implementation Validator

+(BOOL)lengthShouldFit:(NSString *)text length:(NSInteger )length
{
    NSUInteger textLength = [text length];
    if (textLength >= length) {
        return YES;
    } else {
        return NO;
    }
}

+(BOOL)emailValidate:(NSString *)text
{
    NSString *regex = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSPredicate *emailText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailText evaluateWithObject:text];
}

@end
