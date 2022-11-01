# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'COVID Tracker 2.0' do
  use_frameworks!
      pod 'FloatingPanel'
      pod 'Charts'
      pod 'CSV.swift'
      pod 'ProgressHUD'
      pod 'Algorithm', '~> 3.1.0'

  
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end
