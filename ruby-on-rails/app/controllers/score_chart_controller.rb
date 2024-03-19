class ScoreChartController < ApplicationController
  include ChartManager
  before_action :clear_tmp_charts, only: [:new]
  before_action :redirect_to_new_score_chart_url, only: [:draw, :download]

  # GET: /score_chart/new
  def new
    @score_chart_form = ScoreChartForm.new
  end

  # POST: /score_chart
  def create
    @score_chart_form = ScoreChartForm.new(test_params)
    if @score_chart_form.valid?
      accuracy_check_query = AccuracyCheckQuery.new(test_params)
      begin
        res_bodies = accuracy_check_query.res_bodies
      rescue SocketError
        flash[:alert] = 'Host is invalid'
        render :new and return
      end

      chart_drawer = ChartDrawer.new(test_params[:test_data], res_bodies)
      begin
        csv_chart = chart_drawer.csv
      rescue NoMethodError
        flash[:alert] = 'BotID, UserID or AccessToken is invalid'
        render :new and return
      end

      save_chart(filename, csv_chart)
      redirect_to score_chart_draw_url
    else
      render :new
    end
  end

  # GET: /score_chart/draw
  def draw
    @chart = matrix_chart
  end

  #GET: /score_chart/download
  def download
    send_file(tmp_chart, filename: filename)
  end

  private

  def test_params
    params.permit(:scheme, :host, :bot_id, :user_id, :access_token, :test_data)
  end

  def filename
    "accuracy_score_chart_#{DateTime.current.strftime('%F%T').gsub(/[:\-]/, '')}.csv"
  end

  def redirect_to_new_score_chart_url
    redirect_to new_score_chart_url and return unless tmp_chart
  end
end
