require 'csv'

namespace :import do

  task customer: :environment do
    puts "Importing customers data from csv"
    CSV.foreach("./lib/data/customers.csv", headers: true) do |row|
      Customer.create!(row.to_hash)
    end
  end

  task merchant: :environment do
    puts "Importing merchants data from csv"
    CSV.foreach("./lib/data/merchants.csv", headers: true) do |row|
      Merchant.create!(row.to_hash)
    end
  end

  task invoice: :environment do
    puts "Importing invoices data from csv"
    CSV.foreach("./lib/data/invoices.csv", headers: true) do |row|
      Invoice.create!(row.to_hash)
    end
  end

  task item: :environment do
    puts "Importing items data from csv"
    CSV.foreach("./lib/data/items.csv", headers: true) do |row|
      Item.create!(row.to_hash)
    end
  end

  task invoice_item: :environment do
    puts "Importing InvoiceItems data from csv"
    CSV.foreach("./lib/data/invoice_items.csv", headers: true) do |row|
      InvoiceItem.create!(row.to_hash)
    end
  end

  task transaction: :environment do
    puts "Importing transactions data from csv"
    CSV.foreach("./lib/data/transactions.csv", headers: true) do |row|
      Transaction.create!(row.to_hash)
    end
  end
end
