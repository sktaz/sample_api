# app/controllers/profiles_controller.rb
class ProfilesController < ApplicationController
    # APIの処理が呼び出される前にaccess_tokenの検証処理を実行する
    before_action :authorize

    def index

        render :json => {id: 123, address: "東京都タワーサンプルホテル1丁目3番地"}
    end
end
