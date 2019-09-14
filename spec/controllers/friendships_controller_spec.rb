# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:friend) { FactoryBot.create(:friend) }

  describe '#index' do
    let(:reciever1) { FactoryBot.create(:friend) }
    let(:reciever2) { FactoryBot.create(:friend) }
    let(:friend1) { FactoryBot.create(:friend) }
    let(:friend2) { FactoryBot.create(:friend) }
    let(:sender1) { FactoryBot.create(:friend) }
    let(:sender2) { FactoryBot.create(:friend) }
    before do
      FactoryBot.create(:friendship, user: user, friend: reciever1)
      FactoryBot.create(:friendship, user: user, friend: reciever2)
      FactoryBot.create(:friendship, :confirmed, user: user, friend: friend1)
      FactoryBot.create(:friendship, :confirmed, user: user, friend: friend2)
      FactoryBot.create(:friendship, user: sender1, friend: user)
      FactoryBot.create(:friendship, user: sender2, friend: user)
    end
    context 'as an authenticated user' do
      before { sign_in user }

      it 'responds successfully' do
        get :index, params: { user_id: user.id }
        expect(response).to be_successful
      end

      context 'fetching confirmed friends' do
        it 'sets @friends to user confirmed friends' do
          get :index, params: { user_id: user.id }
          expect(assigns(:friends)).to match_array([friend1, friend2])
        end
      end

      context 'fetching sent requests' do
        it 'sets @friends to user confirmed friends' do
          get :index, params: { user_id: user.id, format: :requests_recieved }
          expect(assigns(:friends)).to match_array([sender1, sender2])
        end
      end

      context 'fetching recieved requests' do
        it 'sets @friends to user confirmed friends' do
          get :index, params: { user_id: user.id, format: :requests_sent }
          expect(assigns(:friends)).to match_array([reciever1, reciever2])
        end
      end
    end

    context 'as a guest' do
      before { get :index, params: { user_id: user.id } }
      it 'doesnt respond successfully' do
        expect(response).not_to be_successful
      end
      it 'redirects to sign in path' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

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

  describe 'update' do
    before { FactoryBot.create(:friendship, user: friend, friend: user) }

    context 'as an authenticated user' do
      before { sign_in user }

      it 'confirms the friendship' do
        post :update, params: { user_id: friend.id }
        expect(Friendship.last.confirmed).to be true
      end
    end

    context 'as an unauthorized user' do
      before { sign_in other_user }

      it 'doesnt udpate the post' do
        post :update, params: { user_id: friend.id }
        expect(Friendship.last.confirmed).to be false
      end
    end

    context 'as a guest' do
      before { post :update, params: { user_id: friend.id } }
      it 'doesnt confirm friendship' do
        expect(Friendship.last.confirmed).to be false
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
