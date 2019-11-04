class TweetsController < ApplicationController

    configure do
        enable :sessions
        set :session_secret, "secret"
    end

    get '/tweets' do
        @tweets = Tweet.all
        if (!Helpers.is_logged_in?(session) || Helpers.current_user(session).nil?)
          redirect '/login'
        end
        erb :'tweets/index'
    end

    get '/tweets/new' do
        if (!Helpers.is_logged_in?(session) || Helpers.current_user(session).nil?)
            redirect '/login'
        else
            erb :'/tweets/new'
        end
    end

    post '/tweets' do
        user = Helpers.current_user(session)
        if params["content"].empty?
            redirect to '/tweets/new'
        else
            @tweet = Tweet.create(:content => params["content"], :user_id => user.id)
            redirect '/tweets'
        end
    end

    get '/tweets/:id' do
        if !Helpers.is_logged_in?(session)
            redirect to '/login'
        end
        @tweet = Tweet.find(params[:id])
        erb :"tweets/show"
    end

    get '/tweets/:id/edit' do
        if !Helpers.is_logged_in?(session)
            redirect to '/login'
        end
        @tweet = Tweet.find(params[:id])
        erb :'/tweets/edit'
    end

    patch '/tweets/:id' do
        @tweet = Tweet.find(params[:id])
        if params["content"].empty?
            redirect "/tweets/#{@tweet.id}/edit"
        else
            @tweet.update(:content => params[:content])
            @tweet.save
            redirect "/tweets/#{@tweet.id}"
        end
    end

    delete '/tweets/:id/delete' do
        user = Helpers.current_user(session)
        if ((@tweet = Tweet.find_by(id: params[:id])) && (@tweet.user_id == user.id))
          @tweet.delete
          redirect '/tweets'
        else
          redirect '/login'
        end
      end

end
