# frozen_string_literal: true
RSpec.shared_examples 'action not allowed for guests' do
  context 'guest tries to access' do

    it 'redirects an unauthenticated visitor' do
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, scope: :user)
      subject
      expect(response).to redirect_to new_user_session_path
      expect(controller).to set_flash[:alert].to 'You need to sign in or sign up before continuing.'
    end
  end
end

RSpec.shared_examples 'action that is allowed for guests' do
  context 'guest tries to access' do
    it 'works for guests' do
      allow(controller).to receive(:current_user).and_return nil
      subject
      expect(response).to have_http_status :success
      expect(controller).not_to set_flash
    end
  end
end

RSpec.shared_examples 'calls authorize with' do |model|
  it 'calls authorize' do
    expect(controller).to receive(:authorize).with(model)
    subject
  end
end

RSpec.shared_examples 'action to be authorized with logged in user' do |model|
  include_context 'user is logged in' do
    include_examples 'calls authorize with', model
  end
end

RSpec.shared_examples 'redirects unauthorized user' do
  it 'redirects and says why' do
    allow(controller).to receive(:authorize).and_raise Pundit::NotAuthorizedError
    subject
    expect(response).to have_http_status :redirect
    expect(controller).to set_flash[:alert].to 'You are not authorized to perform this action'
  end
end

RSpec.shared_examples 'successful request' do
  it 'returns success status code' do
    subject
    expect(response).to have_http_status :success
  end
end
