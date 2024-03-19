class TrainingDataController < ApplicationController
  include Format

  # GET: /training_data/new
  def new
    @training_data_form = TrainingDataForm.new
  end

  # POST: /training_data/download
  def download
    @training_data_form = TrainingDataForm.new(training_params)
    if @training_data_form.valid?
      send_data(to_json(training_params[:training_data]), filename: filename)
    else
      render :new
    end
  end

  private

  def training_params
    params.permit(:training_data)
  end

  def filename
    "training_data_#{DateTime.current.strftime('%F%T').gsub(/[:\-]/, '')}.json"
  end
end
