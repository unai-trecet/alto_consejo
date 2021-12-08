RSpec.shared_examples 'not_logged_in' do
  it 'redirects to login page' do
    call_action

    expect(response).to redirect_to(new_user_session_path)
  end
end
