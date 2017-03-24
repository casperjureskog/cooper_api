class Api::V1::PerformanceDataController < ApplicationController
  before_action :authenticate_api_v1_user!

  def create
    @data = PerformanceData.new(performance_data_params.merge(user: current_api_v1_user))

    if @data.save
      render json: { message: 'all good' }
    else
      render json: { error: @data.errors.full_messages }
    end
  end

  def index
     @collection = current_api_v1_user.performance_data
     render json: { entries: @collection }
  end

  def destroy
      signed_out = (PerformanceData.sign_out_all_scopes ? sign_out : sign_out(user: current_api_v1_user))
      set_flash_message! :notice, :signed_out if signed_out
      yield if block_given?
      respond_to_on_destroy
  end

  private

  def performance_data_params
    params.require(:performance_data).permit!
  end


end
