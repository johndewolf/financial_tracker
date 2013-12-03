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
  attr_reader :date, :amount, :description, :balance
  def initialize(date, amount, description, balance = nil)
    @date = date
    @amount = amount
    @description = description
    @balance = balance
  end
end

class Account
  attr_reader :account_balance, :transactions

  def initialize
    @account_balance = 0
    @transactions = []
    @overdrafts = []
  end

  def add_transaction(transaction)
    @account_balance += transaction.amount
    if @account_balance < 0
      @overdrafts << Transaction.new(transaction.date, transaction.amount, transaction.description, @account_balance)
      @transactions << Transaction.new(transaction.date, -20, 'Overdraft', @account_balance)
      @account_balance += -20
    end
    @transactions << transaction
  end

  def income_summary
    income = []
    @transactions.each do |transaction|
      if transaction.amount > 0
        income << transaction.amount
      end
    end
    income.inject (:+)
  end

  def expense_summary
    expenses = []
    @transactions.each do |transaction|
      if transaction.amount < 0
        expenses << transaction.amount
      end
    end
    expenses.inject (:+)
  end

  def overdraft_total
    @overdrafts.count * 20
  end

  def overdraft_summary
    @overdrafts.each do |overdraft|
      puts "#{"%.2f" % overdraft.balance}, #{overdraft.amount}, #{overdraft.description}, #{overdraft.date}"
    end
  end
end

def format_money(amount)
  "$#{"%.2f" % amount}"
end


transactions = TransactionsImport.new
transactions = transactions.file_import('transactions.csv')
account_data = Account.new
transactions.each do |transaction|
  account_data.add_transaction(transaction)
end
puts "Total Income: #{format_money(account_data.income_summary)}"
puts "Total Expenses: #{format_money(account_data.expense_summary)}"
puts "account_balance: #{format_money(account_data.account_balance)}"
puts "Total Overdraft Charges: #{format_money(account_data.overdraft_total)}"

puts nil
puts "Overdrafts (account_balance, expense, description, date)"
account_data.overdraft_summary
