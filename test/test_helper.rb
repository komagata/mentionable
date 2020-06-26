# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rails'
require 'active_record'

require 'mentionable'

require 'dummy_app'
require 'test/unit/rails/test_help'

CreateAllTables.up unless ActiveRecord::Base.connection.table_exists? 'comments'
