require_relative "./simple_banking/lib/simple_banking"

puts "Creating a new Bank..."
bank = SimpleBank.new()
bank.setup_from_file("./mable_acc_balance.csv")
p bank
puts bank.report()

puts "Performing transfers"
bank.execute_transfers_from_file("./mable_trans.csv")
puts bank.report()
