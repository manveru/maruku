
*** Parameters: ***
require 'maruku/ext/math'; {:math_enabled => false}
*** Markdown input: ***

This is not $math$.

\[ \alpha \]

*** Output of inspect ***
md_el(:document,[md_par(["This is not $math$."]), md_par(["[ \\alpha ]"])],{},[])
*** Output of to_html ***
<p>This is not $math$.</p>

<p>[ \alpha ]</p>
*** Output of to_latex ***
This is not \$math\$.

[ $\backslash$alpha ]
*** Output of to_md ***
This is not $math$.

[ \alpha ]
*** Output of to_s ***
This is not $math$.[ \alpha ]
*** EOF ***



	OK!



*** Output of Markdown.pl ***
<p>This is not $math$.</p>

<p>[ \alpha ]</p>

*** Output of Markdown.pl (parsed) ***
Error: #<NoMethodError: undefined method `write_children' for <div> ... </>:REXML::Element>
