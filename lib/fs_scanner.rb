module SecCheck
    class FSScanner
        attr_accessor :dir
    
        # it should accept a set of directories. and maybe a way to blacklist some of them
        def initialize(dir = '.')
            @dir = dir
        end

        # return a hash
        def search(dir = @dir)
          fs = {:files=>{},:devices=>{},:directories=>{}}
          my_pool = FileInfo.pool

          Find.find(@dir) do |path|
              my_file = my_pool.set_file(path)
              case my_file.ftype
              when :file
                sup_hash = {}
                {:md5=>:md5sum,:setuid=>:setuid?,:setgid=>:setgid?,:writable_and_executable=>:writable_and_executable?,
                    :world_writable_and_not_sticky=>:world_writable_and_not_sticky?,:mode=>:mode,
                    :gid=>:gid,:uid=>:uid,:owner=>:owner}.each do |k,v|
                    sup_hash.merge!({k=>my_file.send(v)})
                end
                fs[:files][my_file.realpath] = sup_hash
              when :characterSpecial
                sup_hash = {}
                {:mode=>:mode,:gid=>:gid,:uid=>:uid,:owner=>:owner}.each do |k,v|
                    sup_hash.merge!({k=>my_file.send(v)})
                end
                fs[:devices][my_file.realpath] = sup_hash
              when :blockSpecial
                sup_hash = {}
                {:mode=>:mode,:gid=>:gid,:uid=>:uid,:owner=>:owner}.each do |k,v|
                    sup_hash.merge!({k=>my_file.send(v)})
                end
                fs[:devices][my_file.realpath] = sup_hash
              when :directory
                sup_hash = {}
                {:mode=>:mode,:gid=>:gid,:uid=>:uid,:owner=>:owner}.each do |k,v|
                    sup_hash.merge!({k=>my_file.send(v)})
                end
                fs[:directories][my_file.realpath] = sup_hash
               end
          end
          fs
        end
    end
end
