//
//  UIView+Extension.h
//  ZLDashboard
//
//  Created by qtx on 16/9/19.
//  Copyright © 2016年 ZL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<QuartzCore/QuartzCore.h>

@interface UIView (Extensions)

@property CGPoint origin;
@property CGSize size;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

@end
