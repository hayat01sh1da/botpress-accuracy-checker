require 'rails_helper'

RSpec.describe TopController, type: :request do
  describe '#new' do
    before do
      get top_path
    end

    it 'returns a successful status code' do
      expect(response).to have_http_status(200)
    end

    it 'returns a page title' do
      expect(response.body).to include('<h1>Botpress Accuracy Checker</h1>')
    end

    it 'returns a list of linked pages' do
      expect(response.body).to include('<li class="list-group-item"><a href="/training_data/new">Create JSON Training Data</a></li>')
      expect(response.body).to include('<li class="list-group-item"><a href="/score_chart/new">Create Score Chart</a></li>')
    end
  end
end
