class DevicesController < ApplicationController
  def destroy
    Device.find(params[:id]).destroy
    redirect_to edit_user_registration_path current_user
  end
end
