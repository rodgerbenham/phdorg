#!/usr/bin/ruby

require 'fileutils'
require 'google_calendar'
require 'rails'

action=ARGV[0]
name=ARGV[1]

def gen_experiment(name)
  puts "Generating #{name} experiment files..."
  dt = DateTime.now
  str = "#{dt.day}_#{dt.month}_#{dt.year}_#{name}"
  if File.directory?("experiment/#{str}")
    STDERR.puts "Aborting, directory for #{str} already exists"
    return
  end

  FileUtils::mkdir_p("experiment")
  FileUtils::mkdir_p("experiment/#{str}")
  FileUtils::mkdir_p("experiment/#{str}/data")
  FileUtils::mkdir_p("experiment/#{str}/notes")
  FileUtils::mkdir_p("experiment/#{str}/results")
  FileUtils::mkdir_p("experiment/#{str}/source")
  File.write("experiment/#{str}/description.txt", "a")
end

def gen_text(name, type, text=nil, prompt=false)
  while prompt
    print "Generate #{name} #{type}? [y/n]: "
    txt = STDIN.gets.chomp
    if txt == "n"
      return
    elsif txt == "y"
      break
    end
  end

  puts "Generating #{name} #{type} files..."

  if File.directory?("#{type}/#{name}")
    STDERR.puts "Aborting, directory for #{name} #{type} already exists"
    return
  end

  FileUtils::mkdir_p("#{type}")
  FileUtils::mkdir_p("#{type}/#{name}")
  FileUtils::mkdir_p("#{type}/#{name}/data")
  FileUtils::mkdir_p("#{type}/#{name}/notes")
  FileUtils::mkdir_p("#{type}/#{name}/source")
  if text == nil
    File.write("#{type}/#{name}/description.txt", "a")
  else
    f = File.new("#{type}/#{name}/description.txt", "a")
    f.puts text
    f.close
  end
end

def gen_from_calendar(access_token)
  cal = Google::Calendar.new(:client_id => ENV['PHDORG_CLIENTID'],
                     :client_secret => ENV['PHDORG_CLIENTSECRET'],
                     :refresh_token => access_token,
                     :redirect_url => "urn:ietf:wg:oauth:2.0:oob",
                     :calendar => "rodger.benham@rmit.edu.au")

  start_date = DateTime.now.in_time_zone(Time.zone).beginning_of_day
  end_date = start = DateTime.now.in_time_zone(Time.zone).end_of_day

  events = cal.find_events_in_range(start_date.to_time, end_date.to_time)
  
  event_pair = []

  events.each do |e|
    if e.title.include?("Rodger") || e.title.include?("Meetup")
      event_pair << [e, "meeting"]
      next
    elsif e.title.include?("Tiger") || e.title.include?("TIGER") || e.title.include?("Talk")
      event_pair << [e, "talk"]
      next
    end
  end

  event_pair.each do |epair|
    dt = DateTime.iso8601(epair[0].start_time)
    short = epair[0].title.split(" ")[0].downcase
    short ||= epair[0].title.downcase
    short ||= "untitled"
    str = "#{dt.day}_#{dt.month}_#{dt.year}_#{dt.hour}_#{dt.min}_#{short}"
    gen_text(str, epair[1], epair[0].title, true)
  end
end

def show_usage
  puts "usage: ./gen.rb <experiment|review|thesis|calendar> [name]"
end

if action == "experiment"
  if name == nil 
    show_usage
    return
  end
  gen_experiment(name)
elsif action == "review" || action == "thesis"
  if name == nil 
    show_usage
    return
  end
  gen_text(name, action)
elsif action == "calendar"
  `python get_oauth2_token.py > token.tmp`
  access_token = ""
  File.readlines("token.tmp").each { |line| access_token = line.split(" ")[1] if line.include?("access_token:") } 
  `rm -f token.tmp creds.data`

  gen_from_calendar(access_token)
else
  show_usage
end
