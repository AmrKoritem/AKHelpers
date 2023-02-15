Pod::Spec.new do |s|

s.name = "AKHelpers"
s.summary = "AKHelpers is the foundation extensions used for AK works."
s.requires_arc = true

s.version = "2.0.0"
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "Amr Koritem" => "amr.koritem92@gmail.com" }
s.homepage = "https://github.com/AmrKoritem/AKHelpers"
s.source = { :git => "https://github.com/AmrKoritem/AKHelpers.git",
             :tag => "v#{s.version}" }

s.framework = "UIKit"
s.source_files = "Sources/AKHelpers/**/*.{swift}"
s.swift_version = "5.0"
s.ios.deployment_target = '11.0'
s.tvos.deployment_target = '11.0'

end
