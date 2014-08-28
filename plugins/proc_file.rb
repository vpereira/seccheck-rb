module SecCheck
    class ProcFile
        class << self
            def mounts
                # return a list of mounted points + dev
                File.read('/proc/mounts').split(/\n/).collect { |f| f.match(/^\/dev/) and f.split[1] }.compact + ["/dev"]
            end
        end
    end
end
