module SecCheck
  class FileSystemCheck

      def initialize(db)
        @db = db
      end

      # TODO
      # implement the logic
      def check_var_spool_mail
        wrong_owners = []
        @db.select { |k,v| k[/\/var\/spool\/mail/] }.each do |k,v|
          if v[:owner] != File.basename(k)
            wrong_owners << [k,v[:owner]]
          end
        end
        wrong_owners
      end
  end
end
