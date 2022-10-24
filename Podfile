platform :ios, '13.0'
inhibit_all_warnings!

install! 'cocoapods',
:disable_input_output_paths => true,
:preserve_pod_file_structure => true,
:warn_for_unused_master_specs_repo => false

# Defined pods

# (Recommended) Pod for Google Analytics
def analytics
#  pod 'Firebase/Crashlytics'
end

def networking
  pod 'Alamofire'
  pod 'ReachabilitySwift'
end

def buildUI
  pod 'SnapKit'
  pod 'AssetsPickerViewController'
end

def storage
  pod 'RealmSwift'
end

def tools
  pod 'Promis'
  pod 'SwiftGen'
  pod 'SwiftLint'
  pod 'MaterialComponents/ProgressView'
end

target 'MyCurrencyConverter' do
  use_frameworks!
  
  networking
  storage
  buildUI
  analytics
  tools
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts "#{target.name}"
  end
end
