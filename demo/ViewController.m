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
    
    [self.view addSubview:btn1];
    
}





- (IBAction)fff:(id)sender {
    
    ViewController2 * vc = [[ViewController2 alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)nextpage{
    ViewController2 * vc = [[ViewController2 alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
