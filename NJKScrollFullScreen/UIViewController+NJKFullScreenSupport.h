//
//  UIViewController+NJKFullScreenSupport.h
//
//  Copyright (c) 2014 Satoshi Asano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NJKFullScreenSupport)

- (void)showNavigationBar:(BOOL)animated;
- (void)hideNavigationBar:(BOOL)animated;
- (void)moveNavigationBar:(CGFloat)deltaY animated:(BOOL)animated;
- (void)setNavigationBarOriginY:(CGFloat)y animated:(BOOL)animated;

@end