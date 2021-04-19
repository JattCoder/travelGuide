class WelcomeController < ApplicationController

    def index
        render json: {'Message'=>'Welcome To The Ultimate Travel Guide API','Error'=>false}
    end

end