require 'rubygems'
require 'hpricot'
require 'open-uri'

base = "http://sy11.kaixindao.org/shuyao/html/dushi/2009/0314/"
index_page = "417.html"
base = "http://sy11.kaixindao.org/shuyao/html/dushi/2009/0703/"
index_page = "4265.html"
doc = Hpricot(open(base + index_page))

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
    puts "Fetching: #{t_page}"
    doc = Hpricot(open(t_page))
    lines = doc.search('.news').inner_html.split('<br />')
    context[num.to_i] = lines
    puts "Got #{t_page} OK"
  }
end
threads.each {|thread| thread.join}
context_array = context.sort
File.open("one", "w") do |f|
  context_array.each { |i| f.puts i[1]}
end

