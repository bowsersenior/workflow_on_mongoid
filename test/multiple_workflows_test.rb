test_dir = File.dirname(__FILE__)
$:.unshift test_dir unless $:.include?(test_dir)

require 'test_helper'

class MultipleWorkflowsTest < ActiveRecordTestCase

  test 'multiple workflows' do

    ActiveRecord::Schema.define do
      create_table :bookings do |t|
        t.string :title, :null => false
        t.string :workflow_state
        t.string :workflow_type
      end
    end

    exec "INSERT INTO bookings(title, workflow_state, workflow_type) VALUES('booking1', 'initial', 'workflow_1')"
    exec "INSERT INTO bookings(title, workflow_state, workflow_type) VALUES('booking2', 'initial', 'workflow_2')"

    class Booking < ActiveRecord::Base
      include Workflow
      
      def initialize_workflow
        # define workflow per object instead of per class
        case workflow_type
        when 'workflow_1'
          class << self
            include Workflow
            workflow do
              state :initial do
                event :progress, :transitions_to => :last
              end
              state :last
            end
          end
        when 'workflow_2'
          class << self
            include Workflow
            workflow do
              state :initial do
                event :progress, :transitions_to => :intermediate
              end
              state :intermediate
              state :last
            end
          end
        end
      end

      def metaclass; class << self; self; end; end

      def workflow_spec
        metaclass.workflow_spec
      end

    end

    booking1 = Booking.find_by_title('booking1')
    booking1.initialize_workflow

    booking2 = Booking.find_by_title('booking2')
    booking2.initialize_workflow

    assert booking1.initial?
    booking1.progress!
    assert booking1.last?, 'booking1 should transition to the "last" state'

    assert booking2.initial?
    booking2.progress!
    assert booking2.intermediate?, 'booking2 should transition to the "intermediate" state'

    assert booking1.workflow_spec, 'can access the individual workflow specification'
    assert_equal 2, booking1.workflow_spec.states.length
    assert_equal 3, booking2.workflow_spec.states.length
  end

  class Object
    # The hidden singleton lurks behind everyone
    def metaclass; class << self; self; end; end
  end

end