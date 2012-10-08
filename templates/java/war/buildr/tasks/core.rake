module Buildr
  module ArchiveTaskExtension
    def war?
      false
    end
  end 

  module WarTaskExtension
    def war?
      true
    end
  end
end

class Buildr::ArchiveTask
  include Buildr::ArchiveTaskExtension
end

class Buildr::Packaging::Java::WarTask
  include Buildr::WarTaskExtension
end