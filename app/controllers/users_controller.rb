class UsersController < ApplicationController

    configure do
        enable :sessions
        set :session_secret, "secret"
    end

    get '/signup' do
      if Helpers.is_logged_in?(session)
        redirect to '/tweets'
      end
      erb :"/users/signup"
    end

    post '/signup' do
        if params[:username].empty? || params[:email].empty? || params[:password].empty?
          redirect '/signup'
        end
        user = User.create(:username => params[:username], :email => params[:email], :password => params[:password])
        redirect '/tweets'
    end

    get '/login' do
        if Helpers.is_logged_in?(session)
          redirect to '/tweets'
        end
      
        erb :'users/login'
    end

    post '/login' do
        @user = User.find_by(:username => params["username"])
        
        if @user && @user.authenticate(params[:password])
          session[:user_id] = @user.id
          redirect to '/tweets'
        end
        redirect '/login'
    end

    get '/logout' do
        if (!Helpers.is_logged_in?(session) || Helpers.current_user(session).nil?)
            redirect '/'
        end
        session.clear
        redirect '/login'
    end

    get "/users/:slug" do
        slug = params[:slug]
        @user = User.find_by_slug(slug)
        @tweets = @user.tweets
        erb :'/users/show'
    end

end
