require 'test_helper'

class MakeAPlayTest < ActionDispatch::IntegrationTest
  def test_a_word_is_played_and_scored
    visit '/plays'
    click_link_or_button 'Play New Word'
    fill_in 'play[word]', :with => "HELLO"
    click_link_or_button 'Play!'
    assert_equal '/plays', current_path

    within('#plays li:first') do
      assert page.has_content?('hello')
      assert page.has_content?('8')
    end
  end

  def test_blank_word_is_not_played_and_can_be_corrected
    visit '/plays'
    click_link_or_button 'Play New Word'
    fill_in 'play[word]', :with => ""
    click_link_or_button 'Play!'

    within('#errors') do
      assert page.has_content?('blank')
    end

    fill_in 'play[word]', :with => "fixed"
    click_link_or_button 'Play!'

    assert_equal '/plays', current_path
    refute page.has_css?('#errors')
  end

  def test_words_with_non_letters_are_rejected
    visit '/plays'
    click_link_or_button 'Play New Word'

    fill_in 'play[word]', :with => 'boom!'
    click_link_or_button 'Play!'
    assert page.has_css?("#errors")

    fill_in 'play[word]', :with => '37nums'
    click_link_or_button 'Play!'
    assert page.has_css?("#errors")

    fill_in 'play[word]', :with => 'ok'
    click_link_or_button 'Play!'
    assert_equal '/plays', current_path
  end

  def test_a_play_is_deleted

    play1 = Play.create(word: 'hello')
    play2 = Play.create(word: 'pizza')
    play3 = Play.create(word: 'beer')

    visit '/plays'
    assert page.has_css? ("li#play#{play1.id}")
    within(:css, "li#play#{play1.id}") do
      click_link_or_button 'Delete'
    end
    assert_equal '/plays', current_path
    refute page.has_css?("#play#{play1.id}")
  end
end
