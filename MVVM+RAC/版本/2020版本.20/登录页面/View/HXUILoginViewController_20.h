//
//  HXUILoginViewController_20.h
//  MVVM+RAC
//
//  Created by Brook on 2020/11/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//考虑点：是否要继承HXUILoginViewController？优缺点？
//不继承，第一，某些公共的方法顺序，可以用模块或V基类解决。第二，V类只有V的构建代码，不可能有过多重复代码，否则就是颗粒不合理。
@interface HXUILoginViewController_20 : UIViewController

@end

NS_ASSUME_NONNULL_END
