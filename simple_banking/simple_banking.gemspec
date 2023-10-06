Gem::Specification.new do |s|
  s.required_ruby_version   = "3.0.6"
  s.name                    = "simple_banking"
  s.version                 = "0.0.0"
  s.summary                 = "Simple Banking"
  s.description             = "A simple banking program"
  s.authors                 = ["Rob Laine"]
  s.email                   = ""
  s.files                   = ["lib/simple_banking.rb"]
  s.homepage                = ""
  s.license                 = "MIT"

  # Add Rspec as dev dependency
  s.add_development_dependency "rspec", "~> 3.2"
end
