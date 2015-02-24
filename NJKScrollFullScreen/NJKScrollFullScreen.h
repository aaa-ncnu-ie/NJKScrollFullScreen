//
//  NJKScrollFullscreen.h
//
//  Copyright (c) 2014 Satoshi Asano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NJKScrollFullScreen : NSObject<UIScrollViewDelegate>

@property (nonatomic) CGFloat upThresholdY; // up distance until fire. default 0 px.
@property (nonatomic) CGFloat downThresholdY; // down distance until fire. default 0 px.

- (id)initWithForwardTarget:(id)forwardTarget viewController:(UIViewController *)viewController;
- (void)reset;

@end
