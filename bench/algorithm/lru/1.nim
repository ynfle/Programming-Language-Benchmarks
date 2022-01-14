import std/[os, strutils, tables]

type
  LRU = object
    size: int
    tbl : OrderedTableRef[uint32, uint32]

const 
  A: uint32 = 1103515245
  C: uint32 = 12345
  M: uint32 = 1 shl 31

proc lcg(seed: uint32): uint32 =
      (A*seed+C) mod M

proc get(lru: LRU, key: uint32): bool =
  if lru.tbl.contains(key):
    let v = lru.tbl[key]
    lru.tbl.del(key)
    lru.tbl[key] = v
    true
  else:
    false

proc put(lru: LRU, key: uint32, value: uint32) =
  if lru.tbl.contains(key):
    let v = lru.tbl[key]
    lru.tbl.del(key)
    lru.tbl[key] = v
  elif lru.tbl.len() == lru.size:
    for k in lru.tbl.keys:
      lru.tbl.del(k)
      break
  lru.tbl[key] = value

proc main() =
  let n = if paramCount() > 0: parseInt(paramStr(1)) else: 100

  let lru = LRU(size:10, tbl: newOrderedTable[uint32, uint32](10))

  var
    hit = 0
    missed = 0
    n0 = uint32(0)
    n1 = uint32(1)

  for i in 0..<n:
      n0 = lcg(n0)
      lru.put(n0 mod 100, n0 mod 100)
      n1 = lcg(n1)
      if lru.get(n1 mod 100):
        inc hit
      else:
        inc missed
  echo hit
  echo missed

when isMainModule:
  main()
