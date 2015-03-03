require 'spec_helper'
require 'fluent/plugin/in_specinfra_inventory'

describe Fluent::SpecinfraInventoryInput do
  before do
    Fluent::Test.setup
    @d = Fluent::Test::InputTestDriver.new(Fluent::SpecinfraInventoryInput).configure(config)
    @d.instance.inventory = {
      'cpu' => {
        'total' => "2",
        '0' => {
          'vendor_id' => "1",
          'cache_size' => "512KB"
        }
      }
    }
  end

  let(:config) do
    %[
      time_span      300
      tag_prefix     test.prefix
      backend        exec
      inventory_keys ["cpu.0"]
      family         ubuntu
      release        14.04
      arch           x86_64
      path           /path/test
      host           localhost
      ssh_user       test-user
      ssh_port       2222
      combine        false
      cast_num       true
      cast_byte      true
      cast_percent   true
      env            {"TEST_ENV": "test_value"}
    ]
  end

  describe "config" do
    example { expect(@d.instance.time_span).to eq 300 }
    example { expect(@d.instance.tag_prefix).to eq "test.prefix" }
    example { expect(@d.instance.backend).to eq "exec" }
    example { expect(@d.instance.inventory_keys).to eq ["cpu.0"] }
    example { expect(@d.instance.family).to eq "ubuntu" }
    example { expect(@d.instance.release).to eq "14.04" }
    example { expect(@d.instance.arch).to eq "x86_64" }
    example { expect(@d.instance.path).to eq "/path/test" }
    example { expect(@d.instance.host).to eq "localhost" }
    example { expect(@d.instance.ssh_user).to eq "test-user" }
    example { expect(@d.instance.ssh_port).to eq 2222 }
    example { expect(@d.instance.combine).to eq false }
    example { expect(@d.instance.cast_num).to eq true }
    example { expect(@d.instance.cast_byte).to eq true }
    example { expect(@d.instance.cast_percent).to eq true }
    example { expect(@d.instance.env).to include('TEST_ENV' => 'test_value') }
  end

  describe "tag" do
    example { expect(@d.instance.tag("cpu")).to eq "test.prefix.cpu" }
  end

  describe "record on flat hash" do
    example { expect(@d.instance.record("cpu")['cpu']).to include('total' => 2) }
  end

  describe "record on nested hash" do
    example { expect(@d.instance.record("cpu.0")['cpu.0']).to include('vendor_id' => 1) }
    example { expect(@d.instance.record("cpu.0")['cpu.0']).to include('cache_size' => 524288) }
  end

  describe "cast_num" do
    example { expect(@d.instance._cast_num("0")).to eq 0 }
    example { expect(@d.instance._cast_num("1")).to eq 1 }
    example { expect(@d.instance._cast_num("109")).to eq 109 }
    example { expect(@d.instance._cast_num("01")).to eq "01" }
    example { expect(@d.instance._cast_num("test")).to eq "test" }
  end

  describe "cast_byte" do
    example { expect(@d.instance._cast_byte("12")).to eq "12" }
    example { expect(@d.instance._cast_byte("0kb")).to eq 0 }
    example { expect(@d.instance._cast_byte("99kb")).to eq 101376 }
    example { expect(@d.instance._cast_byte("99kB")).to eq 101376 }
    example { expect(@d.instance._cast_byte("99KB")).to eq 101376 }
    example { expect(@d.instance._cast_byte("akb")).to eq "akb" }
    example { expect(@d.instance._cast_byte("1%")).to eq "1%" }
  end

  describe "cast_percent" do
    example { expect(@d.instance._cast_percent("99")).to eq "99" }
    example { expect(@d.instance._cast_percent("77%")).to eq 77 }
    example { expect(@d.instance._cast_percent("0%")).to eq 0 }
    example { expect(@d.instance._cast_percent("percent")).to eq "percent" }
    example { expect(@d.instance._cast_percent("s%")).to eq "s%" }
  end
end
