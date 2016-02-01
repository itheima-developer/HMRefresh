Pod::Spec.new do |s|
  s.name         = "HMRefresh"
  s.version      = "1.1.2"
  s.summary      = "轻量级的上拉／下拉刷新控件"
  s.homepage     = "https://github.com/itheima-developer/HMRefresh"
  s.license      = "MIT"
  s.author       = { "黑马程序员" => "ios@itcast.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/itheima-developer/HMRefresh.git", :tag => s.version }
  s.source_files = "HMRefresh/HMRefresh/HMRefresh/*.{h,m}"
  s.resources    = "HMRefresh/HMRefresh/HMRefresh/HMRefresh.bundle"
  s.requires_arc = true
end
