//
//  HXRouteManager.m
//  MVVM+RAC
//
//  Created by Brook on 2020/11/13.
//

#import "HXRouteManager.h"
//视图
#import <UIKit/UIKit.h>
//路由类
#import <JLRoutes/JLRoutes.h>
#import "HXNSViewConfigManager.h"

@implementation HXRouteManager

+(void)load {
    //注册页面路由
    [[JLRoutes routesForScheme:HXRouteScheme] addRoute:@"/*" handler:^BOOL(NSDictionary *parameters) {
        NSArray *pathComponents = parameters[JLRouteWildcardComponentsKey];
        if (pathComponents.count > 0) {
            NSString *pageName = pathComponents[0];
            //方案一：通过加后缀生成不同的类，通过中间层获取最终的方法
            NSString *realPageName = HXNSViewRealName(pageName);
            UIViewController *vc = [[NSClassFromString(realPageName) alloc] init];
            if (vc) {
                //临时代码，拿到合适的导航栏
                UINavigationController *navi = (UINavigationController *)[UIApplication sharedApplication].windows.firstObject.rootViewController;
                [navi pushViewController:vc animated:YES];
            }
            return YES;
        }
        return NO;
    }];
}
@end
