require 'constants'

RSpec.describe 'the record editing', type: :feature do
  before do
    File.open(Constants::PATH_TO_DATABASE, 'w') do |file|
      file << 'Ложкин Дмитрий Николаевич,+7 (911) 453-22-30,' \
      '43-00-21,"Россия, Москва, ул. Глебовская, д. 3, к. 5, кв. 123",Коллега'
    end
  end

  it 'should edit first record' do
    visit('/')
    find('[href^="edit/0"]').click
    fill_in('phone', with: '00-00-00')
    click_on('Сохранить')
    expect(page).to have_content('00-00-00')
  end

  it 'should alert about bad hash' do
    visit('/edit/0/290219308c4d7c69429cc8d00c96e384')
    expect(page).to have_content('Не удалось совершить действие над записями, набор данных был изменён в другом окне')
  end

  it 'should alert about bad id' do
    visit('/edit/not-number/425a2b9a62fad182439c0e29f3018a54')
    expect(page).to have_content('Не удалось совершить действие над записями, передайте число в качестве идентификатора')
  end

  after do
    File.delete(Constants::PATH_TO_DATABASE) if File.exist?(Constants::PATH_TO_DATABASE)
  end
end
