fs = require 'fs'
http = require 'http'
{spawn} = require 'child_process'

console.log 'Starting upload.coffee...'

fps = parseInt process.argv[2], 10

token = "#{new Date().getTime()}"

opt = {
  method: 'POST'
  host: 'localhost'
  port: 3000
  path: "/stream/#{token}/upload/"
}
p = spawn '/usr/local/Cellar/ffmpeg/1.2.1/bin/ffmpeg', [
    '-re',
    '-r', "#{fps}",
    '-f', 'image2pipe',
    '-vcodec', 'ppm',
    '-threads', '8'
    '-i', '-',
    '-s', '1280x720',
    '-aspect', '16:9',
    '-g', "5",
    '-f', 'flv',
    '-qmin', '5',
    '-qmax', '5',
    'rtmp://localhost/live/mystream'
  ]
console.log "*** PID #{p.pid}"
process.stdin.resume()
process.stdin.pipe p.stdin

p.on 'exit', () ->
  console.log '**** ffmpeg exited'

console.log 'Started.'
