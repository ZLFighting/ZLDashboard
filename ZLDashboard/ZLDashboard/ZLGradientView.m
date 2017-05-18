//
//  ZLGradientView.m
//  ZLDashboard
//
//  Created by qtx on 16/9/19.
//  Copyright © 2016年 ZL. All rights reserved.
//

#import "ZLGradientView.h"
#import "UIColor+Extensions.h"

#define HEXCOLOR(hexColor) [UIColor colorWithHex:hexColor]

@interface ZLGradientView ()

@property (nonatomic, strong) CAGradientLayer * gradientLayer;

//@property (nonatomic, strong) NSMutableArray * allColors;

//@property (nonatomic, strong) NSArray * colors1;
//
//@property (nonatomic, strong) NSArray * colors2;
//
//@property (nonatomic, strong) NSArray * colors3;
//
//@property (nonatomic, strong) NSArray * colors4;

@property (nonatomic, strong) NSArray * upColorArray;

@property (nonatomic, strong) NSArray * middleColorArray;

@property (nonatomic, strong) NSArray * downColorArray;

@property (nonatomic, assign) NSInteger bgCount;

@property (nonatomic, assign) NSInteger changeCount;

@property (nonatomic, strong) NSTimer * bgTimer;

@property (nonatomic, assign) CGFloat totalAnimationTime;

@end


@implementation ZLGradientView

- (void)setupColors {
    NSArray * upColorArray = @[HEXCOLOR(0xff2a01),HEXCOLOR(0xec1f41),
                               HEXCOLOR(0xff2a01),HEXCOLOR(0xff5801),
                               HEXCOLOR(0xf15916),HEXCOLOR(0xf57d0c),
                               HEXCOLOR(0xdba337),HEXCOLOR(0xdbd034),
                               HEXCOLOR(0xffad01),HEXCOLOR(0xe5df1f),
                               HEXCOLOR(0x5ec36d),HEXCOLOR(0x5fc36d),
                               HEXCOLOR(0x69bff3),HEXCOLOR(0x17afc0),
                               HEXCOLOR(0x108ef2)];
    NSArray * middleColorArray = @[HEXCOLOR(0xF5311E),HEXCOLOR(0xf0418d),
                                   HEXCOLOR(0xf66042),HEXCOLOR(0xffab3a),
                                   HEXCOLOR(0xf87b43),HEXCOLOR(0xf6960b),
                                   HEXCOLOR(0xe9c34f),HEXCOLOR(0xe6d733),
                                   HEXCOLOR(0xf8d423),HEXCOLOR(0xe2ec3c),
                                   HEXCOLOR(0x30cb9a),HEXCOLOR(0x82d273),
                                   HEXCOLOR(0x2adbbd),HEXCOLOR(0x19c5b5),
                                   HEXCOLOR(0x4baef3)];
    NSArray * downColorArray = @[HEXCOLOR(0xf3735a),HEXCOLOR(0xf14ea9),
                                 HEXCOLOR(0xf3735a),HEXCOLOR(0xffcf53),
                                 HEXCOLOR(0xfa814c),HEXCOLOR(0xf7a20a),
                                 HEXCOLOR(0xf7e568),HEXCOLOR(0xf6e232),
                                 HEXCOLOR(0xf6e12f),HEXCOLOR(0xe0f956),
                                 HEXCOLOR(0x1bcfae),HEXCOLOR(0x92d975),
                                 HEXCOLOR(0x05ec9d),HEXCOLOR(0x1acfaf),
                                 HEXCOLOR(0x69bdf4)];
    self.upColorArray = upColorArray;
    self.middleColorArray = middleColorArray;
    self.downColorArray = downColorArray;
    
}

//- (NSMutableArray *)allColors {
//    if (!_allColors) {
//        _allColors = [NSMutableArray array];
//    }
//    return _allColors;
//}

