module Attender
  class Agent
    Signal.trap(:INT) { exit 0}

    def initialize
      @url = 'localhost'
      @port = '8500'
      @timeout = 5
      @index = nil
      STDOUT.sync = true
    end

    def run
      path = '/v1/health/state/passing'

      loop do
        response = get(path)

        Thread.new do
          puts response
          Thread.pass
        end
      end
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

  end
end
