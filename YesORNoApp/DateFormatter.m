//
//  DateFormatter.m
//  YesORNoApp
//
//  Created by nicholas on 14-9-9.
//  Copyright (c) 2014年 nicholas. All rights reserved.
//

#import "DateFormatter.h"



@implementation DateFormatter

+(NSString *)friendlyDate:(NSDate *)date
{
#define SECOND_STAMP 1000
#define MINUTE_STAMP 1000*60
#define HOUR_STAMP 1000*60*60
#define DAY_STAMP 1000*60*60*24
    
    NSString *friendlyDate;
    NSDate *now = [NSDate date];
    float dateTimeStamp = [date timeIntervalSince1970]*1000;
    float nowTimeStamp = [now timeIntervalSince1970]*1000;
    
    float stamp = -(dateTimeStamp - nowTimeStamp);
    if (stamp == 0) {
        friendlyDate = @"刚刚";
    }
    if (stamp < DAY_STAMP) {
        if (stamp < MINUTE_STAMP && stamp > 0) {
            friendlyDate = [NSString stringWithFormat:@"%f 秒前", floor(stamp/SECOND_STAMP)];
        }
        if (stamp > MINUTE_STAMP && stamp < HOUR_STAMP) {
            friendlyDate = [NSString stringWithFormat:@"%f 分钟前", floorf(stamp / MINUTE_STAMP)];
        }
        if (stamp > HOUR_STAMP) {
            friendlyDate = [NSString stringWithFormat:@"%f 小时前", floorf(stamp / HOUR_STAMP)];
        }
    } else {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
        NSInteger month = [components month];
        NSInteger day = [components day];
        NSInteger hour = [components hour];
        NSInteger minutes = [components minute];
        friendlyDate = [NSString stringWithFormat:@"%ld月%ld日 - %ld:%ld", (long)month, (long)day, (long)hour, (long)minutes];
    }
    
    
    return friendlyDate;
}

@end
