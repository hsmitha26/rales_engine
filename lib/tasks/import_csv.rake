# require 'csv'
#
# namespace :import do
#   desc "Import customers data from csv"
#   task customer: :environment do
#     CSV.foreach("./lib/data/customers.csv", headers: true) do |row|
#       Customer.create!(row.to_hash)
#   end
# end
