//
//  IPHLocationManager.m
//  iPhuanLib
//
//  Created by iPhuan on 2016/12/23.
//  Copyright © 2016年 iPhuan. All rights reserved.
//

#import "IPHLocationManager.h"

#ifndef IPHIsAvailableString
#define IPHIsAvailableString(X)        ([X isKindOfClass:[NSString class]] && ![@"" isEqualToString:X])
#endif

#ifndef IPHUnNilString
#define IPHUnNilString(X)              ([X isKindOfClass:[NSString class]]?X:@"")
#endif

NSString * const kIPHRequestLocationErrorDomain = @"com.iPhuanLib.error.location.request";


@interface IPHCLLocationManager : CLLocationManager

@property (nonatomic, assign) BOOL needReverseGeocodeLocation;
@property (nonatomic, assign) BOOL hasGetLocation;
@property (nonatomic, copy) IPHLocateCompletionHandler completionHandler;

- (void)executeBlockWithError:(NSError *)error;

@end

@implementation IPHCLLocationManager

- (void)executeBlockWithError:(NSError *)error {
    if (_completionHandler) {
        _completionHandler(error);
    }
}

@end



@interface IPHLocationManager ()<CLLocationManagerDelegate>
@property (nonatomic, readwrite, strong) CLLocation *location;
@property (nonatomic, readwrite, strong) CLPlacemark *placemark;
@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite, copy) NSString *address;
@property (nonatomic, readwrite, copy) NSString *city;
@property (nonatomic, strong) NSMutableArray *locationManagers;
@property (nonatomic, strong) CLLocationManager *requestAuthorizationManager;

@end

@implementation IPHLocationManager


+ (IPHLocationManager *)sharedManager {
    static IPHLocationManager *sharedLocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocationManager = [[self alloc] init];
        sharedLocationManager.requestAuthorizationType = IPHRequestAuthorizationTypeWhenInUse;
        sharedLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        sharedLocationManager.distanceFilter = 100.0f;
    });
    
    return sharedLocationManager;
}


- (CLLocationCoordinate2D)coordinate{
    if (_location) {
        return _location.coordinate;
    }
    return kCLLocationCoordinate2DInvalid;
}

- (NSMutableArray *)locationManagers{
    if (_locationManagers == nil) {
        _locationManagers =  [NSMutableArray arrayWithCapacity:5];
    }
    return _locationManagers;
}

#pragma mark - Public methods

- (void)requestAuthorizationOnly {
    if (self.authorizationStatus == IPHAuthorizationStatusNotDetermined) {
        if (_requestAuthorizationType == IPHRequestAuthorizationTypeWhenInUse) {
            [self.requestAuthorizationManager requestWhenInUseAuthorization];
        } else {
            [self.requestAuthorizationManager requestAlwaysAuthorization];
        }
    }
}

- (void)requestLocation{
    [self p_requestLocationNeedReverseGeocodeLocation:NO completionHandler:nil];
}

- (void)requestLocationWithCompletionHandler:(IPHRequestLocationCompletionHandler)completionHandler{
    [self p_requestLocationNeedReverseGeocodeLocation:NO completionHandler:^(NSError *error){
        if (completionHandler) {
            completionHandler(self.location, error);
        }
    }];}

- (void)requestCoordinateWithCompletionHandler:(IPHRequestCoordinateCompletionHandler)completionHandler{
    [self p_requestLocationNeedReverseGeocodeLocation:NO completionHandler:^(NSError *error){
        if (completionHandler) {
            completionHandler(self.coordinate, error);
        }
    }];
}

- (void)requestReversedGeocodeLocation {
    [self p_requestLocationNeedReverseGeocodeLocation:YES completionHandler:nil];
}

- (void)requestAddressWithCompletionHandler:(IPHRequestAddressCompletionHandler)completionHandler{
    [self p_requestLocationNeedReverseGeocodeLocation:YES completionHandler:^(NSError *error){
        if (completionHandler) {
            completionHandler(_address, error);
        }
    }];
}

- (void)requestCityWithCompletionHandler:(IPHRequestCityCompletionHandler)completionHandler{
    [self p_requestLocationNeedReverseGeocodeLocation:YES completionHandler:^(NSError *error){
        if (completionHandler) {
            completionHandler(_city, error);
        }
    }];
}


- (void)requestCoordinateAndAddressCompletionHandler:(IPHRequestCoordinateAndAddressCompletionHandler)completionHandler{
    [self p_requestLocationNeedReverseGeocodeLocation:YES completionHandler:^(NSError *error){
        if (completionHandler) {
            completionHandler(self.coordinate, _address, error);
        }
    }];
    
}


#pragma mark - Private methods

