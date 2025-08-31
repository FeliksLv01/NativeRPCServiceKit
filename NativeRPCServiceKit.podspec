Pod::Spec.new do |spec|
  spec.name         = "NativeRPCServiceKit"
  spec.version      = "0.0.14"
  spec.summary      = "Cross Platform Communication Framework"
  spec.description  = <<-DESC
                      NativeRPCServiceKit is a cross-platform communication framework that enables seamless 
                      communication between native code and web content. It provides WKWebView integration, 
                      type-safe parameter passing, async operation support, and bidirectional communication 
                      with separated method calls and event notifications.
                      DESC

  spec.homepage     = "https://github.com/FeliksLv01/NativeRPCServiceKit"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "FeliksLv" => "felikslv@example.com" }

  spec.ios.deployment_target = "13.0"
  spec.osx.deployment_target = "10.15"

  spec.source       = { :git => "https://github.com/FeliksLv01/NativeRPCServiceKit.git", :tag => "#{spec.version}" }
  spec.source_files = "Sources/NativeRPCServiceKit/**/*.swift"
  
  spec.framework    = "Foundation"
  spec.ios.framework = "UIKit", "WebKit"
  spec.osx.framework = "AppKit", "WebKit"
  
  spec.prefix_header_file = false
  spec.static_framework = true
  spec.swift_version = "5.9"
  spec.requires_arc = true
end