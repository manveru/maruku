Write a comment here
*** Parameters: ***
{} # params 
*** Markdown input: ***
 ![bar](/foo.jpg)


*** Output of inspect ***
md_el(:document,[md_par([md_im_image(["bar"], "/foo.jpg", nil)])],{},[])
*** Output of to_html ***
<p><img src='/foo.jpg' alt='bar' /></p>
*** Output of to_latex ***

*** Output of to_md ***
bar
*** Output of to_s ***
bar
*** EOF ***



	OK!



*** Output of Markdown.pl ***
<p><img src="/foo.jpg" alt="bar" title="" /></p>

*** Output of Markdown.pl (parsed) ***
Error: #<NoMethodError: undefined method `write_children' for <div> ... </>:REXML::Element>
