# section_link_form.rb

@section_number = @cgi.params['section'][0]
@section_number = nil unless /^\d+$/ =~ @section_number

eval( <<MODIFY_CLASS, TOPLEVEL_BINDING )
module TDiary
	class Comment
		alias :initialize_orig :initialize
		def initialize( name, mail, body, date = Time::now )
			initialize_orig( name, mail, body, date )
			#{if @section_number then
				%Q|@body = "#p#{@section_number} " + @body|
			end}
		end

		def body
			@body.sub( /^#p\\d+\\s+/, '' )
		end

		def section
			/^#p(\\d+)\\s+/ =~ @body && $1
		end

		def visible?
			#{if @section_number then
				%Q|@show && "#{@section_number}" == section|
			else
				'@show'
			end}
		end
	end
end
MODIFY_CLASS

if @section_number then
	@section_index = Hash.new( @section_number.to_i - 1 )
	alias :comment_body_label_orig :comment_body_label
	def comment_body_label
		r = %Q|<input type="hidden" name="section" value="#{h( @section_number )}">|
		r << comment_body_label_orig
	end
else
	@conf.hide_comment_form = true
end
