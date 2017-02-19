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
	    msb = 'msbuild_not_found'
      versions = find_msbuild_versions
      if versions.any?
        msb = versions[versions.keys.max]
      end
      self.command = msb
    end

		### imported from latest version of albacore https://github.com/Albacore/albacore.git
	 	def find_msbuild_versions
	    return nil unless ::Rake::Win32.windows?
	    require 'win32/registry'
	    retval = Hash.new
	    begin
	      Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\Microsoft\MSBuild\ToolsVersions') do |toolsVersion|
	        toolsVersion.each_key do |key|
	          begin
	            version_key = toolsVersion.open(key)
	            version = key.to_i
	            msb = File.join(version_key['MSBuildToolsPath'],'msbuild.exe')
	            retval[version] = msb
	          rescue
	            error "failed to open #{key}"
	          end
	        end
	      end
	    rescue
	      error "failed to open HKLM\\SOFTWARE\\Microsoft\\MSBuild\\ToolsVersions"
	    end
	    retval
    end
  end
end


