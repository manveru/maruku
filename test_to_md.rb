require 'maruku'
require 'strscan'

def process(title, mkd)
  doc = Maruku.new(mkd)
  md = doc.to_md(:line_length => 80)
  if md == mkd
    puts("%-30s passed" % title)
  else
    puts " #{title} ".center(80, '=')
    p doc
    p mkd
    p md
    exit
  end
end

scanner = StringScanner.new(DATA.read)
title = mkd = nil

until scanner.eos?
  if scanner.scan(/\*\*\* (.*?) \*\*\*/)
    process(title, mkd.strip) if title and mkd
    title = scanner[1]
    mkd = ''
  elsif scanner.scan(/.+/)
    mkd << scanner.matched
  elsif scanner.scan(/\n/)
    mkd << scanner.matched
  else
    exit
  end
end

process(title, mkd[1..-2]) if title and mkd

__END__
*** Header ***
# Header 1
## Header 2
### Header 3
#### Header 4
##### Header 5

*** Link inline ***
This is [an example](http://example.com/ "Title") inline link.

*** Link without title ***
[This link](http://example.net/) has no title attribute.

*** Link reference style ***
This is [an example][id] reference-style link.

*** Link reference definition ***
[id]: http://example.com/ "Optional Title Here"
[Google][google]

*** Emphasis ***
_single underscores_

__double underscores__

un_fucking_believable

*** Code ***
Use the `printf()` function.

``There is a literal backtick (`) here.``

Please don't use any `<blink>` tags.

`&#8212;` is the decimal-encoded equivalent of `&mdash;`.

*** Images ***
![Alt text](/path/to/img.jpg)

![Alt text](/path/to/img.jpg "Optional title")

![Alt text][id]

*** Automatic links ***
<http://example.com/>

<address@example.com>

*** Backslash escape ***
\*literal asterisks\*
