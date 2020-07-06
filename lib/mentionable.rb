# frozen_string_literal: true

require 'mentionable/version'

module Mentionable
  REGEXP = /@\w+/.freeze

  def self.included(base)
    base.after_save do
      if self.class.class_variable_defined? :@@on_mention
        send self.class.on_mention, new_mentions if new_mentions?
      end
    end
    base.extend ClassMethods
  end

  module ClassMethods
    def mentionable_as(column, on_mention: :after_mention, regexp: REGEXP)
      klass = name.constantize
      klass.class_variable_set :@@mentionable_name, column
      klass.class_variable_set :@@on_mention, on_mention
      klass.class_variable_set :@@regexp, regexp
    end

    def mentionable_name
      class_variable_get :@@mentionable_name
    end

    def on_mention
      class_variable_get :@@on_mention
    end

    def regexp
      class_variable_get :@@regexp
    end
  end

  def extract_mentions(text)
    text.scan(self.class.regexp).uniq
  end

  def mentionable
    send self.class.mentionable_name
  end

  def mentionable_before_last_save
    send "#{self.class.mentionable_name}_before_last_save"
  end

  def mentions
    extract_mentions(mentionable)
  end

  def mentions?
    mentions.present?
  end

  def mentions_were
    extract_mentions(mentionable_before_last_save || '')
  end

  def new_mentions
    mentions - mentions_were
  end

  def new_mentions?
    new_mentions.present?
  end
end

ActiveSupport.on_load :active_record do
  include Mentionable
end
