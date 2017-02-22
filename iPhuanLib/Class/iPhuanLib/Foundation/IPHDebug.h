//
//  IPHDebug.h
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/18.
//  Copyright © 2017年 iPhuan. All rights reserved.
//


#ifdef DEBUG
#define IPHLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define IPHLog(xx, ...)  ((void)0)
#endif


// Prints the current method's name.
#define IPH_PRINT_METHOD_NAME()  IPHLog(@"%s", __PRETTY_FUNCTION__)

#ifdef DEBUG
#define IPH_CONDITION_PRINT(condition, xx, ...)  do {   \
if ((condition)) {  \
    IPHLog(xx, ##__VA_ARGS__);  \
}   \
} while(0)

#else
#define IPH_CONDITION_PRINT(condition, xx, ...) ((void)0)
#endif
