//
//  ICXFunction.m
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#import "ICXFunction.h"
#import "OpenUDID.h"
#import "UIDevice+ICX.h"

@implementation ICXFunction

+ (NSString *)uniqueMessageID {
    static NSString *openUDID = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        openUDID = [[UIDevice currentDevice] openUDID];
        if (openUDID.length > 16) {
            openUDID = [openUDID substringToIndex:16];
        }
    });

    long long  uniqueNumber = [[NSDate date] timeIntervalSince1970] * 1000000;
    int random1 = (arc4random() % 100) + 1; // 获得1-100之间的随机数
    int random2 = (arc4random() % 100) + 1;
    int random3 = (arc4random() % 100) + 1;

    NSString *char1 = [NSString stringWithFormat:@"%c", arc4random_uniform(26) + 'a']; // 获得'a' - 'z'之间的随机字母
    NSString *char2 = [NSString stringWithFormat:@"%c", arc4random_uniform(26) + 'a'];
    NSString *char3 = [NSString stringWithFormat:@"%c", arc4random_uniform(26) + 'a'];
    NSString *char4 = [NSString stringWithFormat:@"%c", arc4random_uniform(26) + 'a'];

    NSString *messageId = [NSString stringWithFormat:@"%@%@%i%@%i%@%i%@%lld", openUDID, char1, random1, char2, random2, char3, random3, char4 , uniqueNumber];

    return messageId;
}

//判断字符串是否是全是数字
+ (BOOL)isPureNumber:(NSString *)string
{
    NSString *str = [NSString stringWithString:string];
    NSScanner* scan = [NSScanner scannerWithString:str];
    NSInteger *val1 = NULL;
    BOOL bInteger = [scan scanInteger:val1] && [scan isAtEnd];
    float val2 = 0;
    BOOL bFloat = [scan scanFloat:&val2] && [scan isAtEnd];
    double val3 = 0;
    BOOL bDouble = [scan scanDouble:&val3] && [scan isAtEnd];
    return (bInteger || bFloat || bDouble);
}

// 计算cmd
+ (NSString *)cmdFromHexCmd:(UInt16)hexCmd {
//    正式环境为：EIM
//    测试环境：EIM_BETA
//    研发环境：EIM_DEV
    NSString *cmd = [NSString stringWithFormat:@"%@/%hu", EIM, hexCmd];
    return cmd;
}

//今天的显示正常的时分，如10:23
//昨天的时间戳，显示规则为：昨天 时时-分分，如：昨天 18:45。
//超过昨天的时间戳则显示具体的日期，如：9月15日 21:34。
//往年的时间戳，显示规则举例：2017年9月12日 15:22.
+ (NSString *)transformedDate:(NSDate*)date format:(NSInteger)formatType
{
    // Initialize the formatter.
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    // Initialize the calendar and flags.
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Create reference date for supplied date.
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    NSDate *suppliedDate = [calendar dateFromComponents:comps];
    NSInteger year = comps.year;
    NSInteger thisYear = 0;
    
    NSString *hourAndMinStr = [ICXFunction detailDate:date];
    
    // Iterate through the eight days (tomorrow, today, and the last six).
    int i;
    for (i = -1; i < 7; i++)
    {
        // Initialize reference date.
        comps = [calendar components:unitFlags fromDate:[NSDate date]];
        [comps setHour:0];
        [comps setMinute:0];
        [comps setSecond:0];
        [comps setDay:[comps day] - i];
        thisYear = comps.year;
        NSDate *referenceDate = [calendar dateFromComponents:comps];
        
        if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == -1)
        {
            // Tomorrow
            return [NSString stringWithFormat:@"Tomorrow"];
        }
        else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 0)
        {
            
            return hourAndMinStr;
        }
        else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 1)
        {
            // Yesterday
            NSString *yesterday = NSLocalizedStringFromTable(@"im_yeartoday_hm", @"ICXChatLocalizable", @"昨天");
            if (formatType == 1) {
                return yesterday;
            }else {
                return [NSString stringWithFormat:NSLocalizedStringFromTable(@"im_yeartoday_hm", @"ICXChatLocalizable", @"昨天 %@"), hourAndMinStr];
            }
            
        }
