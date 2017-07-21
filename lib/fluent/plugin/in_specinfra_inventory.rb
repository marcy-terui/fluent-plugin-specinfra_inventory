require 'fluent/input'

module Fluent
  class SpecinfraInventoryInput < Input
    Plugin.register_input('specinfra_inventory', self)

    # Define `router` method of v0.12 to support v0.10 or earlier
    unless method_defined?(:router)
      define_method("router") { Fluent::Engine }
    end

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
    config_param :inventory_keys, :array,   default: []
    config_param :combine,        :bool,    default: true
    config_param :cast_num,       :bool,    default: false
    config_param :cast_byte,      :bool,    default: false
    config_param :cast_percent,   :bool,    default: false

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
      @inventory_keys = Specinfra::HostInventory::KEYS if @inventory_keys.empty?
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
        if @combine
          emit_combine_record(time)
        else
          emit_separate_record(time)
        end
        sleep @time_span
      end
    end

    def emit_combine_record(time)
      records = {}
      @inventory_keys.each do |key|
        records.merge!(record(key))
      end
      router.emit(@tag_prefix, time, records) if records.length > 0
    end

    def emit_separate_record(time)
      time = Engine.now
      @inventory_keys.each do |key|
        router.emit(tag(key), time, record(key))
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
      {key => cast(inv)}
    end

    def cast(inv)
      if @cast_num || @cast_byte || @cast_percent
        if inv.is_a?(Hash)
          inv = Hash[inv.map { |k,v| [k, cast(v)] }]
        elsif inv.is_a?(Array)
          inv = inv.map do |v|
            v = cast(v)
          end
        else
          inv = _cast_num(inv) if @cast_num && inv.is_a?(String)
          inv = _cast_byte(inv) if @cast_byte && inv.is_a?(String)
          inv = _cast_percent(inv) if @cast_percent && inv.is_a?(String)
        end
      end
      inv
    end

    def _cast_num(v)
      m = v.match(/^([1-9]\d*|0)$/)
      m.nil? ? v : m[0].to_i
    end

    def _cast_byte(v)
      m = v.match(/^(\d+)(kb|KB|kB)$/)
      m.nil? ? v : m[0].to_i * 1024
    end

    def _cast_percent(v)
      m = v.match(/^(\d+)%$/)
      m.nil? ? v : m[0].to_i
    end
  end
end
