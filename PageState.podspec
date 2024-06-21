
Pod::Spec.new do |s|
  s.name             = 'PageState'
  s.version          = '0.1.0'
  s.summary          = '轻松实现页面或组件数据状态管理'

  s.description      = <<-DESC
快捷实现「加载中」、「网络错误」、「空数据」等状态的切换。
对UIScrollView、UITableView、UICollectionView进行扩展：
1. 有数据时自动隐藏；
2. 控制显示状态视图时是否可滑动；
                       DESC

  s.homepage         = 'https://github.com/git179979506/PageState'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhaoshouwen' => 'zsw19911017@163.com' }
  s.source           = { :git => 'https://github.com/git179979506/PageState.git', :tag => s.version.to_s }
  s.social_media_url = 'https://juejin.cn/user/4265760847569166'

  s.ios.deployment_target = '10.0'
  s.swift_versions = ['4.2', '5.0']

  s.source_files = 'PageState/Classes/**/*'

end
