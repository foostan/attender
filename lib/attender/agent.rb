module Attender
  class Agent


    def initialize
      @url   = 'localhost'
      @port  = '8500'
      @index = nil
    end

    def run
      path = '/v1/health/state/passing'

      while true
        puts get(path)
      end
    end

    def get(path)
      http     = Net::HTTP.new(@url, @port)
      path += "?index=#{@index}" unless @index.nil?
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
