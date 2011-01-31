# Copyright (C) 2011, KADO Masanori <kdmsnr@gmail.com>
# You can redistribute it and/or modify it under GPL.
module TDiary
	class TDiaryDay
		alias :_orig_eval_rhtml :eval_rhtml
		def eval_rhtml
			if @cgi.params['section'].join('') != ""
				@diary.section_no = @cgi.params['section'][0]
			end
			_orig_eval_rhtml
		end
	end

	class TDiaryComment
		def do_eval_rhtml( prefix )
			load_plugins
			@plugin.instance_eval { update_proc } if @comment
			sn = @diary.section_no ? "p#{@diary.section_no}" : ""
			anchor_str = @plugin.instance_eval( %Q[anchor "#{@diary.date.strftime('%Y%m%d')}#{sn}"].untaint )
			raise ForceRedirect::new( "#{@conf.index}#{anchor_str}#c#{'%02d' % @diary.count_comments( true )}" )
		end
	end
end

# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 3
# ruby-indent-level: 3
# End:
# vim: ts=3
