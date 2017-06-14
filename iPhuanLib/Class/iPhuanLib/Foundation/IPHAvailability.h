//
//  IPHAvailability.h
//  iPhuanLib
//
//  Created by iPhuan on 2017/5/17.
//  Copyright © 2017年 iPhuan. All rights reserved.
//



/* Version of iPhuanLib */
#define __IPHUANLIB_1_0_0 10000
#define __IPHUANLIB_1_0_1 10001
/* coho:next-version,insert-before */
#define __IPHUANLIB_NA 99999      /* not available */




/* Return the string version of the decimal version */
#define IPH_DECIMAL_VERSION(X) [NSString stringWithFormat:@"%d.%d.%d", \
(X / 10000), (X % 10000) / 100, (X % 10000) % 100]

/* Current version of iPhuanLib */
#define IPHUANLIB_CURRENT_VERSION  __IPHUANLIB_1_0_1
#define IPH_VERSION  IPH_DECIMAL_VERSION(IPHUANLIB_CURRENT_VERSION)



#ifdef __clang__
#define IPH_DEPRECATED(version, msg) __attribute__((deprecated("Deprecated in iPhuanLib " #version ". " msg)))
#else
#define IPH_DEPRECATED(version, msg) __attribute__((deprecated()))
#endif


//IPH_DEPRECATED(1.0.1, "Do not use this"))
