class ApplicationController < ActionController::Base
	before_action :append_view_path

	def append_view_path 
		prepend_view_path SpreeBuybidThemesBuybid1st::Engine.root.join('app', 'views')
	end
end
