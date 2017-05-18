//
//  ZLDashboardView.h
//  ZLDashboard
//
//  Created by qtx on 16/9/19.
//  Copyright © 2016年 ZL. All rights reserved.
//

/**
 *  根据跃动数字
 *
 *  确定百分比
 *  现在的跳动数字——>背景颜色变化
 *
 */

#import <UIKit/UIKit.h>

@interface ZLDashboardView : UIView

@property (nonatomic, strong) UIImage *bgImage;

@property (nonatomic, copy) void(^TimerBlock)(NSInteger);

/**
 *  跃动数字刷新
 *
 */
- (void)refreshJumpNOFromNO:(NSString *)startNO toNO:(NSString *)toNO;

@end
