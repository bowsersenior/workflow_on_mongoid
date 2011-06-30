require 'workflow'

module Workflow
  module MongoidInstanceMethods
    def load_workflow_state
      send(self.class.workflow_column)
    end

    def persist_workflow_state(new_value)
      self.update_attribute(self.class.workflow_column, new_value)
    end

    private
      def write_initial_state
        send("#{self.class.workflow_column}=", current_state.to_s) if load_workflow_state.blank?
      end
  end

  def self.included(klass)
    klass.send :include, WorkflowInstanceMethods
    klass.extend WorkflowClassMethods
    if Object.const_defined?(:ActiveRecord) && klass < ActiveRecord::Base
      klass.send :include, ActiveRecordInstanceMethods
      klass.before_validation :write_initial_state
    elsif Object.const_defined?(:Remodel) && klass < Remodel::Entity
      klass.send :include, RemodelInstanceMethods
    elsif Object.const_defined?(:Mongoid) && klass < Mongoid::Document
      klass.class_eval do
        klass.send :field, klass.workflow_column
        klass.send :include, MongoidInstanceMethods
        klass.before_validation :write_initial_state
      end
    end
  end
end