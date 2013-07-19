class BuildUploadsController < ApplicationController
  def new
    @upload = BuildUpload.new(params[:build_upload])

    respond_to do |format|
      if @upload.save
        format.html { render notice: 'Build was successfully uploaded.' }
        format.json { render json: @upload, status: :created }
      else
        format.html { render action: "new" }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end
end
