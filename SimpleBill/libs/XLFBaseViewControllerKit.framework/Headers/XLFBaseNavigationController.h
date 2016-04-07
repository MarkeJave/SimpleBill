//
//  BaseNaviGationController.h
//  XLFCommerce
//
//  Created by Marike Jave 3/11/14.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIViewController (UINavigationButtonAnimate)

- (void)viewAppearFromLeft;
- (void)viewAppearFromRight;
- (void)viewDisappearFromLeft;
- (void)viewDisappearFromRight;

@end

@interface XLFBaseNavigationController : UINavigationController

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate;
@end
