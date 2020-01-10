#
# Be sure to run `pod lib lint DarkEggKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DarkEggKit'
  s.version          = '0.4.0'
  s.summary          = 'DarkEgg UI Kit.'
  s.swift_version         = '5.0'
  s.ios.deployment_target = '12.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  * 0.4.0 (2019/10/20)
    - Add ButtonMenu (Is not prefect now)
    ```
    pod 'DarkEggKit/ButtonMenu'
    ```
    - Fix some bugs
  ---
  * 0.3.1 (2019/09/30)
    Update to iOS 11
  ---
  * 0.3.0 (2019/08/31)
    Add AnimatedImageView
    ```
    pod 'DarkEggKit/AnimatedImageView'
    ```
  ---
  * 0.2.1 (2019/05/16)
    Set DZPaddinLabel to public
    Delete column in Logger.debug and Logger.error
  ---
  * 0.2.0 (2019/03/17)
    Fix some bugs
  ---
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
  
  # DarkEggKit/Common
  s.subspec 'Common' do |common|
    common.source_files = 'DarkEggKit/Classes/Common/*'
  end
  
  # DarkEggKit/PaddingLabel
  s.subspec 'PaddingLabel' do |paddingLabel|
    paddingLabel.source_files = 'DarkEggKit/Classes/PaddingLabel/*'
    paddingLabel.dependency 'DarkEggKit/Common'
  end
  
  # DarkEggKit/PopupMessage
  s.subspec 'PopupMessage' do |popupMessage|
    popupMessage.source_files = 'DarkEggKit/Classes/PopupMessage/*'
    popupMessage.resources = ['DarkEggKit/Classes/PopupMessage/*.xcassets']
    popupMessage.dependency 'DarkEggKit/Common'
  end
  
  # DarkEggKit/SideMenu
  s.subspec 'SideMenu' do |sideMenu|
    sideMenu.source_files = 'DarkEggKit/Classes/SideMenu/*'
    sideMenu.dependency 'DarkEggKit/Common'
  end
  
  # DarkEggKit/AnimatedImageView
  # not release in this version
  s.subspec 'AnimatedImageView' do |aImageView|
    aImageView.source_files = 'DarkEggKit/Classes/AnimatedImageView/*'
    aImageView.dependency 'DarkEggKit/Common'
  end

  # DarkEggKit/ButtonMenu
  # not release in this version
  s.subspec 'ButtonMenu' do |buttonMenu|
    buttonMenu.source_files = 'DarkEggKit/Classes/ButtonMenu/*'
    buttonMenu.resources = ['DarkEggKit/Classes/ButtonMenu/*.xcassets']
    buttonMenu.dependency 'DarkEggKit/Common'
  end
  
  # DarkEggKitit/AnnularProgress
  # will be released in version 0.5.0
  s.subspec 'AnnularProgress' do |progress|
    # progress.source_files = ''
    progress.dependency 'DarkEggKit/Common'
  end
end
