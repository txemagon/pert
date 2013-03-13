# Pert

Creates an evaluated PERT diagram in dot language whenever 
you provide a list of tasks.

## Installation
Now:

Clone the repos and run (see below).

In a near feauture:

Add this line to your application's Gemfile:

    gem 'pert'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pert

## Usage

    $ bundle exec bin/pert <file>

One example file is provided. To see it type:

    $ budle exec bin/pert examples/pert.diag

If you want to see an image, then:

    $ budle exec bin/pert examples/pert.diag | dot | display

   Remember to install graphviz and imagemagick.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
