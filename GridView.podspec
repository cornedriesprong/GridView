Pod::Spec.new do |s|
  s.name             = "GridView"
  s.version          = "1.0"
  s.summary          = "Jambl grid view"
  s.homepage         = "https://github.com/"
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { "Corné" => "cdriesprong@gmail.com" }
  s.source           = { :git => "https://github.com/cornedriesprong/GridView.git", :tag => s.version }
  s.platform         = :ios, '10.0'
  s.requires_arc     = true
  s.source_files     = 'GridView/*.swift'
end
