require 'record_set'

RSpec.describe RecordSet do
  before do
    @records = RecordSet.new
    @record = Record.from_hash(
      'full_name' => 'Ложкин Дмитрий Николаевич',
      'mobile' => '+7 (911) 453-22-30',
      'phone' => '43-00-21',
      'address' => 'Россия, Москва, ул. Глебовская, д. 3, к. 5, кв. 123',
      'status' => 'Коллега'
    )
    @secord_record = @record.clone
    @secord_record.status = 'Знакомый'
  end

  context '#add' do
    it 'should increase record set size' do
      expect(@records.add(@record).size).to eq(1)
    end
  end

  context '#remove_by_index' do
    it 'should record set size be zero' do
      expect(@records.add(@record).remove_by_index(0).size).to eq(0)
    end
  end

  context '#edit' do
    it 'should change statud field' do
      expect(@records.add(@record).edit(0, @secord_record).at(0).status).to eq('Знакомый')
    end
  end

  context '#size' do
    it 'should size be 3' do
      expect(@records.add(@record).add(@record).add(@record).size).to eq(3)
    end
  end

  context '#at' do
    it 'should return the same record at zero position' do
      expect(@records.add(@record).at(0)).to eq(@record)
    end
  end

  context '#hash' do
    it 'should return hash' do
      expect(@records.add(@record).hash).to eq('425a2b9a62fad182439c0e29f3018a54')
    end
  end

  context '#all_statuses' do
    it 'should return two statuses' do
      expect(@records.add(@record).add(@secord_record).all_statuses).to eq(Set.new(%w[Коллега Знакомый]))
    end
  end

  context 'testing database' do
    before do
      File.open(Constants::PATH_TO_DATABASE, 'w') do |file|
        file.write('Ложкин Дмитрий Николаевич,+7 (911) 453-22-30,43-00-21,' \
          '"Россия, Москва, ул. Глебовская, д. 3, к. 5, кв. 123",Коллега')
      end
    end

    context '#read_from_db' do
      it 'should read test database from the file' do
        expect(RecordSet.read_from_db.at(0)).to eq(@record)
      end
    end

    context '#save' do
      it 'should save two records' do
        RecordSet.new.add(@record).add(@record).save
        expect(RecordSet.read_from_db.at(1)).to eq(@record)
      end
    end

    after do
      File.delete(Constants::PATH_TO_DATABASE)
    end
  end
end
