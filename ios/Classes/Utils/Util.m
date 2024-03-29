//
//  Util.m
//  carching_background_locator
//
//  Created by tech firdaus yusof on 19/12/2022.
//

#import "Util.h"
#import "Globals.h"

@implementation Util

+ (CLLocationAccuracy) getAccuracy:(long)key {
    switch (key) {
        case 0:
            return kCLLocationAccuracyKilometer;
        case 1:
            return kCLLocationAccuracyHundredMeters;
        case 2:
            return kCLLocationAccuracyNearestTenMeters;
        case 3:
            return kCLLocationAccuracyBest;
        case 4:
            return kCLLocationAccuracyBestForNavigation;
        default:
            return kCLLocationAccuracyBestForNavigation;;
    }
}

+ (NSDictionary<NSString *,NSNumber *> *)getLocationMap:(CLLocation *)location {
    NSTimeInterval timeInSeconds = [location.timestamp timeIntervalSince1970];
    return @{
        kArgLatitude: @(location.coordinate.latitude),
        kArgLongitude: @(location.coordinate.longitude),
        kArgAccuracy: @(location.horizontalAccuracy),
        kArgAltitude: @(location.altitude),
        kArgSpeed: @(location.speed),
        kArgSpeedAccuracy: @(0.0),
        kArgHeading: @(location.course),
        kArgTime: @(((double) timeInSeconds) * 1000.0)
    };
}

@end