//        else if ([suppliedDate compare:referenceDate] == NSOrderedSame)
//        {
//            // Day of the week
//            if (formatType == 1) {
//                [formatter setDateFormat:@"EEEE"];
//                return [formatter stringFromDate:date];
//            }else {
//                [formatter setDateFormat:@"EEEE"];
//                return [NSString stringWithFormat:@"%@ %@",[formatter stringFromDate:date],hourAndMinStr];
//            }
//        }
    }
    
    // It's not in those eight days.
    if (formatType == 1) {
        [formatter setDateFormat:@"yy-MM-dd"];
        return [formatter stringFromDate:date];
    }else {
        if (year == thisYear) {
            
            [formatter setDateFormat:NSLocalizedStringFromTable(@"im_mdhm", @"ICXChatLocalizable", nil)];
//            return [NSString stringWithFormat:@"%@ %@",[formatter stringFromDate:date],hourAndMinStr];
            return [formatter stringFromDate:date];
        }
        [formatter setDateFormat:NSLocalizedStringFromTable(@"im_ymdhm", @"ICXChatLocalizable", nil)];
//        return [NSString stringWithFormat:@"%@ %@",[formatter stringFromDate:date],hourAndMinStr];
        return [formatter stringFromDate:date];
    }
}

+ (NSString *)detailDate:(NSDate *)date{
    if (!date) {
        return nil;
    }
    // Initialize the calendar and flags.
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    static NSCalendar *calendar;
    if (!calendar) {
        calendar = [NSCalendar currentCalendar];
    }
    
    // 如果在系统设置里面修改时区，而这里的calendar又是上个时区，会有问题，所以需要每次设置timezone
    if ([calendar.timeZone secondsFromGMT] != [[NSTimeZone localTimeZone] secondsFromGMT]) {
        calendar = [NSCalendar currentCalendar];
    }
    
    // Create reference date for supplied date.
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger hour = [comps hour];
    NSInteger minute = [comps minute];
    NSString *dateStr;
    //获取系统是24小时制或者12小时制
//    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
//    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = NO;//containsA.location != NSNotFound;
    //hasAMPM==TURE为12小时制，否则为24小时制
    if (hasAMPM) {
        NSInteger hour2 = hour;;
        if (hour > 12) {
            hour2 = hour - 12;
        }
        
        NSString *currentLanguageCode = [[NSUserDefaults standardUserDefaults] stringForKey:@"i18n"];//[[NSLocale preferredLanguages] objectAtIndex:0];
        
        // currentLanguageCode有可能为空的情况
        if (currentLanguageCode && ![currentLanguageCode isEqualToString:@"system"]) {
            
        } else {
            currentLanguageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
        }
        
        NSRange r = NSMakeRange(NSNotFound, 0);
        if (currentLanguageCode.length >= 2) {
            NSString *languageStr = @"zh|ko|ja";
            currentLanguageCode = [currentLanguageCode substringToIndex:2];
            r = [languageStr rangeOfString:currentLanguageCode];
        }
        
        // 开发者选项中的切换语言功能判断
        BOOL i18n = NO;
        
        /*NSString *language = [[NSUserDefaults standardUserDefaults] stringForKey:@"i18n"];
         
         if (language && ![language isEqualToString:@"system"]) {
         NSRange r2 = [language rangeOfString:currentLanguageCode];
         i18n = (r2.location == NSNotFound) ? YES : NO;
         }*/
        
        if (r.location == NSNotFound || i18n) {  // AM PM format
            if (hour == 0 || hour == 12) {
                //hourStr = @"12";
                hour2 = 12;
            }
            
            if (hour < 12) {
                dateStr = [NSString stringWithFormat:@"%ld:%02ldam",(long)hour2,(long)minute];
            }else {
                dateStr = [NSString stringWithFormat:@"%ld:%02ldpm",(long)hour2,(long)minute];
            }
        }else { // 凌晨 早上 中午 晚上 formate
            NSString *timeStr;
            if (hour == 0) {
                timeStr = [NSString stringWithFormat:@"%ld:%02ld",(long)hour2,(long)minute];
            }else {
                timeStr = [NSString stringWithFormat:@"%ld:%02ld",(long)hour2,(long)minute];
            }
            
            if (hour < 6) {
                dateStr = [NSString stringWithFormat:NSLocalizedString(@"dateforamte1 %@", @"Date Formate:Early in the morning"),timeStr];
            }else if (hour < 12){
                dateStr = [NSString stringWithFormat:NSLocalizedString(@"dateforamte2 %@", @"Date Formate:Morning"),timeStr];
            }else if (hour < 14){
                dateStr = [NSString stringWithFormat:NSLocalizedString(@"dateforamte3 %@", @"Date Formate:Noon"),timeStr];
            }else if (hour < 19){
                dateStr = [NSString stringWithFormat:NSLocalizedString(@"dateforamte4 %@", @"Date Formate:Afternoon"),timeStr];
            }else {
                dateStr = [NSString stringWithFormat:NSLocalizedString(@"dateforamte5 %@", @"Date Formate:night"),timeStr];
            }
            
        }
    }else {
        dateStr = [NSString stringWithFormat:@"%02ld:%02ld",(long)hour,(long)minute];
    }
    
    return dateStr;
}

@end
