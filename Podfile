platform :ios, '17.0'

target 'OurMemory' do
  use_frameworks!
  pod 'YandexMapsMobile', '4.29.0-lite'

  target 'OurMemoryTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
    end
  end
end
