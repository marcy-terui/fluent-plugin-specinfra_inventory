# fluent-plugin-specinfra_inventory

Specinfra Host Inventory Plugin for [Fluentd](http://github.com/fluent/fluentd)

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
  time_span      300
  tag_prefix     example.prefix
  backend        exec
  inventory_keys ["cpu","memory"]
  family         ubuntu
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
Prefix of tags of events.  
Event tags are added together inventory key at the end. like: `example.prefix.cpu`  
default: `specinfra.inventory`

### backend
Specinfra backend type  
default: `exec`


### inventory_keys
Key of Host Inventory

### family, release, arch
See [Multi OS Support](http://serverspec.org/tutorial.html)

### path
`PATH` environment variable

### host
Target host

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
