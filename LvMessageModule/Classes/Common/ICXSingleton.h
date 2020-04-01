//
//  ICXSingleton.h
//  ICXFrame
//
//  Created by krisouljz on 2018/3/18.
//  Copyright (c) 2020 krisouljz. All rights reserved.
//

#ifndef ICXSingleton_h
#define ICXSingleton_h

#define ICX_AS_SINGLETON( __class , __method) \
+ (__class *)__method;


#define ICX_DEF_SINGLETON( __class , __method ) \
+ (__class *)__method {\
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

#endif /* ICXSingleton_h */
