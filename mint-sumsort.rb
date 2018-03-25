#!/usr/bin/ruby
require "csv"

if 2 != ARGV.length
    print "Usage: mint-sumsort.rb infile.csv outfile.csv\n"
    exit 1
end

def scan_categories(filename)
    categories = Hash.new
    f = File.new(filename, 'r')
    
    # Skip past header
    f.readline
    
    f.each_line() { |line|
        big_data = CSV::parse(line);
        next if nil == big_data || nil == big_data[0] || nil == big_data[0][0]
        data = big_data[0]
        category = data[5]
        categories[category] = 1
    }
    f.close()
    result = categories.keys.sort
    cat_count = result.size
    print("Scanned #{cat_count} categor#{1 == cat_count ? 'y' : 'ies'}\n")
    return result
end

def append_category(filename, outfile, match_category)
    sum = 0
    f = File.new(filename, 'r')
    
    # Skip past header
    f.readline
    
    f.each_line() { |line|
        big_data = CSV::parse(line);
        next if nil == big_data || nil == big_data[0] || nil == big_data[0][0]
        data = big_data[0]
        amount = data[3].to_f
        category = data[5]
        data[1] = data[1] + ' — ' + data[9] if !data[9].empty?
        next if category != match_category
        outfile.write(CSV::generate_line(data));
        sum += amount
    }
    outfile.write(",\"Category Total\",,#{sum},,,,\n")
    outfile.write("\n");
    f.close()
end

categories = scan_categories(ARGV[0])

outfile = File.new(ARGV[1], 'w')

# Add header
header = ["Date","Description","Original Description","Amount","Transaction Type","Category","Subcategory","Account Name","Labels","Notes"]
outfile.write(CSV::generate_line(header))

categories.each { |category|
    print("Appending category \"#{category}\n")
    append_category(ARGV[0], outfile, category)
}
outfile.close()
