require_relative 'validators'

Record = Struct.new(:full_name, :mobile, :phone, :address, :status) do
  def self.from_hash(hash)
    Record.new(
      hash['full_name'].to_s.strip,
      hash['mobile'].to_s.strip,
      hash['phone'].to_s.strip,
      hash['address'].to_s.strip,
      hash['status'].to_s.strip
    )
  end

  def validate_fields
    begin
      Validators.check('ФИО', full_name, Validators::TWO_AND_MORE_WORDS)
      Validators.check('Статус', status, Validators::NOT_EMPTY)
    rescue Validators::Error => validation_error
      return validation_error.message
    end
    true
  end

  def to_s
    full_name + mobile + phone + address + status
  end
end
