//
//  HXUIMiddleConvertView.m
//  MVVM+RAC
//
//  Created by Brook on 2020/11/5.
//

#import "HXUIMiddleConvertView.h"
#import "HXNSViewConfigManager.h"

//VM
#import "HXRACBaseViewModel.h"
//视图
#import "HXUICustomProtocol.h"

@interface HXUIMiddleConvertView ()
@property(nonatomic,copy)IBInspectable NSString *realViewName;
@property(nonatomic,strong)id realViewObject;
@end

@implementation HXUIMiddleConvertView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self settingUI];
        });
    }
    return self;
}

- (void)settingUI {
    self.backgroundColor = [UIColor clearColor];
    if (self.realViewName && self.realViewName.length > 0) {
        NSString *realPageName = HXNSViewRealName(self.realViewName);
        
        self.realViewObject = [[NSClassFromString(realPageName) alloc] init];
        if ([self.realViewObject conformsToProtocol:@protocol(HXUICustomProtocol)]) {
            ((id<HXUICustomProtocol>)self.realViewObject).customView.frame = self.bounds;
            [self addSubview:((id<HXUICustomProtocol>)self.realViewObject).customView];
        } else {
            //兼容不做定制视图或页面
            if ([self.realViewObject isKindOfClass:UIViewController.class]) {
                UIViewController *vc = (UIViewController *)self.realViewObject;
                vc.view.frame = self.bounds;
                [self addSubview:vc.view];
            } else if([self.realViewObject isKindOfClass:UIView.class]) {
                UIView *view = self.realViewObject;
                view.frame = self.bounds;
                [self addSubview:view];
            }
        }
        
    }
}

#pragma mark HXUICustomProtocol

- (UIView *)customView {
    return self;
}

- (HXRACBaseViewModel *)customViewModel {
    if ([self.realViewObject conformsToProtocol:@protocol(HXUICustomProtocol)]) {
        return ((id<HXUICustomProtocol>)self.realViewObject).customViewModel;
    } else {
        return nil;
    }
}

@end
