require 'rubygems'
require 'hpricot'
require 'open-uri'

def grabber(dir, index, num)
  chapters = []
  threads = []
  1.upto(num) do |no|
    threads << Thread.new(no) { |i|
      page = (i == 1 ? "#{index}.html":"#{index}_#{i}.html")
      doc = Hpricot(open(dir+page))
      lines = doc.search('.wen').inner_html.split(%r{<br\s*/*>})
      chapters[i-1] = lines
    }
  end
  threads.each {|thread| thread.join(60)}
  File.open("#{index}.txt", "w") do |f|
    chapters.each { |ch| f.puts ch}
  end
end

def list(dir)
  title = {}
  doc = Hpricot(open(dir))
  doc.search('a') do |link|
    frag = link.inner_html[/(\d+)(_*)(\d*)/,1].to_i
    next if frag == 0
		title[frag] ||= 0
		title[frag] += 1
  end
  title.each do |key, value| 
    puts "grabbering: #{key} => #{value}"
    #grabber(dir, key, value)
  end
end

list(ARGV[0])
