require_relative 'companies_collection'

companies = CompaniesCollection.new

companies.load_from_json('./companies.json')
companies.load_users_from_json('./users.json')

companies.print_to_console