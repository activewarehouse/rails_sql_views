# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'rails_sql_views'
  s.version = "5.0" # this number was chosen arbitrarily --ken
  s.summary = "Adds SQL Views to Rails."
  s.description = <<-EOF
    Library which adds SQL Views to Rails.
  EOF

  s.add_dependency('activerecord', '>= 2.1.0')
  s.add_dependency('rake', '>= 0.8.3')

  s.rdoc_options << '--exclude' << '.'
  s.has_rdoc = false

  s.files        = Dir.glob("lib/**/*") + %w(README)
  s.require_path = 'lib'

  s.author = "Anthony Eden"
  s.email = "anthonyeden@gmail.com"
  s.homepage = "http://activewarehouse.rubyforge.org/rails_sql_views"
  s.rubyforge_project = "activewarehouse"
end
