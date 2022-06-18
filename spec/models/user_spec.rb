require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it 'User名が期待どおりに等しくあること' do
    # expect(user.name).to eq 'My name is test'
    # expect(User.count).to eq 1
  end

  it 'User名が期待どおりに等しくないこと' do
    # expect(user.name).not_to eq 'Your name is test'
    # expect(User.count).to eq 1
  end
end
