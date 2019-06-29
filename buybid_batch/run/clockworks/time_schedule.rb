require 'clockwork'
require 'active_support/time'
require './config/boot'
require './config/environment'

Markets::TimeScheduleRunner.new.execute