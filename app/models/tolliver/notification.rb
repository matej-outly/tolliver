# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Notification
# *
# * Author: Matěj Outlý
# * Date  : 21. 1. 2016
# *
# *****************************************************************************

module Tolliver
  class Notification < ActiveRecord::Base
    include Tolliver::Utils::Enum
    include Tolliver::Models::Notification
  end
end
