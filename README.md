# fluent-plugin-specinfra_inventory
[![Gem Version](https://badge.fury.io/rb/fluent-plugin-specinfra_inventory.svg)](http://badge.fury.io/rb/fluent-plugin-specinfra_inventory)

[Specinfra](https://github.com/serverspec/specinfra) Host Inventory Plugin for [Fluentd](http://github.com/fluent/fluentd)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fluent-plugin-specinfra_inventory'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-specinfra_inventory

## Configuration

```
<source>
  @type specinfra_inventory
  time_span      300
  tag_prefix     example.prefix
  backend        exec
  inventory_keys ["cpu.total","memory"]
  combine        false
  family         ubuntu
  cast_num       true
  cast_byte      true
  cast_percent   true
  release        14.04
  arch           x86_64
  path           /user/local/bin
  host           localhost
  ssh_user       vagrant
  ssh_port       2222
  env            {"LANG": "C"}
</source>
```

### time_span
Time span(sec) for collecting inventory.  
defualt: `60`

### tag_prefix
Prefix of event tags.  
Event tags are added together inventory key at the end(like: `example.prefix.cpu`)  
If you set `true` to `combine` option, It does not added the key at the end.  
default: `specinfra.inventory`

### backend
Specinfra backend type.  
default: `exec`

### inventory_keys
Key of Host Inventory.  
If you access the key on nested Hash, you should separated by `.`  
default: All available keys of `Specinfra::HostInventory`  

### combine
Combining values of `inventory_keys` to one record.  
default: `true`

### cast_num
Cast all number value to integer.  
default: `false`

### cast_byte
Cast all byte value(like `512KB`) to integer.  
default: `false`

### cast_percent
Cast all percentile value(like `50%`) to integer.  
default: `false`

### family, release, arch
See [Multi OS Support](http://serverspec.org/tutorial.html)

### path
Environment variable `PATH`

### host
Target hostname or IP

### ssh_user
SSH user name

### ssh_port
SSH port

### env
Environment variables

## Contributing

* Source hosted at [GitHub][repo]
* Report issues/questions/feature requests on [GitHub Issues][issues]

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make. For
example:

1. Fork the repo
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Authors

Created and maintained by [Masashi Terui][author] (<marcy9114@gmail.com>)

## License

MIT (see [LICENSE][license])

[author]:           https://github.com/marcy-terui
[issues]:           https://github.com/marcy-terui/fluent-plugin-specinfra_inventory/issues
[license]:          https://github.com/marcy-terui/fluent-plugin-specinfra_inventory/blob/master/LICENSE.txt
[repo]:             https://github.com/marcy-terui/fluent-plugin-specinfra_inventory
