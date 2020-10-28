# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Notification delivery
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2017
# *
# *****************************************************************************

module Tolliver
  class NotificationDelivery < ActiveRecord::Base
    include Tolliver::Utils::Enum
    include Tolliver::Models::NotificationDelivery
  end
end