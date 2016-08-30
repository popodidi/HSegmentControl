#
# Be sure to run `pod lib lint HSegmentControl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HSegmentControl'
  s.version          = '0.1.0'
  s.summary          = 'A customized segment control sublassing UIControl.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "A customized segment control sublassing UIControl where the view, titles of each segment and the indicator view can all be cutomized."

  s.homepage         = 'https://github.com/popodidi/HSegmentControl'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Chang, Hao' => 'popodidi@livemail.tw' }
  s.source           = { :git => 'https://github.com/popodidi/HSegmentControl.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'HSegmentControl/Classes/**/*'
end