- (void)p_requestLocationNeedReverseGeocodeLocation:(BOOL)isNeed completionHandler:(IPHLocateCompletionHandler)completionHandler{
    if (![IPHCLLocationManager locationServicesEnabled]) {
        [self p_executeBlock:completionHandler withLocalizedDescription:@"Location services disabled"];
        return;
    }
    
    if (self.authorizationStatus == IPHAuthorizationStatusDenied) {
        [self p_executeBlock:completionHandler withLocalizedDescription:@"Location services refused"];
        return;
    }
    
    IPHCLLocationManager *locationManager = [[IPHCLLocationManager alloc] init];
    if (self.authorizationStatus == IPHAuthorizationStatusNotDetermined) {
        if (_requestAuthorizationType == IPHRequestAuthorizationTypeWhenInUse) {
            [locationManager requestWhenInUseAuthorization];
        } else {
            [locationManager requestAlwaysAuthorization];
        }
    }
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = self.desiredAccuracy;
    locationManager.distanceFilter = self.distanceFilter;
    
    locationManager.needReverseGeocodeLocation = isNeed;
    locationManager.completionHandler = completionHandler;
    
    [locationManager startUpdatingLocation];
    [self.locationManagers addObject:locationManager];
}

- (void)p_executeBlock:(IPHLocateCompletionHandler)completionHandler withLocalizedDescription:(NSString *)description{
    if (completionHandler) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:description};
        NSError *error = [NSError errorWithDomain:kIPHRequestLocationErrorDomain code:-1 userInfo:userInfo];
        completionHandler(error);
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    IPHCLLocationManager *locationManager = (IPHCLLocationManager *)manager;
    
    // 如果已经获取了位置则return掉，防止多次调用
    if (locationManager.hasGetLocation) {
        return;
    }
    
    [self.locationManagers removeObject:manager];
    
    [locationManager stopUpdatingLocation];
    
    CLLocation *availableLocation = nil;
    
    //当横向精度为负数时说明获取的位置无效
    for (int index = (int)locations.count - 1; index >= 0; index--) {
        CLLocation *location = [locations objectAtIndex:index];
        if (location.horizontalAccuracy > 0) {
            availableLocation = location;
            break;
        }
    }
    if (!availableLocation) {
        [self p_executeBlock:locationManager.completionHandler withLocalizedDescription:@"Invalid location"];
        return;
    }
    
    self.location = availableLocation;
    locationManager.hasGetLocation = YES;
    
    if (!locationManager.needReverseGeocodeLocation) {
        [locationManager executeBlockWithError:nil];
        return;
    }
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:availableLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0) {
            self.placemark = [placemarks objectAtIndex:0];
            
            NSString *address = _placemark.name;
            if (IPHIsAvailableString(address)) {
                NSString *administrativeArea = IPHUnNilString(_placemark.administrativeArea);
                if ([_placemark.locality isEqualToString:_placemark.administrativeArea]) {
                    administrativeArea = @"";
                }
                address = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                           IPHUnNilString(_placemark.country),
                           administrativeArea,
                           IPHUnNilString(_placemark.subAdministrativeArea),
                           IPHUnNilString(_placemark.locality),
                           IPHUnNilString(_placemark.subLocality),
                           IPHUnNilString(_placemark.thoroughfare),
                           IPHUnNilString(_placemark.subThoroughfare)];
            }
            self.city = _placemark.locality;
            self.address = address;
            [locationManager executeBlockWithError:nil];
        }else{
            [locationManager executeBlockWithError:error];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    IPHCLLocationManager *locationManager = (IPHCLLocationManager *)manager;
    [self.locationManagers removeObject:manager];
    [locationManager stopUpdatingLocation];
    [locationManager executeBlockWithError:error];
}


#pragma mark - Get

- (IPHAuthorizationStatus)authorizationStatus {
    CLAuthorizationStatus authStatus = [IPHCLLocationManager authorizationStatus];
    if (authStatus == kCLAuthorizationStatusNotDetermined) {
        return IPHAuthorizationStatusNotDetermined;
    } else if (authStatus == kCLAuthorizationStatusRestricted || authStatus == kCLAuthorizationStatusDenied) {
        return IPHAuthorizationStatusDenied;
    } else {
        return IPHAuthorizationStatusAuthorized;
    }
}

- (BOOL)isAuthorizationAuthorized {
    return self.authorizationStatus == IPHAuthorizationStatusAuthorized;
}

- (CLLocationManager *)requestAuthorizationManager {
    if (_requestAuthorizationManager == nil) {
        _requestAuthorizationManager = [[CLLocationManager alloc] init];
    }
    return _requestAuthorizationManager;
}


@end


