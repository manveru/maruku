
require 'tempfile'
require 'fileutils'
require 'digest/md5'

require 'cgi'
require 'open-uri'

module MaRuKu; module Out; module HTML
	
	MATHTRAN_URL = 'http://www.mathtran.org/cgi-bin/mathtran?tex='
  PNG = Struct.new(:src,:depth,:height) unless PNG
	
	def convert_to_png_mathtrans(kind, tex)
    tex = '\displaystyle ' + tex if kind == :equation

    FileUtils::mkdir_p MaRuKu::Globals[:html_png_dir]

    # first, we check whether this image has already been processed
    md5sum = Digest::MD5.hexdigest(tex)
    png_file = File.join(MaRuKu::Globals[:html_png_dir], md5sum+".png")
    depth_file = File.join(MaRuKu::Globals[:html_png_dir], md5sum+".txt")

    depth = 0
    if File.exists?(depth_file) and File.exists?(png_file)
      open(depth_file) do |txt|
        depth = txt.readline
      end
    else
      open(png_file, 'w') do |png|
	      open( MATHTRAN_URL + CGI.escape(tex) ) do |uri|
	        depth = uri.meta['x-mathimage-depth']
          uri.each do |line|
            png.print line
          end
        end
      end
      
      open(depth_file, 'w') do |txt|
        txt.print depth
      end
    end

    width, height = IO.read(png_file)[0x10..0x18].unpack('NN')
    height = height.to_f
    depth = depth.to_f

    png_url = File.join(MaRuKu::Globals[:html_png_url], md5sum+".png")
    return PNG.new(png_url, depth, height - depth)
    
    # begin
    #   FileUtils::mkdir_p MaRuKu::Globals[:html_png_dir]
    # 
    #   # first, we check whether this image has already been processed
    #   md5sum = Digest::MD5.hexdigest(tex)
    #   result_file = File.join(MaRuKu::Globals[:html_png_dir], md5sum+".png")
    # 
    #   if not File.exists?(result_file)
    #     tmp_in = Tempfile.new('maruku_blahtex')
    #         f = tmp_in.open
    #     f.write tex
    #     f.close
    # 
    #     resolution = get_setting(:html_png_resolution)
    # 
    #     options = "--png --use-preview-package --shell-dvipng 'dvipng -D #{resolution}' "
    #     options += ("--png-directory '%s'" % MaRuKu::Globals[:html_png_dir])
    # 
    #     cmd = "blahtex #{options} < #{tmp_in.path} > #{result_file}"
    #     $stderr.puts "$ #{cmd}"
    #         system cmd
    #     tmp_in.delete
    #   end
    #   
    #       result = File.read(result_file)
    #       if result.nil? || result.empty?
    #         raise "Blahtex error: empty output"
    #       end
    #       
    #   doc = Document.new(result, {:respect_whitespace =>:all})
    #   png = doc.root.elements[1]
    #   if png.name != 'png'
    #     raise "Blahtex error: \n#{doc}"
    #   end
    #   depth = png.elements['depth'] || (raise "No depth element in:\n #{doc}")
    #   height = png.elements['height'] || (raise "No height element in:\n #{doc}")
    #   md5 = png.elements['md5'] || (raise "No md5 element in:\n #{doc}")
    #   
    #   depth = depth.text.to_f
    #   height = height.text.to_f # XXX check != 0
    #   md5 = md5.text
    #   
    #   dir_url = MaRuKu::Globals[:html_png_url]
    #   return PNG.new("#{dir_url}#{md5}.png", depth, height)
    # rescue Exception => e
    #   maruku_error "Error: #{e}"
    # end
    # nil
	end

end end end
