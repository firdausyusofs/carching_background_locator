#import <Flutter/Flutter.h>
#import <CoreLocation/CoreLocation.h>
#import "MethodCallHelper.h"

@interface CarchingBackgroundLocatorPlugin : NSObject<FlutterPlugin, CLLocationManagerDelegate, MethodCallHelperDelegate>

+ (CarchingBackgroundLocatorPlugin* _Nullable) getInstance;
- (void)invokeMethod:(NSString* _Nonnull)method arguments:(id _Nullable)arguments;

@end
