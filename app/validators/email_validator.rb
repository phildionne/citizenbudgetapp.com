# http://my.rails-royce.org/2010/07/21/email-validation-in-ruby-on-rails-without-regexp/
class EmailValidator < ActiveModel::EachValidator
  # Domain must be present and have two or more parts.
  def validate_each(record, attribute, value)
    address = Mail::Address.new value
    unless address.address == value && address.domain && address.domain.split('.').size > 1
      record.errors[attribute] << (options[:message] || 'is invalid')
    end
  end
end
