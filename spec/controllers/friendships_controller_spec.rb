# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:friend) { FactoryBot.create(:friend) }

  describe '#create' do
    context 'as an authenticated user' do
      before { sign_in user }

      context 'to a non friend nor self' do
        it 'create a non confirmed firendhip' do
          expect do
            post :create, params: { user_id: friend.id }
          end.to change(user.friendships, :count).by(1)
        end
      end

      context 'to self' do
        it 'does not add a project' do
          expect do
            post :create, params: { user_id: user.id }
          end.not_to change(user.friendships, :count)
        end
      end

      context 'to already existing friendship' do
        it 'does not add a project' do
          FactoryBot.create(:friendship, user: user, friend: friend)
          expect do
            post :create, params: { user_id: friend.id }
          end.not_to change(user.friendships, :count)
        end
      end
    end

    context 'as an unauthorized user' do
      before { sign_in other_user }

      it "doesn't create a friendship" do
        expect do
          post :create, params: { user_id: friend.id }
        end.not_to change(user.friendships, :count)
      end
    end

    context 'as a guest' do
      before { post :create, params: { user_id: friend.id } }
      it 'doesnt respond successfully' do
        expect(response).not_to be_successful
      end

      it 'redirects to the sign-in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#destroy' do
    before { FactoryBot.create(:friendship, user: user, friend: friend) }

    context 'as an authenticated user' do
      before { sign_in user }

      it 'delete friendship' do
        expect do
          delete :destroy, params: { user_id: friend.id }
        end.to change(user.friendships, :count).by(-1)
      end

      it 'redirects to the root url' do
        delete :destroy, params: { user_id: friend.id }
        expect(response).to redirect_to root_url
      end
    end

    context 'as an unauthorized user' do
      before { sign_in other_user }

      it "doesn't delete a post" do
        expect do
          delete :destroy, params: { user_id: friend.id }
        end.not_to change(user.friendships, :count)
      end
    end

    context 'as a guest' do
      it 'doesnt delete the post' do
        expect do
          delete :destroy, params: { user_id: friend.id }
        end.not_to change(user.friendships, :count)
      end
    end
  end
end
