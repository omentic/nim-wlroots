# TODO: Verify that these are correct

type PixmanBox32* = object
  x1, y1, x2, y2: int

type
  PixmanRegion32* = object
    extents: PixmanBox32
    data: ptr PixmanRegion32_data

  PixmanRegion32_data* = object
    size: clong
    numRects: clong

type PixmanImage* = object
