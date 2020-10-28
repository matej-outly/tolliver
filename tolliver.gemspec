# Maintain your gem's version:
version = File.read(File.expand_path("../VERSION", __FILE__)).strip

Gem::Specification.new do |s|
  s.name = "tolliver"
  s.version = version
  s.authors = ["Matěj Outlý"]
  s.email = ["matej.outly@gmail.com"]
  s.summary = "Event notification and distribution"
  s.description = "Tolliver is an engine for event notification and distribution among users via e-mail, SMS or other 3rd party systems."
  s.homepage = "https://github.com/matej-outly/tolliver"
  s.license = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 6.0"
end
