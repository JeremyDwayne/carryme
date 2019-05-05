class CarriesController < ApplicationController
  before_action :set_carry, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  # GET /carries
  # GET /carries.json
  def index
    columns_array = ["title", "description", "price", "carry_type"]
    search = params[:carry].present? ? params[:carry][:search] : nil
    puts "carries search: #{search}"
    @carries = Carry.search(search, columns_array)
  end

  # GET /carries/1
  # GET /carries/1.json
  def show
  end

  # GET /carries/new
  def new
    @carry = Carry.new
  end

  # GET /carries/1/edit
  def edit
  end

  # POST /carries
  # POST /carries.json
  def create
    @carry = current_user.carries.new(carry_params)

    respond_to do |format|
      if @carry.save
        format.html { redirect_to @carry, notice: 'Carry was successfully created.' }
        format.json { render :show, status: :created, location: @carry }
      else
        format.html { render :new }
        format.json { render json: @carry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carries/1
  # PATCH/PUT /carries/1.json
  def update
    respond_to do |format|
      if @carry.update(carry_params)
        format.html { redirect_to @carry, notice: 'Carry was successfully updated.' }
        format.json { render :show, status: :ok, location: @carry }
      else
        format.html { render :edit }
        format.json { render json: @carry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carries/1
  # DELETE /carries/1.json
  def destroy
    @carry.destroy
    respond_to do |format|
      format.html { redirect_to carries_url, notice: 'Carry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_carry
      @carry = Carry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def carry_params
      params.require(:carry).permit(:title, :description, :carry_type, :price, :user_id)
    end
end
