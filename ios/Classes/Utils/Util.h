//
//  Util.h
//  carching_background_locator
//
//  Created by tech firdaus yusof on 19/12/2022.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Util : NSObject

+ (CLLocationAccuracy) getAccuracy:(long)key;
+ (NSDictionary<NSString *,NSNumber*>*) getLocationMap:(CLLocation *)location;

@end

NS_ASSUME_NONNULL_END
