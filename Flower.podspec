#
# Be sure to run `pod lib lint Flower.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Flower"
  s.version          = "0.2.0"
  s.summary          = "A workflow engine for iOS that runs parrallel tasks based processes."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
s.description      = <<-DESC
                    This CocoaPod provides the ability to orchestrate a complex structure of tasks into a runnable process.
                    It allows a process to complete even when app goes to the background, if needed
                    DESC

  s.homepage         = "https://github.com/vodio-labs/flower-ios"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Nir Ninio" => "nir@vod.io" }
  s.source           = { :git => "https://github.com/vodio-labs/flower-ios.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/craveapps'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'Flower' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
