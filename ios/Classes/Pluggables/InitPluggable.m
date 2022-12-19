//
//  InitPluggable.m
//  carching_background_locator
//
//  Created by tech firdaus yusof on 19/12/2022.
//

#import "InitPluggable.h"

#import "Globals.h"
#import "PreferencesManager.h"
#import "CarchingBackgroundLocatorPlugin.h"

@implementation InitPluggable {
    BOOL isInitialCallbackCalled;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        isInitialCallbackCalled = NO;
    }
    return self;
}

- (void)onServiceDispose {
    isInitialCallbackCalled = NO;
}

- (void)onServiceStart:(nonnull NSDictionary *)initialDataDictionary {
    if (!isInitialCallbackCalled) {
        NSDictionary *map = @{
            kArgInitCallback: @([PreferencesManager getCallbackHandle:kInitCallbackKey]),
            kArgInitDataCallback: initialDataDictionary
        };
        
        [[CarchingBackgroundLocatorPlugin getInstance] invokeMethod:kBCMInit arguments:map];
    }
    isInitialCallbackCalled = YES;
}

- (void)setCallback:(int64_t)callbackHandle {
    [PreferencesManager setCallbackHandle:callbackHandle key:kInitCallbackKey];
}

@end
