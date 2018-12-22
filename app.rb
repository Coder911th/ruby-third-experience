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

get '/remove/:id/:hash' do
  records = RecordSet.read_from_db
  if params['hash'] != records.hash
    return erb :alert, locals: {
      type: 'danger',
      message: 'Не удалось удалить запись, набор данных был изменён в другом окне'
    }
  end

  id = params['id'].strip
  if id.to_i.to_s != id
    return erb :alert, locals: {
      type: 'danger',
      message: 'Не удалось удалить запись, передайте число в качестве идентификатора'
    }
  end

  records.remove_by_index(id.to_i).save
  redirect to('/')
end
