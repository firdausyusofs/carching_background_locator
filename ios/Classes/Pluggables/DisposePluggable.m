//
//  DisposePluggable.m
//  carching_background_locator
//
//  Created by tech firdaus yusof on 19/12/2022.
//

#import "DisposePluggable.h"
#import "PreferencesManager.h"
#import "Globals.h"
#import "CarchingBackgroundLocatorPlugin.h"

@implementation DisposePluggable

- (void)onServiceDispose {
    
}

- (void)onServiceStart:(nonnull NSDictionary *)initialDataDictionary {
    
}


- (void)setCallback:(int64_t)callbackHandle {
    [PreferencesManager setCallbackHandle:callbackHandle key:kDisposeCallbackKey];
}


@end
