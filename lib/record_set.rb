require 'csv'
require 'English'
require 'digest'
require_relative 'record'
require_relative 'constants'

class RecordSet
  include Enumerable

  def each
    @records.each { |record| yield record }
  end

  def self.read_from_db
    record_set = RecordSet.new
    record_size = Record.new.length
    return record_set if !File.file?(Constants::PATH_TO_DATABASE)

    CSV.foreach(Constants::PATH_TO_DATABASE) do |line|
      raise "В строке #{$INPUT_LINE_NUMBER} ожидалось #{record_size} столбцов" if line.size != record_size

      record_set.add(Record.new(*line))
    end

    record_set
  end

  def initialize
    @records = []
  end

  def add(record)
    @records.append(record)
    self
  end

  def remove_by_index(id)
    @records.delete_at(id)
    self
  end

  def edit(id, new_record)
    @records[id] = new_record
    self
  end

  def size
    @records.size
  end

  def at(index)
    @records[index]
  end

  def save
    CSV.open(Constants::PATH_TO_DATABASE, 'wb') { |file| @records.each { |record| file << record.to_a } }
  end

  def hash
    data = ''
    @records.each { |record| data += record.to_s }
    Digest::MD5.hexdigest(data)
  end
end
