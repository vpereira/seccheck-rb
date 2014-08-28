module SecCheck
    class RpmMD5Check
        def self.run
            Cheetah.run(["/bin/rpm","-Va"],["grep","^5"],:stdout=>:capture)
        end
    end
end
