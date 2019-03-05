#
# Be sure to run `pod lib lint DarkEggKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DarkEggKit'
  s.version          = '0.1.1'
  s.summary          = 'DarkEgg UI Kit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  * 0.1.1 (2019/03/05)
    Common, PaddingLabel, PopupMessage and SideMenu.
    Please check README.md on git repo.
  ---
  * 0.1.0
    First commit, with Common, PaddingLabel, PopupMessage and SideMenu
                       DESC

  s.homepage         = 'https://github.com/darkzero/DarkEggKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'darkzero' => 'darkzero_mk2@hotmail.com' }
  s.source           = { :git => 'https://github.com/darkzero/DarkEggKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/darkzero_mk2'

  s.ios.deployment_target = '10.0'
  #s.source_files = 'DarkEggKit/Classes/**/*'
  #s.resources = ['DarkEggKit/Classes/PopupMessage/*.xcassets']
  s.default_subspec = 'Common'
  
  s.subspec 'Common' do |common|
    common.source_files = 'DarkEggKit/Classes/Common/*'
  end
  
  s.subspec 'PaddingLabel' do |paddingLabel|
    paddingLabel.source_files = 'DarkEggKit/Classes/PaddingLabel/*'
    paddingLabel.dependency 'DarkEggKit/Common'
  end
  
  s.subspec 'PopupMessage' do |popupMessage|
    popupMessage.source_files = 'DarkEggKit/Classes/PopupMessage/*'
    popupMessage.dependency 'DarkEggKit/Common'
    popupMessage.resources = ['DarkEggKit/Classes/PopupMessage/*.xcassets']
  end
  
  s.subspec 'SideMenu' do |sideMenu|
    sideMenu.source_files = 'DarkEggKit/Classes/SideMenu/*'
    sideMenu.dependency 'DarkEggKit/Common'
  end
end
