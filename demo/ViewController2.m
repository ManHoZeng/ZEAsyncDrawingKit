//
//  ViewController2.m
//  demo
//
//  Created by Apple on 2017/3/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ViewController2.h"
#import "ZEButton.h"
@interface ViewController2 ()

@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UITextField * tf = [[UITextField alloc]initWithFrame:CGRectMake(50, 150, 150, 30)];
//    tf.backgroundColor = [UIColor redColor];
//
//    tf.inputView = [[UIView alloc]initWithFrame:CGRectZero];
//    [self.view addSubview:tf];
    

    // Do any additional setup after loading the view from its nib.
}


-(void)noralmalbtn{
    
    for (NSInteger i = 0; i < 40; i ++) {
        
        UIButton * btn1 = [[UIButton alloc]initWithFrame:CGRectMake(i * 70, 100, 67, 67)];
        
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [btn1 setTitle:@"12" forState:UIControlStateNormal];
        
        [btn1 setBackgroundImage:[UIImage imageNamed:@"键盘按键"] forState:UIControlStateNormal];
        
//        [btn1 addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn1];
        
    }
    
    
}

-(void)asyncbtn{
    
    
    
    for (NSInteger i = 0; i < 40; i ++) {
        
        ZEButton * btn1 = [[ZEButton alloc]initWithFrame:CGRectMake(i * 70, 100, 67, 67)];
        
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [btn1 setTitle:@"12" forState:UIControlStateNormal];
        
        [btn1 setBackgroundImage:[UIImage imageNamed:@"键盘按键"] forState:UIControlStateNormal];
        
        //        [btn1 addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn1];
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.imageview.image = nil;
    NSLog(@"vc2被释放");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
