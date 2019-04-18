
Pod::Spec.new do |s|


s.name         = "PWChartLib"
s.version      = "0.0.56"
s.summary      = "图表库"


s.description  = "图表库"

s.homepage     = "https://github.com/wnrz/PWChartLib.git"

s.license      = "MIT"

s.author       = { "Peter Wang" => "66682060@qq.com" }


s.platform     = :ios, "8.0"
s.ios.deployment_target = "8.0"


#s.source       = { :git => "../"}
s.source           = { :git => 'https://github.com/wnrz/PWChartLib.git', :tag => s.version.to_s }

s.requires_arc = true
s.framework = "UIKit","Foundation"


s.subspec 'ChartLib' do |ss|#图表库
ss.source_files = 'PWChartLib/PWChartLib/**/*.{h,m,a,c}'
ss.ios.frameworks = 'UIKit', 'Foundation'
end

s.resource_bundles = {'PWChartLib' => ['PWChartLib/PWChartLib/**/*.{storyboard,xib,png,strings}']}

s.dependency 'PWDataBridge'
end


