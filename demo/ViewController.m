//
//  ViewController.m
//  demo
//
//  Created by Apple on 2017/3/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"
#import "ZEButton.h"
#import "YYKit.h"
#import "ZENormalBarrage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];

    
    ZEButton * btn1 = [[ZEButton alloc]initWithFrame:CGRectMake(70, 100, 67, 67)];
    
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [btn1 setTitle:@"AsyncKit" forState:UIControlStateNormal];
    
    [btn1 setBackgroundImage:[UIImage imageNamed:@"键盘按键"] forState:UIControlStateNormal];
    
    [btn1 setBackgroundImage:[UIImage imageNamed:@"键盘短按键down"] forState:UIControlStateHighlighted];
    
    [btn1 addTarget:self action:@selector(nextpage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
}





- (IBAction)fff:(id)sender {
    
    ViewController2 * vc = [[ViewController2 alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)nextpage{
//    ViewController2 * vc = [[ViewController2 alloc]init];
//
//    [self.navigationController pushViewController:vc animated:YES];
    
    self.title = [NSString stringWithFormat:@"现在有%ld条弹幕",self.view.subviews.count];
    
    ZENormalBarrage * zzz = [[ZENormalBarrage alloc]init];
    [zzz setTextStyle:^(ZEBarrageTextStyle *model) {
        
        
        
        model.text = @"AsyncKit";
        model.textFont = [UIFont systemFontOfSize:15];
    }];
    
    [zzz renderBarrageInView:self.view];
    
    [self performSelector:@selector(nextpage) withObject:nil afterDelay:0.01];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRST获取屏幕 宽度、高度 bounds就是屏幕的全部区域挫折伴我成长，我会以乐观当航标，这样才不会迷失方向。没有了乐观的态度，就会迷失奋斗的方向、丢失一切信念，任理想的帆船在汹涌的挫折波涛里随波逐流、上下颠簸乃至全体覆没。而挫折并不是到了一败涂地的境地，而是俨然警示你不要懒散，要坚持信念，随时以乐观、沉着去乘风破浪。如此我的成长之路哪能离开挫折这个善良严师？";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

@end
