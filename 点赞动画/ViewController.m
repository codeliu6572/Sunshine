//
//  ViewController.m
//  发光的太阳
//
//  Created by 刘浩浩 on 16/8/25.
//  Copyright © 2016年 CodingFire. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 100, 100);
    btn.center = self.view.center;
    btn.layer.cornerRadius = 50;
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(good:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    imageView.image = [self circleImageSomeAngle:[UIImage imageNamed:@"zbar.jpg"]];
    [self.view addSubview:imageView];
}

- (void)good:(UIButton *)btn
{
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    //发射器得尺寸大小
    [emitterLayer setEmitterSize:CGSizeMake(CGRectGetWidth(btn.frame), CGRectGetHeight(btn.frame))];
    //发射器的中心
    emitterLayer.emitterPosition = CGPointMake(btn.bounds.size.width / 2, btn.bounds.size.height / 2);
    //从发射器边缘发出
    emitterLayer.emitterMode = kCAEmitterLayerOutline;
    //发射器形状，圆，粒子在圆形范围发射
    emitterLayer.emitterShape = kCAEmitterLayerCircle;
    [btn.layer addSublayer:emitterLayer];
    
    CAEmitterCell *emitterCell = [[CAEmitterCell alloc]init];
    //设置一个关键字来查找这个对象
    [emitterCell setName:@"sunShine"];
    //设置内容
    emitterCell.contents = (__bridge id _Nullable)([self creatImage].CGImage);
    //设置出生率
    emitterCell.birthRate = 0;
    //设置生命周期
    emitterCell.lifetime = 0.4;
    //设置变透明的速度
    emitterCell.alphaSpeed = -2;
    //设置速率
    emitterCell.velocity = 200;
    //设置速率容差
    emitterCell.velocityRange = 200;
    //粒子单元数组，用来放发射粒子
    emitterLayer.emitterCells = @[emitterCell];
    
    
    CABasicAnimation *emitterBasic = [CABasicAnimation animationWithKeyPath:@"emitterCells.sunShine.birthRate"];
    //通过基础动画设置出生率，从有到无
    emitterBasic.fromValue = [NSNumber numberWithFloat:100000];
    emitterBasic.toValue = [NSNumber numberWithFloat:0];
    //因为存在生命周期，所以持续时间可以不给
    emitterBasic.duration = 0;
    //设置向外加速
    emitterBasic.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [emitterLayer addAnimation:emitterBasic forKey:@"good"];
    
}
//自己来画一张纯色图片
- (UIImage *)creatImage
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef text = UIGraphicsGetCurrentContext();
    //设置填充色
    CGContextSetFillColorWithColor(text, [UIColor yellowColor].CGColor);
    //设置填充区域
    CGContextFillRect(text, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [self circleImage:image];
    
}

//给图片变圆的高效方法
- (UIImage *)circleImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef text = UIGraphicsGetCurrentContext();
    //设置边线宽
    CGContextSetLineWidth(text, 1);
    //设置边线条颜色
    CGContextSetStrokeColorWithColor(text, [UIColor blackColor].CGColor);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    //画一个圆
    CGContextAddArc(text, image.size.width / 2, image.size.height / 2, image.size.width / 2, 0, M_PI * 2, NO);
    //截取圆的部分
    CGContextClip(text);
    //在圆区域上画图
    CGContextDrawImage(text, rect, image.CGImage);
    UIImage *circlrImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return circlrImage;
    
}
//给图片加圆角的高效方法,同时还能设定具体哪个角是圆角

- (UIImage *)circleImageSomeAngle:(UIImage *)image
{
    //第二个参数为透明与否，第三个参数设置分辨率和屏幕一样
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
    CGContextRef text = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(50, 50)];
    CGContextAddPath(text, maskPath.CGPath);
    CGContextClip(text);
    
    //下面注视的方法和CGContextDrawImage都可以，具体区别有知道的可以发表在评论处
//    [image drawInRect:rect];
//    CGContextDrawPath(text, kCGPathFillStroke);
    
    CGContextDrawImage(text, rect, image.CGImage);
    
    UIImage *circlrImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return circlrImage;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
