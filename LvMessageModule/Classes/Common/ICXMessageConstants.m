//
//  ICXConstants.m
//  ICXCoach
//
//  Created by krisouljz on 2019/1/11.
//  Copyright © 2019krisouljz All rights reserved.
//

#import "ICXMessageConstants.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <CocoaLumberjack/DDLegacyMacros.h>

int ddLogLevel =
#ifdef DEBUG
DDLogLevelVerbose;
#else
DDLogLevelAll;
#endif

@implementation ICXMessageConstants

@end
