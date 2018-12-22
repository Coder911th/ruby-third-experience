require 'record'

RSpec.describe Record do
  before do
    @record = Record.from_hash(
      'full_name' => 'Ложкин Дмитрий Николаевич',
      'mobile' => '+7 (911) 453-22-30',
      'phone' => '43-00-21',
      'address' => 'Россия, Москва, ул. Глебовская, д. 3, к. 5, кв. 123',
      'status' => 'Коллега'
    )
  end

  context '#from_hash' do
    it 'should set full_name' do
      expect(@record.full_name).to eq('Ложкин Дмитрий Николаевич')
    end

    it 'should set mobile' do
      expect(@record.mobile).to eq('+7 (911) 453-22-30')
    end

    it 'should set phone' do
      expect(@record.phone).to eq('43-00-21')
    end

    it 'should set address' do
      expect(@record.address).to eq('Россия, Москва, ул. Глебовская, д. 3, к. 5, кв. 123')
    end

    it 'should set status' do
      expect(@record.status).to eq('Коллега')
    end
  end

  context '#validate_fields' do
    it 'should pass validation succesfully' do
      expect(@record.validate_fields).to eq(true)
    end

    it 'should fail validation by full name (at least two words)' do
      expect(Record.new('Дмитрий', '', '11-22-33', '', 'Друг').validate_fields).to eq(
        'Введите хотя бы два слова в поле `ФИО`'
      )
    end

    it 'should fail validation by full name (empty string)' do
      expect(Record.new('', '', '11-22-33', '', 'Друг').validate_fields).to eq('Поле `ФИО` обязательно для заполнения')
    end

    it 'should fail validation by status (empty string)' do
      expect(Record.new('Ложкин Дмитрий', '', '11-22-33', '', '').validate_fields).to eq('Поле `Статус` обязательно для заполнения')
    end
  end

  context '#to_s' do
    it 'should serialize fields' do
      expect(@record.to_s).to eq('Ложкин Дмитрий Николаевич+7 (911) 453-22-3043-00' \
        '-21Россия, Москва, ул. Глебовская, д. 3, к. 5, кв. 123Коллега')
    end
  end
end
