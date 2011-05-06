#!/bin/env ruby

unless ARGV.length == 1
  puts "Usage p2stable PACKAGE_NAME"
  exit 1
end

releases=['5']
archs = [ 'i386','x86_64' ]

unless File.exist?(File.expand_path('~/.pbad.yml'))
  puts "No configuration file found in ~/.pbad.yml"
  exit
end
require 'yaml'
options = YAML.load(File.read(File.expand_path('~/.pbad.yml')))
unless options['target_dir'] && File.exist?(options['target_dir'])
  puts "Set target_dir in ~/.pbad.yml to an existing directory"
  exit 1
end

require 'fileutils'
releases.each do |release|
  archs.each do |arch|
    Dir["#{options['target_dir']}/el#{release}-testing/#{arch}/#{ARGV[0]}*.rpm"].each do |rpm| 
      puts "Move #{rpm}"
      FileUtils.mv(rpm,"#{options['target_dir']}/el#{release}/#{arch}/")
    end
    Dir["#{options['target_dir']}/el#{release}-testing/#{arch}-debuginfo/#{ARGV[0]}*.rpm"].each do |rpm| 
      puts "Move #{rpm}"
      FileUtils.mv(rpm,"#{options['target_dir']}/el#{release}/#{arch}-debuginfo/")
    end
  end
end