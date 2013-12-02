#!/usr/bin/env ruby
require 'CSV'
require 'pry'
class TransactionsImport

  def file_import(file)
    account = Account.new
    transactions = []
    CSV.foreach(file, headers: true) do |row|
      date = row['date']
      amount = row['amount'].to_f
      description = row['description']
      transaction = Transaction.new(date, amount, description)
      transactions << transaction
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
  attr_reader :transactions

  def initialize
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
account.add_transaction(transaction)
