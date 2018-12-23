require 'constants'

RSpec.describe 'the record addition', type: :feature do
  before do
    File.open(Constants::PATH_TO_DATABASE, 'w') do |file|
      file << 'Ложкин Дмитрий Николаевич,+7 (911) 453-22-30,' \
      '43-00-21,"Россия, Москва, ул. Глебовская, д. 3, к. 5, кв. 123",Коллега'
    end
  end

  it 'should allow to add record' do
    visit('/')
    find('[href^="edit/0"]').click
    fill_in('phone', with: '00-00-00')
    click_on('Сохранить')
    expect(page).to have_content('00-00-00')
  end

  after do
    File.delete(Constants::PATH_TO_DATABASE)  if File.exist?(Constants::PATH_TO_DATABASE)
  end
end
