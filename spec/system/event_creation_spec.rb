require 'constants'
require 'fileutils'

RSpec.describe 'the event creation', type: :feature do
  before do
    @event_folder = File.expand_path("#{Constants::PATH_TO_DATA}/Тестовое системное событие")
    FileUtils.rm_rf(@event_folder) if File.exist?(@event_folder)
    File.open(Constants::PATH_TO_DATABASE, 'w') do |file|
      file << 'Ложкин Дмитрий Николаевич,+7 (911) 453-22-30,' \
      '43-00-21,"Россия, Москва, ул. Глебовская, д. 3, к. 5, кв. 123",Коллега'
    end
  end

  it 'should create event' do
    visit('/')
    click_on('Создать событие')
    fill_in('name', with: 'Тестовое системное событие')
    fill_in('message', with: 'Текст события')
    check('need_insert_address')
    click_on('Создать приглашения')
    expect(page).to have_content('Сообщения успешно созданы')
  end

  after do
    File.delete(Constants::PATH_TO_DATABASE) if File.exist?(Constants::PATH_TO_DATABASE)
    FileUtils.rm_rf(@event_folder) if File.exist?(@event_folder)
  end
end
