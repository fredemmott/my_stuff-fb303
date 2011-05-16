# Copyright 2011-present Fred Emmott. All Rights Reserved.

include 'fb303.thrift'

service EchoService extends fb303.FacebookService {
  void echo(1:string what);
}
