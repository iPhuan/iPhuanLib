//
//  IPHLocationManager.h
//  iPhuanLib
//
//  Created by iPhuan on 2016/12/23.
//  Copyright © 2016年 iPhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


#define IPH_LOCATION_MANAGER   [IPHLocationManager sharedLocationManager]


typedef void(^IPHRequestLocationCompletionHandler)(NSError *error);
typedef void(^IPHRequestCoordinateCompletionHandler)(CLLocationCoordinate2D coordinate, NSError *error);
typedef void(^IPHRequestAddressCompletionHandler)(NSString *address, NSError *error);
typedef void(^IPHRequestCityCompletionHandler)(NSString *city, NSError *error);
typedef void(^IPHRequestCoordinateAndAddressCompletionHandler)(CLLocationCoordinate2D coordinate, NSString *address, NSError *error);

@interface IPHLocationManager : NSObject
@property (nonatomic, strong, readonly) CLLocation *location;
@property (nonatomic, strong, readonly) CLPlacemark *placemark;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly) NSString *address; // 详细地址
@property (nonatomic, copy, readonly) NSString *city; // 城市名，不包含字符“市”


+ (IPHLocationManager *)sharedLocationManager;

- (void)requestLocation;
- (void)requestLocationWithCompletionHandler:(IPHRequestLocationCompletionHandler)completionHandler;
- (void)requestCoordinateWithCompletionHandler:(IPHRequestCoordinateCompletionHandler)completionHandler;
- (void)requestAddressWithCompletionHandler:(IPHRequestAddressCompletionHandler)completionHandler;
- (void)requestCityWithCompletionHandler:(IPHRequestCityCompletionHandler)completionHandler;
- (void)requestCoordinateAndAddressCompletionHandler:(IPHRequestCoordinateAndAddressCompletionHandler)completionHandler;


@end
