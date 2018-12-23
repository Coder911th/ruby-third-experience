require 'event'
require 'record_set'
require 'fileutils'

RSpec.describe Event do
  context '#from_hash' do
    before do
      @event = Event.from_hash(
        'name' => 'Тестовое событие',
        'status' => 'Коллега',
        'message' => 'Добрый день!',
        'need_insert_address' => true
      )
    end

    it 'should read name field from hash' do
      expect(@event.name).to eq('Тестовое событие')
    end

    it 'should read status field from hash' do
      expect(@event.status).to eq('Коллега')
    end

    it 'should read message field from hash' do
      expect(@event.message).to eq('Добрый день!')
    end

    it 'should read need_insert_address field from hash' do
      expect(@event.need_insert_address).to eq(true)
    end
  end

  context '#initialize' do
    before do
      @event = Event.new('Тестовое событие', 'Коллега', 'Добрый день!', true)
    end

    it 'should initialize name field from constructor' do
      expect(@event.name).to eq('Тестовое событие')
    end

    it 'should initialize status field from constructor' do
      expect(@event.status).to eq('Коллега')
    end

    it 'should initialize message field from constructor' do
      expect(@event.message).to eq('Добрый день!')
    end

    it 'should initialize need_insert_address field from constructor' do
      expect(@event.need_insert_address).to eq(true)
    end
  end

  context '#validate_fields' do
    it 'should pass validation successfully (Event name / NOT EMPTY)' do
      expect(Event.new('Тестовое событие', 'Коллега', 'Добрый день!', true).validate_fields(['Коллега'])).to eq(true)
    end

    it 'should fail validation (Event name / NOT EMPTY)' do
      expect(Event.new('', 'Коллега', 'Добрый день!', true).validate_fields(['Коллега'])).to eq(
        'Поле `Название события` обязательно для заполнения'
      )
    end

    it 'should pass validation successfully (Event status / NOT EMPTY)' do
      expect(Event.new('Тестовое событие', 'Коллега', 'Добрый день!', true).validate_fields(['Коллега'])).to eq(true)
    end

    it 'should fail validation (Event status / NOT EMPTY)' do
      expect(Event.new('Тестовое событие', '', 'Добрый день!', true).validate_fields(['Коллега'])).to eq(
        'Поле `Статус` обязательно для заполнения'
      )
    end

    it 'should pass validation successfully (Event status / EXISTS_STATUS)' do
      expect(Event.new('Тестовое событие', 'Коллега', 'Добрый день!', true).validate_fields(['Коллега'])).to eq(true)
    end

    it 'should fail validation (Event status / EXISTS_STATUS)' do
      expect(Event.new('Тестовое событие', 'Коллега', 'Добрый день!', true).validate_fields(['Знакомый'])).to eq(
        'Выбран статус, которого уже нет в базе данных'
      )
    end
  end

  context '#create_messages' do
    before do
      @event = Event.new('Тестовое событие', 'Коллега', 'Добрый день!', true)
      @event_folder = File.expand_path("#{Constants::PATH_TO_DATA}/#{@event.name}")
      @records = RecordSet.new
      @record = Record.from_hash(
        'full_name' => 'Ложкин Дмитрий Николаевич',
        'mobile' => '+7 (911) 453-22-30',
        'phone' => '43-00-21',
        'address' => 'Россия, Москва, ул. Глебовская, д. 3, к. 5, кв. 123',
        'status' => 'Коллега'
      )
      @records.add(@record)
      FileUtils.rm_rf(@event_folder) if File.exist?(@event_folder)
    end

    it 'should create messages' do
      @event.create_messages(@records)
      expect(File.open("#{@event_folder}/Ложкин Дмитрий Николаевич.txt").read).to eq(
        "Ложкин Дмитрий Николаевич\nАдрес: Россия, Москва, ул. Глебовская, д. 3, к. 5, кв. 123\nДобрый день!\n")
    end

    after do
      FileUtils.rm_rf(@event_folder) if File.exist?(@event_folder)
    end
  end
end
