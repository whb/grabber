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
      lines = doc.search('.news').inner_html.split('<br />')
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
    frag = link.inner_html[0,4].to_i
    if frag !=0 then
      if !title.has_key?(frag)
        title[frag] = 1
      else
        title[frag] = title[frag] + 1
      end
    end
  end
  title.each do |key, value| 
    puts "grabbering: #{key} => #{value}"
    grabber(dir, key, value)
  end
end

list(ARGV[0])
