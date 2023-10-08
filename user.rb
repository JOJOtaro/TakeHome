require 'json-schema'

class User
  include Comparable

  attr_reader :last_name, :company_id, :active_status, :email_status

  class << self
    @@schema = {
      "type" => "object",
      "required" => ["id", "last_name", "company_id"],
      "properties" => {
        "id" => {"type" => "integer"},
        "last_name" => {"type" => "string"},
        "company_id" => {"type" => "integer"}
      }
    }

    def create_from_hash(user_hash)
      unless JSON::Validator.validate(@@schema, user_hash)
        CustomLogger.warn(message: "Invalid user: #{user_hash}")
        return nil
      end

      User.new(id: user_hash['id'], 
        first_name: user_hash['first_name'], 
        last_name: user_hash['last_name'], 
        email: user_hash['email'], 
        company_id: user_hash['company_id'], 
        email_status: user_hash['email_status'], 
        active_status: user_hash['active_status'], 
        tokens: user_hash['tokens'])
    end
  end

  def initialize(id:, first_name:, last_name:, email:, company_id:, email_status: false, active_status: false, tokens: 0)
    @id = id
    @first_name = first_name
    @last_name = last_name
    @email = email
    @company_id = company_id
    @email_status = email_status
    @active_status = active_status
    @tokens = tokens
    @previous_token_balance = 0
  end

  def top_up(amount)
    @previous_token_balance = @tokens
    @tokens += amount
  end

  def <=>(other_user)
    @last_name <=> other_user.last_name
  end

  def to_s
    "    " + @last_name + ", " + @first_name + ", " + @email + "\n" +
    "      Previous Token Balance, " + @previous_token_balance.to_s + "\n" +
    "      New Token Balance, " + @tokens.to_s + "\n"

  end
end