# ZLDashboard
仿支付宝仪表盘

自定义View之高仿支付宝芝麻信用分数仪表盘动画效果

![仪表盘动画效果.jpg](https://github.com/ZLFighting/ZLDashboard/blob/master/ZLDashboard/090171AC90DADBC5099B0D5C6DAB22F3.jpg)

> 主要思路:
* 1. 圆环上绿点的旋转
* 2. 分数值及提示语的变化
* 3. 背景色的变化

直接上主要核心代码:

## 一. 自定义ZLDashboardView仪表盘文件:

根据跃动数字, 确定百分比,  现在的跳动数字 ----> 背景颜色变化
.h 文件里公开跃动数字刷新方法:
```
@property (nonatomic, copy) void(^TimerBlock)(NSInteger);

/**
*  跃动数字刷新
*
*/
- (void)refreshJumpNOFromNO:(NSString *)startNO toNO:(NSString *)toNO;
```
.m 文件
1.自定义Lift cycle
```
#pragma mark - Life cycle
- (instancetype)initWithFrame:(CGRect)frame {
self = [super initWithFrame:frame];
if (self) {
self.backgroundColor = [UIColor clearColor];
self.circelRadius = self.frame.size.width - 10.f;
self.lineWidth = 2.f;
self.startAngle = -200.f;
self.endAngle = 20.f;
// 尺寸需根据图片进行调整
self.bgImageView.frame = CGRectMake(6, 6, self.circelRadius, self.circelRadius * 2 / 3);          self.bgImageView.backgroundColor = [UIColor clearColor];
[self addSubview:self.bgImageView];
// 添加圆框
[self setupCircleBg];
// 光标
[self setupMarkerImageView];
// 添加跃动数字 及 提示语
[self setupJumpNOView];
}
return self;
}
```
2.添加圆框
```
- (void)setupCircleBg {
// 圆形路径
UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width / 2, self.height / 2)
radius:(self.circelRadius - self.lineWidth) / 2
startAngle:degreesToRadians(self.startAngle)
endAngle:degreesToRadians(self.endAngle)
clockwise:YES];
// 底色
self.bottomLayer = [CAShapeLayer layer];
self.bottomLayer.frame = self.bounds;
self.bottomLayer.fillColor = [[UIColor clearColor] CGColor];
self.bottomLayer.strokeColor = [[UIColor  colorWithRed:206.f / 256.f green:241.f / 256.f blue:227.f alpha:1.f] CGColor];
self.bottomLayer.opacity = 0.5;
self.bottomLayer.lineCap = kCALineCapRound;
self.bottomLayer.lineWidth = self.lineWidth;
self.bottomLayer.path = [path CGPath];
[self.layer addSublayer:self.bottomLayer];
// 240 是用整个弧度的角度之和 |-200| + 20 = 220
//    [self createAnimationWithStartAngle:degreesToRadians(self.startAngle)
//                               endAngle:degreesToRadians(self.startAngle + 220 * 1)];
}
```
3.设置光标
```
- (void)setupMarkerImageView {
if (_markerImageView) {
return;
}
_markerImageView = [[UIImageView alloc] init];
_markerImageView.backgroundColor = [UIColor clearColor];
_markerImageView.layer.backgroundColor = [UIColor greenColor].CGColor;
_markerImageView.layer.shadowColor = [UIColor whiteColor].CGColor;
_markerImageView.layer.shadowOffset = CGSizeMake(0, 0);
_markerImageView.layer.shadowRadius = kMarkerRadius*0.5;
_markerImageView.layer.shadowOpacity = 1;
_markerImageView.layer.masksToBounds = NO;
self.markerImageView.layer.cornerRadius = self.markerImageView.frame.size.height / 2;
[self addSubview:self.markerImageView];
_markerImageView.frame = CGRectMake(-100, self.height, kMarkerRadius, kMarkerRadius);
}
```
4.添加跳跃文字及提示语
```
- (void)setupJumpNOView {
if (_showLable) {
return;
}
CGFloat width = self.circelRadius / 2 + 50;
CGFloat height = self.circelRadius / 2 - 50;
CGFloat xPixel = self.bgImageView.left + (self.bgImageView.width - width)*0.5;//self.circelRadius / 4;
CGFloat yPixel = self.circelRadius / 4;
CGRect labelFrame = CGRectMake(xPixel, yPixel, width, height);
_showLable = [[UILabel alloc] initWithFrame:labelFrame];
_showLable.backgroundColor = [UIColor clearColor];
_showLable.textColor = [UIColor greenColor];
_showLable.textAlignment = NSTextAlignmentCenter;
_showLable.font = [UIFont systemFontOfSize:100.f];
_showLable.text = [NSString stringWithFormat:@"%ld",jumpCurrentNO];
[self addSubview:_showLable];    // 提示语
_markedLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPixel, CGRectGetMaxY(_showLable.frame), width, 30)];
_markedLabel.backgroundColor = [UIColor clearColor];
_markedLabel.textColor = [UIColor greenColor];
_markedLabel.textAlignment = NSTextAlignmentCenter;
_markedLabel.font = [UIFont systemFontOfSize:20.f];
_markedLabel.text = @"营养良好";
[self addSubview:_markedLabel];
}
```
5.动画相关
```
#pragma mark - Animation
- (void)createAnimationWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle { // 光标动画

//启动定时器
[_fastTimer setFireDate:[NSDate distantPast]];    // 设置动画属性
CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
pathAnimation.calculationMode = kCAAnimationPaced;
pathAnimation.fillMode = kCAFillModeForwards;
pathAnimation.removedOnCompletion = NO;
pathAnimation.duration = _percent * kTimerInterval;
pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
pathAnimation.repeatCount = 1;    // 设置动画路径
CGMutablePathRef path = CGPathCreateMutable();    CGPathAddArc(path, NULL, self.width / 2, self.height / 2, (self.circelRadius - kMarkerRadius / 2) / 2, startAngle, endAngle, 0);
pathAnimation.path = path;    CGPathRelease(path);

[self.markerImageView.layer addAnimation:pathAnimation forKey:@"moveMarker"];

}
```
6.开始动画,确定百分比
```
- (void)refreshJumpNOFromNO:(NSString *)startNO toNO:(NSString *)toNO {

beginNO = 0;//[startNO integerValue];
jumpCurrentNO = 0;//[startNO integerValue];
endNO = [toNO integerValue];
_percent = endNO * 100 / MaxNumber;
NSInteger diffNum = endNO - beginNO;
if (diffNum <= 0) {
return;
}    if (diffNum < 100) {
_intervalNum = 5;
} else if (diffNum < 300) {
_intervalNum = 15;
} else if (diffNum <= MaxNumber) {
_intervalNum = 10;
}
NSLog(@"数字间隔：%ld",_intervalNum);
//数字
[self setupJumpThings];
// 设置角度
NSInteger angle = 0;
NSInteger num = [toNO floatValue] - [startNO floatValue];
if (num < 200) {
angle = self.startAngle + 220 * (num / 200.0) / 5.0;
} else if (num < 350) {
angle = self.startAngle + 220 / 5.0 + (3 / 5.0 * 220) * (num - 200) / 150.0;
} else {
angle = self.startAngle + 220 / 5.0 * 4 + (220 / 5.0) * (num - 350) / 250.0;
}
//光标
[self createAnimationWithStartAngle:degreesToRadians(self.startAngle)
endAngle:degreesToRadians(angle)];
}

- (void)setBgImage:(UIImage *)bgImage {

_bgImage = bgImage;    self.bgImageView.image = bgImage;
}

- (UIImageView *)bgImageView {    if (nil == _bgImageView) {
_bgImageView = [[UIImageView alloc] init];
}    return _bgImageView;
}
```
7.跃动数字
```
- (void)setupJumpThings {

animationTime = _percent * kTimerInterval;
self.fastTimer = [NSTimer timerWithTimeInterval:kTimerInterval*kFastProportion
target:self
selector:@selector(fastTimerAction)
userInfo:nil
repeats:YES];
[[NSRunLoop currentRunLoop] addTimer:_fastTimer forMode:NSRunLoopCommonModes];
//时间间隔 = （总时间 - 快时间间隔*变化次数）/ 再次需要变化的次数
//快时间
NSInteger fastEndNO = endNO * kFastProportion;
NSInteger fastJump = fastEndNO/_intervalNum;
if (fastJump % _intervalNum) {
fastJump++;
fastEndNO += _intervalNum;
}
CGFloat fastTTime = fastJump*kTimerInterval*kFastProportion;
//剩余应跳动次数
NSInteger changNO = endNO - fastEndNO;
NSInteger endJump = changNO / _intervalNum + changNO % _intervalNum;
//慢时间间隔
NSTimeInterval slowInterval = (animationTime - fastTTime) / endJump;
self.slowTimer = [NSTimer timerWithTimeInterval:slowInterval
target:self
selector:@selector(slowTimerAction)
userInfo:nil
repeats:YES];
[[NSRunLoop currentRunLoop] addTimer:_slowTimer forMode:NSRunLoopCommonModes];
[_fastTimer setFireDate:[NSDate distantFuture]];
[_slowTimer setFireDate:[NSDate distantFuture]];
}
```
8.定时器触发事件
```
#pragma mark 加速定时器触发事件
- (void)fastTimerAction {
if (jumpCurrentNO >= endNO) {
[self.fastTimer invalidate];
return;
}    if (jumpCurrentNO >= endNO * kFastProportion) {
[self.fastTimer invalidate];
[self.slowTimer setFireDate:[NSDate distantPast]];
return;
}
[self commonTimerAction];
}
#pragma mark 减速定时器触发事件
- (void)slowTimerAction {
if (jumpCurrentNO >= endNO) {
[self.slowTimer invalidate];
return;
}
[self commonTimerAction];
}

#pragma mark 计时器共性事件 - lable赋值 背景颜色及提示语变化
- (void)commonTimerAction {
if (jumpCurrentNO % 100 == 0 && jumpCurrentNO != 0) {
NSInteger colorIndex = jumpCurrentNO / 100;
dispatch_async(dispatch_get_main_queue(), ^{
if (self.TimerBlock) {
self.TimerBlock(colorIndex);
}
});
}
NSInteger changeValueBy = endNO - jumpCurrentNO;
if (changeValueBy/10 < 1) {
jumpCurrentNO++;
} else {
//        NSInteger changeBy = changeValueBy / 10;
jumpCurrentNO += _intervalNum;
}

_showLable.text = [NSString stringWithFormat:@"%ld",jumpCurrentNO];
if (jumpCurrentNO < 350) {
_markedLabel.text = @"营养太差";
} else if (jumpCurrentNO <= 550) {
_markedLabel.text = @"营养较差";
} else if (jumpCurrentNO <= 600) {
_markedLabel.text = @"营养中等";
} else if (jumpCurrentNO <= 650) {
_markedLabel.text = @"营养良好";
} else if (jumpCurrentNO <= 700) {
_markedLabel.text = @"营养优秀";
} else if (jumpCurrentNO <= 950) {
_markedLabel.text = @"营养较好";
}
}
```

## 二. 在所需的当前控制器里展示:

1.创建背景色
```
- (void)setupGradientView {
self.gradientView = [[ZLGradientView alloc] initWithFrame:self.view.bounds];
[self.view addSubview:self.gradientView];
}
```
2.创建仪表盘

```
- (void)setupCircleView {
self.dashboardView = [[ZLDashboardView alloc] initWithFrame:CGRectMake(40.f, 70.f, SCREEN_WIDTH - 80.f, SCREEN_WIDTH - 80.f)];
self.dashboardView.bgImage = [UIImage imageNamed:@"backgroundImage"];
[self.view addSubview:self.dashboardView];
}
```
3.添加触发动画的点击按钮
```
- (void)addActionButton {
UIButton *stareButton = [UIButton buttonWithType:UIButtonTypeCustom];
stareButton.frame = CGRectMake(10.f, self.dashboardView.bottom + 50.f, SCREEN_WIDTH - 20.f, 38.f);
[stareButton addTarget:self action:@selector(onStareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
[stareButton setTitle:@"Start Animation" forState:UIControlStateNormal];
[stareButton setBackgroundColor:[UIColor lightGrayColor]];
stareButton.layer.masksToBounds = YES;
stareButton.layer.cornerRadius = 4.f;
[self.view addSubview:stareButton];

_clickBtn = stareButton;
}
```
4.改变 Value
```
- (void)addSlideChnageValue {
CGFloat width = 280;
CGFloat height = 40;
CGFloat xPixel = (SCREEN_WIDTH - width) * 0.5;
CGFloat yPixel = CGRectGetMaxY(_clickBtn.frame) + 20;
CGRect slideFrame = CGRectMake(xPixel, yPixel, width, height);
UISlider *slider = [[UISlider alloc] initWithFrame:slideFrame];

slider.minimumValue = MinNumber;
slider.maximumValue = MaxNumber;

slider.minimumTrackTintColor = [UIColor colorWithRed:0.000 green:1.000 blue:0.502 alpha:1.000];
slider.maximumTrackTintColor = [UIColor colorWithWhite:0.800 alpha:1.000];    /**
*  注意这个属性：如果你没有设置滑块的图片，那个这个属性将只会改变已划过一段线条的颜色，不会改变滑块的颜色，如果你设置了滑块的图片，又设置了这个属性，那么滑块的图片将不显示，滑块的颜色会改变（IOS7）
*/
[slider setThumbImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
slider.thumbTintColor = [UIColor cyanColor];


[slider setValue:0.5 animated:YES];

[slider addTarget:self action:@selector(slideTap:)forControlEvents:UIControlEventValueChanged];

[self.view addSubview:slider];

_slider = slider;
}
```
```
- (void)slideTap:(UISlider *)sender {
CGFloat value = sender.value;
NSLog(@"%.f",value);
}

- (void)setupGradientView {
self.gradientView = [[ZLGradientView alloc] initWithFrame:self.view.bounds];
[self.view addSubview:self.gradientView];
}
- (void)setupCircleView {
self.dashboardView = [[ZLDashboardView alloc] initWithFrame:CGRectMake(40.f, 70.f, SCREEN_WIDTH - 80.f, SCREEN_WIDTH - 80.f)];
self.dashboardView.bgImage = [UIImage imageNamed:@"backgroundImage"];
[self.view addSubview:self.dashboardView];
}

- (void)onStareButtonClick:(UIButton *)sender {
if (sender.selected) {
[self.gradientView removeFromSuperview];
self.gradientView = nil;
[self.dashboardView removeFromSuperview];
self.dashboardView = nil;

[self setupGradientView];
[self setupCircleView];

[self.view bringSubviewToFront:self.clickBtn];
[self.view bringSubviewToFront:_slider];
}
sender.selected = YES;
CGFloat value = _slider.value;
NSString *startNO = [NSString stringWithFormat:@"%d", MinNumber];
NSString *toNO = [NSString stringWithFormat:@"%.f",value];//@"693"; 950
NSLog(@"endNO:%@",toNO);
[self.dashboardView refreshJumpNOFromNO:startNO toNO:toNO];

__block typeof(self)blockSelf = self;    self.dashboardView.TimerBlock = ^(NSInteger index) {
[blockSelf.gradientView setUpBackGroundColorWithColorArrayIndex:index];
};
}
```
界面性问题可以根据自己项目需求调整即可, 具体可参考代码, Demo能够直接运行!


您的支持是作为程序媛的我最大的动力, 如果觉得对你有帮助请送个Star吧,谢谢啦