//- (NSArray *)colors1 {
//    if (_colors1.count == 0) {
//        _colors1 = [NSArray arrayWithObjects:
//                    (__bridge id)[[UIColor colorWithRed:1.000 green:0.679 blue:0.650 alpha:1.000] CGColor],
//                    (__bridge id)[[UIColor colorWithRed:1.000 green:0.398 blue:0.362 alpha:1.000] CGColor],
//                    (__bridge id)[[UIColor colorWithRed:1.000 green:0.276 blue:0.294 alpha:1.000] CGColor], nil];
//    }
//    return _colors1;
//}
//
//- (NSArray *)colors2 {
//    if (_colors2.count == 0) {
//        _colors2 = [NSArray arrayWithObjects:
//                    (__bridge id)[[UIColor colorWithRed:1.000 green:0.843 blue:0.681 alpha:1.000] CGColor],
//                    (__bridge id)[[UIColor colorWithRed:1.000 green:0.686 blue:0.383 alpha:1.000] CGColor],
//                    (__bridge id)[[UIColor colorWithRed:1.000 green:0.620 blue:0.066 alpha:1.000] CGColor], nil];
//    }
//    return _colors2;
//}
//
//- (NSArray *)colors3 {
//    if (_colors3.count == 0) {
//        _colors3 = [NSArray arrayWithObjects:
//                    (__bridge id)[[UIColor colorWithRed:0.672 green:1.000 blue:0.652 alpha:1.000] CGColor],
//                    (__bridge id)[[UIColor colorWithRed:0.450 green:1.000 blue:0.406 alpha:1.000] CGColor],
//                    (__bridge id)[[UIColor colorWithRed:0.139 green:1.000 blue:0.111 alpha:1.000] CGColor], nil];
//    }
//    return _colors3;
//}
//
//- (NSArray *)colors4 {
//    if (_colors4.count == 0) {
//        _colors4 = [NSArray arrayWithObjects:
//                    (__bridge id)[[UIColor colorWithRed:0.664 green:0.693 blue:1.000 alpha:1.000] CGColor],
//                    (__bridge id)[[UIColor colorWithRed:0.517 green:0.541 blue:1.000 alpha:1.000] CGColor],
//                    (__bridge id)[[UIColor colorWithRed:0.259 green:0.304 blue:1.000 alpha:1.000] CGColor], nil];
//    }
//    return _colors4;
//}

- (CAGradientLayer *)gradientLayer {
    
    if (_gradientLayer == nil) {
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        UIColor *upColor = self.upColorArray[0];
        UIColor *middleColor = self.middleColorArray[0];
        UIColor *downColor = self.downColorArray[0];
        gradientLayer.colors = [NSArray arrayWithObjects:
                                (__bridge id)[downColor CGColor],
                                (__bridge id)[middleColor CGColor],
                                (__bridge id)[upColor CGColor],nil];
        [gradientLayer setLocations:@[@0.3, @0.7, @1 ]];
        [gradientLayer setStartPoint:CGPointMake(0.5, 1)];
        [gradientLayer setEndPoint:CGPointMake(0.5, 0)];
        _gradientLayer = gradientLayer;
    }
    return _gradientLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //        self.allColors = [NSMutableArray arrayWithArray:@[self.colors1,self.colors2,self.colors3,self.colors4]];
        [self setupColors];
        [self.layer addSublayer:self.gradientLayer];
        
    }
    return self;
}

#pragma mark - set

//- (void)setPercent:(CGFloat)percent {
//    _percent = percent;
//    self.bgCount = percent / kPurePercent + 1;//个数不能超出colors的个数
//    self.totalAnimationTime = kTimerInterval * percent;
//    NSTimeInterval time = self.totalAnimationTime / self.bgCount;
//
//    self.bgTimer = [NSTimer timerWithTimeInterval:time
//                                              target:self
//                                            selector:@selector(bgAnimation)
//                                            userInfo:nil
//                                             repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:_bgTimer forMode:NSRunLoopCommonModes];
//}

- (void)setUpBackGroundColorWithColorArrayIndex:(NSInteger)index {
    UIColor *upColor = self.upColorArray[index];
    UIColor *middleColor = self.middleColorArray[index];
    UIColor *downColor = self.downColorArray[index];
    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (__bridge id)[downColor CGColor],
                             (__bridge id)[middleColor CGColor],
                             (__bridge id)[upColor CGColor],nil];
    [self setNeedsLayout];
}

//- (void)bgAnimation {
//
//    if (self.bgCount > self.allColors.count) {
//        NSLog(@"颜色数组错误");
//        [self.bgTimer invalidate];
//        return;
//    }
//
//    _changeCount++;
//    if (_changeCount == _bgCount) {
//        _changeCount = 0;
//        [self.bgTimer invalidate];
//        return;
//    }
//
//    self.gradientLayer.colors = //self.allColors[(self.changeCount)];
//    [self setNeedsLayout];
//}

@end
