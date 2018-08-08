
Pod::Spec.new do |s|


s.name         = "PWChartLib"
s.version      = "0.0.2"
s.summary      = "通信业务库"


s.description  = "通信业务库"

s.homepage     = "http://47.98.36.186/wangning/ChartLib"

s.license      = "MIT"

s.author       = { "Peter Wang" => "66682060@qq.com" }


s.platform     = :ios, "8.0"
s.ios.deployment_target = "8.0"


#s.source       = { :git => "../"}
s.source           = { :git => 'http://47.98.36.186/wangning/ChartLib.git', :tag => s.version.to_s }

s.requires_arc = true
s.framework = "UIKit","Foundation"


s.subspec 'ChartLib' do |ss|#图表库
ss.source_files = 'ChartLib/ChartLib/**/*.{h,m,a,c}'
ss.ios.frameworks = 'UIKit', 'Foundation'
end

s.resource_bundles = {'ChartLib' => ['ChartLib/ChartLib/**/*.{storyboard,xib,png,strings}']}

s.dependency 'BaseUtils'
s.dependency 'NetworkController'
s.dependency 'SDAutoLayout'
end


