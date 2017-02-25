//
//  IPHPathUtils.m
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/21.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "IPHPathUtils.h"


#pragma mark - Bundle

static NSBundle *globalBundle = nil;

void IPHSetDefaultBundle(NSBundle* bundle) {
    globalBundle = bundle;
}

NSBundle *IPHDefaultBundle(){
    return (nil != globalBundle) ? globalBundle : [NSBundle mainBundle];
}

NSString *IPHPathForBundleResource(NSString *relativePath) {
    NSString *resourcePath = [IPHDefaultBundle() resourcePath];
    return [resourcePath stringByAppendingPathComponent:relativePath];
}



#pragma mark - Sandbox

NSString *IPHPathForDocuments() {
    return IPHPathForDirectory(NSDocumentDirectory);
}

NSString *IPHPathForCache() {
    return IPHPathForDirectory(NSCachesDirectory);
}

NSString *IPHPathForDirectory(NSSearchPathDirectory directory) {
    static NSString *documentsPath = nil;
    if (documentsPath == nil) {
        NSArray *dirs = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
        documentsPath = dirs[0];
    }
    return documentsPath;
}


NSString *IPHPathForDocumentsResource(NSString *relativePath) {
    return IPHPathForDirectoryResource(NSDocumentDirectory, relativePath);
}

NSString *IPHPathForCacheResource(NSString* relativePath) {
    return IPHPathForDirectoryResource(NSCachesDirectory, relativePath);
}

NSString *IPHPathForDirectoryResource(NSSearchPathDirectory directory, NSString *relativePath) {
    return [IPHPathForDirectory(directory) stringByAppendingPathComponent:relativePath];
}



