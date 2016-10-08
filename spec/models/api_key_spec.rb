require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  let(:key) { create(:api_key) }

  it 'is valid' do
    expect(key).to be_valid
  end

  describe '#disable' do
    it 'disables the key' do
      key.disable
      expect(key.reload.active).to eq false
    end
  end
end
