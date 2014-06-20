module Attender
  class Agent
    Signal.trap(:INT) { exit 0 }

    def initialize
      @url = 'localhost'
      @port = '8500'
      @timeout = 60
      @index = nil
      @response_queue = Queue.new
      STDOUT.sync = true
    end

    def run
      getter = Thread.new do
        path = '/v1/health/state/passing'
        loop do
          @response_queue << get(path)
        end
      end

      putter = Thread.new do
        loop do
          unless @response_queue.empty?
            put(@response_queue.pop)
          end
          sleep rand * 0.1
        end
      end

      getter.join
      putter.join
    end

    def get(path, lp = true)
      http = Net::HTTP.new(@url, @port)
      http.read_timeout = @timeout
      path+= "?wait=#{(@timeout-1).to_s}s&index=#{@index}" unless @index.nil? if lp
      response = http.get(path)

      code = response.code
      unless code == '200'
        abort("Invalid status code #{code}")
      end

      @index = response['x-consul-index']
      if @index.nil?
        abort('Missing x-consul-index')
      end

      response.body
    end

    def put(response)
      puts response
    end
  end
end
