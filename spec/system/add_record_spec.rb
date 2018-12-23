require 'constants'

RSpec.describe 'the record addition', type: :feature do
  before do
    File.delete(Constants::PATH_TO_DATABASE) if File.exist?(Constants::PATH_TO_DATABASE)
  end

  it 'should allow to add record' do
    visit('/add')
    fill_in('full_name', with: 'Тестовый Пользователь')
    fill_in('mobile', with: '+7 (999) 100-30-50')
    fill_in('phone', with: '44-10-23')
    fill_in('status', with: 'Тестовая запись')
    click_on('Сохранить')
    expect(page).to have_content('Тестовый Пользователь')
  end

  after do
    File.delete(Constants::PATH_TO_DATABASE) if File.exist?(Constants::PATH_TO_DATABASE)
  end
end
