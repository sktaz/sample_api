# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
    # # app/controllers/concerns/secured.rbをincludeする
    include Secured
end
