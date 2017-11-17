class CalendarsController < ApplicationController
  before_action :set_client

  def redirect
    redirect_to @client.authorization_uri.to_s
  end

  def callback
    @client.code = params[:code]
    response = @client.fetch_access_token!
    session[:authorization] = response

    redirect_to  events_url
  end


  def events
    @client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client

    @owner_calendar = service.list_calendar_lists.items.select{ |calendar| calendar.access_role == 'owner' }.first
    @event_list = service.list_events(@owner_calendar.id)
  rescue Google::Apis::AuthorizationError
    response = @client.refresh!

    session[:authorization] = session[:authorization].merge(response)

    retry
  end

  private

    def set_client
      @client = Signet::OAuth2::Client.new(client_options)
    end

    def client_options
      {
          client_id: Rails.application.secrets.google_client_id,
          client_secret: Rails.application.secrets.google_client_secret,
          authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
          token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
          scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
          redirect_uri: 'http://localhost:3000/callback'
      }
    end
end
