//
//  BezierCurveView.h
//  Graph
//
//  Created by zzqtkj on 2021/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define MARGIN            30   // 坐标轴与画布间距
#define Y_EVERY_MARGIN    40   // y轴每一个值的间隔数

// 颜色RGB
#define XYQColor(r, g, b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 线条类型
typedef NS_ENUM(NSInteger, LineType) {
    LineType_Straight, // 折线
    LineType_Curve     // 曲线
};

@interface BezierCurveView : UIView
//初始化画布
+ (instancetype)initWithFrame:(CGRect)frame;

/**
 *  画折线图
 *  @param x_names      x轴值的所有值名称
 *  @param targetValues 所有目标值
 *  @param lineType     直线类型
 */
- (void)drawLineChartViewWithX_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues LineType:(LineType) lineType;
@end

NS_ASSUME_NONNULL_END
