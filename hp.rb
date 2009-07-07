require 'rubygems'
require 'hpricot'
require 'open-uri'

def abstract(page)
	doc = Hpricot(open(page))
  File.open("one", "a") do |f|
    lines = doc.search('.news').inner_html.split('<br />')
    lines.each {|line| f.puts line}
  end
end
def grabber(page)
	doc = Hpricot(open(page))
  lines = doc.search('.news').inner_html.split('<br />')
  File.open("one", "a") do |f|
    lines.each {|line| f.puts line}
  end
end

base = "http://sy11.kaixindao.org/shuyao/html/dushi/2009/0314/"
index_page = "403.html"
doc = Hpricot(open("index.html"))

pages = []
pages << index_page
doc.search('.plist').search("li").search("a") do |link|
  page = link.attributes['href']
	pages << page if (!page.nil? && (page.include? 'html'))
end
pages.uniq!

context = {}
threads = []
for page in pages
  threads << Thread.new(base+page) { |t_page|
    num = t_page[/_(\d*)\.html/, 1]
    num = 1 if num.nil?
    puts num
    puts "Fetching: #{t_page}"
    #doc = Hpricot(open(t_page))
    #lines = doc.search('.news').inner_html.split('<br />')
    lines = "test #{num}"
    context[num.to_i] = lines
    puts "Got #{t_page} OK"
  }
end
threads.each {|thread| thread.join}
context_array = context.sort
context_array.each { |i| puts i[1]}
#puts context_array


#pages.each {|page| abstract(base+page)}


