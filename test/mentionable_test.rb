# frozen_string_literal: true

require 'test_helper'

class MentionableTest < ActiveSupport::TestCase
  test '.mentionable_name' do
    assert_equal :body, Comment.mentionable_name
    assert_equal :description, Post.mentionable_name
  end

  test '.on_mention' do
    assert_equal :after_mention, Comment.on_mention
    assert_equal :foo, Post.on_mention
  end

  test '.regexp' do
    assert_equal(/@\w+/, Comment.regexp)
    assert_equal(/:\w+/, Post.regexp)
  end

  test '.mentionable_as' do
    assert_equal 'ok',
                 Comment.create(body: '@nobunaga Hi.').instance_variable_get(:@result)

    assert_equal 'ng',
                 Post.create(description: ':nobunaga Hi.').instance_variable_get(:@result)
  end

  test '#extract_mentions' do
    assert_equal ['@nobunaga', '@hideyosi', '@ieyasu'],
                 Comment.new.extract_mentions('@nobunaga @hideyosi @ieyasu Hi guys.')
    assert_equal ['@nobunaga'],
                 Comment.new.extract_mentions('@nobunaga @nobunaga @nobunaga Hi guys.')

    assert_equal [':nobunaga', ':hideyosi', ':ieyasu'],
                 Post.new.extract_mentions(':nobunaga :hideyosi :ieyasu Hi guys.')
    assert_equal [':nobunaga'],
                 Post.new.extract_mentions(':nobunaga :nobunaga :nobunaga Hi guys.')
  end

  test '#mentionable' do
    assert_equal '@nobunaga Hi.', Comment.new(body: '@nobunaga Hi.').mentionable
    assert_equal '@hideyosi Hi.', Post.new(description: '@hideyosi Hi.').mentionable
  end

  test '#mentionable_before_last_save' do
    comment = Comment.create(body: '@nobunaga Hi.')
    assert_nil comment.mentionable_before_last_save
    comment.update(body: '@nobunaga @ieyasu Hi guys.')
    assert_equal '@nobunaga Hi.', comment.mentionable_before_last_save

    post = Post.create(description: '@hideyosi Hi.')
    assert_nil post.mentionable_before_last_save
    post.update(description: '@hideyosi @ieyasu Hi guys.')
    assert_equal '@hideyosi Hi.', post.mentionable_before_last_save
  end

  test '#mentions' do
    assert_equal ['@nobunaga'], Comment.new(body: '@nobunaga Hi.').mentions
    assert_equal [], Comment.new(body: 'Hi.').mentions

    assert_equal [':hideyosi'], Post.new(description: ':hideyosi Hi.').mentions
    assert_equal [], Post.new(description: 'Hi.').mentions
  end

  test '#mentions?' do
    assert Comment.new(body: '@nobunaga Hi.').mentions?
    assert_not Comment.new(body: 'Hi.').mentions?

    assert Post.new(description: ':nobunaga Hi.').mentions?
    assert_not Post.new(description: 'Hi.').mentions?
  end

  test '#mentions_were' do
    comment = Comment.create(body: '@nobunaga Hi.')
    assert_equal [], comment.mentions_were
    comment.update(body: '@nobunaga @ieyasu Hi guys.')
    assert_equal ['@nobunaga'], comment.mentions_were

    post = Post.create(description: ':nobunaga Hi.')
    assert_equal [], post.mentions_were
    post.update(description: ':nobunaga :ieyasu Hi guys.')
    assert_equal [':nobunaga'], post.mentions_were
  end

  test '#new_mentions' do
    comment = Comment.create(body: '@nobunaga Hi.')
    assert_equal ['@nobunaga'], comment.new_mentions
    comment.update(body: '@nobunaga @ieyasu Hi guys.')
    assert_equal ['@ieyasu'], comment.new_mentions

    post = Post.create(description: ':nobunaga Hi.')
    assert_equal [':nobunaga'], post.new_mentions
    post.update(description: ':nobunaga :ieyasu Hi guys.')
    assert_equal [':ieyasu'], post.new_mentions
  end

  test '#new_mentions?' do
    comment = Comment.create(body: 'Hi.')
    assert_not comment.new_mentions?
    comment.update(body: '@nobunaga Hi.')
    assert comment.new_mentions?

    post = Post.create(description: 'Hi.')
    assert_not post.new_mentions?
    post.update(description: ':nobunaga Hi.')
    assert post.new_mentions?
  end
end
