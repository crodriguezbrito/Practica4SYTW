   require 'rack/request'
   require 'rack/response'
   require 'haml'
   require 'thin'
   require 'sinatra'
   
   module RockPaperScissors
     class App 
   
		 def initialize(app = nil)
			@app = app
			@content_type = :html
			@defeat = {'rock' => 'scissors', 'paper' => 'rock', 'scissors' => 'paper'}
			@throws = @defeat.keys
		 end
  
      def call(env)
        req = Rack::Request.new(env)  
        req.env.keys.sort.each { |x| puts "#{x} => #{req.env[x]}" }
        computer_throw = @throws.sample
        player_throw = req.GET["choice"]
        anwser = if !@throws.include?(player_throw)
           inicio = "Elige Rock Paper o Scissors para empezar a jugar:"
          elsif player_throw == computer_throw
            "Empate"
          elsif computer_throw == @defeat[player_throw]
			"Ganar"
          
          else
            "Perder"        
          end
  
			engine = Haml::Engine.new File.open("./app/views/index.html.haml").read
			res = Rack::Response.new
			res.write engine.render({},
				:anwser => anwser,
				:choose => @choose,
				:throws => @throws,
				:computer_throw => computer_throw,
				:player_throw => player_throw,
				:inicio => inicio,)
			res.finish
      end # call
    end   # App
  end     # RockPaperScissors
  
  if $0 == __FILE__
    require 'rack'
    require 'rack/showexceptions'
    Rack::Server.start(
      :app => Rack::ShowExceptions.new(
                Rack::Lint.new(
                  RockPaperScissors::App.new)), 
      :Port => 9292,
      :server => 'thin'
    )
  end
