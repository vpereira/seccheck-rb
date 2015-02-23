require_relative '../seccheck'
#require_relative '../plugins/file_system_check'
require "minitest/autorun"

describe SecCheck::FileSystemCheck do
  before do
    @db = {:files=>{"/var/spool/mail/test"=>{:md5=>"2e0222fbc0446123dca93e41cb4dff54",
      :setuid=>false, :setgid=>false, :writable_and_executable=>false,
      :world_writable_and_not_sticky=>false, :mode=>100644, :gid=>0, :uid=>0, :owner=>"root"}}
    }
  end
  describe "FileSystemCheck" do
    before do
      @fs_check = SecCheck::FileSystemCheck.new @db
    end
    it "check var spool mail and search for files with wrong owner" do
      @fs_check.check_var_spool_mail.must_be_instance_of Array
    end
  end
end
