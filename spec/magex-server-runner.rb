# Magex Copyright 2013 Elisabeth Hendrickson
# See LICENSE.txt for licensing information

$LOAD_PATH << "./app"
$LOAD_PATH << "./magex-client/lib"

require 'app'
require 'magex-client'

def start_magex_simulation
  pipe = IO.popen("rackup -E test -p 4567")
  sleep 3
  pipe
end

$proc = start_magex_simulation

at_exit do
  Process.kill("KILL", $proc.pid)
end
