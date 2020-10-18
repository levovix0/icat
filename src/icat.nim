import cligen, imageman, with, colorize, math

type Color = tuple
  r, g, b, a: byte

proc color(r, g, b: int): Color = (r.byte, g.byte, b.byte, 255'u8)
var gs = false

const weights = [" ", "·", "⋄", "⋄", "+", "*", "*", "⊠", "▲", "⁜", "#", "W", "■", "■", "█", "█"]
const grWeights = [" ", "·", "⋄", "⋄", "+", "*", "*", "c", "d", "D", "#", "W", "▲", "●", "■", "█"]
const colors = [
  (color(255, 255, 255), fgWhite),
  (color(182, 185, 192), fgWhite),
  (color(128, 128, 128), fgLightGray),
  (color(80, 80, 80), fgDarkGray),
  (color(255, 0, 0), fgLightRed),
  (color(126, 76, 73), fgRed),
  (color(186, 22, 47), fgRed),
  (color(115, 35, 30), fgRed),
  (color(152, 96, 133), fgLightMagenta),
  (color(163, 106, 149), fgLightMagenta),
  (color(125, 106, 138), fgMagenta),
  (color(68, 30, 51), fgMagenta),
  (color(0, 255, 0), fgGreen),
  (color(0, 0, 255), fgLightBlue),
  (color(0, 0, 170), fgBlue),
  (color(0, 0, 50), fgBlue),
  (color(230, 230, 150), fgLightYellow),
  (color(200, 200, 120), fgLightYellow),
  (color(255, 255, 200), fgLightYellow),
  (color(170, 170, 100), fgYellow),
  (color(172, 97, 84), fgYellow),
  (color(205, 126, 102), fgYellow),
]

proc cols(s: string, c: Color): string =
  var minDelta = int.high
  var i = fgWhite
  for (cc, f) in colors:
    var delta = 0
    delta += abs(cc.r.int - c.r.int)
    delta += abs(cc.g.int - c.g.int)
    delta += abs(cc.b.int - c.b.int)
    if minDelta > delta: minDelta = delta; i = f
  return i(s)

proc c2s(c: Color): string =
  let g = with c: (r.int + g.int + b.int + 3) div 3
  let w = ((g * c.a.int) shr 8) div 16
  return if gs:
    grweights[w]
  else: 
    weights[w].cols(c)

proc r2c(col: proc(x, y: Natural): Color, x1, y1, x2, y2: Natural): Color =
  if x2 <= x1 or y2 <= y1: return (0'u8, 0'u8, 0'u8, 0'u8)

  var r, g, b, a: int = 0

  for y in y1..y2:
    for x in x1..x2:
      let c = col(x, y)
      r += c.r.int; g += c.g.int; b += c.b.int; a += c.a.int
  let S = (x2 - x1 + 1) * (y2 - y1 + 1)
  return ((r div S).byte, (g div S).byte, (b div S).byte, (a div S).byte)

proc icat(resolution: Positive = 10, grayscale: bool = false, args: seq[string]) =
  ## Display an (png) image in terminal
  
  gs = grayscale
  doassert args.len > 0
  let file = args[0]

  let img = loadImage[ColorRGBAU] file

  proc col(x, y: Natural): Color = 
    var c = img.data[y * img.width + x]
    cast[ptr Color](c.addr)[]

  let rx = (resolution.float * 0.6).int
  let ry = resolution
  let w = img.width div rx
  let h = img.height div resolution

  for y in 0..<(h-1):
    for x in 0..<(w-1):
      let c = r2c(col, x * rx, y * ry, (x+1) * rx, (y+1) * ry)
      stdout.write c2s(c)
    stdout.write '\n'

dispatch icat
