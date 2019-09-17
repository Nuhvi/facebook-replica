# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:friend) { FactoryBot.create(:friend) }
  let(:reciever1) { FactoryBot.create(:friend) }
  let(:reciever2) { FactoryBot.create(:friend) }
  let(:friend1) { FactoryBot.create(:friend) }
  let(:friend2) { FactoryBot.create(:friend) }
  let(:sender1) { FactoryBot.create(:friend) }
  let(:sender2) { FactoryBot.create(:friend) }

  describe '#index' do
    before do
      user.friend_request(reciever1)
      user.friend_request(reciever2)
      sender1.friend_request(user)
      sender2.friend_request(user)
      friend1.friend_request(user)
      friend2.friend_request(user)
      user.accept_request(friend1)
      user.accept_request(friend2)
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
          expect(assigns(:friends)).to eq([ friend2, friend1])
        end
      end

      context 'fetching sent requests' do
        it 'sets @friends to user confirmed friends' do
          get :index, params: { user_id: user.id, format: :requests_received }
          expect(assigns(:friends)).to eq([sender2, sender1])
        end
      end

      context 'fetching received requests' do
        it 'sets @friends to user confirmed friends' do
          get :index, params: { user_id: user.id, format: :requests_sent }
          expect(assigns(:friends)).to eq([reciever2, reciever1])
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
        it 'create a non confirmed firendship' do
          expect do
            post :create, params: { user_id: friend.id }
          end.to change(user.friendships, :count).by(1)
        end
      end

      context 'to self' do
        it 'does not create a firendship' do
          expect do
            post :create, params: { user_id: user.id }
          end.not_to change(user.friendships, :count)
        end
      end

      context 'to already existing friendship' do
        it 'does not create a firendship' do
          user.friend_request(friend)
          friend.accept_request(user)
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
    before do
      friend.friend_request(user)
    end

    context 'as an authenticated user' do
      before { sign_in user }

      it 'confirms the friendship' do
        post :update, params: { user_id: friend.id }
        expect(user.friends_with?(friend)).to be true
      end
    end

    context 'as an unauthorized user' do
      before { sign_in other_user }

      it 'doesnt udpate the post' do
        post :update, params: { user_id: friend.id }
        expect(user.friends_with?(friend)).to be false
      end
    end

    context 'as a guest' do
      before { post :update, params: { user_id: friend.id } }
      it 'doesnt confirm friendship' do
        expect(user.friends_with?(friend)).to be false
      end

      it 'redirects to the sign-in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#destroy' do
    before do
      user.friend_request(friend)
      friend.accept_request(user)
    end

    context 'as an authenticated user' do
      before { sign_in user }

      it '.reject request' do
        sender1.friend_request(user)
        expect do
          delete :destroy, params: { user_id: sender1.id, format: :reject_request }
        end.to change(user.requested_friends, :count).by(-1)
      end

      it '.cancel request' do
        user.friend_request(reciever1)
        expect do
          delete :destroy, params: { user_id: reciever1.id, format: :cancel_request }
        end.to change(user.pending_friends, :count).by(-1)
      end

      it 'unfriend existing friend' do
        expect do
          delete :destroy, params: { user_id: friend.id }
        end.to change(user.friends, :count).by(-1)
      end

      it 'redirects to the root url' do
        delete :destroy, params: { user_id: friend.id }
        expect(response).to redirect_to root_url
      end
    end

    context 'as an unauthorized user' do
      before { sign_in other_user }

      it "doesn't remove a friendship" do
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
