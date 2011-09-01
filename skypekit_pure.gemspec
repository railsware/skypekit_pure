$LOAD_PATH.unshift 'lib'
require 'skypekit_pure/version'

Gem::Specification.new do |s|
  s.name              = "skypekit_pure"
  s.version           = SkypekitPure::Version
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = "SkypekitPure is a skypekit ruby lib."
  s.homepage          = "https://github.com/railsware/skypekit_pure"
  s.email             = "alexey.vasiliev@railsware.com"
  s.authors           = [ "Alexey Vasiliev" ]

  s.files             = %w( README.markdown Rakefile LICENSE HISTORY.md )
  s.files            += Dir.glob("lib/**/*")
  s.files            += Dir.glob("test/**/*")

  s.extra_rdoc_files  = [ "LICENSE", "README.markdown" ]
  s.rdoc_options      = ["--charset=UTF-8"]

  #s.add_dependency "redis-namespace", "~> 1.0.2"

  s.description = <<description
    SkypekitPure is a skypekit ruby lib.
description
end