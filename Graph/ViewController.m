//
//  ViewController.m
//  Graph
//
//  Created by zzqtkj on 2021/11/7.
//

#import "ViewController.h"
#import "BezierCurveView.h"

#define SCREEN_W  [UIScreen mainScreen].bounds.size.width
#define SCREEN_H  [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
@property (strong,nonatomic)BezierCurveView *bezierView;
@property (strong,nonatomic)NSMutableArray *x_names;
@property (strong,nonatomic)NSMutableArray *targets;
@property (strong,nonatomic)NSMutableArray *targets2;
@end

@implementation ViewController

/**
 *  X轴值
 */
-(NSMutableArray *)x_names{
    if (!_x_names) {
        _x_names = [NSMutableArray arrayWithArray:@[@"5月",@"12月",@"22月",@"36月"]];
    }
    return _x_names;
}

/**
 *  Y轴值
 */
-(NSMutableArray *)targets{
    if (!_targets) {
        _targets = [NSMutableArray arrayWithArray:@[@2,@4.5,@8,@6.5]];
    }
    return _targets;
}

-(NSMutableArray *)targets2{
    if (!_targets2) {
        _targets2 = [NSMutableArray arrayWithArray:@[@1,@6,@10]];
    }
    return _targets2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.初始化
    _bezierView = [BezierCurveView initWithFrame:CGRectMake(0, 0, SCREEN_W - 0, 280)];
    _bezierView.center = self.view.center;
    [self.view addSubview:_bezierView];
    
    [self drawLineChart];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self drawLineChart];
//}

//画折线图
- (void)drawLineChart {
    //曲线
    [_bezierView drawLineChartViewWithX_Value_Names:self.x_names TargetValues:self.targets LineType:LineType_Curve];
    
    [_bezierView drawLineChartViewWithX_Value_Names:self.x_names TargetValues:self.targets2 LineType:LineType_Curve];
}

@end
