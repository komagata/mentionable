# frozen_string_literal: true

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

module MentionableTestApp
  Application = Class.new(Rails::Application) do
    config.eager_load = false
    config.active_support.deprecation = :log
  end.initialize!
end

class Comment < ActiveRecord::Base
  mentionable_as :body, on_mention: :after_mention, regexp: /@\w+/

  def after_mention(mentions)
    @result = 'ok'
  end
end

class Post < ActiveRecord::Base
  mentionable_as :description, on_mention: :foo, regexp: /:\w+/

  def foo(mentions)
    @result = 'ng'
  end
end

class User < ActiveRecord::Base
end

class CreateAllTables < ActiveRecord::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[5.0] : ActiveRecord::Migration
  def self.up
    create_table(:comments) { |t| t.string :body }
    create_table(:posts) { |t| t.string :description }
    create_table(:users) { |t| t.string :nickname }
  end
end
