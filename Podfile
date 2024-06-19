# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Demo_1' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  
  # Pods for Demo_1
  pod 'SwiftVideoGenerator'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'GoogleSignIn'
  pod 'SideMenu'
  pod 'SDWebImage'
  pod 'IQKeyboardManagerSwift'
  pod 'FacebookLogin'
  pod 'FBSDKLoginKit'
  pod 'SVProgressHUD'
  pod 'Stripe', '~> 22.8'
  pod 'LGSegmentedControl'
  pod 'CHTCollectionViewWaterfallLayout'
  pod 'TPPDF'
  pod 'SwiftyStoreKit'
  pod 'STTabbar'

  target 'Demo_1Tests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Demo_1UITests' do
    # Pods for testing
  end

end
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end

