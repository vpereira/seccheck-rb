require_relative 'seccheck'


if ARGV[0].nil?
    puts "#{$0} directory"
    exit(1)
end

fs_scanner = SecCheck::FSScanner.new ARGV[0]
hash_fs = fs_scanner.search
File.open(File.join(File.dirname(__FILE__),"data","test.json"), "w") { |to_file| to_file.write(hash_fs.to_json) }
