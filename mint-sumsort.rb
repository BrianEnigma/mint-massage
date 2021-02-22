#!/usr/bin/ruby
require "csv"

Skip_Summary_Categories = ['Cash', 'Transfer', 'Taxes', 'Uncategorized']

if 2 != ARGV.length && 3 != ARGV.length
    print "Usage: mint-sumsort.rb infile.csv outfile.csv [category_summary_file.csv]\n"
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

def append_category(filename, outfile, match_category, categoryfile)
    sum = 0
    f = File.new(filename, 'r')
    
    # Skip past header
    f.readline

    outfile.write(",\"Category: #{match_category}\"\n");
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
    sum_rounded = sprintf("%0.2f", sum)
    outfile.write(",\"Category Total\",,#{sum_rounded},,,,\n")
    outfile.write(",\n");
    f.close()
    if categoryfile != nil && !Skip_Summary_Categories.include?(match_category)
        categoryfile.write("\"#{match_category}\", $#{sum_rounded}\n")
    end
end

categories = scan_categories(ARGV[0])

outfile = File.new(ARGV[1], 'w')
categoryfile = nil
if 3 == ARGV.length
    categoryfile = File.new(ARGV[2], 'w')
    categoryfile.write("\"Category\", \"Sum\"\n")
end

# Add header
header = ["Date","Description","Original Description","Amount","Transaction Type","Category","Subcategory","Account Name","Labels","Notes"]
outfile.write(CSV::generate_line(header))

categories.each { |category|
    print("Appending category \"#{category}\n")
    append_category(ARGV[0], outfile, category, categoryfile)
}
outfile.close()
categoryfile.close() if categoryfile != nil
