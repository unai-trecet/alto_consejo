RSpec.shared_examples 'not_logged_in' do
  it 'returns 401 status' do
    call_action

    expect(response).to redirect_to(new_user_session_path)
  end
end
