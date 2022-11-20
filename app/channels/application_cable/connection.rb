module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :connected_user

    def connect
      self.connected_user = get_user
    end

    private

    def get_user
      cookies['_blog_session'] || reject_unauthorized_connection
    end
  end
end
