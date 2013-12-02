#!/usr/bin/env ruby
require 'CSV'
require 'pry'

class TransactionsImport

  def file_import(file)
    transactions = []
    CSV.foreach(file, headers: true) do |row|
      date = row['date']
      amount = row['amount'].to_f
      description = row['description']
      transactions << Transaction.new(date, amount, description)
    end
    transactions
  end
end

class Transaction
  attr_reader :amount, :date, :date
  def initialize(date, amount, description)
    @date = date
    @amount = amount
    @description = description
  end
end

class Account
  attr_reader :balance

  def initialize(transactions)
    @balance = 0
    @transactions = []
  end

  def add_transaction(transaction)
    @balance += transaction.amount
    @transactions << transaction
  end
end


transactions = TransactionsImport.new
transactions = transactions.file_import('transactions.csv')
account_data = Account.new(transactions)
transactions.each do |transaction|
  account_data.add_transaction(transaction)
end
binding.pry
