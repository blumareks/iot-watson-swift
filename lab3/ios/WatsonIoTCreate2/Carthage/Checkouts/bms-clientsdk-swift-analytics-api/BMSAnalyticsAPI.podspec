Pod::Spec.new do |s|

  s.name         = 'BMSAnalyticsAPI'
  s.version      = '2.2.0'
  s.summary      = 'The analytics and logger APIs of the Swift client SDK for IBM Bluemix Mobile Services'
  s.homepage     = 'https://github.com/ibm-bluemix-mobile-services/bms-clientsdk-swift-analytics-api'
  s.license      = 'Apache License, Version 2.0'
  s.authors      = { 'IBM Bluemix Services Mobile SDK' => 'mobilsdk@us.ibm.com' }

  s.source       = { :git => 'https://github.com/ibm-bluemix-mobile-services/bms-clientsdk-swift-analytics-api.git', :tag => s.version }
  s.source_files = 'Source/**/*.swift'
  s.ios.exclude_files = 'Source/**/*watchOS*.swift'

  s.requires_arc = true

  s.ios.deployment_target = '8.0'
  s.watchos.deployment_target = '2.0'

end
