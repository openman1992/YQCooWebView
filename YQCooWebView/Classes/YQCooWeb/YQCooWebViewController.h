//
//  YQCooWebViewController.h
//  web
//
//  Created by 意想不到 on 2019/4/4.
//  Copyright © 2019年 意想不到. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface YQCooWebViewController : UIViewController

@property (nonatomic, strong) UIImage *canBackNormalItemImage; // 是否可以返回 普通状态 普通状态不可返回 选中状态可以返回

@property (nonatomic, strong) UIImage *canBackSelectedItemImage; // 是否可以返回 选中状态

@property (nonatomic, strong) UIImage *canGoForwardNormalItemImage; // 是否可以前进

@property (nonatomic, strong) UIImage *canGoForwardSelectedItemImage;

@property (nonatomic, strong) UIImage *refreshImage; // 刷新当前页

@property (nonatomic, strong) UIImage *goMenuImage; // 回到首页

// 网页需要导航器
+ (UINavigationController *)instanceWithUrl:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
