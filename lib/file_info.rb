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
end 
