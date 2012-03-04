#!/bin/env ruby

### config

### end fo config

if ARGV.length < 1
  puts "Usage: pbad  [--releases 5,6] path/to/SOME.spec [path/to/OTHER.spec]"
  exit 1
end

if ARGV.include?('--releases')
  @releases = ARGV.slice!(ARGV.index('--releases'),2)[1].split(',')
end

unless ARGV.all?{|file| File.exist?(file) }
  puts "Some Specfiles do not exist!"
  exit 1
end

unless File.exist?(File.expand_path('~/.pbad.yml'))
  puts "No configuration file found in ~/.pbad.yml"
  exit
end
require 'yaml'
@options = YAML.load(File.read(File.expand_path('~/.pbad.yml')))
unless @options['target_dir'] && File.exist?(@options['target_dir'])
  puts "Set target_dir in ~/.pbad.yml to an existing directory"
  exit 1
end
def releases(name=nil)
  @releases ||= (name.nil? ? @options['releases'] : (@options[name]['releases'])) || @options['releases']
end
def archs
  @options['archs']
end


require 'rubygems'
require 'highline/import'
@pgppassphrase = ask("Enter password for GPG Key:  ") { |q| q.echo = "x" }

require 'systemu'

def exec_command(cmd)
  stdout, stderr = '', ''
  status = systemu cmd, 'stdout' => stdout, 'stderr' => stderr
  [status.exitstatus, stdout, stderr ]
end

def print_error(str,stdout,stderr)
  puts str
  puts "stdout: #{stdout}"
  puts
  puts "stderr: #{stderr}"
  exit 1
end

def build_rpm(specfile)
  status, stdout, stderr = exec_command("rpmbuild -bs --nodeps #{specfile}")
  srpmfile = stdout.chomp.sub('Wrote: ','')
  
  unless (status == 0) && srpmfile =~ /^\// && File.exist?(srpmfile)
    print_error("SRPM not builded correctly!",stdout,stderr)
  end
  puts "SRPM (#{File.basename(srpmfile)}) successfully builded."
  
  require 'fileutils'
  releases(File.basename(specfile,'.spec')).each do |release|
    archs.each do |arch|
      puts "Building RPM (#{File.basename(srpmfile)}) for RHEL#{release} on #{arch}"
      status, stdout, stderr = exec_command("/usr/bin/mock -r epel-#{release}-#{arch} rebuild #{srpmfile}")
      if status == 0
        puts "RPM (#{File.basename(srpmfile)}) successfully builded for RHEL#{release} on #{arch}"
        Dir["/var/lib/mock/epel-#{release}-#{arch}/result/*.rpm"].each do |rpm| 
          unless rpm =~ /src.rpm$/
            status, stdout, stderr = exec_command("signrpm #{@pgppassphrase} #{rpm}")
            unless stdout =~ /Pass phrase is good\./
              print_error("Error while signing package #{rpm}",stdout,stderr)
            else
              puts "Signed package #{rpm}"
              unless rpm =~ /-debuginfo-.*rpm$/
               FileUtils.cp(rpm,"#{@options['target_dir']}/el#{release}-testing/#{arch}/")
              else
                FileUtils.cp(rpm,"#{@options['target_dir']}/el#{release}-testing/#{arch}-debuginfo/")
              end
            end
          else
            FileUtils.cp(rpm,"#{@options['target_dir']}/el#{release}/SRPMS/")
          end
          puts "Deloyed package #{rpm} into testing."
        end
      else
        print_error("Error while building SRPM (#{File.basename(srpmfile)}) for RHEL#{release} on #{arch}",stdout,stderr)
      end
    end
  end
end

ARGV.each{|specfile| build_rpm(specfile) }
