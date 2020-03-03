#
# Be sure to run `pod lib lint DarkEggKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name                  = 'DarkEggKit'
    s.version               = '0.5.5'
    s.summary               = 'DarkEgg UI Kit.'
    s.swift_version         = '5.0'
    s.ios.deployment_target = '12.0'

    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    s.description = <<-DESC
      * 0.5.5 (2020/03/04)
      - Add bar align in BarChart
      - Others
      ---
      * 0.5.4 (2020/02/14)
      - Change property of doughnut chart (delete inner and outer, add lineWidth)
      ---
      * 0.5.3 (2020/02/05)
      - Add text to BarChart.
      - Add sort before chart displaying. (BarChart and DoughnutChart)
      - Others
      ---
      * 0.5.2 (2020/01/31)
      - fix some bugs
      ---
      * 0.5.1 (2020/01/27)
      - Add BarChart
      ```
      pod 'DarkEggKit/BarChart'
      ```
      ---
      * 0.5.0 (2020/01/19)
      - Add DoughnutChart
      ```
      pod 'DarkEggKit/DoughnutChart'
      ```
      ---
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
        common.source_files = 'DarkEggKit/Classes/Common/*.swift'
        #common.resources = ['DarkEggKit/Classes/Common/*.md']
    end

    # DarkEggKit/PaddingLabel
    s.subspec 'PaddingLabel' do |paddingLabel|
        paddingLabel.source_files = 'DarkEggKit/Classes/PaddingLabel/*.swift'
        #paddingLabel.resources = ['DarkEggKit/Classes/PaddingLabel/*.md']
        paddingLabel.dependency 'DarkEggKit/Common'
    end

    # DarkEggKit/PopupMessage
    s.subspec 'PopupMessage' do |popupMessage|
        popupMessage.source_files = 'DarkEggKit/Classes/PopupMessage/*.swift'
        popupMessage.resources = ['DarkEggKit/Classes/PopupMessage/*.xcassets']
        popupMessage.dependency 'DarkEggKit/Common'
    end

    # DarkEggKit/SideMenu
    s.subspec 'SideMenu' do |sideMenu|
        sideMenu.source_files = 'DarkEggKit/Classes/SideMenu/*.swift'
        #sideMenu.resources = ['DarkEggKit/Classes/SideMenu/*.md']
        sideMenu.dependency 'DarkEggKit/Common'
    end

    # DarkEggKit/AnimatedImageView
    # not release in this version
    s.subspec 'AnimatedImageView' do |aImageView|
        aImageView.source_files = 'DarkEggKit/Classes/AnimatedImageView/*.swift'
        aImageView.resources = ['DarkEggKit/Classes/AnimatedImageView/*.xcassets']
        aImageView.dependency 'DarkEggKit/Common'
    end

    # DarkEggKit/ButtonMenu
    # not release in this version
    s.subspec 'ButtonMenu' do |buttonMenu|
        buttonMenu.source_files = 'DarkEggKit/Classes/ButtonMenu/*.swift'
        buttonMenu.resources = ['DarkEggKit/Classes/ButtonMenu/*.xcassets']
        buttonMenu.dependency 'DarkEggKit/Common'
    end

    # DarkEggKitit/DoughnutChart
    # will be released in version 0.5.0
    s.subspec 'DoughnutChart' do |dount|
        dount.source_files = 'DarkEggKit/Classes/DoughnutChart/*.swift'
        #dount.resources = ['DarkEggKit/Classes/DoughnutChart/*.md']
        dount.dependency 'DarkEggKit/Common'
    end

    # DarkEggKitit/BarChart
    # will be released in version 0.5.1
    s.subspec 'BarChart' do |barDount|
        barDount.source_files = 'DarkEggKit/Classes/BarChart/*.swift'
        #barDount.resources = ['DarkEggKit/Classes/BarChart/*.md']
        barDount.dependency 'DarkEggKit/Common'
    end
end
