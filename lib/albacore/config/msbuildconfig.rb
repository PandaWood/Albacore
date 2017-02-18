require 'ostruct'
require 'albacore/config/netversion'
require 'albacore/support/openstruct'

module Configuration
  module MSBuild
    include Albacore::Configuration
    include Configuration::NetVersion

    def self.msbuildconfig
      @msbuildconfig ||= OpenStruct.new.extend(OpenStructToHash).extend(MSBuild)
    end

    def msbuild
      config = MSBuild.msbuildconfig
      yield(config) if block_given?
      config
    end

    def self.included(mod)
      self.msbuildconfig.use :net40
    end

    def use(netversion)
      # self.command = File.join(get_net_version(netversion), "MSBuild.exe")
      self.command = "MSBuild.exe"    # above ends up using wrong version, so we'll fall back to relying on the correct one being in the path, for now
    end
  end
end

