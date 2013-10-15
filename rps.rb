   require 'rack/request'
   require 'rack/response'
   require 'haml'
   
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
            "Elige Rock Paper o Scissors para empezar a jugar:"
          elsif player_throw == computer_throw
            "Empate"
          elsif computer_throw == @defeat[player_throw]
            "Ganaste; #{player_throw} vence a #{computer_throw}."
          
                    else
            "Ouch Perdiste; #{computer_throw} vence a #{player_throw}."
          end
  
			engine = Haml::Engine.new File.open("views/index.html.haml").read
			res = Rack::Response.new
			res.write engine.render({},
				:anwser => anwser)
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
