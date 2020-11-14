Pod::Spec.new do |s|
  s.name             = 'BBMainProject'
  s.version          = '0.1.0'
  s.summary          = 'A short description of BBMainProject.'
  s.description      = '主项目物理分割分层实践'
  
  s.homepage         = 'https://github.com/ysh287515814@hotmail.com/BBMainProject'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ysh287515814@hotmail.com' => '287515814@icloud.com' }
  s.source           = { :git => 'https://github.com/ysh287515814@hotmail.com/BBMainProject.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '8.0'
  s.default_subspec = 'Core'
  
  #  做SDK非常便利，不需要手动将图片加入bundle，会自动加入。
  s.resource_bundles = {
    'BBBundle' => ['主目录/**/*.plist']
  }
  
  #难点在于合理分层\合理的颗粒度划分
  s.subspec 'Core' do |sp|
    sp.subspec '配置中心' do |ssp|
      ssp.resource_bundles = {
        'BBBundle' => ['主目录/**/*.plist']
      }
      ssp.source_files = '主目录/配置管理/**/*.{h,m}'
    end
    sp.subspec 'route' do |ssp|
      ssp.dependency 'BBMainProject/Core/配置中心' #依赖配置中心拿配置跳转目标界面
      ssp.dependency  'JLRoutes'
      ssp.source_files = '主目录/路由管理/**/*.{h,m}'
    end
    # 非视图的基础功能库
    sp.subspec 'HXNS基础库' do |ssp|
      ssp.dependency  'YYModel'
      ssp.dependency  'ReactiveObjC'
      ssp.dependency  'AFNetworking'
      ssp.dependency  'ReactiveAFNetworking'
      
      ssp.source_files = '主目录/HXNS基础库/**/*.{h,m}'
    end
    sp.subspec 'HXUI基础库' do |ssp|
      ssp.dependency  'Masonry'
      ssp.dependency  'QMUIKit'
      ssp.dependency  'MBProgressHUD'
      ssp.dependency 'BBMainProject/Core/HXNS基础库' #对项目中基础功能库有依赖
      ssp.dependency 'BBMainProject/Core/配置中心' #依赖配置中心拿配置目标界面或视图
      ssp.source_files = '主目录/HXUI基础库/**/*.{h,m}'
    end
    sp.subspec 'HX页面功能库' do |ssp|
      ssp.dependency 'BBMainProject/Core/HXUI基础库'
      ssp.dependency 'BBMainProject/Core/route'
      
      ssp.subspec '登录' do |sssp|
        sssp.source_files = '主目录/HX页面功能库/登录页面/**/*.{h,m}'
      end
      ssp.subspec '交易' do |sssp|
        sssp.source_files = '主目录/HX页面功能库/交易界面/**/*.{h,m}'
      end
    end
    
  end
  
  #  注意目前只做UI版本控制
  s.subspec 'Versions' do |sp|
    #只能选一个，但也可以做基于20版本的zs版本。在zs的subspec依赖v20的，修改下视图的指向
    sp.subspec 'V20' do |ssp|
      #      下面两行是不考虑模块的写法
      #      ssp.dependency 'BBMainProject/Core/HX页面功能库'
      #      ssp.source_files = '版本/2020版本.20/**/*.{h,m}' 为支持可按功能增删，必须用subspec分割模块。参考core中一模一样
      
      #    分定制的视图单独做依赖，可以方便后面使用功能单独做引入
      
      
      ssp.subspec 'HXUI基础库' do |sssp|
        sssp.dependency 'BBMainProject/Core/HXUI基础库' #对项目中基础功能库有依赖
        sssp.source_files = '版本/2020版本.20/五档视图模块/**/*.{h,m}'
        sssp.resource_bundles = {
          'BBBundle' => ['主目录/**/*.plist','版本/**/*.plist']
        }
      end
      ssp.subspec 'HX页面功能库' do |sssp|
        sssp.subspec '登录' do |ssssp|
          ssssp.dependency 'BBMainProject/Core/HX页面功能库/登录'
          ssssp.source_files = '版本/2020版本.20/登录页面/**/*.{h,m}'
          ssssp.resource_bundles = {
            'BBBundle' => ['主目录/**/*.plist','版本/**/*.plist']
          }
        end
      end
      
      ssp.resource_bundles = {
        'BBBundle' => ['主目录/**/*.plist','版本/**/*.plist']
      }
    end
    
    sp.subspec 'V30' do |ssp|
      #      sp.dependency 'BBMainProject/Versions/v20' #如果要基于v20，或里面的资源则需要依赖
#      ssp.source_files = '版本/zs.zs/**/*..{h,m}'

      ssp.dependency 'BBMainProject/Core/HX页面功能库' #基于16公版
      ssp.dependency 'BBMainProject/Versions/V20/HX页面功能库/登录' #要部分的20版功能，问题导入了配置文件
      
      ssp.resource_bundles = {
        'BBBundle' => ['主目录/**/*.plist','版本/2030版本.30/**/*.plist']
      }
    end
  end
  
  
  # s.resource_bundles = {
  #   'BBMainProject' => ['BBMainProject/Assets/*.png']
  # }
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
