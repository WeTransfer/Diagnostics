Pod::Spec.new do |spec|
  spec.name             = 'Diagnostics'
  spec.version          = '1.8.0'
  spec.summary          = 'Create easy Diagnostics Reports and let user send them to your support team.'
  spec.description      = 'Diagnostics is a library written in Swift which makes it really easy to share Diagnostics Reports to your support team.'

  spec.homepage         = 'https://github.com/WeTransfer/Diagnostics'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.authors          = {
    'Antoine van der Lee' => 'ajvanderlee@gmail.com'
  }
  spec.source           = { :git => 'https://github.com/WeTransfer/Diagnostics.git', :tag => spec.version.to_s }
  spec.social_media_url = 'https://twitter.com/WeTransfer'

  spec.ios.deployment_target = '10.0'
  spec.source_files     = 'Sources/**/*.swift'
  spec.swift_version    = '5.1'
end
