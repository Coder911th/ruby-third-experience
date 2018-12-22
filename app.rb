require 'sinatra'
require_relative 'lib/record_set'

get '/' do
  erb :main, locals: { records: RecordSet.read_from_db }
end

get '/add' do
  erb :editor, locals: { new: true }
end

post '/add' do
  new_record = Record.from_hash(params)
  validation_result = new_record.validate_fields
  if validation_result != true
    return erb :editor, locals: {
      new: true,
      error_message: validation_result,
      record: new_record
    }
  end

  RecordSet.read_from_db.add(new_record).save
  redirect to('/')
end
