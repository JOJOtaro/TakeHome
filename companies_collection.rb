require 'json'
require_relative 'company'
require_relative 'user'
require_relative 'custom_logger'

class CompaniesCollection
  def initialize
    @companies = []
    @company_look_up = {}
  end

  def load_from_json(file_path)
    data_hash = process_json_array(file_path)
    return unless data_hash

    data_hash.each do |company_hash|
      new_company = Company.create_from_hash company_hash
      next unless new_company
      
      @company_look_up[new_company.id] = new_company
      
      insert_at = @companies.bsearch_index { |company| company > new_company} || @companies.length
      @companies.insert(insert_at, new_company)
    end
  end

  def load_users_from_json(file_path)
    data_hash = process_json_array(file_path)
    return unless data_hash

    data_hash.each do |user_hash|
      new_user = User.create_from_hash user_hash
      next unless new_user
      if @company_look_up.key?(new_user.company_id)
        @company_look_up[new_user.company_id].add_user new_user
      else
        CustomLogger.warn(message: "User #{user_hash} cannot be added to company with id: #{new_user.company_id}")
      end
    end
  end

  def process_json_array(file_path)
    file = File.read(file_path)
    data_hash = JSON.parse(file)
    unless data_hash.kind_of?(Array)
      CustomLogger.error(message: "#{file_path} format is invalid, should be an array of json objects")
      return nil
    end
    return data_hash
  rescue Errno::ENOENT
    CustomLogger.error(message: "#{file_path} is not found")
    return nil
  rescue JSON::ParserError
    CustomLogger.error(message: "#{file_path} is invalid")
    return nil
  end

  def print_to_console
    @companies.select{ |company| company.users.any? }.each {|company| 
      puts company.to_s
    }
  end
end