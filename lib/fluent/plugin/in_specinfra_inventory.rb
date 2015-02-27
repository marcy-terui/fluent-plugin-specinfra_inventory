module Fluent
  class SpecinfraInventoryInput < Input
    Plugin.register_input('specinfra_inventory', self)

    config_param :time_span,      :integer, default: 60
    config_param :tag_prefix,     :string,  default: 'specinfra.inventory'
    config_param :backend,        :string,  default: 'exec'
    config_param :family,         :string,  default: nil
    config_param :release,        :string,  default: nil
    config_param :arch,           :string,  default: nil
    config_param :path,           :string,  default: nil
    config_param :host,           :string,  default: nil
    config_param :ssh_user,       :string,  default: nil
    config_param :ssh_port,       :integer, default: nil
    config_param :env,            :hash,    default: {}
    config_param :inventory_keys, :array

    KEY_DELIMITER = "."

    attr_accessor :inventory

    def initialize
      super
      require 'specinfra'
      require 'specinfra/host_inventory'
    end

    def configure(conf)
      super

      Specinfra.configuration.send(:backend, @backend.to_sym)
      Specinfra.configuration.send(:path, @path) if @path
      Specinfra.configuration.send(:host, @host) if @host
      Specinfra.configuration.send(:env, @env) if @env

      opt = {}
      opt[:family]  = @family  if @family
      opt[:release] = @release if @release
      opt[:arch]    = @arch    if @arch
      Specinfra.configuration.send(:os, opt) if opt.length > 0

      opt = {}
      opt[:user] = @ssh_user  if @ssh_user
      opt[:port] = @ssh_port  if @ssh_port
      Specinfra.configuration.send(:ssh_options, opt) if opt.length > 0

      @inventory = Specinfra::HostInventory.instance
    end

    def start
      @finished = false
      @thread = Thread.new(&method(:run))
    end

    def shutdown
      @finished = true
      @thread.join
    end

    def run
      loop do
        time = Engine.now
        @inventory_keys.each do |key|
          Engine.emit(tag(key), time, record(key))
        end
        sleep @time_span
      end
    end

    def tag(key)
      "#{@tag_prefix}.#{key}"
    end

    def record(key)
      inv = @inventory
      key.split(KEY_DELIMITER).each do |k|
        inv = inv[k]
      end
      {key => inv}
    end

  end
end
