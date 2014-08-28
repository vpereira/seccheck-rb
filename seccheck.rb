require 'digest' # stdlib
require 'find'   # stdlib
require 'hashdiff' # gem install hashdiff
require 'celluloid' # gem install celluloid
require 'etc' # stdlib
require 'json' # stdlib
require 'json-compare'

module SecCheck 


    class FileInfo

        include Celluloid
        attr_accessor :file

        def initialize(file = '')
            @file = file
        end
        
        # not sure if Celluloid works with accessors
        def set_file(file)
            @file  = file
            self
        end

        def md5sum
            begin
                Digest::MD5.file(@file).hexdigest
            rescue
                ""
            end
        end

        def gid
            File::stat(@file).gid
        end

        def uid
            File::stat(@file).uid
        end

        def setgid?
            File::stat(@file).setgid?
        end

        def setuid?
            File::stat(@file).setuid?
        end

        def writable?
            File::stat(@file).writable?
        end

        def executable?
            File::stat(@file).executable?
        end

        def sticky?
            File::stat(@file).sticky?
        end

        # we return it in octal
        def mode
            sprintf("%o",File::stat(@file).mode).to_i
        end

        def world_writable?
            File::stat(@file).world_writable? ? true : false
        end

        def writable_and_executable?
            writable? and executable?
        end

        def world_writable_and_not_sticky?
            world_writable? and !sticky?
        end

        def blockdev?
            File::stat(@file).blockdev?
        end

        def chardev?
            File::stat(@file).chardev?
        end

        def device?
            blockdev? or chardev?
        end

        def realpath
            File::realpath(@file)
        end

        def ftype
            File::ftype(@file).to_sym
        end

        def owner
            Etc.getpwuid(uid).name rescue uid
        end

    end
    class ConfigDiff
        def initialize(a,b)
            @a = a
            @b = b
        end

        def do
            HashDiff.diff(@a,@b)
        end
    end

    class Scan

        def initialize(db)
            @db = db
        end
        # check if the permissions are correctly being set
        def check_var_spool_mail
            @db.select { |k,v| k.match /^\/var\/spool\/mail/ }.each do |k,v|
                if v[:owner] != File.basename(k)
                    puts "WARNING: #{k} owned by #{v[:owner]}"
                end
            end

        end
    end
end

require_relative 'lib/fs_scanner'
require_relative 'plugins/proc_file'

if __FILE__ == $0
   # retrieving:
    #old_hash_fs = File.open("test.marshal", "r"){|from_file| Marshal.load(from_file)}
    old_hash_fs = JSON.load(File.read("test.json")) # we could just suck it up, but pass it through load, 
    #works as sanity check
    fs_scanner = SecCheck::FSScanner.new ARGV[0]
    hash_fs = fs_scanner.search
    puts JsonCompare.get_diff(old_hash_fs.to_json,hash_fs.to_json)
    #SecCheck::Scan.new(hash_fs[:files]).check_var_spool_mail
    #puts SecCheck::ConfigDiff.new(old_hash_fs,hash_fs).do
    #File.open("test.marshal", "w"){|to_file| Marshal.dump(hash_fs, to_file)}
    #File.open("test.json", "w"){ |to_file| to_file.write(hash_fs.to_json)}
 end
