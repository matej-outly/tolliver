# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Notification attachment
# *
# * Author: Matěj Outlý
# * Date  : 27. 10. 2020
# *
# *****************************************************************************

module Tolliver
  class NotificationAttachment < ActiveRecord::Base
    include Tolliver::Models::NotificationAttachment
  end
end