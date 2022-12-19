//
//  Pluggable.h
//  carching_background_locator
//
//  Created by tech firdaus yusof on 19/12/2022.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol Pluggable <NSObject>

- (void)setCallback:(int64_t) callbackHandle;
- (void)onServiceStart:(NSDictionary *)initialDataDictionary;
- (void)onServiceDispose;

@end

NS_ASSUME_NONNULL_END
