# Erlang on Alpine Linux

[![Docker Automated build](https://img.shields.io/docker/automated/muhifauzan/alpine-erlang.svg)](https://hub.docker.com/r/muhifauzan/alpine-erlang/)
[![Docker Build Status](https://img.shields.io/docker/build/muhifauzan/alpine-erlang.svg)](https://hub.docker.com/r/muhifauzan/alpine-erlang/builds/)

This Dockerfile provides a full installation of Erlang on Alpine, intended for
running on CI with minimum dependency and it has no build tools installed. This
Dockerfile is almost identical with bitwalker/alpine-erlang with additional
Dialyzer. The caveat of course is if one has NIFs which require a native
compilation toolchain, but that is left as an exercise for the reader.

# Dialyzer PLT

This image provide PLT that built against current Erlang/OTP version. The Erlang
apps that were included are `erts`, `kernel`, `stdlib`, and `crypto`. The output
file is `erlang-20.0.plt`. PLT file is stored in `DIALYZER_PLT_PATH` directory.


# Usage

To boot straight to a prompt in the image:

``` shell
$ docker run --rm -it muhifauzan/alpine-erlang erl
Erlang/OTP 20 [erts-9.0] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1
0] [hipe] [kernel-poll:false]

Eshell V9.0  (abort with ^G)
1>
User switch command
 --> q
```

<!--  LocalWords:  bitwalker
 -->
