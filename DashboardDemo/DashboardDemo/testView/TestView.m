//
//  TestView.m
//  ShuJuYueTong_iOS
//
//  Created by FuNing on 2021/4/21.
//

#import "TestView.h"
#import "UIView+Extionsiton.h"
#import "UIColor+HexColor.h"

#define DEGREES_TO_RADIANS(angle) ((angle + 90) / 180.0 * M_PI)
@interface TestView ()
@property (nonatomic, strong) UIColor *defaultColor;
@property (nonatomic, strong) UIColor *mainColor;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGPoint myCenter;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) UIView *needleView;

// 数据
@property (nonatomic, strong) UILabel *countNumL;
@property (nonatomic, strong) UILabel *averageL;
@end

@implementation TestView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    _endValue = 0;
//    _value = 0;
    _defaultColor = [UIColor colorWithHex:@"#B6ECCE"];
    _mainColor = [UIColor colorWithHex:@"#0DBF5C"];
    _myCenter = CGPointMake(self.size.width/2,self.size.width/2);

    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateDashboard:)];
    
    
    // 画箭头
    [self drawNeedle];
    
    // 画中间数据
    [self drawCenterView];
 
}
-(void)animateDashboard:(CADisplayLink *)sender{
    if(_endValue <= self.value){// 到达终点值，停止动画
        self.value = _endValue;
        [self.displayLink invalidate];
        
    }else{
        CGFloat speed = _endValue/1.5;
        CGFloat detalValue = sender.duration * speed;
        self.value += detalValue;
        [self setNeedsDisplay];
        _needleView.transform= CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(90 + 45) + DEGREES_TO_RADIANS(180) * _value);
    }
}

-(void)drawRect:(CGRect)rect{
    
    CGFloat startDegree = 45;
    CGFloat endDegree = 315;
    
    // 画刻度
    CGFloat radius = self.size.width/2 - 20;
    UIColor *color = _defaultColor;
    CGFloat span = endDegree-startDegree;
    CGFloat degree = span*_value;// percent covert to 0-270 degrees.
    for(int i = 0;i<=span;i+=5){// +5是间隔
        
        if( i > degree){
            color = _defaultColor;
        }else{
            color = _mainColor;
        }
        [self drawMarkAt:i+startDegree radius:radius color:color];
        

    }
    
    // 画背景圈
    CGFloat startAngleBag = DEGREES_TO_RADIANS(45);
    CGFloat endAngleBag = DEGREES_TO_RADIANS(315);
    UIBezierPath *pathBag = [UIBezierPath bezierPathWithArcCenter:_myCenter radius:radius - 25 startAngle:startAngleBag endAngle:endAngleBag clockwise:YES];
    pathBag.lineWidth = 15;
    pathBag.lineCapStyle = kCGLineJoinRound;
    [_defaultColor set];
    [pathBag stroke];
    
   // 画进度圈
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:_myCenter radius:radius - 25 startAngle:startAngleBag endAngle:startAngleBag + (endAngleBag - startAngleBag) * _value  clockwise:YES];
    path.lineWidth = 15;
    path.lineCapStyle = kCGLineJoinRound;
    [_mainColor set];
    [path stroke];
   

}

-(void)drawMarkAt:(CGFloat)degree radius:(CGFloat)radius color:(UIColor*)color{
    
//    NSLog(@"%.0f,%@",degree,color);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, _myCenter.x, _myCenter.y);

    CGContextRotateCTM(context, (degree-90) * M_PI / 180);
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(-radius, -0)];
    [bezierPath addLineToPoint: CGPointMake(7-radius, 0)];//长
    bezierPath.lineCapStyle = kCGLineCapRound;
    
    [color setStroke];
    bezierPath.lineWidth = 3;//宽
    [bezierPath stroke];
    
    CGContextRestoreGState(context);

}

