# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe '#show' do
    before { @user = FactoryBot.create(:user) }
    it 'responds successfully' do
      get :show, params: { id: @user.id }
      expect(response).to be_successful
    end
  end
end
