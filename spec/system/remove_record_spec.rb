require 'constants'

RSpec.describe 'the record removing', type: :feature do
  before do
    File.open(Constants::PATH_TO_DATABASE, 'w') do |file|
      file << 'Ложкин Дмитрий Николаевич,+7 (911) 453-22-30,' \
      '43-00-21,"Россия, Москва, ул. Глебовская, д. 3, к. 5, кв. 123",Коллега'
    end
  end

  it 'should remove all records' do
    visit('/')
    find('[href^="remove/0"]').click
    expect(page).to have_content('Нет ни одной записи')
  end

  after do
    File.delete(Constants::PATH_TO_DATABASE) if File.exist?(Constants::PATH_TO_DATABASE)
  end
end