// 指针
- (void)drawNeedle {
    CGFloat scaleRadius = self.size.width/2 - 50;
    CGFloat radius = self.size.width/2 - 80;

    CGFloat h = scaleRadius - 10 -2;
    _needleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1,h*2)];
    _needleView.center = _myCenter;
    _needleView.backgroundColor = [UIColor whiteColor];
    _needleView.transform= CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(90 + 45));
    [self addSubview:_needleView];
    
    CAShapeLayer *needle = [CAShapeLayer layer];
    needle.frame = CGRectMake(0, 0, 1, h);
    //画尖角
    UIBezierPath *needlePath = [UIBezierPath bezierPath];
    [needlePath moveToPoint:CGPointMake(0,1)];
    [needlePath addLineToPoint:CGPointMake(0-5,needle.bounds.size.height-radius-10)];
    [needlePath addLineToPoint:CGPointMake(0+5,needle.bounds.size.height-radius-10)];
    [needlePath closePath];
    needle.path = needlePath.CGPath;
    needle.fillColor = _mainColor.CGColor;
    needle.strokeColor = _mainColor.CGColor;
    needle.lineWidth = 3.0;
    [_needleView.layer addSublayer:needle];
    
    CGFloat width = 50;
    CGFloat lineWidth = 8;
    CAShapeLayer *twoNeedle = [CAShapeLayer layer];
    twoNeedle.frame = CGRectMake(0, 0, 1, h*2);
    UIBezierPath *twoneedlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width, h) radius:h-lineWidth - 3 startAngle:DEGREES_TO_RADIANS(180 - width) endAngle:DEGREES_TO_RADIANS(180 + width) clockwise:YES];
    twoNeedle.path = twoneedlePath.CGPath;
    twoNeedle.fillColor = [UIColor clearColor].CGColor;
    twoNeedle.strokeColor = [UIColor yellowColor].CGColor;
    twoNeedle.lineWidth = lineWidth;
    twoNeedle.lineCap = kCALineCapRound;

    [_needleView.layer addSublayer:twoNeedle];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor, (__bridge id)_mainColor.CGColor, (__bridge id)[UIColor whiteColor].CGColor];
    gradientLayer.locations = @[@0.0,  @0.5,@1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(-width, 0, width * 2, h * 2);
    gradientLayer.mask = twoNeedle;
    [_needleView.layer addSublayer:gradientLayer];
    
}

- (void)drawCenterView {
    CGFloat radius = (self.size.width/2 - 80)*2;
    UIView *centerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, radius, radius)];
    centerV.center = _myCenter;
    centerV.layer.cornerRadius = radius/2;
    centerV.clipsToBounds = YES;
    [self addSubview:centerV];
    
    CAGradientLayer *layer = [CAGradientLayer new];
    layer.colors = @[(__bridge id)_defaultColor.CGColor, (__bridge id)[UIColor whiteColor].CGColor];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(0, 1);
    layer.frame = centerV.bounds;
    [centerV.layer addSublayer:layer];
    
    
    _countNumL = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, centerV.width, 50)];
    _countNumL.textAlignment = NSTextAlignmentCenter;
    _countNumL.textColor = _mainColor;
    [centerV addSubview:_countNumL];
    
   
    UILabel *msgL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_countNumL.frame) , centerV.width, 30)];
    msgL.text = @"已结算金额";
    msgL.font = [UIFont systemFontOfSize:17];
    msgL.textAlignment = NSTextAlignmentCenter;
    msgL.textColor = [UIColor colorWithHex:@"#333333"];
    [centerV addSubview:msgL];

    _averageL = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, centerV.width, 50)];
    _averageL.textAlignment = NSTextAlignmentCenter;
    _averageL.textColor = [UIColor colorWithHex:@"#666666"];
    [centerV addSubview:_averageL];
    
}

- (void)setEndValue:(CGFloat)endValue {
    _endValue = endValue;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)setCountNum:(NSString *)countNum {
    _countNum = countNum;
    _countNumL.text = [NSString stringWithFormat:@"%.2f亿",[countNum floatValue]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_countNumL.text];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:35.0 weight:UIFontWeightMedium] range:NSMakeRange(0, str.length - 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium] range:NSMakeRange(str.length - 1, 1)];
    _countNumL.attributedText = str;
}
@end
