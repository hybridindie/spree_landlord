module Spree
  module SpreeLandlord
    module Support

      module SkippableMethod
        module ClassMethods

          protected
          def __skip_method(*args);end

          def skip_and_restore_method(*method_names,&block)
            method_names.each do |method_name|
              instance_eval <<-EVAL
            alias #{method_name}_skipped #{method_name}
            alias #{method_name} __skip_method
              EVAL
            end

            yield

            method_names.each do |method_name|
              instance_eval <<-EVAL
            alias #{method_name} #{method_name}_skipped
            undef #{method_name}_skipped
              EVAL
            end
          end
        end

        def self.included(receiver)
          receiver.extend         ClassMethods
        end
      end

    end
  end
end

