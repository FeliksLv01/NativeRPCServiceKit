Pod::Spec.new do |s|
  s.name             = 'NativeRPCServiceKit'
  s.version          = '0.0.1'
  s.summary          = 'A short description of NativeRPCServiceKit.'
  s.homepage         = 'https://github.com/FeliksLv01/NativeRPCServiceKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'FeliksLv01' => 'felikslv@163.com' }
  s.source           = { :git => 'https://github.com/FeliksLv01/NativeRPCServiceKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.prefix_header_file = false
  s.source_files = [
    'Sources/**/*.{swift,h,m,mm}'
  ]
  s.module_map = "Sources/NativeRPCServiceKit.modulemap"
end
