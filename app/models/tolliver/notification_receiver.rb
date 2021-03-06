# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Notification receiver
# *
# * Author: Matěj Outlý
# * Date  : 21. 1. 2016
# *
# *****************************************************************************

module Tolliver
  class NotificationReceiver < ActiveRecord::Base
    include Tolliver::Utils::Enum
    include Tolliver::Models::NotificationReceiver
  end
end
