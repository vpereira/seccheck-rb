module SecCheck
  class FileSystemCheck

      def initialize(db)
        @db = db
      end

      # TODO
      # implement the logic
      def check_var_spool_mail
        @db.select { |k,v| k.match /\/var\/spool\/mail/ }.each do |k,v|
          if v[:owner] != File.basename(k)
            puts "WARNING: #{k} owned by #{v[:owner]}"
          end
        end
      end
  end
end
