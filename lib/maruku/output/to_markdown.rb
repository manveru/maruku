#--
#   Copyright (C) 2006  Andrea Censi  <andrea (at) rubyforge.org>
#
# This file is part of Maruku.
#
#   Maruku is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   Maruku is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with Maruku; if not, write to the Free Software
#   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#++

class String
  # FIXME: Complete escaping
  def to_md(context = {})
    gsub(/([*_])/, '\\\\\1')
  end
end

module MaRuKu::Out::Markdown

  DefaultLineLength = 40

  def to_md(context={})
    children_to_md(context)
  end

  # Convert each child to html
  def children_to_md(context)
    array_to_md(@children, context)
  end

  def to_md_paragraph(context)
    line_length = context[:line_length] || DefaultLineLength
    # wrap(@children, line_length, context)+"\n"
    wrap(children_to_md(context), line_length, context) << "\n"
  end

  def to_md_li_span(context)
    len = (context[:line_length] || DefaultLineLength) - 2
    s = add_tabs(wrap(@children, len-2, context), 1, '  ')
    s[0] = ?*
    s + "\n"
  end

  def to_md_abbr_def(context)
    "*[#{self.abbr}]: #{self.text}\n"
  end

  def to_md_ol(context)
    len = (context[:line_length] || DefaultLineLength) - 2
    md = ""
    self.children.each_with_index do |li, i|
      s = add_tabs(w=wrap(li.children, len-2, context), 1, '    ')+"\n"
      s[0,4] = "#{i+1}.  "[0,4]
      #			puts w.inspect
      md += s
    end
    md + "\n"
  end

  def to_md_ul(context)
    len = (context[:line_length] || DefaultLineLength) - 2
    md = ""
    self.children.each_with_index do |li, i|
      w = wrap(li.children, len-2, context)
      #			puts "W: "+ w.inspect
      s = add_indent(w)
      #			puts "S: " +s.inspect
      s[0,1] = "-"
      md += s
    end
    md + "\n"
  end

  def to_md_header(context)
    "#{'#' * level} #{self}\n"
  end

  # FIXME: Bug? title[:title] instead of title
  def to_md_ref_definition(context)
    if title
      %~[#{ref_id}]: #{url} "#{title[:title]}"\n~
    else
      "[#{ref_id}]: #{url}\n"
    end
  end

  def to_md_im_link(context)
    if title
      %~[#{self}](#{url} "#{title}")~
    else
      "[#{self}](#{url})"
    end
  end

  def to_md_link(context)
    "[#{self}][#{ref_id}]"
  end

  def to_md_emphasis(context)
    string = to_s
    if string =~ /_/
      "*#{string}*"
    else
      "_#{string}_"
    end
  end

  def to_md_strong(context)
    string = to_s
    if string =~ /_/
      "**#{string}**"
    else
      "__#{string}__"
    end
  end

  def to_md_inline_code(context)
    if raw_code =~ /`/
      "``#{raw_code}``"
    else
      "`#{raw_code}`"
    end
  end

  def to_md_entity(context)
    MaRuKu::Out::Latex.need_entity_table
    MaRuKu::Out::Latex::ENTITY_TABLE[entity_name].latex_string
  end

  def to_md_im_image(context)
    if title
      %~![#{self}](#{url} "#{title}")~
    else
      "![#{self}](#{url})"
    end
  end

  def to_md_image(context)
    "![#{self}][#{ref_id}]"
  end

  def to_md_immediate_link(context)
    "<#{url}>"
  end

  def to_md_email_address(context)
    "<#{email}>"
  end

  def show_me
    puts
    puts("caller: %p" % caller[0][/`(.*?)'/, 1])
    puts("self  : %p" % self)
    puts("to_s  : %p" % to_s)
    puts("meta  : %p" % meta_priv)
    puts("attr  : %p" % attributes)
    puts
    ""
  end

  def add_indent(s,char="    ")
    t = s.split("\n").map{|x| char+x }.join("\n")
    s << ?\n if t[-1] == ?\n
    s
  end

  def wrap(array, line_length, context)
    out, line = '', ''

    array.each do |c|
      if c.respond_to?(:node_type) and c.node_type == :linebreak
        out << line.strip << "  \n"
        line = ''
        next
      end

      pieces =
        if c.respond_to?(:split)
          c.split.map{|s| s + ' '}
        else
          [c.to_md(context)].flatten
        end

      pieces.each do |p|
        if p.size + line.size > line_length
          out << line.strip << "\n";
          line = ""
        end
        line << p
      end
    end
    out << line.strip << "\n" if line.size > 0
    out << "\n" unless out[-1, 1] == "\n"
    out
  end


  def array_to_md(array, context, join_char='')
    array.map{|c|
      m = c.respond_to?(:node_type) ? "to_md_#{c.node_type}" : :to_md
      h = c.send(m, context)
      raise("%p md after sending %p to %p" % [h,m,c]) if h.nil?
      h
    }.flatten.join(join_char).strip
  end
end

module MaRuKu
  class MDDocument
    def to_md(context = {})
      super
    end
  end
end
