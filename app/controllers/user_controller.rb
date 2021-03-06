class UserController < ApplicationController
  # before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:show, :edit, :update, :destroy]
  after_action :sync_characters, only: [:create]

  # GET /users/1
  # GET /users/1.json
  def show
    @characters = current_user.characters
  end

  def sync_characters
    region = "us"
    path = "wow/user/characters"
    @response = HTTParty.get("https://#{region}.api.blizzard.com/#{path}", {
      headers: { "Authorization": "Bearer #{session[:bnet_access_token]}" }
    }).parsed_response["characters"]
    current_user.sync_characters(@response)
    redirect_to current_user
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:title, :description, :user_type, :price, :user_id)
    end

end
