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
          'vendor_id' => "1"
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
    example { expect(@d.instance.env).to include('TEST_ENV' => 'test_value') }
  end

  describe "tag" do
    example { expect(@d.instance.tag("cpu")).to eq "test.prefix.cpu" }
  end

  describe "record on flat hash" do
    example { expect(@d.instance.record("cpu")['cpu']).to include('total' => "2") }
  end

  describe "record on nested hash" do
    example { expect(@d.instance.record("cpu.0")['cpu.0']).to include('vendor_id' => "1") }
  end
end
