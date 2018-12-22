module InputChecker
  def check_hash(params, records)
    if params['hash'] != records.hash
      return erb :alert, locals: {
        type: 'danger',
        message: 'Не удалось совершить действие над записями, набор данных был изменён в другом окне'
      }
    end
    true
  end

  def check_id(id, records)
    id = id.to_s
    error_message = nil

    if id.to_i.to_s != id
      error_message = 'Не удалось совершить действие над записями, передайте число в качестве идентификатора'
    end

    id = id.to_i
    error_message = 'Передан недопустимый идентификатор записи' if id < 0 || id >= records.size

    if error_message.nil?
      return erb :alert, locals: {
        type: 'danger',
        message: error_message
      }
    end
    true
  end

  def check_hash_and_id(params, records, id)
    result_hash_checking = check_hash(params, records)
    return result_hash_checking if result_hash_checking != true

    result_id_checking = check_id(records, id)
    return result_id_checking if result_id_checking != true

    true
  end

  def check_record(record, is_new)
    validation_result = record.validate_fields
    if validation_result != true
      return erb :editor, locals: {
        new: is_new,
        error_message: validation_result,
        record: record
      }
    end
    true
  end

  def check_hash_id_and_record(params, records, id, record, is_new)
    result_hash_and_id_checking = check_hash_and_id(params, records, id)
    return result_hash_and_id_checking if result_hash_and_id_checking != true

    result_record_checking = check_record(record, is_new)
    return result_record_checking if result_record_checking != true

    true
  end
end
