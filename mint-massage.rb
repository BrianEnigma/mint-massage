#!/usr/bin/ruby
require "csv"

# Output files for this year
out_income = File.new("expenses-2017-income.csv", "w")
out_expenses = File.new("expenses-2017-expenses.csv", "w")

# Map specific categories to general categories
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
    "Books" => "Entertainment",
    "Music" => "Entertainment",
    "Television" => "Entertainment",
    
    "Education" => "Education",
    "Tuition" => "Education",

    "Student Loan" => "Financial",
    "Life Insurance" => "Financial",
    "ATM Fee" => "Financial",
    "Bank Fee" => "Financial",
    "Financial" => "Financial",
    "Loan Payment" => "Financial",
    "Fees & Charges" => "Financial",
    "Financial Advisor" => "Financial",
    "Finance Charge" => "Financial",
    "Late Fee" => "Financial",
    "Legal" => "Financial",

    "Gift" => "Gift",
    "Charity" => "Gift",
    "Gifts & Donations" => "Gift",

    "Gym" => "Health",
    "Pharmacy" => "Health",
    "Health & Fitness" => "Health",
    "Eyecare" => "Health",

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
    "Printing" => "Shopping",
    "Newspapers & Magazines" => "Shopping",

    "State Tax" => "Taxes",
    "Federal Tax" => "Taxes",
    "Local Tax" => "Taxes",
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
    "Auto Payment" => "Vehicles",
    
    "Uncategorized" => "Uncategorized",
    "Check" => "Uncategorized",

    "Transfer" => "Transfer",
    "Credit Card Payment" => "Transfer"
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
        
        data[8] = 'Esme (House Cleaning)' if nil != data[8] && data[8].index('Esme') != nil
    
        column = 0
        data.each() { |item|
            column += 1
            if (data[5] == item && column >= 3)
                out << "\"#{category}\","
                category_printed = true
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
