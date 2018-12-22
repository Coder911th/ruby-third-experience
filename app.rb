require 'sinatra'
require_relative 'lib/record_set'
require_relative 'lib/input_checker'

helpers InputChecker

get '/' do
  erb :main, locals: { records: RecordSet.read_from_db }
end

get '/add' do
  erb :editor, locals: { new: true }
end

post '/add' do
  new_record = Record.from_hash(params)
  checking_result = check_record(new_record, true)
  return checking_result if checking_result != true

  RecordSet.read_from_db.add(new_record).save
  redirect to('/')
end

get '/remove/:id/:hash' do
  records = RecordSet.read_from_db
  id = params['id']
  checking_result = check_hash_and_id(params, records, id)
  return checking_result if checking_result != true

  records.remove_by_index(id.to_i).save
  redirect to('/')
end

get '/edit/:id/:hash' do
  records = RecordSet.read_from_db
  id = params['id']
  checking_result = check_hash_and_id(params, records, id)
  return checking_result if checking_result != true

  erb :editor, locals: {
    new: false,
    record: records.at(id.to_i)
  }
end

post '/edit/:id/:hash' do
  records = RecordSet.read_from_db
  id = params['id']
  new_record = Record.from_hash(params)
  checking_result = check_hash_id_and_record(params, records, id, new_record, false)
  return checking_result if checking_result != true

  RecordSet.read_from_db.edit(id.to_i, new_record).save
  redirect to('/')
end
