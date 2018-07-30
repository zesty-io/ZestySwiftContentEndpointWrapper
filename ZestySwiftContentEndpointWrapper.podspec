#
# Be sure to run `pod lib lint ZestySwiftContentEndpointWrapper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZestySwiftContentEndpointWrapper'
  s.version          = '0.2.0'
  s.summary          = 'An easy way to access the Zesty.io Basic JSON API as well as your own custom JSON Endpoints.'
  s.swift_version = '4.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
The ZestyJSONAPI allows users to access their data on their Zesty.io hosted website in an easy way. It provides a framework to easily get data using the Basic JSON API, and also lets users get data from their own custom endpoints.
DESC

  s.homepage         = 'https://github.com/zesty-io/ZestySwiftContentEndpointWrapper'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ronakdev' => 'ronak.shah.zesty@gmail.com' }
  s.source           = { :git => 'https://github.com/zesty-io/ZestySwiftContentEndpointWrapper.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/zestyio'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ZestySwiftContentEndpointWrapper/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ZestySwiftContentEndpointWrapper' => ['ZestySwiftContentEndpointWrapper/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'SwiftyJSON', '~> 4.0'
  s.dependency 'Alamofire', '~> 4.7'
  s.platform = :ios, "10.0"
end
