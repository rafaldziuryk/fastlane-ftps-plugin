module Fastlane
  module Helper
    class FtpsHelper
      # class methods that you define here become available in your action
      # as `Helper::FtpsHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the ftps plugin helper!")
      end
    end
  end
end
