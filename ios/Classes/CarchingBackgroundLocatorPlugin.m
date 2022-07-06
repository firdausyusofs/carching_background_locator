#import "CarchingBackgroundLocatorPlugin.h"
#if __has_include(<carching_background_locator/carching_background_locator-Swift.h>)
#import <carching_background_locator/carching_background_locator-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "carching_background_locator-Swift.h"
#endif

@implementation CarchingBackgroundLocatorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCarchingBackgroundLocatorPlugin registerWithRegistrar:registrar];
}
@end
