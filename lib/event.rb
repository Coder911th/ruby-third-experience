require_relative 'constants'
require_relative 'validators'

class Event
  attr_accessor :name, :status, :message, :need_insert_address

  def self.from_hash(hash)
    Event.new(
      hash['name'].to_s.strip,
      hash['status'].to_s.strip,
      hash['message'].to_s.strip,
      !hash['need_insert_address'].to_s.strip.empty?
    )
  end

  def initialize(name, status, message, need_insert_address)
    @name = name
    @status = status
    @message = message
    @need_insert_address = need_insert_address
  end

  def validate_fields(all_statuses)
    begin
      Validators.check('Название события', name, Validators::NOT_EMPTY)
      Validators.check('Статус', status, Validators::NOT_EMPTY)
      Validators.check('Статус', status, Validators::EXISTS_STATUS, all_statuses)
      Validators.check('Сообщение', message, Validators::NOT_EMPTY)
    rescue Validators::Error => validation_error
      return validation_error.message
    end
    true
  end

  def create_messages(records)
    receivers = records.to_a.delete_if { |record| record.status != status }
    event_folder = File.expand_path("#{Constants::PATH_TO_DATA}/#{name}")
    Dir.mkdir(event_folder)
    receivers.each do |receiver|
      file = File.new(File.expand_path("#{event_folder}/#{receiver.full_name}.txt"), 'w')
      file.puts(receiver.full_name)
      file.puts("Адрес: #{receiver.address}") if need_insert_address && !receiver.address.empty?
      file.puts(message)
      file.close
    end
    receivers
  end
end
