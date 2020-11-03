# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * SMTP e-mail provider
# *
# * Author: Matěj Outlý
# * Date  : 1. 12. 2017
# *
# *****************************************************************************

module Tolliver
  module Services
    module Methods
      class Email
        class Smtp

          def initialize(params = {}) end

          def deliver(notification, notification_receiver)
            Tolliver::NotificationMailer.notify(notification, notification_receiver).deliver_now
          end

        end
      end
    end
  end
end
