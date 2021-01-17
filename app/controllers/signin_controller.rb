class SigninController < ApplicationController
  before_action :authorize_access_request!, only: [:destroy]

  def create
    user = User.find_by!(full_name: params[:full_name])
    if user.authenticate(params[:password])
      payload  = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      tokens = session.login

      response.set_cookie(JWTSessions.access_cookie,
                          value: tokens[:access],
                          httponly: true,
                          same_site: (Rails.env.production? ? :none : :lax),
                          secure: Rails.env.production?)
      render json: { csrf: tokens[:csrf] }
    else
      not_authorized
    end
  end

  def destroy
    session = JWTSessions::Session.new(payload: payload)
    session.flush_by_access_payload
    render json: :ok
  end

  private

  def not_found
    render json: { error: 'Cannont find such name/password combination' }, status: :not_found
  end
end