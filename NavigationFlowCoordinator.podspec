Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '9.0'
s.name = "NavigationFlowCoordinator"
s.summary = "Navigation flow coordinator"
s.author = { "Rafał Urbaniak" => "rafal.urbaniak@rndity.com" }
s.homepage = "http://rndity.com"
s.license = { :type => "MIT" }

s.version = "1.0.0"
s.requires_arc = true
s.source = { :git => 'https://github.com/RnDity/NavigationFlowCoordinator.git', :tag => "#{s.version}" }
s.source_files = "true", "**/*.{h,m,swift}"

s.framework = "UIKit"

end
