require 'rails_helper'
RSpec.describe 'Books', type: :request do

  let(:ruby_microscope) { create(:ruby_microscope) }
  let(:rails_tutorial) { create(:ruby_on_rails_tutorial) }
  let(:agile_web_dev) { create(:agile_web_development) }

  let(:books) { [ruby_microscope, rails_tutorial, agile_web_dev] }

  describe 'GET /api/books' do

    before do
      books
    end

    context 'when fields are passed' do
      before do
        get '/api/books?fields=id,title,author_id'
      end

      it 'gets books with only the id, title and author_id keys' do
        json_body['data'].each do |book|
          expect(book.keys).to eq ['id', 'title', 'author_id']
        end
      end
    end

    context 'default behaviour' do
      before do
        get '/api/books'
      end

      it 'receives 200 status' do
        expect(response.status).to eq(200)
      end

      it { expect(json_body['data']).to_not be_nil }

      it { expect(json_body['data'].size).to eq(3) }

      it 'gets books all keys' do
        json_body['data'].each do |book|
          expect(book.keys).to eq BookPresenter.build_attributes.map(&:to_s)
        end
      end
    end
  end
end