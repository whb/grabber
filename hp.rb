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

base = "http://sy11.kaixindao.org/shuyao/html/dushi/2009/0314/"
index_page = "403.html"
doc = Hpricot(open(base + index_page))
pages = []
pages << index_page
doc.search('.plist').search("li").search("a") do |link|
  page = link.attributes['href']
	pages << page if (!page.nil? && (page.include? 'html'))
end
pages.uniq!
#abstract(base+pages[1])
pages.each {|page| abstract(base+page)}
#pages.each {|page| puts (base+page)}


