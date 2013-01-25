#!/bin/ruby
require 'rubygems'
require 'zip/zip'
require "asciify"

class Student < Struct.new(:name, :toledoUserName)
end

def unzip_file (file, destination)
  Zip::ZipFile.open(file) { |zip_file|
   zip_file.each { |f|
     f_path=File.join(destination, f.name)
     FileUtils.mkdir_p(File.dirname(f_path))
     zip_file.extract(f, f_path) unless File.exist?(f_path)
   }
  }
end
	# zoek de txt file
	# filter de naam uit de txt file
	# maak directory met naam
	# vul directory met bestanden
	# OF unzip zipfile

users = Array.new

puts "Scanning files..."
Dir.glob('./*.txt') do |file|
	next if file == '.' or file == '..'
	begin #try 
		firstLine = File.open(file).first.asciify
		
		name = firstLine[/\:([^}]+)\(/,1].strip!.gsub(' ', '-').gsub('?', '_')
		toledoUserName = firstLine[/\(([^}]+)\)/,1]

		users.push Student.new(name, toledoUserName)
	rescue #catch
	end
end

puts "Unzipping files..."
Dir.glob("./*.zip") do |file|
	puts "Unzipping... " + file
	unzip_file(file.to_s, file.gsub(/.zip$/) { "" })
end

puts "Moving files..."
users.each do |user|
	if !File.exists?(user.name)
		Dir.mkdir(user.name)
	end
	FileUtils.move Dir.glob("*#{user.toledoUserName}*"), user.name  #,    :verbose => true   #:noop => true,
end







