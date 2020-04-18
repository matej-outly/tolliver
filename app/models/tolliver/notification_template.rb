# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Notification template
# *
# * Author: Matěj Outlý
# * Date  : 9. 5. 2016
# *
# *****************************************************************************

module Tolliver
  class NotificationTemplate < ActiveRecord::Base
    include Tolliver::Utils::Enum
    include Tolliver::Models::NotificationTemplate
  end
end
