//
//  UIColor+Extension.h
//  ZLDashboard
//
//  Created by qtx on 16/9/19.
//  Copyright © 2016年 ZL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extensions)

+ (UIColor *)colorWithHex:(long)hexColor;

+ (UIColor *)colorWithHex:(long)hexColor alpha:(CGFloat)alpha;

@end
