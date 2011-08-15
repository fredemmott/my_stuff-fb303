# Copyright 2011-present Fred Emmott. See COPYING file.

# Compatibility Wrapper for 0.0.2 and below.
#
# Please directly use MyStuff::Fb303::Server instead for new code.
require 'my_stuff/fb303/server'

module MyStuff
  Fb303Server = MyStuff::Fb303::Server
end
