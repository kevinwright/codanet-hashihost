#!/usr/bin/env bash

avahi-browse -rtpl _hashicorp_consul_server._tcp | \
    grep = | \
    awk '
      BEGIN { print  "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
              print  "┃ Other hosts currently advertising are: ┃"
      }
            { printf "┃ ● %-20s ┃" $8}
      END   { print  "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛\n"}      
    ' FS=";"
