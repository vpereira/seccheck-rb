require 'digest' # stdlib
require 'find'   # stdlib
require 'hashdiff' # gem install hashdiff
require 'celluloid' # gem install celluloid
require 'etc' # stdlib
require 'json' # stdlib
require 'json-compare' # gem install json-compare

module SecCheck

   class ConfigDiff

        def initialize(a,b)
            @a = a
            @b = b
        end

        def run
            HashDiff.diff(@a,@b)
        end
    end
end

# libs
require_relative 'lib/file_info'
require_relative 'lib/fs_scanner'

# plugins
require_relative 'plugins/proc_check'
require_relative 'plugins/file_system_check'
require_relative 'plugins/rpm_md5_check'

if __FILE__ == $0

   if ARGV[0].nil?
     puts "#{$0} <base-dir>"
     exit 1
   end
   # retrieving:
    #old_hash_fs = File.open("test.marshal", "r"){|from_file| Marshal.load(from_file)}
    old_hash_fs = JSON.load(File.read("test.json")) # we could just suck it up,
    #but pass it through load,works as sanity check
    fs_scanner = SecCheck::FSScanner.new ARGV[0]
    hash_fs = fs_scanner.search
    JsonCompare.get_diff(old_hash_fs.to_json,hash_fs.to_json)
    SecCheck::FileSystemCheck.new(hash_fs[:files]).check_var_spool_mail.each do |v|
      puts "WARNING: #{v[0]} owned by #{v[1]}"
    end
    #puts SecCheck::ConfigDiff.new(old_hash_fs,hash_fs).run
    #File.open("test.marshal", "w"){|to_file| Marshal.dump(hash_fs, to_file)}
    File.open("test.json", "w"){ |to_file| to_file.write(hash_fs.to_json)}
 end
