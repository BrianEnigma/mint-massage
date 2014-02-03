#!/usr/bin/ruby
require "csv"

out_income = File.new("expenses-2013-income.csv", "w")
out_expenses = File.new("expenses-2013-expenses.csv", "w")

MAP = {
    "Cash & ATM" => "Cash",
    "Transfer for Cash Spending" => "Cash",
    
    "Movies & DVDs" => "Entertainment",
    "Date Night" => "Entertainment",
    "Restaurants" => "Entertainment",
    "Coffee Shops" => "Entertainment",
    "Alcohol & Bars" => "Entertainment",
    "Lunch" => "Entertainment",
    "Fast Food" => "Entertainment",
    "Food & Dining" => "Entertainment",
    "Entertainment" => "Entertainment",
    
    "Student Loan" => "Financial",
    "Life Insurance" => "Financial",
    "Credit Card Payment" => "Financial",
    "ATM Fee" => "Financial",
    "Bank Fee" => "Financial",
    "Financial" => "Financial",
    "Loan Payment" => "Financial",
    "Fees & Charges" => "Financial",
    "Financial Advisor" => "Financial",
    "Finance Charge" => "Financial",

    "Gift" => "Gift",
    "Charity" => "Gift",

    "Gym" => "Health",
    "Pharmacy" => "Health",

    "Home Improvement" => "Home",
    "Furnishings" => "Home",
    "Lawn & Garden" => "Home",
    "Mortgage & Rent" => "Home",
    "Home Supplies" => "Home",
    "Home Services" => "Home",
    "Home" => "Home",
    
    "Paycheck" => "Paycheck",
    "Bonus" => "Paycheck",

    "Groceries" => "Groceries",

    "Interest Income" => "Income",
    "Income" => "Income",
    "Deposit" => "Income",

    "Investments" => "Investments",
    
    "Dentist" => "Medical",
    "Massage Therapy" => "Medical",
    "Doctor" => "Medical",

    "Pet Food & Supplies" => "Pets",
    "Veterinary" => "Pets",
    "Pets" => "Pets",

    "Electronics & Software" => "Shopping",
    "Hobbies" => "Shopping",
    "Hair" => "Shopping",
    "Clothing" => "Shopping",
    "Shopping" => "Shopping",
    "Personal Care" => "Shopping",
    "Arts" => "Shopping",
    "Office Supplies" => "Shopping",
    "Shipping" => "Shopping",
    "Sporting Goods" => "Shopping",
    "Spa & Massage" => "Shopping",

    "State Tax" => "Taxes",
    "Federal Tax" => "Taxes",
    "Taxes" => "Taxes",
    
    "Rental Car & Taxi" => "Travel",
    "Air Travel" => "Travel",
    "Hotel" => "Travel",
    "Hotels" => "Travel",
    "Vacation" => "Travel",
    "Travel" => "Travel",

    "Internet" => "Utilities",
    "Mobile Phone" => "Utilities",
    "Utilities" => "Utilities",
    "Business Services" => "Utilities",
    "Bills & Utilities" => "Utilities",
    "Home Phone" => "Utilities",

    "Public Transportation" => "Vehicles",
    "Gas & Fuel" => "Vehicles",
    "Auto Insurance" => "Vehicles",
    "Service & Parts" => "Vehicles",
    "Auto & Transport" => "Vehicles",
    "Parking" => "Vehicles",
    
    "Uncategorized" => "Uncategorized",
    "Check" => "Uncategorized",

    "Transfer" => "Transfer"
    
}

if 0 == ARGV.length
    print "Error: put CSV file(s) on command line"
    exit 1
end

ARGV.each { |input_filename|

    f = File.new(input_filename, "r")

    # Read header
    f.readline()

    f.each_line() { |line|
        big_data = CSV::parse(line);
        next if nil == big_data || nil == big_data[0] || nil == big_data[0][0]
        data = big_data[0]
        #print "#{line}\n"
        #p big_data
    
        out = nil
        if data[4] == "debit"
            out = out_expenses
        elsif data[4] == "credit"
            out = out_income
        else
            throw "Unknown type #{data[4]}"
        end
    
        category = MAP[data[5]]
        if nil == category or category.length() == 0
            p data
            throw "Unknown category for #{data[5]}"
        end
    
        data.each() { |item|
            if (data[5] == item)
                out << "\"#{category}\","
            end
            item_clean = item.gsub('"', ' ')
            out << "\"#{item_clean}\","
        }
        out << "\n"
    }
    f.close()
}

out_income.close()
out_expenses.close()
