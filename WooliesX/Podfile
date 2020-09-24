# Uncomment the next line to define a global platform for your project
 platform :ios, '11.0'

def common_pods
  pod 'SnapKit'
  pod 'RxCocoa'
  pod 'Alamofire'
  pod 'RxAlamofire'
  pod 'RxSwift'
  pod 'Kingfisher'
end
target 'WooliesX' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WooliesX
  common_pods

  target 'WooliesXTests' do
    inherit! :search_paths
    # Pods for testing
    common_pods
  end

end
