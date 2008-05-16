require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'

require File.join(File.dirname(__FILE__), 'lib/rails_sql_views', 'version')

PKG_BUILD       = ENV['PKG_BUILD'] ? '.' + ENV['PKG_BUILD'] : ''
PKG_NAME        = 'rails_sql_views'
PKG_VERSION     = RailsSqlViews::VERSION::STRING + PKG_BUILD
PKG_FILE_NAME   = "#{PKG_NAME}-#{PKG_VERSION}"
PKG_DESTINATION = ENV["PKG_DESTINATION"] || "../#{PKG_NAME}"

RELEASE_NAME  = "REL #{PKG_VERSION}"

RUBY_FORGE_PROJECT = "activewarehouse"
RUBY_FORGE_USER    = "aeden"

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the library.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

namespace :rcov do
  desc 'Measures test coverage'
  task :test do
    rm_f 'coverage.data'
    mkdir 'coverage' unless File.exist?('coverage')
    rcov = "rcov --aggregate coverage.data --text-summary -Ilib"
    system("#{rcov} test/*_test.rb test/**/*_test.rb")
    system("open coverage/index.html") if PLATFORM['darwin']
  end
end

desc 'Generate documentation library.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Rails SQL Views'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

PKG_FILES = FileList[
  'CHANGELOG',
  'README',
  'Rakefile',
  'bin/**/*',
  'lib/**/*',
] - [ 'test' ]

spec = Gem::Specification.new do |s|
  s.name = 'rails_sql_views'
  s.version = PKG_VERSION
  s.summary = "Adds SQL Views to Rails."
  s.description = <<-EOF
    Library which adds SQL Views to Rails.
  EOF

  s.add_dependency('activerecord', '>= 1.14.4')
  s.add_dependency('rake', '>= 0.7.1')

  s.rdoc_options << '--exclude' << '.'
  s.has_rdoc = false

  s.files = PKG_FILES.to_a.delete_if {|f| f.include?('.svn')}
  s.require_path = 'lib'

  s.author = "Anthony Eden"
  s.email = "anthonyeden@gmail.com"
  s.homepage = "http://activewarehouse.rubyforge.org/rails_sql_views"
  s.rubyforge_project = "activewarehouse"
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
  pkg.need_tar = true
  pkg.need_zip = true
end

desc "Generate code statistics"
task :lines do
  lines, codelines, total_lines, total_codelines = 0, 0, 0, 0

  for file_name in FileList["lib/**/*.rb"]
    next if file_name =~ /vendor/
    f = File.open(file_name)

    while line = f.gets
      lines += 1
      next if line =~ /^\s*$/
      next if line =~ /^\s*#/
      codelines += 1
    end
    puts "L: #{sprintf("%4d", lines)}, LOC #{sprintf("%4d", codelines)} | #{file_name}"
    
    total_lines     += lines
    total_codelines += codelines
    
    lines, codelines = 0, 0
  end

  puts "Total: Lines #{total_lines}, LOC #{total_codelines}"
end

desc "Publish the release files to RubyForge."
task :release => [ :package ] do
  `rubyforge login`

  for ext in %w( gem tgz zip )
    release_command = "rubyforge add_release activewarehouse #{PKG_NAME} 'REL #{PKG_VERSION}' pkg/#{PKG_NAME}-#{PKG_VERSION}.#{ext}"
    puts release_command
    system(release_command)
  end
end

desc "Publish the API documentation"
task :pdoc => [:rdoc] do 
  Rake::SshDirPublisher.new("aeden@rubyforge.org", "/var/www/gforge-projects/activewarehouse/rails_sql_views/rdoc", "rdoc").upload
end