#!/usr/bin/env bash

avahi-browse -rtpl _hashicorp_consul_server._tcp | \
    grep = | \
    awk '
      BEGIN { print  "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
              print  "┃ Other advertising hosts:         ┃"
              print  "┃                                  ┃"
      }
            { printf "┃ ● %-30s ┃\n", $8}
      END   { print  "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛\n"}      
    ' FS=";"
