class Company
  include Comparable

  attr_reader :id, :users

  class << self
    @@schema = {
      "type" => "object",
      "required" => ["id", "name"],
      "properties" => {
        "id" => {"type" => "integer"},
        "name" => {"type" => "string"},
      }
    }

    def create_from_hash(company_hash)
      unless JSON::Validator.validate(@@schema, company_hash)
        CustomLogger.warn(message: "Invalid company: #{company_hash}")
        return nil
      end

      Company.new(id: company_hash['id'], 
        name: company_hash['name'], 
        top_up: company_hash['top_up'], 
        email_status: company_hash['email_status'])
    end
  end

  def initialize(id:, name:, top_up: 0, email_status: false)
    @id = id
    @name = name
    @top_up = top_up
    @email_status = email_status
    @users = []
    @total_top_up = 0
  end

  def add_user(new_user)
    insert_at = @users.bsearch_index { |user| user > new_user}
    unless insert_at
      @users << new_user
    else
      @users.insert(insert_at, new_user)
    end
    
    if new_user.active_status
      new_user.top_up @top_up
      @total_top_up += @top_up
    end
  end

  def <=>(other_company)
    @id <=> other_company.id
  end

  def to_s()
    emailed_users = ""
    not_emailed_users = ""
    @users.select { |user| user.email_status && user.active_status }.each{ |user| emailed_users += user.to_s}
    @users.select { |user| !user.email_status && user.active_status }.each{ |user| not_emailed_users += user.to_s}
    "  Company Id: #{@id}\n" + 
    "  Company Name: #{@name}\n" +
    "  Users emailed:\n" +
    emailed_users + 
    "  Users not emailed:\n" +
    not_emailed_users +
    "  Total amount of top ups for #{@name}: #{@total_top_up.to_s}\n\n"
  end
end