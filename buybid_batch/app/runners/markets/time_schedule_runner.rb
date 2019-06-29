# frozen_string_literal: true

require 'clockwork'
require 'active_support/time'
require './config/boot'
require './config/environment'

module Markets
	class TimeScheduleRunner
		include Clockwork

		def execute			
			BuybidBatch::TimeSchedule.all.each do |time_schedule|
				make_schedule(time_schedule.id, time_schedule.repeat_time, time_schedule.repeat_type, time_schedule.repeat_num, time_schedule.repeat_start, time_schedule.task_name, time_schedule.data_hash) 
			end
		end

		private 

		def execute_task(schedule_id, task_name, data_hash)
			Rails.logger.info "Markets::TimeScheduleRunner.execute_task(#{schedule_id}, #{task_name}, #{data_hash})"
			case task_name
			when 'sneak_product_cards'
			  Markets::SneakProductCardsJob.perform_later(data_hash[:buybid_market_name], data_hash[:category_id]) if task_name == 'sneak_product_cards' && BuybidBatch::TimeSchedule.where(:id => schedule_id, :actived => true).exists?
			else
			end
			Rails.logger.info "Markets::TimeScheduleRunner.execute_task end"
		end

		def time_parse(schedule_id, repeat_time, repeat_type)
			case repeat_type
			when 'seconds'
				repeat_time.seconds
			when 'minutes'
				repeat_time.minutes
			when 'hours'
				repeat_time.hours
			when 'days'
				repeat_time.days
			when 'weeks'
				repeat_time.weeks
			when 'months'
				repeat_time.months
			when 'years'
				repeat_time.years
			else
				raise RuntimeError.new("BuybidBatch::TimeSchedule #{schedule_id}, invalid repeat_type: #{repeat_type}")
			end
		end

		def make_schedule(schedule_id, repeat_time, repeat_type, repeat_num, repeat_start, task_name, data_hash)
			Rails.logger.info "Markets::TimeScheduleRunner.make_schedule(#{schedule_id}, #{repeat_time}, #{repeat_type}, #{repeat_num}, #{task_name}, #{data_hash})"
		  every(time_parse(schedule_id, repeat_time, repeat_type), 
		  	"task: #{task_name} every #{repeat_time} #{repeat_type}") do
		  	execute_task(schedule_id, task_name, data_hash) 
		  end
		  #every(1.day, 'myjob', at: '00:00', :if => lambda { |t| t.day == 1 }) do ... end
		  Rails.logger.info "Markets::TimeScheduleRunner.make_schedule end"
		end
	end
end
