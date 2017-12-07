//
//  IPHLocationManager.h
//  iPhuanLib
//
//  Created by iPhuan on 2016/12/23.
//  Copyright © 2016年 iPhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


#define IPH_LOCATION_MANAGER   [IPHLocationManager sharedManager]

typedef NS_ENUM(NSUInteger, IPHRequestAuthorizationType) {
    IPHRequestAuthorizationTypeWhenInUse = 0,
    IPHRequestAuthorizationTypeAlways
};

typedef NS_ENUM(NSUInteger, IPHAuthorizationStatus) {
    IPHAuthorizationStatusNotDetermined = 0,    // 未决定状态，等同于kCLAuthorizationStatusNotDetermined
    IPHAuthorizationStatusDenied,               // 已禁用，包含kCLAuthorizationStatusRestricted和kCLAuthorizationStatusDenied
    IPHAuthorizationStatusAuthorized            // 已授权，包含kCLAuthorizationStatusAuthorizedAlways，kCLAuthorizationStatusAuthorizedWhenInUse，kCLAuthorizationStatusAuthorized
};

typedef void(^IPHLocateCompletionHandler)(NSError *error);
typedef void(^IPHRequestLocationCompletionHandler)(CLLocation *location, NSError *error);
typedef void(^IPHRequestCoordinateCompletionHandler)(CLLocationCoordinate2D coordinate, NSError *error);
typedef void(^IPHRequestAddressCompletionHandler)(NSString *address, NSError *error);
typedef void(^IPHRequestCityCompletionHandler)(NSString *city, NSError *error);
typedef void(^IPHRequestCoordinateAndAddressCompletionHandler)(CLLocationCoordinate2D coordinate, NSString *address, NSError *error);

@interface IPHLocationManager : NSObject
@property (nonatomic, assign) IPHRequestAuthorizationType requestAuthorizationType; // 默认IPHRequestAuthorizationTypeWhenInUse，调用requestWhenInUseAuthorization来请求权限
@property(nonatomic, assign) CLLocationAccuracy desiredAccuracy;    // 设置CLLocationManager的desiredAccuracy，默认kCLLocationAccuracyBest
@property(nonatomic, assign) CLLocationDistance distanceFilter;     // 设置CLLocationManager的distanceFilter，默认100m更新位置信息

@property (nonatomic, readonly, assign) IPHAuthorizationStatus authorizationStatus;     // 授权状态
@property (nonatomic, readonly, assign) BOOL isAuthorizationAuthorized;                 // 是否已授权

// 以下各个属性不一定都获取到值，请谨慎使用
@property (nonatomic, readonly, strong) CLLocation *location;
@property (nonatomic, readonly, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, strong) CLPlacemark *placemark;
@property (nonatomic, readonly, copy) NSString *address;                                // 详细地址
@property (nonatomic, readonly, copy) NSString *city;                                   // 城市名，包含字符“市”


+ (IPHLocationManager *)sharedManager;

// 只获取地理位置权限，不进行定位操作
- (void)requestAuthorizationOnly;

// 只获取location
- (void)requestLocation;

// block中能拿到坐标信息
- (void)requestLocationWithCompletionHandler:(IPHRequestLocationCompletionHandler)completionHandler;
- (void)requestCoordinateWithCompletionHandler:(IPHRequestCoordinateCompletionHandler)completionHandler;



// 获取location后继续获取反向地理编码位置
- (void)requestReversedGeocodeLocation;

// 以下所有方法block中能拿到坐标信息和地址信息
- (void)requestAddressWithCompletionHandler:(IPHRequestAddressCompletionHandler)completionHandler;
- (void)requestCityWithCompletionHandler:(IPHRequestCityCompletionHandler)completionHandler;
- (void)requestCoordinateAndAddressCompletionHandler:(IPHRequestCoordinateAndAddressCompletionHandler)completionHandler;


@end

