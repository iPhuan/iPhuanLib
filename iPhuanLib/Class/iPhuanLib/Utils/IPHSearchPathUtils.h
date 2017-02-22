//
//  IPHSearchPathUtils.h
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/21.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


// 设置全局bundle,默认为main bundle, 如多主题可以使用
void IPHSetDefaultBundle(NSBundle *bundle);

// 获取默认bundle
NSBundle *IPHDefaultBundle();

// 获取bundle资源路径
NSString *IPHPathForBundleResource(NSString *relativePath);


// 获取Documents目录路径
NSString *IPHPathForDocuments();

// 获取Cache目录路径
NSString *IPHPathForCache();

// 通过NSSearchPathDirectory来获取对应的沙盒路径
NSString *IPHPathForDirectory(NSSearchPathDirectory directory);

// 获取Documents目录下的资源路径
NSString *IPHPathForDocumentsResource(NSString *relativePath);

// 获取Cache目录下的资源路径
NSString *IPHPathForCacheResource(NSString *relativePath);

// 通过NSSearchPathDirectory来获取对应沙盒目录下的资源路径
NSString *IPHPathForDirectoryResource(NSSearchPathDirectory directory, NSString *relativePath);

NS_ASSUME_NONNULL_END
