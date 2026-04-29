require 'rails_helper'

RSpec.describe "Events", type: :request do
  describe "GET /events" do
    it "returns a successful response" do
      get events_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /events" do
    let(:valid_attributes) {
      {
        event: {
          title: 'New Event',
          workload: 10,
          instructor_name: 'Instructor',
          instructor_email: 'inst@example.com',
          period: '2024',
          location: 'Remote'
        }
      }
    }

    it "creates a new Event" do
      expect {
        post events_path, params: valid_attributes
      }.to change(Event, :count).by(1)
    end

    it "redirects to the created event" do
      post events_path, params: valid_attributes
      expect(response).to redirect_to(Event.last)
    end
  end
end
