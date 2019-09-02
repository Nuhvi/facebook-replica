# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe '#new' do
    context 'as an authenticated user' do
      before { @user = FactoryBot.create(:user) }

      it 'responds successfully' do
        sign_in @user
        get :new
        expect(response).to be_successful
      end
    end

    context 'as a guest' do
      it 'responds successfully' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
