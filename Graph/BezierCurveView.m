//
//  BezierCurveView.m
//  Graph
//
//  Created by zzqtkj on 2021/11/8.
//

#import "BezierCurveView.h"

static CGRect myFrame;

@interface BezierCurveView ()

@end

@implementation BezierCurveView

//初始化画布
+ (instancetype)initWithFrame:(CGRect)frame{
    
    BezierCurveView *bezierCurveView = [[BezierCurveView alloc] init];
    bezierCurveView.frame = frame;
    
    //背景视图
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    backView.backgroundColor = XYQColor(255, 229, 239);
    [bezierCurveView addSubview:backView];
    
    myFrame = frame;
    return bezierCurveView;
}

- (void)drawLineChartViewWithX_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues LineType:(LineType) lineType {
    
    //1.画坐标轴
    [self drawXYLine:x_names];
    
    CGFloat x_width = (CGRectGetWidth(myFrame) - 3*MARGIN) / x_names.count;
    
    //2.获取目标值点坐标
    NSMutableArray *allPoints = [NSMutableArray array];
    for (int i=0; i<targetValues.count; i++) {
        CGFloat doubleValue = 20*[targetValues[i] floatValue]; //目标值放大两倍
        CGFloat X = 2*MARGIN + x_width*(i+1);
        CGFloat Y = CGRectGetHeight(myFrame)-MARGIN-doubleValue;
        CGPoint point = CGPointMake(X,Y);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x-1, point.y-1, 2.5, 2.5) cornerRadius:2.5];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.strokeColor = [UIColor purpleColor].CGColor;
        layer.fillColor = [UIColor purpleColor].CGColor;
        layer.path = path.CGPath;
        [self.subviews[0].layer addSublayer:layer];
        [allPoints addObject:[NSValue valueWithCGPoint:point]];
    }
    
    //3.坐标连线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:[allPoints[0] CGPointValue]];
    CGPoint PrePonit;
    switch (lineType) {
        case LineType_Straight: //直线
            for (int i =1; i<allPoints.count; i++) {
                CGPoint point = [allPoints[i] CGPointValue];
                [path addLineToPoint:point];
            }
            break;
        case LineType_Curve:   //曲线
            for (int i =0; i<allPoints.count; i++) {
                if (i==0) {
                    PrePonit = [allPoints[0] CGPointValue];
                }else{
                    CGPoint NowPoint = [allPoints[i] CGPointValue];
                    [path addCurveToPoint:NowPoint controlPoint1:CGPointMake((PrePonit.x+NowPoint.x)/2, PrePonit.y) controlPoint2:CGPointMake((PrePonit.x+NowPoint.x)/2, NowPoint.y)]; //三次曲线
                    PrePonit = NowPoint;
                }
            }
            break;
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 2.0;
    [self.subviews[0].layer addSublayer:shapeLayer];
    
    //4.添加目标值文字
    for (int i =0; i<allPoints.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor purpleColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [self.subviews[0] addSubview:label];

        if (i==0) {
            CGPoint NowPoint = [allPoints[0] CGPointValue];
            //label.text = [NSString stringWithFormat:@"%.0lf",(CGRectGetHeight(myFrame)-NowPoint.y-MARGIN)/2];
            label.text = [NSString stringWithFormat:@"%@",targetValues[i]];
            label.frame = CGRectMake(NowPoint.x-MARGIN/2, NowPoint.y-20, MARGIN, 20);
            PrePonit = NowPoint;
        }
        else {
            CGPoint NowPoint = [allPoints[i] CGPointValue];
            if (NowPoint.y<PrePonit.y) {  //文字置于点上方
                label.frame = CGRectMake(NowPoint.x-MARGIN/2, NowPoint.y-20, MARGIN, 20);
            }else{ //文字置于点下方
                label.frame = CGRectMake(NowPoint.x-MARGIN/2, NowPoint.y, MARGIN, 20);
            }
            //label.text = [NSString stringWithFormat:@"%.0lf",(CGRectGetHeight(myFrame)-NowPoint.y-MARGIN)/2];
            label.text = [NSString stringWithFormat:@"%@",targetValues[i]];
            PrePonit = NowPoint;
        }
    }
    
}

