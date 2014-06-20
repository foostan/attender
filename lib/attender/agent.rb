require 'json'

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
      Thread.abort_on_exception = true
    end

    def run
      getter = Thread.new do
        path = '/v1/health/state/passing'
        loop do
          @response_queue << get(path)
        end
      end

      putter = Thread.new do
        response = nil
        loop do
          unless @response_queue.empty?
            prev_response = response
            response = @response_queue.pop
            put(response, prev_response)
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
        raise "Invalid status code #{code}"
      end

      @index = response['x-consul-index']
      if @index.nil?
        raise 'Missing x-consul-index'
      end

      JSON.parse(response.body)
    end

    def put(response, prev_response)
      return if prev_response.nil?
      add_diff = response.select do |v|
        !prev_response.include?(v)
      end

      ded_diff = prev_response.select do |v|
        !response.include?(v)
      end

      puts add_diff.to_json
      puts ded_diff.to_json
    end
  end
end
