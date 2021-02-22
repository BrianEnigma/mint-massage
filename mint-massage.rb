#!/usr/bin/ruby
require "csv"

year_filter = 2019

# Output files for this year
out_income = File.new("expenses-2019-income.csv", "w")
out_expenses = File.new("expenses-2019-expenses.csv", "w")

# Map specific categories to general categories
MAP = {
    "Cash & ATM" => "Cash",
    "Transfer for Cash Spending" => "Cash",
    
    "Alcohol & Bars" => "Entertainment",
    "Amusement" => "Shopping",
    "Books" => "Entertainment",
    "Coffee Shops" => "Entertainment",
    "Date Night" => "Entertainment",
    "Entertainment" => "Entertainment",
    "Fast Food" => "Entertainment",
    "Food & Dining" => "Entertainment",
    "Kids Activities" => "Entertainment",
    "Lunch" => "Entertainment",
    "Movies & DVDs" => "Entertainment",
    "Music" => "Entertainment",
    "Restaurants" => "Entertainment",
    "Television" => "Entertainment",
    
    "Education" => "Education",
    "Tuition" => "Education",

    "ATM Fee" => "Financial",
    "Bank Fee" => "Financial",
    "Fees & Charges" => "Financial",
    "Finance Charge" => "Financial",
    "Financial Advisor" => "Financial",
    "Financial" => "Financial",
    "Late Fee" => "Financial",
    "Legal" => "Financial",
    "Loan Payment" => "Financial",
    "Student Loan" => "Financial",

    "Life Insurance" => "Life Insurance",

    "Charity" => "Charity",

    "Gift" => "Gift",
    "Gifts & Donations" => "Gift",

    "Eyecare" => "Health",
    "Gym" => "Health",
    "Health & Fitness" => "Health",
    "Pharmacy" => "Health",

    "Furnishings" => "Home",
    "Home Improvement" => "Home",
    "Home Services" => "Home",
    "Home Supplies" => "Home",
    "Home" => "Home",
    "Lawn & Garden" => "Home",
    "Mortgage & Rent" => "Home",
    
    "Bonus" => "Paycheck",
    "Paycheck" => "Paycheck",

    "Groceries" => "Groceries",

    "Deposit" => "Income",
    "Income" => "Income",
    "Interest Income" => "Income",

    "Investments" => "Investments",
    
    "Dentist" => "Medical",
    "Doctor" => "Medical",
    "Massage Therapy" => "Medical",

    "Pet Food & Supplies" => "Pets",
    "Pets" => "Pets",
    "Veterinary" => "Pets",

    "Arts" => "Shopping",
    "Clothing" => "Shopping",
    "Electronics & Software" => "Shopping",
    "Hair" => "Shopping",
    "Hobbies" => "Shopping",
    "Newspapers & Magazines" => "Shopping",
    "Office Supplies" => "Shopping",
    "Personal Care" => "Shopping",
    "Printing" => "Shopping",
    "Shipping" => "Shopping",
    "Shopping" => "Shopping",
    "Spa & Massage" => "Shopping",
    "Sporting Goods" => "Shopping",

    "Spousal Support" => "Spousal Support",

    "Federal Tax" => "Taxes",
    "Local Tax" => "Taxes",
    "State Tax" => "Taxes",
    "Taxes" => "Taxes",
    
    "Air Travel" => "Travel",
    "Hotel" => "Travel",
    "Hotels" => "Travel",
    "Rental Car & Taxi" => "Travel",
    "Travel" => "Travel",
    "Vacation" => "Travel",

    "Bills & Utilities" => "Utilities",
    "Business Services" => "Utilities",
    "Home Phone" => "Utilities",
    "Internet" => "Utilities",
    "Mobile Phone" => "Utilities",
    "Utilities" => "Utilities",

    "Auto & Transport" => "Vehicles",
    "Auto Insurance" => "Vehicles",
    "Auto Payment" => "Vehicles",
    "Gas & Fuel" => "Vehicles",
    "Parking" => "Vehicles",
    "Public Transportation" => "Vehicles",
    "Service & Parts" => "Vehicles",

    "Check" => "Uncategorized",
    "Uncategorized" => "Uncategorized",

    "Credit Card Payment" => "Transfer",
    "Transfer" => "Transfer"
}

if 0 == ARGV.length
    print "Error: put CSV file(s) on command line"
    exit 1
end

year_filter_string = "/#{year_filter}"

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
        next if data[0].to_s().index(year_filter_string) == nil
        data[0] = "0#{data[0]}" if data[0].length == 9 # Cheap way to zero-pad the month. Day is already zero-padded.

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

        #p data
        # Update Notes
        data[8] = 'Esme (House Cleaning)' if nil != data[8] && data[8].index('Esme') != nil
        # Update name+category
        if nil != data[2] && data[2].index('AMERIPRISE') != nil
            if data[3].to_i > 400
                data[1] = 'RiverSource Universal Life (Ameriprise)'
                category = 'Life Insurance'
            else
                data[1] = 'RiverSource Disability Life (Ameriprise)'
                category = 'Financial'
            end
        end
        if nil != data[2] && data[2].index('LPL') != nil && data[3].to_i > 400
            category = 'Transfer'
        end
        #p data

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
