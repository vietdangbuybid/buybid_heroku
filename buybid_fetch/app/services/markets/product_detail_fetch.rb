module Markets
  class ProductDetailFetch
    def initialize(queue_name)
      @queue_name = queue_name
    end

    def exchange
      BuybidCommon::Queues::MarketsQueue.fetch_exchange(:fanout, @queue_name)
    end

    def queue
      puts "queue_name 1: #{@queue_name}"
      @queue ||= BuybidCommon::Queues::MarketsQueue.fetch_queue(@queue_name).bind(exchange)
    end

    def execute
      Rails.logger.info 'ProductDetailFetch start'

      ActiveRecord::Base.connection_pool.with_connection do
        queue.subscribe(block: true) do |delivery_info, properties, payload|
          Rails.logger.info 'ProductDetailFetch begin'
          begin
            on_product(JSON.parse(payload))
          rescue => e
            Rails.logger.fatal "ProductDetailFetch exception: #{e.message}"
            Rails.logger.fatal e.backtrace.join("\n")
            Raven.capture_exception(e)
          end
        end
      end
      
      Rails.logger.info 'ProductDetailFetch end'
    end

    private

    def on_product(product)
    	Rails.logger.info '      - Fetch product detail...'    	
    end
  end
end
