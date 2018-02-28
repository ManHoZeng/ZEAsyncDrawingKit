//
//  AppDelegate.m
//  demo
//
//  Created by Apple on 2017/3/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "YYFPSLabel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self.window makeKeyAndVisible];
    
//    NFCNDEFReaderSession *session = [[NFCNDEFReaderSession alloc] initWithDelegate:self queue:dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT) invalidateAfterFirstRead:NO];
//    [session beginSession];
    
    ViewController * vc = [[ViewController alloc]init];

    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];

    self.window.rootViewController = nav;
    
    YYFPSLabel * fps = [[YYFPSLabel alloc] initWithFrame:CGRectMake(0, 20, 100, 60)];

    [fps sizeToFit];

    fps.alpha = 1;
    [self.window.rootViewController.view addSubview:fps];

    [self.window.rootViewController.view bringSubviewToFront:fps];
//
    return YES;
}


//- (void)readerSessionDidBecomeActive:(NFCReaderSession *)session
//{
//    NSLog(@"%@",session);
//}
//
//- (void) readerSession:(nonnull NFCNDEFReaderSession *)session didDetectNDEFs:(nonnull NSArray *)messages {
//    
//    for (NFCNDEFMessage *message in messages) {
//        for (NFCNDEFPayload *payload in message.records) {
//            NSLog(@"Payload data:%@",payload.payload);
//        }
//    }
//}
//
//- (void)readerSession:(NFCNDEFReaderSession *)session didInvalidateWithError:(NSError *)error
//{
//    NSLog(@"%@  error:%@",session,error);
//}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
