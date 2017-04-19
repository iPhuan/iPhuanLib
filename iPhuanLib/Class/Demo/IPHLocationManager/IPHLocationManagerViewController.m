//
//  IPHLocationManagerViewController.m
//  iPhuanLib
//
//  Created by iPhuan on 2017/4/19.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "IPHLocationManagerViewController.h"
#import "IPHLocationManager.h"


@interface IPHLocationManagerViewController ()
@property (nonatomic, strong) NSArray *optionTitles;


@end

@implementation IPHLocationManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.optionTitles = @[@"requestLocation",
                          @"requestLocationWithCompletionHandler",
                          @"requestCoordinateWithCompletionHandler",
                          @"requestAddressWithCompletionHandler",
                          @"requestCityWithCompletionHandler",
                          @"requestCoordinateAndAddressCompletionHandler"
                          ];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _optionTitles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString  *cellIdentifier = @"IPHLocationManagerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = _optionTitles[indexPath.row];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IPH_LOCATION_MANAGER.requestAuthorizationType = IPHRequestAuthorizationTypeAlways;
    IPH_LOCATION_MANAGER.desiredAccuracy = kCLLocationAccuracyBest;
    IPH_LOCATION_MANAGER.distanceFilter = 200.0f;
    
    __block NSString *locationInfo = nil;
    switch (indexPath.row) {
        case 0:
            [IPH_LOCATION_MANAGER requestLocation];
            locationInfo = @"已请求地理位置";
            [self iph_popupAlertViewWithTitle:@"获取位置信息" message:locationInfo];
            break;
        case 1:
        {
            [IPH_LOCATION_MANAGER requestLocationWithCompletionHandler:^(NSError *error) {
                locationInfo = [NSString stringWithFormat:@"location: %@\n\nplacemark: %@\n\nlatitude: %f\nlongitude: %f\ncity: %@\naddress: %@", IPH_LOCATION_MANAGER.location, IPH_LOCATION_MANAGER.placemark, IPH_LOCATION_MANAGER.coordinate.latitude, IPH_LOCATION_MANAGER.coordinate.longitude, IPH_LOCATION_MANAGER.city, IPH_LOCATION_MANAGER.address];
                [self iph_popupAlertViewWithTitle:@"获取位置信息" message:locationInfo];
            }];
            break;
        }
        case 2:
        {
            [IPH_LOCATION_MANAGER requestCoordinateWithCompletionHandler:^(CLLocationCoordinate2D coordinate, NSError *error) {
                locationInfo = error.localizedDescription;
                if (error == nil) {
                    locationInfo = [NSString stringWithFormat:@"location: %@\n\nplacemark: %@\n\nlatitude: %f\nlongitude: %f", IPH_LOCATION_MANAGER.location, IPH_LOCATION_MANAGER.placemark, coordinate.latitude, coordinate.longitude];
                }
                [self iph_popupAlertViewWithTitle:@"获取位置信息" message:locationInfo];
            }];
            break;
        }
        case 3:
        {
            [IPH_LOCATION_MANAGER requestAddressWithCompletionHandler:^(NSString *address, NSError *error) {
                locationInfo = error.localizedDescription;
                if (error == nil) {
                    locationInfo = [NSString stringWithFormat:@"address: %@", address];
                }
                [self iph_popupAlertViewWithTitle:@"获取位置信息" message:locationInfo];

            }];
            break;
        }
        case 4:
        {
            [IPH_LOCATION_MANAGER requestCityWithCompletionHandler:^(NSString *city, NSError *error) {
                locationInfo = error.localizedDescription;
                if (error == nil) {
                    locationInfo = [NSString stringWithFormat:@"city: %@", city];
                }
                [self iph_popupAlertViewWithTitle:@"获取位置信息" message:locationInfo];
            }];
            break;
        }
        case 5:
        {
            [IPH_LOCATION_MANAGER requestCoordinateAndAddressCompletionHandler:^(CLLocationCoordinate2D coordinate, NSString *address, NSError *error) {
                locationInfo = [NSString stringWithFormat:@"latitude: %f\nlongitude: %f\naddress: %@", coordinate.latitude, coordinate.longitude, address];
                [self iph_popupAlertViewWithTitle:@"获取位置信息" message:locationInfo];
            }];
            break;
        }
            
            break;
        default:
            break;
    }
}



@end

