#!/bin/bash

arGravity=()

arGravity+=("^ad([sxv]?[0-9]*|system)[_.-]([^.[:space:]]+\.){1,}|[_.-]ad([sxv]?[0-9]*|system)[_.-]")
arGravity+=("^(.+[_.-])?adse?rv(er?|ice)?s?[0-9]*[_.-]                                            ")
arGravity+=("^(.+[_.-])?telemetry[_.-]                                                            ")
arGravity+=("^adim(age|g)s?[0-9]*[_.-]                                                            ")
arGravity+=("^adtrack(er|ing)?[0-9]*[_.-]                                                         ")
arGravity+=("^advert(s|is(ing|ements?))?[0-9]*[_.-]                                               ")
arGravity+=("^aff(iliat(es?|ion))?[_.-]                                                           ")
arGravity+=("^analytics?[_.-]                                                                     ")
arGravity+=("^banners?[_.-]                                                                       ")
arGravity+=("^beacons?[0-9]*[_.-]                                                                 ")
arGravity+=("^count(ers?)?[0-9]*[_.-]                                                             ")
arGravity+=("^mads\.                                                                              ")
arGravity+=("^pixels?[-.]                                                                         ")
arGravity+=("^stat(s|istics)?[0-9]*[_.-]                                                          ")

for regex in ${arGravity[*]}; do
  trimrx=$(echo -e "${regex}" | tr -d '[:space:]')
  pihole --regex ${trimrx}
done
