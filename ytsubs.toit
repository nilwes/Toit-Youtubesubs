// Copyright (C) 2021 Toitware ApS. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be found
// in the LICENSE file.

// Import libraries for HTTP.
import net
import http
import tls
import certificate_roots

import encoding.json
import hd44780
import gpio

RSpin := gpio.Pin.out 13
ENpin := gpio.Pin.out 12
D4pin := gpio.Pin.out 18
D5pin := gpio.Pin.out 17
D6pin := gpio.Pin.out 16
D7pin := gpio.Pin.out 15

viewCount       := 0
subscriberCount := 0

channelID := "YourYoutubeChannelID"
APIKey    := "YourYoutubeAPIKey"

main:
  hd44780.lcd_init RSpin ENpin D4pin D5pin D6pin D7pin --cursor_enabled=false --cursor_blink=false 
  url := "https://www.googleapis.com/youtube/v3/channels?part=statistics&id=" + channelID + "&key=" + APIKey

  get_yt_stats url
  print_to_display
  

get_yt_stats url:
  network_interface := net.open
  //host := "www.google.com" // Google as our host
  host := "www.googleapis.com" // Google as our host

  tcp := network_interface.tcp_connect host 443
  socket := tls.Socket.client tcp
    --server_name=host
    --root_certificates=[certificate_roots.GLOBALSIGN_ROOT_CA]
  connection := http.Connection socket host
  request := connection.new_request "GET" url  // Create an HTTPS request.
  response := request.send // Send the HTTPS request.

  bytes := 0
  msg := #[]
  while data := response.read:
    msg += data

  decoded := json.decode msg
  viewCount = decoded["items"][0]["statistics"]["viewCount"]
  subscriberCount = decoded["items"][0]["statistics"]["subscriberCount"]

print_to_display:
  hd44780.lcd_write "Subs: $subscriberCount" 0 0
  hd44780.lcd_write "Views: $viewCount" 1 0
