# Copyright 2011-present Fred Emmott. See COPYING file.

include 'fb303.thrift'

service EchoService extends fb303.FacebookService {
  void echo(1:string what);
}
