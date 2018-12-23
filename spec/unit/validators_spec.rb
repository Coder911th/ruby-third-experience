require 'validators'

RSpec.describe Validators do
  context '#check' do
    it 'should pass validation successfully(NOT_EMPTY)' do
      expect(Validators.check('ФИО', 'Дмитрий', Validators::NOT_EMPTY)).to eq(true)
    end

    it 'should throw error (NOT_EMPTY)' do
      expect { Validators.check('ФИО', '', Validators::NOT_EMPTY) }.to raise_error(Validators::Error)
    end

    it 'should pass validation successfully(TWO_AND_MORE_WORDS)' do
      expect(Validators.check('ФИО', 'Ложкин Дмитрий', Validators::TWO_AND_MORE_WORDS)).to eq(true)
    end

    it 'should throw error (TWO_AND_MORE_WORDS / empty)' do
      expect { Validators.check('ФИО', '', Validators::TWO_AND_MORE_WORDS) }.to raise_error(Validators::Error)
    end

    it 'should throw error (TWO_AND_MORE_WORDS / at leat two words)' do
      expect { Validators.check('ФИО', 'Дмитрий', Validators::TWO_AND_MORE_WORDS) }.to raise_error(Validators::Error)
    end

    it 'should pass validation successfully(EXISTS_STATUS)' do
      expect(Validators.check('Статус', 'Друг', Validators::EXISTS_STATUS, %w[Коллега Друг Знакомый])).to eq(true)
    end

    it 'should throw error (EXISTS_STATUS)' do
      expect { Validators.check('Статус', 'Друг', Validators::EXISTS_STATUS, %w[Коллега Знакомый]) }.to raise_error(
        Validators::Error
      )
    end
  end
end
