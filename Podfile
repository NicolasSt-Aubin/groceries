platform :ios, '9.0'
use_frameworks!
target 'Groceries' do
    pod 'SDWebImage'
    pod 'Alamofire', '~> 4.0'
    pod 'SwiftGen'
    pod 'PKHUD', :git => 'https://github.com/toyship/PKHUD.git'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'KeychainSwift'
    pod 'SwiftGen’

    post_install do |installer|
        installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end
end