/**
 *  画坐标轴
 */
- (void)drawXYLine:(NSMutableArray *)x_names {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //1.Y轴、X轴的直线
    [path moveToPoint:CGPointMake(MARGIN + MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN + MARGIN, CGRectGetHeight(myFrame) - MARGIN - 5*Y_EVERY_MARGIN)];
    
    [path moveToPoint:CGPointMake(MARGIN + MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
    //[path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame)-MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame)-10, CGRectGetHeight(myFrame)-MARGIN)];
    
//    //2.添加箭头
//    [path moveToPoint:CGPointMake(MARGIN, MARGIN)];
//    [path addLineToPoint:CGPointMake(MARGIN-5, MARGIN+5)];
//    [path moveToPoint:CGPointMake(MARGIN, MARGIN)];
//    [path addLineToPoint:CGPointMake(MARGIN+5, MARGIN+5)];
//
//    [path moveToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
//    [path addLineToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN-5, CGRectGetHeight(myFrame)-MARGIN-5)];
//    [path moveToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
//    [path addLineToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN-5, CGRectGetHeight(myFrame)-MARGIN+5)];

    //3.添加索引格
    //X轴
    CGFloat x_width = (CGRectGetWidth(myFrame) - 3*MARGIN) / x_names.count;
    for (int i=0; i<x_names.count; i++) {
        CGFloat X = 2*MARGIN + x_width*(i+1);
        CGPoint point = CGPointMake(X,CGRectGetHeight(myFrame)-MARGIN);
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(point.x, point.y-3)];
    }
    //Y轴（实际长度为200,此处比例缩小一倍使用）
    for (int i=0; i<5; i++) {
        CGFloat Y = CGRectGetHeight(myFrame)-MARGIN-Y_EVERY_MARGIN*(i + 1);
        CGPoint point = CGPointMake(2*MARGIN,Y);
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(point.x+3, point.y)];
    }
    
    //5.添加Y轴渐变色
    UIView *colorView = [[UIView alloc] init];
    CGFloat color_width = 10;
    CGFloat color_height = 5 * Y_EVERY_MARGIN;
    CGFloat x = 2*MARGIN - 2*color_width;
    CGFloat y = CGRectGetHeight(myFrame) - MARGIN - 5 * Y_EVERY_MARGIN;
    colorView.frame = CGRectMake(x, y, color_width, color_height);
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = colorView.bounds;
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor clearColor].CGColor];
    //gradientLayer.locations = @[@0.8,@1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    [colorView.layer addSublayer:gradientLayer];
    [self.subviews[0] addSubview:colorView];
    
    //4.添加索引格文字
    //X轴
    for (int i=0; i<x_names.count; i++) {
        CGFloat X = 2*MARGIN + x_width + x_width*i - (MARGIN / 2);
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(X, CGRectGetHeight(myFrame)-MARGIN, MARGIN, 20)];
        textLabel.text = x_names[i];
        textLabel.font = [UIFont systemFontOfSize:10];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor blackColor];
        [self addSubview:textLabel];
    }
    //Y轴
    for (int i=0; i<6; i++) {
        CGFloat Y = CGRectGetHeight(myFrame)-MARGIN-Y_EVERY_MARGIN*i;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, Y-5, MARGIN, 10)];
        textLabel.text = [NSString stringWithFormat:@"%d",2*i];
        textLabel.font = [UIFont systemFontOfSize:10];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor blackColor];
        [self addSubview:textLabel];
    }

    //5.渲染路径
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 2.0;
    [self.subviews[0].layer addSublayer:shapeLayer];
}

@end
