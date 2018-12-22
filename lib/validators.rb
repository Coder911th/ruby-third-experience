module Validators
  class Error < RuntimeError; end
  NOT_EMPTY = ->(name, value) { value.size.zero? ? "Поле `#{name}` обязательно для заполнения" : true }
  TWO_AND_MORE_WORDS = lambda do |name, value|
    not_empty_result = NOT_EMPTY.call(name, value)
    return not_empty_result if not_empty_result != true

    value.include?(' ') ? true : "Введите хотя бы два слово в поле `#{name}`"
  end
  EXISTS_STATUS = lambda do |_, value, all_statuses|
    all_statuses.include?(value) ? true : 'Выбран статус, которого уже нет в базе данных'
  end

  def self.check(name, value, validator, meta = nil)
    result = meta.nil? ? validator.call(name, value) : validator.call(name, value, meta)
    raise Validators::Error, result if result != true

    true
  end
end
