//
//  UIViewController+NJKFullScreenSupport.m
//
//  Copyright (c) 2014 Satoshi Asano. All rights reserved.
//

#import "UIViewController+NJKFullScreenSupport.h"

#define kNearZero 0.000001f

@implementation UIViewController (NJKFullScreenSupport)

- (void)showNavigationBar:(BOOL)animated
{
    CGFloat statusBarHeight = [self statusBarHeight];

    UIWindow *appKeyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *appBaseView = appKeyWindow.rootViewController.view;
    CGRect viewControllerFrame =  [appBaseView convertRect:appBaseView.bounds toView:appKeyWindow];

    CGFloat overwrapStatusBarHeight = statusBarHeight - viewControllerFrame.origin.y;

    [self setNavigationBarOriginY:overwrapStatusBarHeight animated:animated];
}

- (void)hideNavigationBar:(BOOL)animated
{
    CGFloat statusBarHeight = [self statusBarHeight];

    UIWindow *appKeyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *appBaseView = appKeyWindow.rootViewController.view;
    CGRect viewControllerFrame =  [appBaseView convertRect:appBaseView.bounds toView:appKeyWindow];

    CGFloat overwrapStatusBarHeight = statusBarHeight - viewControllerFrame.origin.y;

    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat top = -navigationBarHeight + overwrapStatusBarHeight;

    [self setNavigationBarOriginY:top animated:animated];
}

- (void)moveNavigationBar:(CGFloat)deltaY animated:(BOOL)animated
{
    CGRect frame = self.navigationController.navigationBar.frame;
    CGFloat nextY = frame.origin.y + deltaY;
    [self setNavigationBarOriginY:nextY animated:animated];
}

- (void)setNavigationBarOriginY:(CGFloat)y animated:(BOOL)animated
{
    CGFloat statusBarHeight = [self statusBarHeight];

    UIWindow *appKeyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *appBaseView = appKeyWindow.rootViewController.view;
    CGRect viewControllerFrame =  [appBaseView convertRect:appBaseView.bounds toView:appKeyWindow];

    CGFloat overwrapStatusBarHeight = statusBarHeight - viewControllerFrame.origin.y;

    CGRect frame = self.navigationController.navigationBar.frame;
    CGFloat navigationBarHeight = frame.size.height;

    CGFloat topLimit = -navigationBarHeight + overwrapStatusBarHeight;
    CGFloat bottomLimit = overwrapStatusBarHeight;

    frame.origin.y = fmin(fmax(y, topLimit), bottomLimit);

    CGFloat navBarHiddenRatio = overwrapStatusBarHeight > 0 ? (overwrapStatusBarHeight - frame.origin.y) / overwrapStatusBarHeight : 0;
    CGFloat alpha = MAX(1.f - navBarHiddenRatio, kNearZero);
    [UIView animateWithDuration:animated ? 0.1 : 0 animations:^{
        self.navigationController.navigationBar.frame = frame;
        NSUInteger index = 0;
        for (UIView *view in self.navigationController.navigationBar.subviews) {
            index++;
            if (index == 1 || view.hidden || view.alpha <= 0.0f) continue;
            view.alpha = alpha;
        }
        UIColor *tintColor = self.navigationController.navigationBar.tintColor;
        if (tintColor) {
            self.navigationController.navigationBar.tintColor = [tintColor colorWithAlphaComponent:alpha];
        }
    }];
}

- (CGFloat)statusBarHeight {
    CGSize statusBarFrameSize = [UIApplication sharedApplication].statusBarFrame.size;
    return statusBarFrameSize.height;
}

@end
