type PixmanBox32* = object
  x1, y1, x2, y2: int32

type PixmanRegion32_data* = object
  size: clong
  numRects: clong

type PixmanRegion32* = object
  extents: PixmanBox32
  data: ptr PixmanRegion32_data

type PixmanImage* = object
