
<img src="resources/banner.gif">

#Lua
###Libraries
* [math](https://www.lua.org/manual/5.1/manual.html#5.6)
* [string](https://www.lua.org/manual/5.1/manual.html#5.4)
* [table](https://www.lua.org/manual/5.1/manual.html#5.5)
* [os](https://www.lua.org/manual/5.1/manual.html#5.8)
* [bit](http://bitop.luajit.org/api.html)

The os library has been restricted to the following functions: clock, time, date

###Functions
* [assert](https://www.lua.org/manual/5.1/manual.html#pdf-assert)
* [print](https://www.lua.org/manual/5.1/manual.html#pdf-print)
* [tostring](https://www.lua.org/manual/5.1/manual.html#pdf-tostring)
* [tonumber](https://www.lua.org/manual/5.1/manual.html#pdf-tonumber)
* [pairs](https://www.lua.org/manual/5.1/manual.html#pdf-pairs)
* [ipairs](https://www.lua.org/manual/5.1/manual.html#pdf-ipairs)
* [unpack](https://www.lua.org/manual/5.1/manual.html#pdf-unpack)
* [type](https://www.lua.org/manual/5.1/manual.html#pdf-type)
* [setmetatable](https://www.lua.org/manual/5.1/manual.html#pdf-setmetatable)
* [loadfile](https://www.lua.org/manual/5.1/manual.html#pdf-loadfile)
* [loadstring](https://www.lua.org/manual/5.1/manual.html#pdf-loadstring)

#Math
###vec2
vec2(number, number)<br>
vec2(vec2)<br>
``` lua
local a = vec2(player.x, player.z)
local b = vec2(a)
a:print()
b:print()
```
####v1:dot(v2)
Parameters<br>
`vec2` v1<br>
`vec2` v2<br>
Return Value<br>
`number` returns dot product<br>
``` lua
local a = player.pos2D:dot(mousePos2D)
print(a)
```
####v1:cross(v2)
Parameters<br>
`vec2` v1<br>
`vec2` v2<br>
Return Value<br>
`number` returns cross product<br>
``` lua
local a = player.pos2D:cross(mousePos2D)
print(a)
```
####v1:len()
Parameters<br>
`vec2` v1<br>
Return Value<br>
`number` returns length of v1<br>
``` lua
local a = mousePos2D - player.pos2D
local b = a:len()
print(b)
```
####v1:lenSqr()
Parameters<br>
`vec2` v1<br>
Return Value<br>
`number` returns squared length of v1<br>
``` lua
local a = mousePos2D - player.pos2D
local b = a:lenSqr()
print(b)
```
####v1:norm()
Parameters<br>
`vec2` v1<br>
Return Value<br>
`vec2` returns normalized v1<br>
``` lua
local a = mousePos2D - player.pos2D
local b = a:norm()
b:print()
```
####v1:dist(v2)
Parameters<br>
`vec2` v1<br>
`vec2` v2<br>
Return Value<br>
`number` returns distance between v1 and v2<br>
``` lua
local a = mousePos2D:dist(player.pos2D)
print(a)
```
####v1:distSqr(v2)
Parameters<br>
`vec2` v1<br>
`vec2` v2<br>
Return Value<br>
`number` returns squared distance between v1 and v2<br>
``` lua
local a = mousePos2D:distSqr(player.pos2D)
print(a)
```
####v1:perp1()
Parameters<br>
`vec2` v1<br>
Return Value<br>
`vec2` returns perpendicular (left) vec2 to v1<br>
``` lua
local a = mousePos2D-player.pos2D
local b = a:norm()
local c = b:perp1()
c:print()
```
####v1:perp2()
Parameters<br>
`vec2` v1<br>
Return Value<br>
`vec2` returns perpendicular (right) vec2 to v1<br>
``` lua
local a = mousePos2D-player.pos2D
local b = a:norm()
local c = b:perp2()
c:print()
```
####v1:lerp(v2, s)
Parameters<br>
`vec2` v1<br>
`vec2` v2<br>
`number` s<br>
Return Value<br>
`vec2` returns interpolated vec2 between v1 and v2 by factor s<br>
``` lua
local a = player.pos2D:lerp(mousePos2D, 0.5)
a:print()
```
####v1:clone()
Parameters<br>
`vec2` v1<br>
Return Value<br>
`vec2` returns cloned v1<br>
``` lua
local a = player.pos2D:clone()
a:print()
```
####v1:to3D(y)
Parameters<br>
`vec2` v1<br>
`number` y<br>
Return Value<br>
`vec3` returns vec3<br>
``` lua
local a = vec2(player.x, player.z)
local b = a:to3D(mousePos.y)
b:print()
```
####v1:rotate(s)
Parameters<br>
`vec2` v1<br>
`number` s<br>
Return Value<br>
`vec2` returns vec2 rotated by s radians<br>
``` lua
local a = (mousePos2D-player.pos2D)
local b = a:norm()
local c = b:rotate(0.785398)
c:print()
```
####v1:print()
Parameters<br>
`vec2` v1<br>
Return Value<br>
`void`
``` lua
local a = vec2(mousePos.x, mousePos.z)
a:print()
```
####vec2.array(n)
Parameters<br>
`number` n<br>
Return Value<br>
`vec2[?]` returns vec2 array of length n<br>
``` lua
local a = vec2.array(12)
a[0].x = 100
a[0].y = 200
a[0]:print()
```
###vec3
vec3(number, number, number)<br>
vec3(vec3)<br>
``` lua
local a = vec3(player.x, player.y, player.z)
local b = vec3(a)
a:print()
b:print()
```
####v1:dot(v2)
Parameters<br>
`vec3` v1<br>
`vec3` v2<br>
Return Value<br>
`number` returns dot product<br>
``` lua
local a = player.pos:dot(mousePos)
print(a)
```
####v1:cross(v2)
Parameters<br>
`vec3` v1<br>
`vec3` v2<br>
Return Value<br>
`number` returns cross product<br>
``` lua
local a = player.pos:cross(mousePos)
print(a)
```
####v1:len()
Parameters<br>
`vec3` v1<br>
Return Value<br>
`number` returns length of v1<br>
``` lua
local a = mousePos - player.pos
local b = a:len()
print(b)
```
####v1:lenSqr()
Parameters<br>
`vec3` v1<br>
Return Value<br>
`number` returns squared length of v1<br>
``` lua
local a = mousePos - player.pos
local b = a:lenSqr()
print(b)
```
####v1:norm()
Parameters<br>
`vec3` v1<br>
Return Value<br>
`vec3` returns normalized v1<br>
``` lua
local a = mousePos - player.pos
local b = a:norm()
b:print()
```
####v1:dist(v2)
Parameters<br>
`vec3` v1<br>
`vec3` v2<br>
Return Value<br>
`number` returns distance between v1 and v2<br>
``` lua
local a = mousePos:dist(player.pos)
print(a)
```
####v1:distSqr(v2)
Parameters<br>
`vec3` v1<br>
`vec3` v2<br>
Return Value<br>
`number` returns squared distance between v1 and v2<br>
``` lua
local a = mousePos:distSqr(player.pos)
print(a)
```
####v1:perp1()
Parameters<br>
`vec3` v1<br>
Return Value<br>
`vec3` returns perpendicular (left) vec3 to v1<br>
``` lua
local a = mousePos-player.pos
local b = a:norm()
local c = b:perp1()
c:print()
```
####v1:perp2()
Parameters<br>
`vec3` v1<br>
Return Value<br>
`vec3` returns perpendicular (right) vec3 to v1<br>
``` lua
local a = mousePos-player.pos
local b = a:norm()
local c = b:perp2()
c:print()
```
####v1:lerp(v2, s)
Parameters<br>
`vec3` v1<br>
`vec3` v2<br>
`number` s<br>
Return Value<br>
`vec3` returns interpolated vec3 between v1 and v2 by factor s<br>
``` lua
local a = player.pos:lerp(mousePos, 0.5)
a:print()
```
####v1:clone()
Parameters<br>
`vec3` v1<br>
Return Value<br>
`vec3` returns cloned v1<br>
``` lua
local a = player.pos:clone()
a:print()
```
####v1:to2D()
Parameters<br>
`vec3` v1<br>
Return Value<br>
`vec2` returns vec2 from x and z properties<br>
``` lua
local a = vec3(player.x, player.y, player.z)
local b = a:to2D()
b:print()
```
####v1:rotate(s)
Parameters<br>
`vec3` v1<br>
`number` s<br>
Return Value<br>
`vec3` returns vec3 rotated by s radians<br>
``` lua
local a = (mousePos-player.pos)
local b = a:norm()
local c = b:rotate(0.785398)
c:print()
```
####v1:print()
Parameters<br>
`vec3` v1<br>
Return Value<br>
`void`
``` lua
local a = vec3(mousePos.x, mousePos.y, mousePos.z)
a:print()
```
####vec3.array(n)
Parameters<br>
`number` n<br>
Return Value<br>
`vec3[?]` returns vec3 array of length n<br>
``` lua
local a = vec3.array(12)
a[0].x = 100
a[0].y = 50
a[0].z = 200
a[0]:print()
```
###vec4
vec4(number, number, number)<br>
vec4(vec4)<br>
####v1:dot(v2)
Parameters<br>
`vec4` v1<br>
`vec4` v2<br>
Return Value<br>
`number` returns dot product<br>
####v1:cross(v2)
Parameters<br>
`vec4` v1<br>
`vec4` v2<br>
Return Value<br>
`number` returns cross product<br>
####v1:len()
Parameters<br>
`vec4` v1<br>
Return Value<br>
`number` returns length of v1<br>
####v1:lenSqr()
Parameters<br>
`vec4` v1<br>
Return Value<br>
`number` returns squared length of v1<br>
####v1:norm()
Parameters<br>
`vec4` v1<br>
Return Value<br>
`vec4` returns normalized v1<br>
####v1:dist(v2)
Parameters<br>
`vec4` v1<br>
`vec4` v2<br>
Return Value<br>
`number` returns distance between v1 and v2<br>
####v1:distSqr(v2)
Parameters<br>
`vec4` v1<br>
`vec4` v2<br>
Return Value<br>
`number` returns squared distance between v1 and v2<br>
####v1:perp1()
Parameters<br>
`vec4` v1<br>
Return Value<br>
`vec4` returns perpendicular (left) vec4 to v1<br>
####v1:perp2()
Parameters<br>
`vec4` v1<br>
Return Value<br>
`vec4` returns perpendicular (right) vec4 to v1<br>
####v1:lerp(v2, s)
Parameters<br>
`vec4` v1<br>
`vec4` v2<br>
`number` s<br>
Return Value<br>
`vec4` returns interpolated vec4 between v1 and v2 by factor s<br>
####v1:clone()
Parameters<br>
`vec4` v1<br>
Return Value<br>
`vec4` returns cloned v1<br>
####v1:to2D()
Parameters<br>
`vec4` v1<br>
Return Value<br>
`vec2` returns vec2 from x and z properties<br>
####v1:rotate(s)
Parameters<br>
`vec4` v1<br>
`number` s<br>
Return Value<br>
`vec4` returns vec4 rotated by s radians<br>
####v1:print()
Parameters<br>
`vec4` v1<br>
Return Value<br>
`void`
####vec4.array(n)
Parameters<br>
`number` n<br>
Return Value<br>
`vec4[?]` returns vec4 array of length n<br>
###mathf
A library of commonly used 2D math functions.<br>
####mathf.PI
Return Value<br>
`number` returns pi<br>
``` lua
print(mathf.PI)
```
####mathf.cos(n)
Parameters<br>
`number` n<br>
Return Value<br>
`number` returns the cosine of n<br>
``` lua
local a = mathf.cos(mathf.PI)
print(a)
```
####mathf.sin(n)
Parameters<br>
`number` n<br>
Return Value<br>
`number` returns the sine of n<br>
``` lua
local a = mathf.sin(mathf.PI)
print(a)
```
####mathf.round(n, d)
Parameters<br>
`number` n<br>
`number` d<br>
Return Value<br>
`number` returns rounded n to precision d<br>
``` lua
local a = mathf.round(1.234567, 3)
print(a)
```
####mathf.sqr(n)
Parameters<br>
`number` n<br>
Return Value<br>
`number` returns squared value of n<br>
``` lua
local a = mathf.sqr(2)
print(a)
```
####mathf.clamp(min, max, n)
Parameters<br>
`number` min<br>
`number` max<br>
`number` n<br>
Return Value<br>
`number` returns clamped n between min and max<br>
``` lua
local a = mathf.clamp(0, 25, -1)
print(a)
```
####mathf.sect_line_line(v1, v3, v3, v4)
Parameters<br>
`vec2` v1<br>
`vec2` v2<br>
`vec2` v3<br>
`vec2` v4<br>
Return Value<br>
`vec2` returns intersection point of lines (v1, v2) and (v3, v4)<br>
``` lua
local v1 = vec2(0, 0)
local v2 = vec2(100,100)
local v3 = vec2(100, 0)
local v4 = vec2(0,100)
local a = mathf.sect_line_line(v1, v2, v3, v4)
a:print()
```
####mathf.dist_line_vector(v1, v2, v3)
Parameters<br>
`vec2` v1<br>
`vec2` v2<br>
`vec2` v3<br>
Return Value<br>
`number` returns distance between v1 and line (v2, v3)<br>
``` lua
local v1 = vec2(0, 0)
local v2 = vec2(100, 0)
local v3 = vec2(0,100)
local a = mathf.dist_line_vector(v1, v2, v3)
print(a)
```
####mathf.angle_between(v1, v2, v3)
Parameters<br>
`vec2` v1<br>
`vec2` v2<br>
`vec2` v3<br>
Return Value<br>
`number` returns the angle between v2 and v3 from origin v1 in radians<br>
``` lua
local v1 = vec2(0, 0)
local a = mathf.angle_between(v1, player.pos2D, mousePos2D)
print(a)
```
####mathf.mec(pts, n)
Parameters<br>
`vec2[]` pts<br>
`number` n<br>
Return Value<br>
`vec2` returns the center of the minimum enclosing circle<br>
`number` returns the radius of the minimum enclosing circle<br>
``` lua
local pts = vec2.array(2)
pts[0].x, pts[0].y = 0, 0
pts[1].x, pts[1].y = mousePos.x, mousePos.z
pts[2].x, pts[2].y = player.x, player.z
local c, n = mathf.mec(pts, 2)
print(c.x, c.y, n)
```
####mathf.project(v1, v2, v3, s1, s2)
Parameters<br>
`vec2` v1<br>
`vec2` v2<br>
`vec2` v3<br>
`number` s1<br>
`number` s2<br>
Return Value<br>
`vec2` returns the collision point<br>
`number` returns the time until collision occurs<br>
``` lua
--calculates collision position and time of a projectile from mousePos along the players path
local src = mousePos2D
local pos_s = player.path.serverPos2D
local pos_e = player.path.point2D[player.path.index]
local s1 = 2000
local s2 = player.moveSpeed

local res, res_t = mathf.project(src, pos_s, pos_e, s1, s2)
if res then
	print(res.x, res.y, res_t)
end
```
####mathf.dist_seg_seg(v1, v2, v3, v4)
Parameters<br>
`vec2` v1<br>
`vec2` v2<br>
`vec2` v3<br>
`vec2` v4<br>
Return Value<br>
`number` returns the distance between line segments (v1, v2) and (v3, v4)<br>
``` lua
local v1 = vec2(0,0)
local v2 = vec2(1000,1000)
local v3 = mousePos2D
local v4 = player.pos2D
local res = mathf.dist_seg_seg(v1, v2, v3, v4)
print(res)
```
####mathf.closest_vec_line(v1, v2, v3)
Parameters<br>
`vec2` v1<br>
`vec2` v2<br>
`vec2` v3<br>
Return Value<br>
`vec2` returns a vec2 along the line (v2, v3) closest to v1<br>
``` lua
local v1 = player.pos2D
local v2 = vec2(0,0)
local v3 = mousePos2D
local res = mathf.closest_vec_line(v1, v2, v3)
res:print()
```
####mathf.closest_vec_line_seg(v1, v2, v3)
Parameters<br>
`vec2` v1<br>
`vec2` v2<br>
`vec2` v3<br>
Return Value<br>
`vec2` returns a vec2 along the line segment (v2, v3) closest to v1<br>
``` lua
local v1 = player.pos2D
local v2 = vec2(0,0)
local v3 = mousePos2D
local res = mathf.closest_vec_line_seg(v1, v2, v3)
if res then
	res:print()
end
```
####mathf.col_vec_rect(v1, v2, v3, w1, w2)
Parameters<br>
`vec2` v1<br>
`vec2` v2<br>
`vec2` v3<br>
`number` w1<br>
`number` w2<br>
Return Value<br>
`boolean` returns true if v1 with bounding radius of w1 collides with line (v2, v3) of width w2<br>
``` lua
local v1 = player.pos2D
local v2 = vec2(0, 0)
local v3 = mousePos2D
local w1 = player.boundingRadius
local w2 = 100
local res = mathf.col_vec_rect(v1, v2, v3, w1, w2)
print(res)
```
####mathf.sect_circle_circle(v1, r1, v2, r2)
Parameters<br>
`vec2` v1<br>
`number` r1<br>
`vec2` v2<br>
`number` r2<br>
Return Value<br>
`vec2` returns first intersection of circles at v1 with radius of r1 and v2 with radius of r2<br>
`vec2` returns second intersection of circles at v1 with radius of r1 and v2 with radius of r2<br>
``` lua
local v1 = mousePos2D
local r1 = 500
local v2 = player.pos2D
local r2 = player.attackRange
local res1, res2 = mathf.sect_circle_circle(v1, r1, v2, r2)
if res1 then
	res1:print()
	res2:print()
end
```
####mathf.sect_line_circle(v1, v2, v3, r)
Parameters<br>
`vec2` v1<br>
`vec2` v2<br>
`vec2` v3<br>
`number` r<br>
Return Value<br>
`vec2` returns first intersection of line (v1, v2) and circle v3 with radius of r<br>
`vec2` returns second intersection of line (v1, v2) and circle v3 with radius of r<br>
``` lua
local v1 = vec2(0, 0)
local v2 = mousePos2D
local v3 = player.pos2D
local r = player.attackRange
local res1, res2 = mathf.sect_line_circle(v1, v2, v3, r)
if res1 then
	res1:print()
end
if res2 then
	res2:print()
end
```
####mathf.mat2()
Return Value<br>
`double[2][2]` returns a 2x2 transformation matrix<br>
####mathf.mat3()
Return Value<br>
`double[3][3]` returns a 3x3 transformation matrix<br>
####mathf.mat4()
Return Value<br>
`double[4][4]` returns a 4x4 transformation matrix<br>
###clipper
Unlike the other math libraries, clipper must first be loaded.<br>
Further documentation can be found [here](http://www.angusj.com/delphi/clipper/documentation/Docs/_Body.htm).
``` lua
local clip = module.internal('clipper')
local polygon = clip.polygon
local polygons = clip.polygons
local clipper = clip.clipper
local clipper_enum = clip.enum
```
Enums:

 * clipper_enum.PolyFillType.EvenOdd
 * clipper_enum.PolyFillType.NonZero
 * clipper_enum.PolyFillType.Positive
 * clipper_enum.PolyFillType.Negative
 * clipper_enum.JoinType.Square
 * clipper_enum.JoinType.Round
 * clipper_enum.JoinType.Miter
 * clipper_enum.ClipType.Intersection
 * clipper_enum.ClipType.Union
 * clipper_enum.ClipType.Difference
 * clipper_enum.ClipType.Xor
 * clipper_enum.PolyType.Subject
 * clipper_enum.PolyType.Clip

####polygon:Add(v1)
Parameters<br>
`vec2` v1<br>
Return Value<br>
`void`<br>
``` lua
local p = polygon()
local v = vec2(200, 200)
p:Add(v)
```
####polygon:ChildCount()
Return Value<br>
`number` returns number of vertices<br>
``` lua
local p = polygon(vec2(200, 200), vec2(200, 100), vec2(100, 200))

print(p:ChildCount())
```
####polygon:Childs(i)
Parameters<br>
`number` i<br>
Return Value<br>
`vec2` returns vec2 at vertex i<br>
``` lua
local p = polygon(vec2(200, 200), vec2(200, 100), vec2(100, 200))

local v = p:Childs(1)
v:print()
```
####polygon:Area()
Return Value<br>
`number` returns the area of polygon<br>
``` lua
local p = polygon(vec2(200, 200), vec2(200, 100), vec2(100, 200))

print(p:Area())
```
####polygon:Clean(dist)
Parameters<br>
`number` dist<br>
Return Value<br>
`void`<br>
``` lua
local p = polygon(vec2(200, 200), vec2(200, 100), vec2(200, 101), vec2(100, 200))

print(p:ChildCount())
p:Clean(5)
print(p:ChildCount())
```
####polygon:Simplify(PolyFillType)
Parameters<br>
`number` PolyFillType<br>
Return Value<br>
`polygons` returns polygon set<br>
``` lua
local p1 = polygon(vec2(5,62), vec2(164,62), vec2(36,157), vec2(85, 4), vec2(134, 158))
local p = p1:Simplify(clipper_enum.PolyFillType.NonZero)
local p2 = p:Childs(0)

cb.add(cb.draw, function()
	p2:Draw2D(5, 0xFF00FFFF)
	p1:Draw2D(2, 0xFFFF00FF)
end)
```
####polygon:Orientation()
Return Value<br>
`number` returns 1 if polygon has clockwise orientation<br>
####polygon:Reverse()
Return Value<br>
`void` reverses polygons orientation<br>
####polygon:Contains(v1)
Parameters<br>
`vec2\vec3` v1<br>
Return Value<br>
`number` returns 1 if v1 is inside of polygon, 0 if outside, -1 if v1 is on polygon edge<br>
``` lua
local p1 = polygon(vec2(200,200), vec2(200,300), vec2(300,300), vec2(300, 200))
cb.add(cb.draw, function()
	p1:Draw2D(2, p1:Contains(game.cursorPos)==1 and 0xFF00FF00 or 0xFFFF0000)
end)
```
####polygon:Draw2D(width, color)
Parameters<br>
`number` width<br>
`number` color<br>
Return Value<br>
`void`<br>
####polygon:Draw3D(y, width, color)
Parameters<br>
`number` y<br>
`number` width<br>
`number` color<br>
Return Value<br>
`void`<br>
####polygon:OnScreen2D()
Return Value<br>
`boolean` returns true if polygon intersects the screen<br>
####polygon:OnScreen3D(y)
Parameters<br>
`number` y<br>
Return Value<br>
`boolean` returns true if polygon intersects the screen<br>
####polygons:Add(polygon)
Parameters<br>
`polygon` polygon<br>
Return Value<br>
`void`<br>
####polygons:ChildCount()
Return Value<br>
`number` returns number of polygons contained polygon set<br>
####polygons:Childs(i)
Parameters<br>
`number` i<br>
Return Value<br>
`polygon` returns polygon at index i<br>
####polygons:Reverse()
Return Value<br>
`void` reverses the orientation of all containing polygons<br>
####polygons:Clean(dist)
Parameters<br>
`number` dist<br>
Return Value<br>
`void` cleans all contained polygons<br>
####polygons:Simplify(PolyFillType)
Parameters<br>
`number` PolyFillType<br>
Return Value<br>
`polygons` returns polygon set<br>
####polygons:Offset(delta, JoinType, limit)
Parameters<br>
`number` delta<br>
`number` JoinType<br>
`number` limit<br>
Return Value<br>
`polygons` returns polygon set<br>
####clipper:AddPath(polygon, PolyType, closed)
Parameters<br>
`polygon` polygon<br>
`number` PolyType<br>
`boolean` closed<br>
Return Value<br>
`void`<br>
####clipper:AddPaths(polygons, PolyType, closed)
Parameters<br>
`polygons` polygons<br>
`number` PolyType<br>
`boolean` closed<br>
Return Value<br>
`void`<br>
####clipper:Clear()
Return Value<br>
`void`<br>
####clipper:Execute(ClipType, PolyFillType, PolyFillType)
Parameters<br>
`number` ClipType<br>
`number` PolyFillType<br>
`number` PolyFillType<br>
Return Value<br>
`polygons` returns polygon set<br>
#Libraries
###hanbot
####hanbot.path
Return Value<br>
`string` returns hanbots working directory
####hanbot.luapath
Return Value<br>
`string` returns directory of non-shard scripts
####hanbot.libpath
Return Value<br>
`string` returns directory of community libraries
####hanbot.shardpath
Return Value<br>
`string` returns directory of shards
####hanbot.hwid
Return Value<br>
`string` returns current users hwid
####hanbot.user
Return Value<br>
`string` returns current users id
####hanbot.language
Return Value<br>
`number` returns language id
###cb
Enums:<br>

 * cb.draw
 * cb.tick
 * cb.spell
 * cb.keyup
 * cb.keydown
 * cb.issueorder
 * cb.issue_order
 * cb.castspell
 * cb.cast_spell
 * cb.pre_tick
 * cb.delete_minion
 * cb.create_minion
 * cb.delete_particle
 * cb.create_particle
 * cb.delete_missile
 * cb.create_missile
 * cb.path
 * cb.draw2
 * cb.sprite
 * cb.error
 
####cb.add(t, f)
Parameters<br>
`number` t<br>
`function` f<br>
Return Value<br>
`void`
``` lua
local tick_n = 0
local function on_tick()
	tick_n = tick_n + 1
	print(tick_n)
end

cb.add(cb.tick, on_tick)
```

####cb.remove(f)
Parameters<br>
`function` f<br>
Return Value<br>
`void`
``` lua
local tick_n = 0
local function on_tick()
	tick_n = tick_n + 1
	if tick_n == 10 then
		print('removed')
		cb.remove(on_tick)
	end
end

cb.add(cb.tick, on_tick)
```

###chat
####chat.isOpened
Return Value<br>
`boolean` returns true if chat is open
####chat.send(str)
Parameters<br>
`string` str<br>
Return Value<br>
`void`<br>
####chat.print(str)
Parameters<br>
`string` str<br>
Return Value<br>
`void`<br>
###console
####console.set_color(c)
Parameters<br>
`number` c<br>
Return Value<br>
`void`<br>
####console.printx(str, c)
Parameters<br>
`string` str<br>
`number` c<br>
Return Value<br>
`void`<br>
###minimap
####minimap.x
Return Value<br>
`number` returns the screen x pos of the upper left corner of the minimap<br>
####minimap.y
Return Value<br>
`number` returns the screen y pos of the upper left corner of the minimap<br>
####minimap.width
Return Value<br>
`number` returns the screen width of the minimap<br>
####minimap.height
Return Value<br>
`number` returns the screen height of the minimap<br>
####minimap.bounds
Return Value<br>
`vec2` returns the maximum map boundaries<br>
####minimap.world_to_map(v1)
Parameters<br>
`vec2\vec3` v1<br>
Return Value<br>
`vec2` returns the screen pos of v1 on the minimap<br>
``` lua
local v1 = player.pos
local a = minimap.world_to_map(v1)
a:print()
```
####minimap.on_map(v1)
Parameters<br>
`vec2` v1<br>
Return Value<br>
`boolean` returns true if v1 is hovering the minimap<br>
``` lua
local v1 = game.cursorPos
local a = minimap.on_map(v1)
print(a)
```
####minimap.on_map_xy(x, y)
Parameters<br>
`number` x<br>
`number` y<br>
Return Value<br>
`boolean` returns true if (x, y) is hovering the minimap<br>
``` lua
local x = game.cursorPos.x
local y = game.cursorPos.y
local a = minimap.on_map_xy(x, y)
print(a)
```
####minimap.draw_circle(v1, r, w, c, n)
Parameters<br>
`vec3` v1<br>
`number` r<br>
`number` w<br>
`number` c<br>
`number` n<br>
Return Value<br>
`void`<br>
``` lua
local function on_draw()
	local v1 = player.pos
	local radius = 1000
	local line_width = 1
	local color = 0xFFFFFFFF
	local points_n = 16
	minimap.draw_circle(v1, radius, line_width, color, points_n)
end

cb.add(cb.draw, on_draw)
```
###ping
Enums:<br>

 * ping.ALERT
 * ping.DANGER
 * ping.MISSING_ENEMY
 * ping.ON_MY_WAY
 * ping.RETREAT
 * ping.ASSIST_ME
 * ping.AREA_IS_WARDED
 
####ping.send(vec3 pos [, number ping_type [, obj target]])
Parameters<br>
`vec3` pos<br>
`number` ping_type<br>
`game.obj` obj<br>
Return Value<br>
`void` <br>
####ping.recv(vec3 pos [, number ping_type [, obj target]])
Parameters<br>
`vec3` pos<br>
`number` ping_type<br>
`game.obj` obj<br>
Return Value<br>
`void` <br>

###navmesh
####navmesh.getTerrainHeight(x, z)
Parameters<br>
`number` x coordinate<br>
`number` z coordinate<br>
Return Value<br>
`number` returns terrain height at x,z<br>

####navmesh.isGrass(v1)
Parameters<br>
`vec2\vec3` v1<br>
Return Value<br>
`boolean` returns true if v1 is in grass<br>

####navmesh.isWall(v1)
Parameters<br>
`vec2\vec3` v1<br>
Return Value<br>
`boolean` returns true if v1 is a wall<br>

####navmesh.isStructure(v1)
Parameters<br>
`vec2\vec3` v1<br>
Return Value<br>
`boolean` returns true if v1 is a structure<br>

####navmesh.isInFoW(v1)
Parameters<br>
`vec2\vec3` v1<br>
Return Value<br>
`boolean` returns true if v1 is in fog of war<br>

####navmesh.getNearstPassable(v1)
Parameters<br>
`vec2\vec3` v1<br>
Return Value<br>
`vec2` returns the nearst passable position to v1<br>

###game
####game.mousePos
Return Value<br>
`vec3` returns the current position of the mouse<br>
####game.mousePos2D
Return Value<br>
`vec2` returns the current position of the mouse<br>
####game.cameraPos
Return Value<br>
`vec3` returns the current position of the camera<br>
####game.cameraLock
Return Value<br>
`boolean` returns true if the camera is locked<br>
####game.setCameraLock(bool)
Parameters<br>
`boolean` bool<br>
Return Value<br>
`void` <br>
####game.cameraY
Return Value<br>
`number` returns the current camera zoom<br>
####game.cursorPos
Return Value<br>
`vec2` returns the current cursor position<br>
####game.time
Return Value<br>
`number` returns the current game time<br>
####game.version
Return Value<br>
`string` returns the current game version<br>
####game.selectedTarget
Return Value<br>
`obj` returns the current selected game object<br>
####game.hoveredTarget
Return Value<br>
`obj` returns the current hovered game object<br>
####game.mapID
Return Value<br>
`number` returns the current map ID<br>
####game.mode
Return Value<br>
`string` returns the current game mode<br>
####game.isWindowFocused
Return Value<br>
`boolean` returns true if LoL is focused<br>
###graphics
####graphics.width
Return Value<br>
`number` returns screen width<br>
####graphics.height
Return Value<br>
`number` returns screen height<br>
####graphics.res
Return Value<br>
`vec2` returns screen resolution<br>
####graphics.draw_text_2D(str, size, x, y, color)
Parameters<br>
`string` str<br>
`number` size<br>
`number` x<br>
`number` y<br>
`number` color<br>
Return Value<br>
`void`<br>
``` lua
local function on_draw()
	graphics.draw_text_2D('foo', 14, game.cursorPos.x, game.cursorPos.y, 0xFFFFFFFF)
end

cb.add(cb.draw, on_draw)
```
####graphics.text_area(str, size, n)
Parameters<br>
`string` str<br>
`number` size<br>
`number` n<br>
Return Value<br>
`number` returns str width<br>
`number` returns str height<br>
``` lua
local str = 'foo'
local font_size = 14
local x, y = graphics.text_area(str, font_size)
print(x, y)
```
####graphics.get_font()
Return Value<br>
`string` returns current font name<br>
####graphics.argb(a, r, g, b)
Parameters<br>
`number` a<br>
`number` r<br>
`number` g<br>
`number` b<br>
Return Value<br>
`number` returns color<br>
``` lua
local color = graphics.argb(255, 25, 185, 90)
local function on_draw()
	graphics.draw_text_2D('foo', 14, game.cursorPos.x, game.cursorPos.y, color)
end

cb.add(cb.draw, on_draw)
```
####graphics.world_to_screen(v1)
Parameters<br>
`vec3` v1<br>
Return Value<br>
`vec2` returns screen position from world position<br>
``` lua
local function on_draw()
	local v = graphics.world_to_screen(player.pos)
	graphics.draw_text_2D('foo', 14, v.x, v.y, 0xFFFFFFFF)
end

cb.add(cb.draw, on_draw)
```
####graphics.world_to_screen_xyz(x, y, z)
Parameters<br>
`number` x<br>
`number` y<br>
`number` z<br>
Return Value<br>
`vec2` returns screen position from world position<br>
``` lua
local function on_draw()
	local v = graphics.world_to_screen_xyz(player.x, player.y, player.z)
	graphics.draw_text_2D('foo', 14, v.x, v.y, 0xFFFFFFFF)
end

cb.add(cb.draw, on_draw)
```
####graphics.draw_line_2D(x1, y1, x2, y2, width, color)
Parameters<br>
`number` x1<br>
`number` y1<br>
`number` x2<br>
`number` y2<br>
`number` width<br>
`number` color<br>
Return Value<br>
`void`<br>
``` lua
local function on_draw()
	graphics.draw_line_2D(0, 0, game.cursorPos.x, game.cursorPos.y, 2, 0xFFFFFFFF)
end

cb.add(cb.draw, on_draw)
```
####graphics.draw_line(v1, v2, width, color)
Parameters<br>
`vec3` v1<br>
`vec3` v2<br>
`number` width<br>
`number` color<br>
Return Value<br>
`void`<br>
``` lua
local function on_draw()
	graphics.draw_line(mousePos, player.pos, 2, 0xFFFFFFFF)
end

cb.add(cb.draw, on_draw)
```

####graphics.draw_triangle_2D(p1, p2, p3, width, color, is_filled)
Parameters<br>
`vec2` p1<br>
`vec2` p2<br>
`vec2` p3<br>
`number` width<br>
`number` color<br>
`boolean` is_filled: default: false<br>
Return Value<br>
`void`<br>
``` lua
local function on_draw()
	graphics.draw_triangle_2D(vec2(10, 10),vec2(10, 50),vec2(50, 10), 2, 0xFFFFFFFF, true)
end

cb.add(cb.draw, on_draw)
```

####graphics.draw_rectangle_2D(x, y, dx, dy, width, color, is_filled)
Parameters<br>
`number` x<br>
`number` y<br>
`number` dx<br>
`number` dy<br>
`number` width<br>
`number` color<br>
`boolean` is_filled: default: false<br>
Return Value<br>
`void`<br>
``` lua
local function on_draw()
	graphics.draw_rectangle_2D(game.cursorPos.x, game.cursorPos.y, 90, 20, 2, 0xFFFFFFFF)
end

cb.add(cb.draw, on_draw)
```
####graphics.draw_line_strip(pts, width, color, pts_n)
Parameters<br>
`vec3[]` pts<br>
`number` width<br>
`number` color<br>
`number` pts_n<br>
Return Value<br>
`void`<br>
``` lua
local function on_draw()
	if player.path.active then
		graphics.draw_line_strip(player.path.point, 2, 0xFFFFFFFF, player.path.count+1)
	end
end

cb.add(cb.draw, on_draw)
```
####graphics.draw_line_strip_2D(pts, width, color, pts_n)
Parameters<br>
`vec2[]` pts<br>
`number` width<br>
`number` color<br>
`number` pts_n<br>
Return Value<br>
`void`<br>
``` lua
local v = vec2.array(4)
v[0].x = 200
v[0].y = 200
v[1].x = 400
v[1].y = 200
v[2].x = 400
v[2].y = 400
v[3].x = 200
v[3].y = 400
local function on_draw()
	graphics.draw_line_strip_2D(v, 2, 0xFFFFFFFF, 4)
end

cb.add(cb.draw, on_draw)
```
####graphics.draw_circle(v1, radius, width, color, pts_n)
Parameters<br>
`vec3` v1<br>
`number` radius<br>
`number` width<br>
`number` color<br>
`number` pts_n<br>
Return Value<br>
`void`<br>
``` lua
local function on_draw()
	graphics.draw_circle(player.pos, player.attackRange, 2, 0xFFFFFFFF, 32)
end

cb.add(cb.draw, on_draw)
```
####graphics.draw_circle_2D(x, y, radius, width, color, pts_n)
Parameters<br>
`number` x<br>
`number` y<br>
`number` radius<br>
`number` width<br>
`number` color<br>
`number` pts_n<br>
Return Value<br>
`void`<br>
``` lua
local function on_draw()
	graphics.draw_circle_2D(game.cursorPos.x, game.cursorPos.y, 120, 2, 0xFFFFFFFF, 32)
end

cb.add(cb.draw, on_draw)
```
####graphics.draw_circle_xyz(x, y, z, radius, width, color, pts_n)
Parameters<br>
`number` x<br>
`number` y<br>
`number` z<br>
`number` radius<br>
`number` width<br>
`number` color<br>
`number` pts_n<br>
Return Value<br>
`void`<br>
``` lua
local function on_draw()
	graphics.draw_circle_xyz(player.x, player.y, player.z, player.attackRange, 2, 0xFFFFFFFF, 32)
end

cb.add(cb.draw, on_draw)
```
####graphics.draw_sprite(name, v1, scale, color)
Parameters<br>
`string` name<br>
`vec3` v1<br>
`number` scale<br>
`number` color<br>
Return Value<br>
`void`<br>
``` lua
local function on_draw_sprite()
	--sprite files must be placed in your shard directory
	graphics.draw_sprite("sprite_name.png", vec3(p.x, p.y, 0), 1.5, 0x66FFFFFF)
end

cb.add(cb.sprite, on_draw_sprite)
```
####graphics.spawn_fake_click(color, v1)
Parameters<br>
`string` color: "red" or "green"<br>
`vec3` v1: world_pos<br>
Return Value<br>
`void`<br>
``` lua
local function on_key_down(k)
	if k==49 then --1
		graphics.spawn_fake_click("green", mousePos)
	end
end

cb.add(cb.keydown, on_key_down)
```

####graphics.set_draw(enabled)
Parameters<br>
`boolean` enabled<br>
Return Value<br>
`void`<br>

####graphics.get_draw()
Parameters<br>
Return Value<br>
`boolean` enabled<br>

####graphics.set_draw_menu(enabled)
Parameters<br>
`boolean` enabled<br>
Return Value<br>
`void`<br>

###shadereffect
####shadereffect.contruct(effect_description, is_3D)
Parameters<br>
`string` effect_description<br>
`boolean` is_3D<br>
Return Value<br>
`shadereffect` shadereffect<br>

####shadereffect.begin(shadereffect, height, is_3D)
Parameters<br>
`shadereffect` shadereffect<br>
`number` hieght<br>
`boolean` is_3D<br>
Return Value<br>
`void`<br>

####shadereffect.set_float(shadereffect, varname, var)
Parameters<br>
`shadereffect` shadereffect<br>
`string` varname<br>
`number` var<br>
Return Value<br>
`void`<br>

####shadereffect.set_vec2(shadereffect, varname, var)
Parameters<br>
`shadereffect` shadereffect<br>
`string` varname<br>
`vec2` var<br>
Return Value<br>
`void`<br>

####shadereffect.set_vec3(shadereffect, varname, var)
Parameters<br>
`shadereffect` shadereffect<br>
`string` varname<br>
`vec3` var<br>
Return Value<br>
`void`<br>

####shadereffect.set_vec4(shadereffect, varname, var)
Parameters<br>
`shadereffect` shadereffect<br>
`string` varname<br>
`vec4` var<br>
Return Value<br>
`void`<br>

####shadereffect.set_float_array(shadereffect, varname, var, size)
Parameters<br>
`shadereffect` shadereffect<br>
`string` varname<br>
`array` var<br>
`number` size<br>
Return Value<br>
`void`<br>

####shadereffect.set_color(shadereffect, varname, color)
Parameters<br>
`shadereffect` shadereffect<br>
`string` varname<br>
`color` var<br>
Return Value<br>
`void`<br>

###objManager
####objManager.player
Return Value<br>
`hero.obj` returns player object<br>
``` lua
print(player.charName)
```

####objManager.maxObjects
Return Value<br>
`number` returns max object count<br>

####objManager.get(i)
Return Value<br>
`obj` returns game object<br>
``` lua
for i=0, objManager.maxObjects-1 do
	local obj = objManager.get(i)
	if obj and obj.type==TYPE_HERO then
		print(obj.charName)
	end
end
```

####objManager.enemies_n
Return Value<br>
`number` returns enemy hero count<br>

####objManager.enemies
Return Value<br>
`hero.obj[]` returns array of enemy heroes<br>
``` lua
for i=0, objManager.enemies_n-1 do
	local obj = objManager.enemies[i]
	print(obj.charName)
end
```
####objManager.allies_n
Return Value<br>
`number` returns ally hero count<br>

####objManager.allies
Return Value<br>
`hero.obj[]` returns array of ally heroes<br>
``` lua
for i=0, objManager.allies_n-1 do
	local obj = objManager.allies[i]
	print(obj.charName)
end
```

####objManager.minions.size[team]
Parameters<br>
`team` can be any of these: `TEAM_ALLY`/`TEAM_ENEMY`/`TEAM_NEUTRAL` / "plants" / "others"<br>
Return Value<br>
`number` returns minion count of respective team<br>

####objManager.minions[team][i]
Parameters<br>
`team` can be any of these: `TEAM_ALLY`/`TEAM_ENEMY`/`TEAM_NEUTRAL` / "plants" / "others"<br>
Return Value<br>
`minion.obj` returns minion object<br>
``` lua
for i=0, objManager.minions.size[TEAM_ENEMY]-1 do
	local obj = objManager.minions[TEAM_ENEMY][i]
	print(obj.charName)
end
```

####objManager.turrets.size[team]
Return Value<br>
`number` returns turret count of respective team<br>

####objManager.turrets[team][i]
Return Value<br>
`turret.obj` returns turret object<br>
``` lua
for i=0, objManager.turrets.size[TEAM_ALLY]-1 do
	local obj = objManager.turrets[TEAM_ALLY][i]
	print(obj.charName)
end
```

####objManager.inhibs.size[team]
Return Value<br>
`number` returns inhib count of respective team<br>

####objManager.inhibs[team][i]
Return Value<br>
`inhib.obj` returns inhib object<br>
``` lua
for i=0, objManager.inhibs.size[TEAM_ALLY]-1 do
	local obj = objManager.inhibs[TEAM_ALLY][i]
	print(obj.health)
end
```

####objManager.nexus[team]
Return Value<br>
`nexus.obj` returns nexus object<br>
``` lua
print(objManager.nexus[TEAM_ENEMY].health)
```

####objManager.loop(f)
Parameters<br>
`function` f<br>
Return Value<br>
`void`<br>
``` lua
local function foo(obj)
	if obj.type==TYPE_HERO then
		print(obj.charName)
	end
end

objManager.loop(foo)
```

###core
####core.block_input()

Only works in `cb.issueorder` and `cb.castspell`, will block current operation.

Return Value<br>
`void`<br>
``` lua
local function on_issue_order(order, pos, target_ptr)
	if order==3 then
		--blocks this attack
		--this only works for orders issued by hanbot
		core.block_input()
	end
end

cb.add(cb.issueorder, on_issue_order)
```
####core.reload()
Return Value<br>
`void`<br>

###memory
Valid types:<br>

 * char
 * unsigned char
 * short
 * unsigned short
 * int
 * unsigned int
 * long long
 * unsigned long long
 * float
 
####memory.new(type, n)
Parameters<br>
`string` type<br>
`number` n<br>
Return Value<br>
`mixed` c-type array<br>
###input
Enums:<br>

 * input.LOCK_MOVEMENT
 * input.LOCK_ABILITIES
 * input.LOCK_SUMMONERSPELLS
 * input.LOCK_SHOP
 * input.LOCK_CHAT
 * input.LOCK_MINIMAPMOVEMENT
 * input.LOCK_CAMERAMOVEMENT
 
####input.lock(...)
Parameters<br>
`number` input_type<br>
Return Value<br>
`void` <br>
####input.unlock(...)
Parameters<br>
`number` input_type<br>
Return Value<br>
`void` <br>
####input.islocked(...)
Parameters<br>
`number` input_type<br>
Return Value<br>
`boolean` <br>
####input.lock_slot(...)
Parameters<br>
`number` slot<br>
Return Value<br>
`void` <br>
####input.unlock_slot(...)
Parameters<br>
`number` slot<br>
Return Value<br>
`void` <br>
####input.islocked_slot(...)
Parameters<br>
`number` slot<br>
Return Value<br>
`boolean` <br>
###keyboard
####keyboard.isKeyDown(key_code)
Parameters<br>
`number` key_code<br>
Return Value<br>
`boolean` returns true if key_code is down<br>
``` lua
local function on_tick()
	if keyboard.isKeyDown(0x20) then --spacebar
		print('spacebar pressed')
	end
end

cb.add(cb.tick, on_tick)
```
####keyboard.getClipboardText()
Return Value<br>
`string` returns text that was copied to clipboard<br>
`string` returns error message on failure<br>
####keyboard.setClipboardText(text)
Parameters<br>
`string` text<br>
Return Value<br>
`void` copies text to clipboard<br>
####keyboard.keyCodeToString(key_code)
Parameters<br>
`number` key_code<br>
Return Value<br>
`string` returns corresponding character of key_code<br>
``` lua
print(keyboard.keyCodeToString(0x20))
```
####keyboard.stringToKeyCode(key)
Parameters<br>
`string` key<br>
Return Value<br>
`number` returns corresponding key_code of key<br>
``` lua
print(keyboard.stringToKeyCode('Space'))
```
###network
####network.latency
Return Value<br>
`number` returns game network latency in seconds<br>
####network.send(url, args)
Parameters<br>
`string` url<br>
`table` args<br>
Return Value<br>
`table`<br>
``` lua
Use the 'args' parameter to optionally configure the request:
	- method: HTTP method to use. Defaults to "GET", but can be any HTTP verb like "POST" or "PUT"
	- headers: Dictionary of additional HTTP headers to send with request
	- data: Dictionary or string to send as request body
	- cookies: Dictionary table of cookies to send
	- timeout: How long to wait for the connection to be made before giving up
	- allow_redirects: Whether or not to allow redirection. Defaults to true
	- body_stream_callback: A method to call with each piece of the response body.
	- header_stream_callback: A method to call with each piece of the resulting header.
	- transfer_info_callback: A method to call with transfer progress data.
	- auth_type: Authentication method to use. Defaults to "none", but can also be "basic", "digest" or "negotiate"
	- username: A username to use with authentication. 'auth_type' must also be specified.
	- password: A password to use with authentication. 'auth_type' must also be specified.
	- files: A dictionary of file names to their paths on disk to upload via stream.

If both body_stream_callback and header_stream_callback are defined, a boolean true will be returned instead of the following object.

The return object is a dictionary with the following members:
	- code: The HTTP status code the response gave. Will not exist if header_stream_callback is defined above.
	- body: The body of the response. Will not exist if body_stream_callback is defined above.
	- headers: A dictionary of headers and their values. Will not exist if header_stream_callback is defined above.
	- headers_raw: A raw string containing the actual headers the server sent back. Will not exist if header_stream_callback is defined above.
	- set_cookies: A dictionary of cookies given by the "Set-Cookie" header from the server. Will not exist if the server did not set any cookies.
```
####network.download_file(url, dest)
Parameters<br>
`string` url<br>
`string` dest<br>
Return Value<br>
`boolean` returns true on success<br>
``` lua
local url = 'https://i.imgur.com/k6HB1gA.gif'
local dest = hanbot.luapath..'/ok.png'
local success = network.download_file(url, dest)
print(success)
```
####network.easy_download(cb, uri, path)
Parameters<br>
`function` cb<br>
`string` uri<br>
`string` dest<br>
Return Value<br>
`void` <br>
####network.easy_post(cb, uri, postfields)
Parameters<br>
`function` cb<br>
`string` uri<br>
`string` postfields<br>
Return Value<br>
`void` <br>
###module
####module.seek(mod)
Parameters<br>
`string` mod<br>
Return Value<br>
`module` returns module if it is loaded<br>
``` lua
local function on_tick()
	--module.seek will only return the module if its loaded
	local evade = module.seek('evade')
	if evade and evade.core.is_active() then return end
end

cb.add(cb.tick, on_tick)
```
####module.load(id, mod)
Parameters<br>
`string` id<br>
`string` mod<br>
Return Value<br>
`module` returns module, loads it if needed<br>
``` lua
local foo_bar = module.load('foo', 'bar')
```
####module.internal(mod)
Parameters<br>
`string` mod<br>
Return Value<br>
`module` returns module, loads it if needed<br>
``` lua
local orb = module.internal('orb')
local function on_tick()
	local evade = module.seek('evade')
	if evade and evade.core.is_active() then return end
end

cb.add(cb.tick, on_tick)
```
####module.lib(id)
Parameters<br>
`string` id<br>
Return Value<br>
`library` returns library, loads it if needed<br>
####module.path(id)
Parameters<br>
`string` id<br>
Return Value<br>
`string` returns module path<br>
####module.is_shard(id)
Parameters<br>
`string` id<br>
Return Value<br>
`boolean` returns true if shard id exists<br>
####module.is_libshard(id)
Parameters<br>
`string` id<br>
Return Value<br>
`boolean` returns true if libshard id exists<br>
####module.is_anyshard(id)
Parameters<br>
`string` id<br>
Return Value<br>
`boolean` returns true if shard id or libshard id exists<br>
####module.file_exists(path)
Parameters<br>
`string` path<br>
Return Value<br>
`boolean` returns true file exists<br>
####module.directory_exists(path)
Parameters<br>
`string` path<br>
Return Value<br>
`boolean` returns true file exists<br>
####module.create_directory(id, path)
Parameters<br>
`string` id<br>
`string` path<br>
Return Value<br>
`boolean` returns true on success<br>
####module.create_script_directory(path)
Parameters<br>
`string` path<br>
Return Value<br>
`boolean` returns true on success<br>
####module.create_lib_directory(path)
Parameters<br>
`string` path<br>
Return Value<br>
`boolean` returns true on success<br>
####module.create_shard_directory(path)
Parameters<br>
`string` path<br>
Return Value<br>
`boolean` returns true on success<br>
####module.open_file(id, path, mode)
Parameters<br>
`string` id<br>
`string` path<br>
`string` mod<br>
Return Value<br>
`file` returns file handle on success<br>
####module.open_script_file(path, mode)
Parameters<br>
`string` path<br>
`string` mod<br>
Return Value<br>
`file` returns file handle on success<br>
####module.open_lib_file(path, mode)
Parameters<br>
`string` path<br>
`string` mod<br>
Return Value<br>
`file` returns file handle on success<br>
####module.open_shard_file(path, mode)
Parameters<br>
`string` path<br>
`string` mod<br>
Return Value<br>
`file` returns file handle on success<br>
####module.delete_file(id, path)
Parameters<br>
`string` id<br>
`string` path<br>
Return Value<br>
`boolean` returns true on success<br>
####module.delete_script_file(path)
Parameters<br>
`string` path<br>
Return Value<br>
`boolean` returns true on success<br>
####module.delete_lib_file(path)
Parameters<br>
`string` path<br>
Return Value<br>
`boolean` returns true on success<br>
####module.delete_shard_file(path)
Parameters<br>
`string` path<br>
Return Value<br>
`boolean` returns true on success<br>
####module.rename_file(id, old, new)
Parameters<br>
`string` id<br>
`string` old<br>
`string` new<br>
Return Value<br>
`boolean` returns true on success<br>
####module.rename_script_file(old, new)
Parameters<br>
`string` old<br>
`string` new<br>
Return Value<br>
`boolean` returns true on success<br>
####module.rename_lib_file(old, new)
Parameters<br>
`string` old<br>
`string` new<br>
Return Value<br>
`boolean` returns true on success<br>
####module.rename_shard_file(old, new)
Parameters<br>
`string` old<br>
`string` new<br>
Return Value<br>
`boolean` returns true on success<br>
####module.generate_tree(id, hash, anyfile)
Parameters<br>
`string` id<br>
`string` hash<br>
`boolean` anyfile<br>
Return Value<br>
`table` returns file tree<br>
###menu
####menu(var, text)
Parameters<br>
`string` var<br>
`string` text<br>
Return Value<br>
`object` returns menu instance<br>
``` lua
local myMenu = menu('example_menu', 'Example Menu')
```
####menu:header(var, text)
Parameters<br>
`string` var<br>
`string` text<br>
Return Value<br>
`void`<br>
``` lua
local myMenu = menu('example_menu', 'Example Menu')
myMenu:header('example_header', 'Example Header')
```
####menu:boolean(var, text, value)
Parameters<br>
`string` var<br>
`string` text<br>
`boolean` value<br>
Return Value<br>
`void`<br>
``` lua
local myMenu = menu('example_menu', 'Example Menu')
myMenu:boolean('example_boolean', 'Example Boolean')

local function on_tick()
	if myMenu.example_boolean:get() then
		print('example_boolean is true')
	end
end

cb.add(cb.tick, on_tick)
```
####menu:slider(var, text, value, min, max, step)
Parameters<br>
`string` var<br>
`string` text<br>
`number` value<br>
`number` min<br>
`number` max<br>
`number` step<br>
Return Value<br>
`void`<br>
``` lua
local myMenu = menu('example_menu', 'Example Menu')
myMenu:slider('example_slider', 'Example Slider', 100, 0, 150, 5)

local function on_tick()
	print(myMenu.example_slider:get())
end

cb.add(cb.tick, on_tick)
```
####menu:keybind(var, text, key, toggle)
Parameters<br>
`string` var<br>
`string` text<br>
`string` key<br>
`string` toggle<br>
Return Value<br>
`void`<br>
``` lua
local myMenu = menu('example_menu', 'Example Menu')
--this creates an on key down keybind for 'A'
myMenu:keybind('example_keybind_a', 'Example Keybind A', 'A', nil)
--this creates a toggle keybind for 'A'
myMenu:keybind('example_keybind_b', 'Example Keybind B', nil, 'A')
--this creates an on key down keybind for 'A' or toggle for 'B'
myMenu:keybind('example_keybind_c', 'Example Keybind C', 'A', 'B')

local function on_tick()
	if myMenu.example_keybind_a:get() then
		print('example_keybind_a is active')
	end
end

cb.add(cb.tick, on_tick)
```
####menu:dropdown(var, text, value, options)
Parameters<br>
`string` var<br>
`string` text<br>
`number` value<br>
`table` options<br>
Return Value<br>
`void`<br>
``` lua
local myMenu = menu('example_menu', 'Example Menu')
myMenu:dropdown('example_dropdown', 'Example Dropdown', 1, {'Option A', 'Option B', 'Option C',})

local function on_tick()
	print(myMenu.example_dropdown:get())
end

cb.add(cb.tick, on_tick)
```
####menu:button(var, text, buttonText, callback)
Parameters<br>
`string` var<br>
`string` text<br>
`string` buttonText<br>
`function` callback<br>
Return Value<br>
`void`<br>
``` lua
local myMenu = menu('example_menu', 'Example Menu')
myMenu:button('example_button', 'Example Button', 'My Button', function() print('button was pressed') end)
```
####menu:color(var, text, red, green, blue, alpha)
Parameters<br>
`string` var<br>
`string` text<br>
`number` red<br>
`number` green<br>
`number` blue<br>
`number` alpha<br>
Return Value<br>
`void`<br>
``` lua
local myMenu = menu('example_menu', 'Example Menu')
myMenu:color('example_color', 'Example Color', 255, 0, 0, 255)

local function on_draw()
	graphics.draw_text_2D('foo', 14, game.cursorPos.x, game.cursorPos.y, myMenu.example_color:get())
end

cb.add(cb.draw, on_draw)
```
####menu:isopen()
Return Value<br>
`boolean` returns true if the menu is currently open<br>
``` lua
local myMenu = menu('example_menu', 'Example Menu')

local function on_tick()
	if myMenu:isopen() then
		print('menu is open')
	end
end

cb.add(cb.tick, on_tick)
```
####menu:set(property, value)
Parameters<br>
`string` property<br>
`mixed` value<br>
Return Value<br>
`void`<br>
``` lua
--[[
The following properties can be set on their respective instances:
	'tooltip'
	'callback'
	'value'
	'text'
	'visible'
	'buttonText'
	'red'
	'green'
	'blue'
	'alpha'
	'options'
	'toggleValue'
	'toggle'
	'key'
	'min'
	'max'
	'step'
]]

local myMenu = menu('example_menu', 'Example Menu')
myMenu:slider('example_slider', 'Example Slider', 100, 0, 150, 5)

myMenu.example_slider:set('tooltip', 'This text will appear when the mouse is hovering Example Slider')
myMenu.example_slider:set('callback', function(old, new)
	print(('example_slider changed from %u to %u'):format(old, new))
end)
```
###md5
####md5.file(path)
Parameters<br>
`string` path<br>
Return Values<br>
`string` returns md5 hash
####md5.sum(str)
Parameters<br>
`string` str<br>
Return Values<br>
`string` returns integer md5 hash
####md5.tohex(str, upper)
Parameters<br>
`string` str<br>
`boolean` upper<br>
Return Values<br>
`string` returns str in hex, in uppercase if upper is true

#Objects
###base.obj
Properties:<br>

 * `number` base.type
 * `number` base.index
> The index of object
 * `number` base.index32
> The object_id of object
 * `number` base.team
 * `string` base.name
 * `number` base.networkID
 * `number` base.networkID32
> The network_id of object
 * `number` base.x
 * `number` base.y
 * `number` base.z
 * `vec3` base.pos
 * `vec2` base.pos2D
 * `boolean` base.isOnScreen
 * `number` base.selectionHeight
 * `number` base.selectionRadius

###hero.obj

Properties:<br>

 * `string` hero.name
 * `string` hero.charName
 * `string` hero.recallName
 * `boolean` hero.isOnScreen
 * `boolean` hero.inShopRange
 * `boolean` hero.isDead
 * `boolean` hero.isVisible
 * `boolean` hero.isRecalling
 * `boolean` hero.isTargetable
 * `boolean` hero.parEnabled
 * `boolean` hero.sarEnabled
 * `vec3` hero.pos
 * `vec3` hero.direction
 * `vec2` hero.pos2D
 * `vec2` hero.direction2D
 * `vec2` hero.barPos
 * `path.obj` hero.path
 * `spell.obj` hero.activeSpell
 * `table` hero.buff
 * `runemanager.obj` hero.rune
 * `number` hero.type
 * `number` hero.index
 * `number` hero.networkID
 * `number` hero.networkID32
 * `number` hero.team
 * `number` hero.x
 * `number` hero.y
 * `number` hero.z
 * `number` hero.selectionHeight
 * `number` hero.selectionRadius
 * `number` hero.boundingRadius
 * `number` hero.overrideCollisionRadius
 * `number` hero.pathfindingCollisionRadius
 * `number` hero.deathTime
 * `number` hero.health
 * `number` hero.maxHealth
 * `number` hero.maxHealthPenalty
 * `number` hero.allShield
 * `number` hero.physicalShield
 * `number` hero.magicalShield
 * `number` hero.champSpecificHealth
 * `number` hero.stopShieldFade
 * `number` hero.isTargetableToTeamFlags
 * `number` hero.mana
 * `number` hero.maxMana
 * `number` hero.baseAttackDamage
 * `number` hero.baseAd
> alias of `baseAttackDamage`
 * `number` hero.bonusAd
 * `number` hero.totalAd
> The TotalAttackDamage
 * `number` hero.totalAp
> The TotalAbilityPower
 * `number` hero.armor
 * `number` hero.spellBlock
 * `number` hero.attackSpeedMod
 * `number` hero.flatPhysicalDamageMod
 * `number` hero.percentPhysicalDamageMod
 * `number` hero.flatMagicDamageMod
 * `number` hero.percentMagicDamageMod
 * `number` hero.healthRegenRate
 * `number` hero.bonusArmor
 * `number` hero.bonusSpellBlock
 * `number` hero.flatBubbleRadiusMod
 * `number` hero.percentBubbleRadiusMod
 * `number` hero.moveSpeed
 * `number` hero.scaleSkinCoef
 * `number` hero.gold
 * `number` hero.goldTotal
 * `number` hero.minimumGold
 * `number` hero.evolvePoints
 * `number` hero.evolveFlag
 * `number` hero.inputLocks
 * `number` hero.skillUpLevelDeltaReplicate
 * `number` hero.manaCost0
 * `number` hero.manaCost1
 * `number` hero.manaCost2
 * `number` hero.manaCost3
 * `number` hero.baseAbilityDamage
 * `number` hero.dodge
 * `number` hero.crit
 * `number` hero.parRegenRate
 * `number` hero.attackRange
 * `number` hero.flatMagicReduction
 * `number` hero.percentMagicReduction
 * `number` hero.flatCastRangeMod
 * `number` hero.percentCooldownMod
 * `number` hero.passiveCooldownEndTime
 * `number` hero.passiveCooldownTotalTime
 * `number` hero.flatArmorPenetration
 * `number` hero.percentArmorPenetration
 * `number` hero.flatMagicPenetration
 * `number` hero.percentMagicPenetration
 * `number` hero.percentLifeStealMod
 * `number` hero.percentSpellVampMod
 * `number` hero.percentBonusArmorPenetration
 * `number` hero.percentCritBonusArmorPenetration
 * `number` hero.percentCritTotalArmorPenetration
 * `number` hero.percentBonusMagicPenetration
 * `number` hero.physicalLethality
 * `number` hero.magicLethality
 * `number` hero.baseHealthRegenRate
 * `number` hero.primaryARBaseRegenRateRep
 * `number` hero.secondaryARRegenRateRep
 * `number` hero.secondaryARBaseRegenRateRep
 * `number` hero.percentCooldownCapMod
 * `number` hero.percentEXPBonus
 * `number` hero.flatBaseAttackDamageMod
 * `number` hero.percentBaseAttackDamageMod
 * `number` hero.baseAttackDamageSansPercentScale
 * `number` hero.exp
 * `number` hero.par
 * `number` hero.maxPar
 * `number` hero.sar
 * `number` hero.maxSar
 * `number` hero.pathfindingRadiusMod
 * `number` hero.levelRef
 * `number` hero.numNeutralMinionsKilled
 * `number` hero.primaryArRegenRateRep
 * `number` hero.physicalDamagePercentageModifier
 * `number` hero.magicalDamagePercentageModifier
 * `number` hero.baseHealth
 * `number` hero.baseMana
 * `number` hero.baseManaPerLevel
 * `number` hero.combatType
 * `number` hero.critDamageMultiplier
 * `number` hero.baseMoveSpeed
 
__The following functions are limited to player only:__<br>
####player:move(v1)
Parameters<br>
`hero.obj` player<br>
`vec3` v1<br>
Return Value<br>
`void`<br>
####player:attackmove(v1)
Parameters<br>
`hero.obj` player<br>
`vec3` v1<br>
Return Value<br>
`void`<br>
####player:altmove(v1)
Parameters<br>
`hero.obj` player<br>
`vec3` v1<br>
Return Value<br>
`void`<br>
####player:attack(obj)
Parameters<br>
`hero.obj` player<br>
`obj` obj<br>
Return Value<br>
`void`<br>
####player:stop()
Parameters<br>
`hero.obj` player<br>
Return Value<br>
`void`<br>
####player:select(n)
Parameters<br>
`hero.obj` player<br>
`number` index<br>
Return Value<br>
`void`<br>
####player:castSpell(type, slot, arg1, arg2, no_limit)
Parameters<br>
`hero.obj` player<br>
`string` type<br>
`number` slot<br>
`mixed` arg1<br>
`mixed` arg2<br>
`boolean` no_limit: ignore the limitation check, maybe kickout/banned, use careful<br>
Return Value<br>
`void`<br>
``` lua
--type 'pos', orianna q
player:castSpell('pos', 0, mousePos)
--type 'obj', teemo q
player:castSpell('obj', 0, game.selectedTarget)
--type 'self', teemo w
player:castSpell('self', 1)
--type 'line', rumble r
player:castSpell('self', 3, player.pos, mousePos)
--type 'release', varus q
player:castSpell('release', 0, player.pos, mousePos)
--type 'move', aurelion sol q
player:castSpell('move', 0, mousePos, nil, true)
```
####player:levelSpell(slot)
Parameters<br>
`hero.obj` player<br>
`number` slot<br>
Return Value<br>
`void`<br>
####player:interact(obj)
Parameters<br>
`hero.obj` player<br>
`obj` obj<br>
Return Value<br>
`void`<br>
####player:buyItem(itemID)
Parameters<br>
`hero.obj` player<br>
`number` itemID<br>
Return Value<br>
`void`<br>
<br>
__The following functions are available for all hero.obj__<br>
####hero:spellSlot(slot)
Parameters<br>
`hero.obj` hero<br>
`number` slot<br>
Return Value<br>
`spell_slot.obj`<br>
####hero:basicAttack(slot)
Parameters<br>
`hero.obj` hero<br>
`number` slot<br>
Return Value<br>
`spell.obj`<br>
####hero:itemID(slot)
Parameters<br>
`hero.obj` hero<br>
`number` slot<br>
Return Value<br>
`number` returns item ID for item slot i<br>

###hero:baseHealthForLevel(level)
Parameters<br>
`number` level<br>
Return Value<br>
`number` returns base health for level i<br>

###hero:statForLevel(type, level)
Parameters<br>
`number` type<br>
`number` level<br>
Return Value<br>
`number` returns stat of type for level i<br>

###hero:getStat(name)
Parameters<br>
`string` name<br>
Return Value<br>
`number` returns stat value<br>

The available stats (Some of them are deprecated by riot and always zero):

 * EXP	
 * GOLD_SPENT	
 * GOLD_EARNED	
 * MINIONS_KILLED	
 * NEUTRAL_MINIONS_KILLED	
 * NEUTRAL_MINIONS_KILLED_YOUR_JUNGLE	
 * NEUTRAL_MINIONS_KILLED_ENEMY_JUNGLE	
 * PLAYER_SCORE_0	
 * PLAYER_SCORE_1	
 * PLAYER_SCORE_2	
 * PLAYER_SCORE_3	
 * PLAYER_SCORE_4	
 * PLAYER_SCORE_5	
 * PLAYER_SCORE_6	
 * PLAYER_SCORE_7	
 * PLAYER_SCORE_8	
 * PLAYER_SCORE_9	
 * PLAYER_SCORE_10	
 * PLAYER_SCORE_11	
 * VICTORY_POINT_TOTAL	
 * TOTAL_DAMAGE_DEALT	
 * PHYSICAL_DAMAGE_DEALT_PLAYER	
 * MAGIC_DAMAGE_DEALT_PLAYER	
 * TRUE_DAMAGE_DEALT_PLAYER	
 * TOTAL_DAMAGE_DEALT_TO_CHAMPIONS	
 * PHYSICAL_DAMAGE_DEALT_TO_CHAMPIONS	
 * MAGIC_DAMAGE_DEALT_TO_CHAMPIONS	
 * TRUE_DAMAGE_DEALT_TO_CHAMPIONS	
 * TOTAL_DAMAGE_TAKEN	
 * PHYSICAL_DAMAGE_TAKEN	
 * MAGIC_DAMAGE_TAKEN	
 * TRUE_DAMAGE_TAKEN	
 * TOTAL_DAMAGE_SELF_MITIGATED	
 * TOTAL_DAMAGE_SHIELDED_ON_TEAMMATES	
 * TOTAL_DAMAGE_DEALT_TO_BUILDINGS	
 * TOTAL_DAMAGE_DEALT_TO_TURRETS	
 * TOTAL_DAMAGE_DEALT_TO_OBJECTIVES	
 * LARGEST_ATTACK_DAMAGE	
 * LARGEST_ABILITY_DAMAGE	
 * LARGEST_CRITICAL_STRIKE	
 * TOTAL_TIME_CROWD_CONTROL_DEALT	
 * TOTAL_TIME_CROWD_CONTROL_DEALT_TO_CHAMPIONS	
 * TOTAL_HEAL_ON_TEAMMATES	
 * TIME_PLAYED	
 * LONGEST_TIME_SPENT_LIVING	
 * TOTAL_TIME_SPENT_DEAD	
 * TIME_OF_FROM_LAST_DISCONNECT	
 * TIME_SPENT_DISCONNECTED	
 * TIME_CCING_OTHERS	
 * TEAM	
 * LEVEL	
 * CHAMPIONS_KILLED	
 * NUM_DEATHS	
 * ASSISTS	
 * LARGEST_KILLING_SPREE	
 * KILLING_SPREES	
 * LARGEST_MULTI_KILL	
 * BOUNTY_LEVEL	
 * DOUBLE_KILLS	
 * TRIPLE_KILLS	
 * QUADRA_KILLS	
 * PENTA_KILLS	
 * UNREAL_KILLS	
 * BARRACKS_KILLED	
 * BARRACKS_TAKEDOWNS	
 * TURRETS_KILLED	
 * TURRET_TAKEDOWNS	
 * HQ_KILLED	
 * HQ_TAKEDOWNS	
 * OBJECTIVES_STOLEN	
 * OBJECTIVES_STOLEN_ASSISTS	
 * FRIENDLY_DAMPEN_LOST	
 * FRIENDLY_TURRET_LOST	
 * FRIENDLY_HQ_LOST	
 * BARON_KILLS	
 * DRAGON_KILLS	
 * RIFT_HERALD_KILLS	
 * NODE_CAPTURE	
 * NODE_CAPTURE_ASSIST	
 * NODE_NEUTRALIZE	
 * NODE_NEUTRALIZE_ASSIST	
 * TEAM_OBJECTIVE	
 * ITEMS_PURCHASED	
 * CONSUMABLES_PURCHASED	
 * ITEM0	
 * ITEM1	
 * ITEM2	
 * ITEM3	
 * ITEM4	
 * ITEM5	
 * ITEM6	
 * PERK_PRIMARY_STYLE	
 * PERK_SUB_STYLE	
 * STAT_PERK_0	
 * STAT_PERK_1	
 * STAT_PERK_2	
 * SIGHT_WARDS_BOUGHT_IN_GAME	
 * VISION_WARDS_BOUGHT_IN_GAME	
 * WARD_PLACED	
 * WARD_KILLED	
 * WARD_PLACED_DETECTOR	
 * VISION_SCORE	
 * SPELL1_CAST	
 * SPELL2_CAST	
 * SPELL3_CAST	
 * SPELL4_CAST	
 * SUMMON_SPELL1_CAST	
 * SUMMON_SPELL2_CAST	
 * KEYSTONE_ID	
 * TOTAL_HEAL	
 * TOTAL_UNITS_HEALED	
 * WAS_AFK	
 * WAS_AFK_AFTER_FAILED_SURRENDER	
 * WAS_EARLY_SURRENDER_ACCOMPLICE	
 * TEAM_EARLY_SURRENDERED	
 * GAME_ENDED_IN_EARLY_SURRENDER	
 * GAME_ENDED_IN_SURRENDER	
 * WAS_SURRENDER_DUE_TO_AFK	
 * WAS_LEAVER	
 * PLAYERS_I_MUTED	


###minion.obj
Properties:<br>

 * `string` minion.name
 * `string` minion.charName
 * `boolean` minion.isOnScreen
 * `boolean` minion.isDead
 * `boolean` minion.isVisible
 * `boolean` minion.isTargetable
 * `vec3` minion.pos
 * `vec3` minion.direction
 * `vec2` minion.pos2D
 * `vec2` minion.direction2D
 * `vec2` minion.barPos
 * `path.obj` minion.path
 * `hero.obj` minion.owner
 * `spell.obj` minion.activeSpell
 * `table` minion.buff
 * `number` minion.networkID
 * `number` minion.networkID32
 * `number` minion.team
 * `number` minion.x
 * `number` minion.y
 * `number` minion.z
 * `number` minion.selectionHeight
 * `number` minion.selectionRadius
 * `number` minion.boundingRadius
 * `number` minion.overrideCollisionRadius
 * `number` minion.pathfindingCollisionRadius
 * `number` minion.deathTime
 * `number` minion.health
 * `number` minion.maxHealth
 * `number` minion.mana
 * `number` minion.maxMana
 * `number` minion.maxHealthPenalty
 * `number` minion.physicalShield
 * `number` minion.magicalShield
 * `number` minion.allShield
 * `number` minion.stopShieldFade
 * `number` minion.isTargetableToTeamFlags
 * `number` minion.actionState
 * `number` minion.baseAttackDamage
 * `number` minion.baseAd
> alias of `baseAttackDamage`
 * `number` minion.bonusAd
 * `number` minion.totalAd
> The TotalAttackDamage
 * `number` minion.totalAp
> The TotalAbilityPower
 * `number` minion.armor
 * `number` minion.spellBlock
 * `number` minion.attackSpeedMod
 * `number` minion.flatPhysicalDamageMod
 * `number` minion.percentPhysicalDamageMod
 * `number` minion.flatMagicDamageMod
 * `number` minion.percentMagicDamageMod
 * `number` minion.healthRegenRate
 * `number` minion.bonusArmor
 * `number` minion.bonusSpellBlock
 * `number` minion.moveSpeed
 * `number` minion.baseAbilityDamage
 * `number` minion.attackRange
 * `number` minion.flatMagicReduction
 * `number` minion.percentMagicReduction
 * `number` minion.flatArmorPenetration
 * `number` minion.percentArmorPenetration
 * `number` minion.flatMagicPenetration
 * `number` minion.percentMagicPenetration
 * `number` minion.physicalLethality
 * `number` minion.magicLethality
 * `number` minion.flatBaseAttackDamageMod
 * `number` minion.percentBaseAttackDamageMod
 * `number` minion.baseAttackDamageSansPercentScale
 * `number` minion.exp
 * `number` minion.par
 * `number` minion.maxPar
 * `number` minion.parEnabled
 * `number` minion.percentDamageToBarracksMinionMod
 * `number` minion.flatDamageReductionFromBarracksMinionMod
 
####m:basicAttack(i)
Parameters<br>
`minion.obj` m<br>
`number` i<br>
Return Value<br>
`spell.obj` returns the minions basic attack<br>
###turret.obj
Properties:<br>

 * `string` turret.name
 * `string` turret.charName
 * `boolean` turret.isOnScreen
 * `boolean` turret.isDead
 * `boolean` turret.isVisible
 * `boolean` turret.isTargetable
 * `vec3` turret.pos
 * `vec3` turret.direction
 * `vec2` turret.pos2D
 * `vec2` turret.barPos
 * `vec2` turret.direction2D
 * `path.obj` turret.path
 * `spell.obj` turret.activeSpell
 * `table` turret.buff
 * `number` turret.networkID
 * `number` turret.networkID32
 * `number` turret.team
 * `number` turret.x
 * `number` turret.y
 * `number` turret.z
 * `number` turret.selectionHeight
 * `number` turret.selectionRadius
 * `number` turret.boundingRadius
 * `number` turret.overrideCollisionRadius
 * `number` turret.pathfindingCollisionRadius
 * `number` turret.deathTime
 * `number` turret.health
 * `number` turret.maxHealth
 * `number` turret.mana
 * `number` turret.maxMana
 * `number` turret.allShield
 * `number` turret.isTargetableToTeamFlags
 * `number` turret.baseAttackDamage
 * `number` turret.baseAd
> alias of `baseAttackDamage`
 * `number` turret.bonusAd
 * `number` turret.totalAd
> The TotalAttackDamage
 * `number` turret.totalAp
> The TotalAbilityPower
 * `number` turret.armor
 * `number` turret.spellBlock
 * `number` turret.attackSpeedMod
 * `number` turret.flatPhysicalDamageMod
 * `number` turret.percentPhysicalDamageMod
 * `number` turret.flatMagicDamageMod
 * `number` turret.percentMagicDamageMod
 * `number` turret.healthRegenRate
 * `number` turret.bonusArmor
 * `number` turret.bonusSpellBlock
 * `number` turret.baseAbilityDamage
 * `number` turret.parRegenRate
 * `number` turret.attackRange
 * `number` turret.flatMagicReduction
 * `number` turret.percentMagicReduction
 * `number` turret.flatArmorPenetration
 * `number` turret.percentArmorPenetration
 * `number` turret.flatMagicPenetration
 * `number` turret.percentMagicPenetration
 * `number` turret.percentBonusArmorPenetration
 * `number` turret.percentBonusMagicPenetration
 * `number` turret.physicalLethality
 * `number` turret.magicLethality
 * `number` turret.baseHealthRegenRate
 * `number` turret.secondaryARBaseRegenRateRep
 * `number` turret.flatBaseAttackDamageMod
 * `number` turret.percentBaseAttackDamageMod
 * `number` turret.baseAttackDamageSansPercentScale
 * `number` turret.exp
 * `number` turret.par
 * `number` turret.maxPar
 * `number` turret.parEnabled
 * `number` turret.physicalDamagePercentageModifier
 * `number` turret.magicalDamagePercentageModifier
 
####t:basicAttack(i)
Parameters<br>
`turret.obj` t<br>
`number` i<br>
Return Value<br>
`spell.obj` returns the turrets basic attack<br>

###inhib.obj
Properties:<br>

 * `number` inhib.type
 * `number` inhib.index
 * `number` inhib.team
 * `number` inhib.networkID
 * `number` inhib.networkID32
 * `string` inhib.name
 * `number` inhib.x
 * `number` inhib.y
 * `number` inhib.z
 * `vec3` inhib.pos
 * `vec2` inhib.pos2D
 * `boolean` inhib.isOnScreen
 * `number` inhib.selectionHeight
 * `number` inhib.selectionRadius
 * `number` inhib.boundingRadius
 * `number` inhib.overrideCollisionRadius
 * `number` inhib.pathfindingCollisionRadius
 * `boolean` inhib.isDead
 * `boolean` inhib.isVisible
 * `number` inhib.deathTime
 * `number` inhib.health
 * `number` inhib.maxHealth
 * `number` inhib.allShield
 * `boolean` inhib.isTargetable
 * `number` inhib.isTargetableToTeamFlags

###nexus.obj
Properties:<br>

 * `string` nexus.name
 * `boolean` nexus.isOnScreen
 * `boolean` nexus.isDead
 * `boolean` nexus.isVisible
 * `boolean` nexus.isTargetable
 * `vec3` nexus.pos
 * `vec2` nexus.pos2D
 * `number` nexus.team
 * `number` nexus.type
 * `number` nexus.x
 * `number` nexus.y
 * `number` nexus.z
 * `number` nexus.health
 * `number` nexus.maxHealth
 * `number` nexus.allShield
 * `number` nexus.isTargetableToTeamFlags
 
###missile.obj
Properties:<br>

 * `number` missile.type
 * `number` missile.index
 * `number` missile.index32
 * `number` missile.team
 * `string` missile.name
 * `number` missile.networkID
 * `number` missile.networkID32
 * `boolean` missile.isOnScreen
 * `number` missile.selectionHeight
 * `number` missile.selectionRadius
 * `number` missile.x
 * `number` missile.y
 * `number` missile.z
 * `vec3` missile.pos
 * `vec2` missile.pos2D
> The `x`/`y`/`z`/`pos`/`pos2D` now means `BoundingBox` of `GameObject`
 * `spell.obj` missile.spell
 * `number` missile.width
 * `number` missile.velocity
 * `missile_info.obj` missile.missile_info
> The `MissileMovement` of `Missile`, And follow properties is getting from this as a alias: 
 * `vec3` missile.startPos
 * `vec2` missile.startPos2D
 * `vec3` missile.endPos
 * `vec2` missile.endPos2D
 * `number` missile.speed


###particle.obj
Properties:<br>

 * `number` particle.type
 * `number` particle.index
 * `number` particle.index32
 * `number` particle.team
 * `string` particle.name
 * `number` particle.networkID
 * `number` particle.networkID32
 * `number` particle.x
 * `number` particle.y
 * `number` particle.z
 * `vec3` particle.pos
 * `vec2` particle.pos2D
 * `boolean` particle.isOnScreen
 * `number` particle.selectionHeight
 * `number` particle.selectionRadius
 * `obj` particle.attachmentObject
 * `obj` particle.targetAttachmentObject


###spell.obj
> known as `SpellCastInfo`

Properties:<br>

 * `number` spell.identifier
> The `missileNetworkID` of `SpellCastInfo`
 * `number` spell.slot
 * `boolean` spell.isBasicAttack
 * `obj` spell.owner
 * `boolean` spell.hasTarget
 * `obj` spell.target
 * `vec3` spell.startPos
 * `vec2` spell.startPos2D
> `LaunchPosition`
 * `vec3` spell.endPos
 * `vec2` spell.endPos2D
> `TargetPosition`
 * `vec3` spell.endPosLine
 * `vec2` spell.endPosLine2D
> `TargetEndPosition`
 * `number` spell.windUpTime
> `DesignerCastTime`
 * `number` spell.animationTime
> `DesignerTotalTime`
 * `number` spell.clientWindUpTime
> `CharacterAttackCastDelay`
 * `number` spell.animationWindUpTime
> `DesignerTotalTime`
 * `spell_info.obj` spell.spell_info
> The `SpellData` of current `SpellCastInfo`
 * `string` spell.name
> equal to `spell.spell_info.name`
 * `spell_static.obj` spell.static
> equal to `spell.spell_info.static`

###spell_slot.obj
> known as `SpellDataInst`

Properties:<br>

 * `number` spell_slot.slot
 * `boolean` spell_slot.isBasicSpellSlot
 * `boolean` spell_slot.isSummonerSpellSlot
 * `string` spell_slot.name
 * `texture.obj` spell_slot.icon
 * `number` spell_slot.targetingType
 * `number` spell_slot.level
 * `number` spell_slot.cooldown
 * `number` spell_slot.totalCooldown
 * `number` spell_slot.stacks
> `CurrentAmmo`
 * `number` spell_slot.stacksCooldown
> `TimeForNextAmmoRecharge`
 * `number` spell_slot.state
 * `number` spell_slot.toggleState
 * `boolean` spell_slot.isCharging
 * `boolean` spell_slot.isNotEmpty
> Whether current `spell_slot` has a active `spell_info` 
 * `spell_info.obj` spell_slot.spell_info
 * `spell_static.obj` spell_slot.static


###spell_info.obj
> known as `SpellData`

Properties:<br>

 * `string` spell_info.name
 * `spell_static.obj` spell_info.static


###spell_static.obj
> known as `SpellDataResource`

Properties:<br>

 * `string` spell_static.alternateName
 * `string` spell_static.imgIconName
 * `number` spell_static.castType
> `Flags`
 * `boolean` spell_static.useMinimapTargeting
 * `number` spell_static.missileSpeed
 * `number` spell_static.lineWidth
 * `number` spell_static.castFrame
 
###path.obj
Properties:<br>

 * `obj` path.owner
 * `boolean` path.isActive
 * `boolean` path.active
 * `boolean` path.isDashing
 * `number` path.dashSpeed
 * `boolean` path.unstoppable
 * `vec3` path.endPos
 * `vec2` path.endPos2D
 * `vec3` path.serverPos
 * `vec2` path.serverPos2D
 * `vec3` path.serverVelocity
 * `vec2` path.serverVelocity2D
 * `vec3[]` path.point
 * `vec2[]` path.point2D
> `WaypointList`
 * `number` path.index
> The index of next point
 * `number` path.count
> The count of `point`/`point2D`
 * `number` path.update
> `UpdateNumber`


 
####p:calcPos(v1)
Parameters<br>
`path.obj` p<br>
`vec3` v1<br>
Return Value<br>
`vec3[]` returns vec3 array containing path points<br>
`number` returns array length<br>
``` lua
cb.add(cb.draw, function()
  local p, n = player.path:calcPos(mousePos)
  for i = 0, n - 1 do
    graphics.draw_circle(p[i], 15, 2, 0xffffffff, 3)
  end
end)
```

####p:isDirectPath(v1, v2)
Parameters<br>
`path.obj` p<br>
`vec3` v1<br>
`vec3` v2<br>
Return Value<br>
`boolean` returns result<br>
`number[]` return lastReachedPos<br>
``` lua
local isDirect,lastReachedPos = player.path:isDirectPath(player.pos, mousePos)
if isDirect then
	print('lastReachedPos.x', lastReachedPos[0])
	print('lastReachedPos.y', lastReachedPos[1])
end
```


###buff.obj
Properties:<br>

 * `number` buff.type
 * `string` buff.name
 * `boolean` buff.valid
 * `obj` buff.owner
 * `obj` buff.source
 * `number` buff.startTime
 * `number` buff.endTime
 * `number` buff.stacks
> `Stacks.size`
 * `number` buff.stacks2
> `Counter`
 
###camp.obj
Properties:<br>

 * `number` camp.type
 * `number` camp.index
 * `number` camp.index32
 * `number` camp.team
 * `string` camp.name
 * `number` camp.networkID
 * `number` camp.networkID32
 * `number` camp.x
 * `number` camp.y
 * `number` camp.z
 * `vec3` camp.pos
 * `vec2` camp.pos2D
 * `boolean` camp.isOnScreen
 * `number` camp.selectionHeight
 * `number` camp.selectionRadius
 
 * `boolean` camp.active
 * `number` camp.spawnTime
 * `number` camp.count

####camp:getMinion(index)
Parameters<br>
`camp.obj` camp<br>
`number` index: the index to get<br>
Return Value<br>
`minion.obj` returns the minion of current index<br>
``` lua
for i=0,camp.count-1 do
	local minion = camp:getMinion(i)
	if minion then
		print(minion.name, minion.pos.x, minion.pos.z)
	end
end

```


#Modules
###pred
####pred.trace.linear.hardlock(input, seg, obj)
Parameters<br>
`table` input<br>
`seg` seg<br>
`obj` obj<br>
Return Value<br>
`boolean` returns true if obj is hard crowd controlled<br>
``` lua

```
####pred.trace.linear.hardlockmove(input, seg, obj)
Parameters<br>
`table` input<br>
`seg` seg<br>
`obj` obj<br>
Return Value<br>
`boolean` returns true if obj is hard crowd controlled by taunts, fears or charms<br>
``` lua

```
####pred.trace.circular.hardlock(input, seg, obj)
Parameters<br>
`table` input<br>
`seg` seg<br>
`obj` obj<br>
Return Value<br>
`boolean` returns true if obj is hard crowd controlled<br>
``` lua

```
####pred.trace.circular.hardlockmove(input, seg, obj)
Parameters<br>
`table` input<br>
`seg` seg<br>
`obj` obj<br>
Return Value<br>
`boolean` returns true if obj is hard crowd controlled by taunts, fears or charms<br>
``` lua

```
####pred.trace.newpath(obj, t1, t2)
Parameters<br>
`obj` obj<br>
`number` t1<br>
`number` t2<br>
Return Value<br>
`boolean` returns true if obj path has updated <t1 seconds ago or >t1 seconds ago<br>
``` lua

```
####pred.core.lerp(path, delay, speed)
Parameters<br>
`path.obj` path<br>
`number` delay<br>
`number` speed<br>
Return Value<br>
`vec2` returns interpolated position along path<br>
`number` returns path index of vec2<br>
`boolean` returns true if vec2 is the end of path<br>
``` lua
local pred = module.internal('pred')

local function on_tick()
	if player.path.active and player.path.count>0 then
		local res, res_i, res_b = pred.core.lerp(player.path, 0.5, player.moveSpeed)
		print(('%.2f-%.2f on index %u'):format(res.x, res.y, res_i), res_b)
	end
end

cb.add(cb.tick, on_tick)
```
####pred.core.project(pos, path, delay, projectileSpeed, pathSpeed)
Parameters<br>
`vec2` pos<br>
`path.obj` path<br>
`number` delay<br>
`number` projectileSpeed<br>
`number` pathSpeed<br>
Return Value<br>
`vec2` returns projected position along path<br>
`number` returns path index of vec2<br>
`boolean` returns true if vec2 is the end of path<br>
``` lua
local pred = module.internal('pred')

local function on_tick()
	if player.path.active and player.path.count>0 then
		local res, res_i, res_b = pred.core.project(mousePos2D, player.path, 0.5, 1200, player.moveSpeed)
		print(('%.2f-%.2f on index %u'):format(res.x, res.y, res_i), res_b)
	end
end

cb.add(cb.tick, on_tick)
```
####pred.core.project_off(pos, path, delay, projectileSpeed, pathSpeed, offset)
Parameters<br>
`vec2` pos<br>
`path.obj` path<br>
`number` delay<br>
`number` projectileSpeed<br>
`number` pathSpeed<br>
`vec2` offset<br>
Return Value<br>
`vec2` returns projected position along path<br>
`number` returns path index of vec2<br>
`boolean` returns true if vec2 is the end of path<br>
``` lua
local pred = module.internal('pred')

local function on_tick()
	if player.path.active and player.path.count>0 then
		--same as core.project, but the path is offset
		local res, res_i, res_b = pred.core.project_off(mousePos2D, player.path, 0.5, 1200, player.moveSpeed, vec2(0,100))
		print(('%.2f-%.2f on index %u'):format(res.x, res.y, res_i), res_b)
	end
end

cb.add(cb.tick, on_tick)
```
####pred.core.get_pos_after_time(obj, time)
Parameters<br>
`obj` obj<br>
`number` time<br>
Return Value<br>
`vec2` returns position of obj after time<br>
``` lua
local pred = module.internal('pred')

local function on_tick()
	local res = pred.core.get_pos_after_time(player, 0.5)
	print(('%.2f-%.2f'):format(res.x, res.y))
end

cb.add(cb.tick, on_tick)
```
####pred.linear.get_prediction(input, tar, src)
Parameters<br>
`table` input<br>
`obj` tar<br>
`obj` src [optional]<br>
Return Value<br>
`seg` returns a line segment<br>
``` lua
--this example is based on caitlyn q
local orb = module.internal('orb')
local ts = module.internal('TS')
local pred = module.internal('pred')

local pred_input = {
  delay = 0.625,
  speed = 2200,
  width = 60,
  range = 1150,
  boundingRadiusMod = 1,
  collision = {
    wall = true,
  },
}

local function trace_filter(seg, obj)
	if seg.startPos:dist(seg.endPos) > pred_input.range then return false end

  if pred.trace.linear.hardlock(pred_input, seg, obj) then
    return true
  end
  if pred.trace.linear.hardlockmove(pred_input, seg, obj) then
    return true
  end
  if pred.trace.newpath(obj, 0.033, 0.500) then
    return true
  end
end

local function target_filter(res, obj, dist)
	if dist > 1500 then return false end
	local seg = pred.linear.get_prediction(pred_input, obj)
	if not seg then return false end
	if not trace_filter(seg, obj) then return false end
	
	res.pos = seg.endPos
	return true
end

local function on_tick()
	if player:spellSlot(0).state~=0 then return end

	
	local res = ts.get_result(target_filter)
	if res.pos then
		player:castSpell('pos', 0, vec3(res.pos.x, mousePos.y, res.pos.y))
		orb.core.set_server_pause()
		return true
	end
end

cb.add(cb.tick, on_tick)
```
####pred.circular.get_prediction(input, tar, src)
Parameters<br>
`table` input<br>
`obj` tar<br>
`obj` src [optional]<br>
Return Value<br>
`seg` returns a line segment<br>
``` lua
--this example is based on xerath w
local orb = module.internal('orb')
local ts = module.internal('TS')
local pred = module.internal('pred')

local pred_input = {
	delay = 0.75,
	radius = 275,
	speed = math.huge,
	boundingRadiusMod = 0,
}

local function trace_filter(seg, obj)
	if seg.startPos:dist(seg.endPos) > 950 then return false end

  if pred.trace.circular.hardlock(pred_input, seg, obj) then
    return true
  end
  if pred.trace.circular.hardlockmove(pred_input, seg, obj) then
    return true
  end
  if pred.trace.newpath(obj, 0.033, 0.500) then
    return true
  end
end

local function target_filter(res, obj, dist)
	if dist > 1500 then return false end
	local seg = pred.circular.get_prediction(pred_input, obj)
	if not seg then return false end
	if not trace_filter(seg, obj) then return false end
	
	res.pos = seg.endPos
	return true
end

local function on_tick()
	if player:spellSlot(1).state~=0 then return end

	
	local res = ts.get_result(target_filter)
	if res.pos then
		player:castSpell('pos', 1, vec3(res.pos.x, mousePos.y, res.pos.y))
		orb.core.set_server_pause()
		return true
	end
end

cb.add(cb.tick, on_tick)
```
####pred.present.get_source_pos(obj)
Parameters<br>
`obj` obj<br>
Return Value<br>
`vec2` returns server pos of obj<br>
####pred.present.get_prediction(input, tar, src)
Parameters<br>
`table` input<br>
`obj` tar<br>
`obj` src [optional]<br>
Return Values<br>
`vec2`<br>
``` lua
--this example is based on kindred e
local orb = module.internal('orb')
local ts = module.internal('TS')
local pred = module.internal('pred')

local pred_input = {
  delay = 0,
  radius = player.attackRange,
  dashRadius = 0,
  boundingRadiusModSource = 1,
  boundingRadiusModTarget = 1,
}

local function target_filter(res, obj, dist)
	if dist>800 then return false end
	if not pred.present.get_prediction(pred_input, obj) then return false end
	
	res.obj = obj
	return true
end

local function invoke()
	if player:spellSlot(2).state~=0 then return end
	
	local res = ts.get_result(target_filter)
	if res.obj then
		player:castSpell('obj', 2, res.obj)
		orb.core.set_server_pause()
		return true
  end
end
```
####pred.collision.get_prediction(input, pred_result, ign_obj)
Parameters<br>
`table` input<br>
`seg` pred_result<br>
`obj` ign_obj [optional]<br>
Return Values<br>
`table` returns a table of objects that pred_result will collide with or nil if no collision is detected<br>
``` lua 
--this example is based on morgana q
local orb = module.internal('orb')
local ts = module.internal('TS')
local pred = module.internal('pred')

local pred_input = {
  delay = 0.25,
  speed = 1200,
  width = 70,
  boundingRadiusMod = 1,
	range = 1100,
  collision = {
    minion = true, --checks collision for minions
    wall = true, --checks collision for yasuo wall or braum shield
    hero = false, --no need to check for hero collision
  },
}

local function trace_filter(seg, obj, dist)
	if seg.startPos:dist(seg.endPos) > pred_input.range then
		return false
	end
  if pred.trace.newpath(obj, 0.033, 0.500) and dist < 600 then
		return true
  end
  if pred.trace.linear.hardlock(pred_input, seg, obj) then
    return true
  end
  if pred.trace.linear.hardlockmove(pred_input, seg, obj) then
    return true
  end
end

local function target_filter(res, obj, dist)
	if dist > pred_input.range then return false end
	local seg = pred.linear.get_prediction(pred_input, obj)
	if not seg then return false end
	if not trace_filter(seg, obj, dist) then return false end
	--pass obj as third arg, it will then be ignored from collision checks
	if pred.collision.get_prediction(pred_input, seg, obj) then return false end
	
	res.pos = seg.endPos
	return true
end

local function on_tick()
  if player:spellSlot(0).state~=0 then return end

  local res = ts.get_result(target_filter)
  if res.pos then
    player:castSpell('pos', 0, vec3(res.pos.x, mousePos.y, res.pos.y))
    orb.core.set_server_pause()
    return true
  end
end

cb.add(cb.tick, on_tick)
```
###orb
####orb.core.reset()
Return Value<br>
`void`<br>
``` lua
local orb = module.internal('orb')
orb.core.reset() --resets the orbwalks attack cooldown
```
####orb.core.can_action()
Return Value<br>
`boolean` returns true if player can move or cast spells<br>
``` lua
local orb = module.internal('orb')

local function on_tick()
	print(orb.core.can_action() and 'can action' or 'can not action')
end

cb.add(cb.tick, on_tick)
```
####orb.core.can_attack()
Return Value<br>
`boolean` returns true if player can attack<br>
``` lua
local orb = module.internal('orb')

local function on_tick()
	print(orb.core.can_attack() and 'can attack' or 'can not attack')
end

cb.add(cb.tick, on_tick)
```
####orb.core.is_paused()
Return Value<br>
`boolean` returns true if the orb is paused (will not issue any orders)<br>
``` lua
local orb = module.internal('orb')

local function on_tick()
	print(orb.core.is_paused() and 'is paused' or 'is not paused')
end

cb.add(cb.tick, on_tick)
```
####orb.core.is_move_paused()
Return Value<br>
`boolean` returns true if the orb movement is paused (will not issue move orders)<br>
``` lua
local orb = module.internal('orb')

local function on_tick()
	print(orb.core.is_move_paused() and 'move is paused' or 'move is not paused')
end

cb.add(cb.tick, on_tick)
```
####orb.core.is_attack_paused()
Return Value<br>
`boolean` returns true if the orb attacks are paused (will not issue attack orders)<br>
``` lua
local orb = module.internal('orb')

local function on_tick()
	print(orb.core.is_attack_paused() and 'attack is paused' or 'attack is not paused')
end

cb.add(cb.tick, on_tick)
```
####orb.core.set_pause(t)
Parameters<br>
`number` t<br>
Return Value<br>
`void`<br>
``` lua
local orb = module.internal('orb')

local function on_process_spell(spell)
	if spell.owner==player and spell.name=='AnnieQ' then
		orb.core.set_pause(0.25)
	end
end

cb.add(cb.spell, on_process_spell)
```
####orb.core.set_pause_move(t)
Parameters<br>
`number` t<br>
Return Value<br>
`void`<br>
####orb.core.set_pause_attack(t)
Parameters<br>
`number` t<br>
Return Value<br>
`void`<br>
``` lua
local orb = module.internal('orb')

local function on_process_spell(spell)
	if spell.owner==player and spell.name=='XayahR' then
		orb.core.set_pause_attack(1.5)
	end
end

cb.add(cb.spell, on_process_spell)
```
####orb.core.set_server_pause()
Return Value<br>
`void`<br>
``` lua
local orb = module.internal('orb')

local function on_tick()
  if orb.core.is_paused() or not orb.core.can_action() or orb.core.is_move_paused() then return end
	
	if player:spellSlot(0).state~=0 then return end
	player:castSpell('pos', 0, mousePos)
	orb.core.set_server_pause()
end

cb.add(cb.tick, on_tick)
```
####orb.core.set_server_pause_attack()
Return Value<br>
`void`<br>
####orb.combat.is_active()
Return Value<br>
`boolean` returns true if combat mode is active<br>
``` lua
local orb = module.internal('orb')

local function on_tick()
  if orb.combat.is_active() then
		print('combat active')
	end
end

cb.add(cb.tick, on_tick)
```
####orb.combat.register_f_after_attack(func)
Parameters<br>
`function` func<br>
Return Value<br>
`void`<br>
``` lua
local orb = module.internal('orb')

local function after_attack()
  print('attack is on cooldown')
end

orb.combat.register_f_after_attack(after_attack)
```
####orb.combat.register_f_out_of_range(func)
Parameters<br>
`function` func<br>
Return Value<br>
`void`<br>
``` lua
local orb = module.internal('orb')

local function out_of_range()
	print('there is no target in aa range')
end

orb.combat.register_f_out_of_range(out_of_range)
```
####orb.combat.register_f_pre_tick(func)
Parameters<br>
`function` func<br>
Return Value<br>
`void`<br>
``` lua
local orb = module.internal('orb')

local function on_tick() --this fucntion is triggered prior to the orbs tick
	
end

orb.combat.register_f_pre_tick(on_tick)
```
####orb.combat.set_invoke_after_attack(val)
Parameters<br>
`boolean` val<br>
Return Value<br>
`void`<br>
``` lua
local orb = module.internal('orb')

local function after_attack()
  print('attack is on cooldown')
	orb.combat.set_invoke_after_attack(false)
end

orb.combat.register_f_after_attack(after_attack)
```
####orb.farm.clear_target
Return Value<br>
`obj` returns the orbs current lane clear target<br>
``` lua
local orb = module.internal('orb')

local function on_tick()
  if orb.farm.clear_target then
		print(orb.farm.clear_target.charName)
	end
end

cb.add(cb.tick, on_tick)
```
####orb.farm.lane_clear_wait()
Return Value<br>
`boolean` returns true if the orb is currently waiting to attack a minion that is soon to die<br>
``` lua
local orb = module.internal('orb')

local function on_tick()
  if orb.farm.lane_clear_wait() then
		print('lane clear is waiting to attack a minion')
	end
end

cb.add(cb.tick, on_tick)
```
####orb.farm.predict_hp(obj, time)
Parameters<br>
`minion.obj` obj<br>
`number` time<br>
Return Value<br>
`number` returns the minions health after time (seconds)<br>
``` lua
local orb = module.internal('orb')

local function on_tick()
	for i=0, objManager.minions.size[TEAM_ENEMY]-1 do
		local obj = objManager.minions[TEAM_ENEMY][i]
		if obj.isVisible then
			local hp = orb.farm.predict_hp(obj, 0.25)
			print(obj.charName, obj.health, hp)
		end
	end
end

cb.add(cb.tick, on_tick)
```
####orb.farm.set_ignore(obj, time)
Parameters<br>
`minion.obj` obj<br>
`number` time<br>
Return Value<br>
`void`<br>
####orb.farm.skill_farm_linear(input)
Parameters<br>
`table` input<br>
Return Value<br>
`seg` returns a line segment<br>
`minion.obj` returns the minion object<br>
``` lua
--based on mundo q
local orb = module.internal('orb')
local input = {
	delay = 0.25,
	speed = 2000,
	width = 60,
	boundingRadiusMod = 1,
	range = 1050,
	collision = {
		minion=true,
		walls=true,
		hero=true,
	},
	damage = function(m)
		local q_level = player:spellSlot(0).level
		return math.min(250 + 50*q_level, math.max(30 + 50*q_level, m.health*(.125 + .025*q_level)))
	end,
}

local function on_tick()
	local seg, obj = orb.farm.skill_farm_linear(input)
	if seg then
		player:castSpell('pos', 0, seg.endPos)
	end
end

cb.add(cb.tick, on_tick)
```
####orb.farm.skill_clear_linear(input)
Parameters<br>
`table` input<br>
Return Value<br>
`seg` returns a line segment<br>
`minion.obj` returns the minion object<br>
``` lua
--based on mundo q
local orb = module.internal('orb')
local input = {
	delay = 0.25,
	speed = 2000,
	width = 60,
	boundingRadiusMod = 1,
	range = 1050,
	collision = {
		minion=true,
		walls=true,
		hero=true,
	},
	damage = function(m)
		local q_level = player:spellSlot(0).level
		return math.min(250 + 50*q_level, math.max(30 + 50*q_level, m.health*(.125 + .025*q_level)))
	end,
}

local function on_tick()
	local seg, obj = orb.farm.skill_clear_linear(input)
	if seg then
		player:castSpell('pos', 0, seg.endPos)
	end
end

cb.add(cb.tick, on_tick)
```
####orb.farm.skill_farm_circular(input)
Parameters<br>
`table` input<br>
Return Value<br>
`seg` returns a line segment<br>
`minion.obj` returns the minion object<br>
``` lua
--based on karthus q
local orb = module.internal('orb')
local input = {
	delay = 0.75,
	speed = math.huge,
	radius = 200,
	boundingRadiusMod = 0,
	range = 874,
	damage = function(m)
		return 20*player:spellSlot(0).level + 30 + .3*(player.flatMagicDamageMod*player.percentMagicDamageMod)
	end,
}

local function on_tick()
	local seg, obj = orb.farm.skill_farm_circular(input)
	if seg then
		player:castSpell('pos', 0, seg.endPos)
	end
end

cb.add(cb.tick, on_tick)
```
####orb.farm.skill_clear_circular(input)
Parameters<br>
`table` input<br>
Return Value<br>
`seg` returns a line segment<br>
`minion.obj` returns the minion object<br>
``` lua
--based on karthus q
local orb = module.internal('orb')
local input = {
	delay = 0.75,
	speed = math.huge,
	radius = 200,
	boundingRadiusMod = 0,
	range = 874,
	damage = function(m)
		return 20*player:spellSlot(0).level + 30 + .3*(player.flatMagicDamageMod*player.percentMagicDamageMod)
	end,
}

local function on_tick()
	local seg, obj = orb.farm.skill_clear_circular(input)
	if seg then
		player:castSpell('pos', 0, seg.endPos)
	end
end

cb.add(cb.tick, on_tick)
```
####orb.farm.skill_farm_target(input)
Parameters<br>
`table` input<br>
Return Value<br>
`seg` returns a line segment<br>
`minion.obj` returns the minion object<br>
``` lua
--based on pantheon q
local orb = module.internal('orb')
local input = {
	delay = 0.25,
	speed = 1500,
	range = 468,
	damage = function(target)
		return 35 + 40*player:spellSlot(0).level + 1.4*((player.baseAttackDamage + player.flatPhysicalDamageMod)*player.percentPhysicalDamageMod - player.baseAttackDamage)
	end,
}

local function on_tick()
	local seg, obj = orb.farm.skill_farm_target(input)
	if obj then
		player:castSpell('obj', 0, obj)
	end
end

cb.add(cb.tick, on_tick)
```
####orb.farm.skill_clear_target(input)
Parameters<br>
`table` input<br>
Return Value<br>
`seg` returns a line segment<br>
`minion.obj` returns the minion object<br>
``` lua
--based on pantheon q
local orb = module.internal('orb')
local input = {
	delay = 0.25,
	speed = 1500,
	range = 468,
	damage = function(target)
		return 35 + 40*player:spellSlot(0).level + 1.4*((player.baseAttackDamage + player.flatPhysicalDamageMod)*player.percentPhysicalDamageMod - player.baseAttackDamage)
	end,
}

local function on_tick()
	local seg, obj = orb.farm.skill_clear_target(input)
	if obj then
		player:castSpell('obj', 0, obj)
	end
end

cb.add(cb.tick, on_tick)
```
####orb.farm.set_clear_target(obj)
Parameters<br>
`minion.obj` obj<br>
Return Value<br>
`void`<br>
####orb.utility.get_missile_speed(obj)
Parameters<br>
`obj` obj<br>
Return Value<br>
`number` returns the obj attack missile speed<br>
####orb.utility.get_wind_up_time(obj)
Parameters<br>
`obj` obj<br>
Return Value<br>
`number` returns the obj attacks wind up time<br>
####orb.utility.get_damage_mod(obj)
Parameters<br>
`obj` obj<br>
Return Value<br>
`number` returns the obj damage mod (wards ex)<br>
####orb.utility.get_damage(source, target, add_bonus)
Parameters<br>
`obj` source<br>
`obj` target<br>
`boolean` add_bonus<br>
Return Value<br>
`number` returns attack damage done to target by source<br>
####orb.utility.get_hit_time(source, target)
Parameters<br>
`obj` source<br>
`obj` target<br>
Return Value<br>
`number` returns time in seconds for an attack from source to hit target<br>
####orb.utility.is_high_value(obj)
Parameters<br>
`minion.obj` obj<br>
Return Value<br>
`boolean` returns true if obj is of high value (cannon minions ex)<br>
####orb.utility.get_bar_width(obj)
Parameters<br>
`minion.obj` obj<br>
Return Value<br>
`number` returns the obj hp bar width<br>
####orb.ts
Return Value<br>
`TS` returns the orbs target selector instance<br>
####orb.menu.combat.key:get()
Return Value<br>
`boolean` returns true if combat mode is active<br>
####orb.menu.lane_clear.key:get()
Return Value<br>
`boolean` returns true lane clear mode is active<br>
####orb.menu.last_hit.key:get()
Return Value<br>
`boolean` returns true last hit mode is active<br>
####orb.menu.hybrid.key:get()
Return Value<br>
`boolean` returns true if hybrid mode is active<br>
###evade
####evade.core.set_server_pause()
Return Value<br>
`void`<br>
####evade.core.set_pause(t)
Parameters<br>
`number` t<br>
Return Value<br>
`void`<br>
``` lua
local evade = module.internal('evade')
evade.core.set_pause(3) --pauses the evade from taking action for 3 seconds
```
####evade.core.is_paused()
Return Value<br>
`boolean` returns true if evade is currently paused<br>
####evade.core.is_active()
Return Value<br>
`boolean` returns true if evade is currently evading a spell<br>
####evade.core.is_action_safe(v1, speed, delay)
Parameters<br>
`vec2\vec3` v1<br>
`number` speed<br>
`number` delay<br>
Return Value<br>
`boolean` returns true if action is safe<br>
``` lua
--this example is based on vayne q
local evade = module.internal('evade')

local function on_tick()
	if player:spellSlot(0).state~=0 then return end
	
	local pos = player.path.serverPos2D + (mousePos2D - player.path.serverPos2D):norm()*300
	if evade.core.is_action_safe(pos, 500 + player.moveSpeed, 0) then
		player:castSpell('pos', 0, vec3(pos.x, mousePos.y, pos.y))
	end
end

cb.add(cb.tick, on_tick)	
```
###TS
####TS.get_result(func, filter, ign_sel, hard)
Parameters<br>
`function` func<br>
`table` filter[optional]<br>
`boolean` ign_sel[optional]<br>
`boolean` hard[optional]<br>
Return Value<br>
`table`<br>
``` lua
--this example is based on annie q
local ts = module.internal('TS')
local pred = module.internal('pred')
local input = {
  delay = 0,
  radius = 505,
  dashRadius = 0,
  boundingRadiusModSource = 1,
  boundingRadiusModTarget = 1,
}

local function ts_filter(res, obj, dist)
	--return false for any objects much too far away
	if dist > 800 then return false end
	
	--pred.present.get_prediction checks that obj is in range for q
	if pred.present.get_prediction(input, obj) then
		--res.obj is arbitrary and could be named anything
		--additionally, anything you like can be added to the res table
		res.obj = obj
		return true
	end
end

local function on_tick()
	--check that q is ready
	if player:spellSlot(0).state~=0 then return end

	--ts.get_result loops through all valid enemies
	--simple usage
	local res = ts.get_result(ts_filter)
	if res.obj then
		player:castSpell('obj', 0, res.obj)
	end
	
	--alternative usages
	local res = ts.get_result(ts_filter, ts.filter_set[2]) --uses filter LESS_CAST_AD_PRIO (overrides menu)
	local res = ts.get_result(ts_filter, nil, true) --ignores ts selected target
	local res = ts.get_result(ts_filter, nil, nil, true) --forces ts selected target to be returned (overrides menu)
end

cb.add(cb.tick, on_tick)
```
####TS.get_active_filter()
Return Value<br>
`table`<br>
``` lua
local ts = module.internal('TS')
print(ts.get_active_filter().name)
```
####TS.loop(func, filter)
Parameters<br>
`function` func<br>
`table` filter[optional]<br>
Return Value<br>
`table`<br>
``` lua
local ts = module.internal('TS')

local function loop_filter(res, obj, dist)
	-- any condition can be set here
	if dist < 800 then
		table.insert(res, obj)
	end
end

local function on_tick()
	local res = ts.loop(loop_filter)
	--res will contain all valid enemies within 800 units
end

cb.add(cb.tick, on_tick)
```
####TS.loop_allies(func, filter)
Parameters<br>
`function` func<br>
`table` filter[optional]<br>
Return Value<br>
`table`<br>
``` lua
local ts = module.internal('TS')

local function loop_filter(res, obj, dist)
	-- any condition can be set here
	if dist < 800 then
		table.insert(res, obj)
	end
end

local function on_tick()
	local res = ts.loop_allies(loop_filter)
	--res will contain all valid allies within 800 units
end

cb.add(cb.tick, on_tick)
```
####TS.filter.new()
Return Value<br>
`table`<br>
``` lua
local ts = module.internal('TS')

local my_filter = ts.filter.new()
my_filter.name = 'LEAST_MANA'
my_filter.rank = {0.33, 0.66, 1.0, 1.33, 1.66} --these correspond to character priorities set in the menu, the lower the ratio the higher priority will be given
my_filter.index = function(obj, rank_val)
	return obj.par
	--alternatively, this will return the target with the least mana adjusted by priority
	-- return obj.par * rank_value
end

local function ts_filter(res, obj, dist)
	if dist < 800 then
		res.obj = obj
		return true
	end
end

local res = ts.get_result(ts_filter, my_filter)
```
####TS.filter_set
Return Value<br>
`table`<br>
``` lua
local ts = module.internal('TS')
for Nebelwolfi=1, #ts.filter_set do
	print(ts.filter_set[Nebelwolfi].name)
end
```
#Globals

 * player
 * mousePos
 * mousePos2D
 * TYPE_TROY
 * TYPE_HERO
 * TYPE_MINION
 * TYPE_MISSILE
 * TYPE_TURRET
 * TYPE_INHIB
 * TYPE_NEXUS
 * TYPE_SPAWN
 * TYPE_SHOP
 * TYPE_CAMP
 * TEAM_ALLY
 * TEAM_ENEMY
 * TEAM_NEUTRAL
 * _Q
 * _W
 * _E
 * _R
 * COLOR_RED
 * COLOR_GREEN
 * COLOR_BLUE
 * COLOR_YELLOW
 * COLOR_AQUA
 * COLOR_PURPLE
 * COLOR_BLACK
 * COLOR_WHITE
 * BUFF_AURA
 * BUFF_COMBATENCHANCER
 * BUFF_COMBATDEHANCER
 * BUFF_SPELLSHIELD
 * BUFF_STUN
 * BUFF_INVISIBILITY
 * BUFF_SILENCE
 * BUFF_TAUNT
 * BUFF_POLYMORPH
 * BUFF_SLOW
 * BUFF_SNARE
 * BUFF_DAMAGE
 * BUFF_HEAL
 * BUFF_HASTE
 * BUFF_SPELLIMMUNITY
 * BUFF_PHYSICALIMMUNITY
 * BUFF_INVULNERABILITY
 * BUFF_ATTACKSPEEDSLOW
 * BUFF_NEARSIGHT
 * BUFF_FEAR
 * BUFF_SHRED
 * BUFF_CHARM
 * BUFF_POISON
 * BUFF_SUPPRESSION
 * BUFF_BLIND
 * BUFF_COUNTER
 * BUFF_CURRENCY
 * BUFF_FLEE
 * BUFF_KNOCKUP
 * BUFF_KNOCKBACK
 * BUFF_DISARM
 * BUFF_GROUNDED
 * BUFF_DROWSY
 * BUFF_ASLEEP
 * BUFF_OBSCURED
 * BUFF_CLICKPROOFTOENEMIES
 * BUFF_UNKILLABLE
 
#Examples
###Callbacks
The following callbacks have no arguments:<br>

 * cb.pre_tick
 * cb.tick
 * cb.draw
 * cb.draw2
 * cb.sprite
 
cb.draw2 is triggered before cb.sprite, while cb.draw is triggered after cb.sprite.

####cb.keydown and cb.keyup
Both have a single arg, key_code:<br>
``` lua
local function on_key_down(k)
	if k==49 then
		print('the 1 key is down')
	end
end

local function on_key_up(k)
	if k==49 then
		print('the 1 key is up')
	end
end

cb.add(cb.keydown, on_key_down)
cb.add(cb.keyup, on_key_up)
```

####cb.spell
Has a single arg, spell.obj:<br>
``` lua
local function on_process_spell(spell)
	print(spell.name, spell.owner.charName)
end

cb.add(cb.spell, on_process_spell)
```

####cb.issueorder
Has three args: order_type, pos, obj:<br>

Note that `cb.issueorder` will only work for hanbot internal request, user's manual movement/attack will not trigger this event.

``` lua
local function on_issue_order(order, pos, obj)
	if order==2 then
		print(('move order issued at %.2f - %.2f'):format(pos.x, pos.z))
	end
	if order==3 then
		print(('attack order issued to %u'):format(obj))
	end
end

cb.add(cb.issueorder, on_issue_order)
```

####cb.issue_order
just a better version of `cb.issueorder`<br>
args: `IssueOrderArgs`:<br>

 * `boolean` args.process
 * `number` args.order
 * `vec3` args.pos
 * `obj` args.target
 * `boolean` args.isShiftPressed
 * `boolean` args.isAltPressed
 * `boolean` args.shouldPlayOrderAcknowledgementSound

Note that `cb.issue_order` will only work for hanbot internal request, user's manual movement/attack will not trigger this event.

Warning: If you want to change the target or pos of `issue_order`, please use `orb.combat.register_f_pre_tick` and `TS.filter`, use `cb.issue_order` is not recommended, it will cause lots logic problems.

``` lua
local function on_issue_order(args)
	if args.order==2 then
		print(('move order issued at %.2f - %.2f'):format(args.pos.x, args.pos.z))
		return
	end
	
	if args.order==3 then
		print(('attack order issued to %u'):format(args.target.ptr))
		return
	end
	
	if SOME_CONDITION_1 then
		args.pos = cursorPos -- you can change any parameters
		return
	end
	
	if SOME_CONDITION_2 then
		args.process = false -- block this issue_order 
		return
	end
end

cb.add(cb.issue_order, on_issue_order)
```

####cb.castspell
Has four args: slot, startpos, endpos, nid:<br>

Note that `cb.cast_spell` will only work for hanbot internal request, user's manual cast will not trigger this event.

``` lua
local function on_cast_spell(slot, startpos, endpos, nid)
	print(('%u, %.2f-%.2f, %.2f-%.2f, %u'):format(slot, startpos.x, startpos.z, endpos.x, endpos.z, nid))
end

cb.add(cb.castspell, on_cast_spell)
```

####cb.cast_spell
just a better version of `cb.castspell` <br>
args: `CastSpellArgs`:<br>

 * `boolean` args.process
 * `number` args.spellSlot
 * `vec3` args.targetPosition
 * `vec3` args.targetEndPosition
 * `obj` args.target

Note that `cb.cast_spell` will only work for hanbot internal request, user's manual cast will not trigger this event.

``` lua
local function on_cast_spell(args)
	print(('spellSlot: %u, target: %u'):format(args.spellSlot, args.target and args.target.ptr or 0))

	if SOME_CONDITION_2 then
		args.process = false -- block this cast_spell 
		return
	end
end

cb.add(cb.cast_spell, on_cast_spell)
```

####cb.create_minion and cb.delete_minion
Both have a single arg, minion.obj<br>
``` lua
local function on_create_minion(obj)
	print(obj.name, obj.charName)
end

local function on_delete_minion(obj)
	--obj is invalid within the scope of this function, it is dangerous to check obj properties other than .ptr
	print(obj.ptr)
end

cb.add(cb.create_minion, on_create_minion)
cb.add(cb.delete_minion, on_delete_minion)
```

####cb.create_missile and cb.delete_missile
Both have a single arg, missile.obj<br>
``` lua
local function on_create_missile(obj)
	print(obj.name, obj.speed, obj.spell.name)
end

local function on_delete_missile(obj)
	--obj is invalid within the scope of this function, it is dangerous to check obj properties other than .ptr
	print(obj.ptr)
end

cb.add(cb.create_missile, on_create_missile)
cb.add(cb.delete_missile, on_delete_missile)
```

####cb.create_particle and cb.delete_particle
Both have a single arg, base.obj<br>
``` lua
local function on_create_particle(obj)
	print(obj.name, obj.x, obj.z)
end

local function on_delete_particle(obj)
	--obj is invalid within the scope of this function, it is dangerous to check obj properties other than .ptr
	print(obj.ptr)
end

cb.add(cb.create_particle, on_create_particle)
cb.add(cb.delete_particle, on_delete_particle)
```

###Creating Shards
Introducing shards, a new way of binding and encrypting your folder into a single file.<br><br>
To build shards, you have to add a shard table to your header.lua, which contains all the names of your files you would use in module.load(id, name).<br>
If you build a libshard, lib = true has to be added additionally.<br>
``` lua
return {
  ...
  ...
  shard = {
    'main', 'spells/q',
  },
  lib = true,
}
```
Additionally you can bind sprites into a shard by adding it's names to a resource table.<br>
When building the shard, the sprites have to be in hanbot/sprites.<br>
``` lua
return {
  ...
  ...
  shard = {
    'main', 'spells/q',
  },
  resources = {
    'SPRITE_NAME.png', —developer/SHARD_NAME/SPRITE_NAME.png
    'SUB_FOLDER/SPRITE_NAME.png', —developer/SHARD_NAME/SUB_FOLDER/SPRITE_NAME.png
  },
  lib = true,
}
```
Note that the sprite name added to the resource folder is the same as when using it ingame.<br>
``` lua
cb.add(cb.sprite, function()
  graphics.draw_sprite('SPRITE_NAME.png', vec3)
  graphics.draw_sprite('SUB_FOLDER/SPRITE_NAME.png', vec3)
end)
```
Shard builder is displayed in hanbox64 client if you have a developer key.<br>
Enter the name of your script or lib folder and press the corresponding button.<br><br>
Warning: <br>
There is no error handling for the shard builder. <br>
Make sure your script is working ingame, has a valid header and the folder name is being input correctly.<br>
Do not build shards out of scripts that already use the crypt module.<br><br>
To load shards ingame, both script (.obj) and libshards (.lib) have to be put directly into lol-nd/shards/<br>
###Avoiding Bugsplats
Variables must be properly purged, attempting to access certain obj properties after the obj has been deleted by the LoL client will result in LoL bugsplatting<br>
``` lua
local ex_obj

local function on_tick()
	if ex_obj and ex_obj.isDead then
		ex_obj = nil
	end
	--continue rest of your code
end

local function on_create_minion(obj)
	if not ex_obj then
		ex_obj = obj
	end
end

local function on_delete_minion(obj)
	if ex_obj and ex_obj.ptr==obj.ptr then
		ex_obj = nil
	end
end

cb.add(cb.tick, on_tick)
cb.add(cb.create_minion, on_create_minion)
cb.add(cb.delete_minion, on_delete_minion)
```
Do not use spell.obj outside of the spell callback.<br>
``` lua
local wrong
local correct

local function on_process_spell(spell)
	if not wrong then
		wrong = spell
	end
	if not correct then
		correct = {
			windUpTime = spell.windUpTime,
			startPos = vec3(spell.startPos),
		}
	end
end

local function on_tick()
	if wrong then
		--DO NOT DO THIS, this is very likely to lead to bugsplats!
		print(wrong.windUpTime)
	end
	
	if correct then
		--Instead, do this
		print(correct.windUpTime)
	end
end

cb.add(cb.spell, on_process_spell)
cb.add(cb.tick, on_tick)
```
Do not attempt to access obj properties other than ptr in cb.delete_minion, cb.delete_particle or cb.delete_missile.<br>
``` lua
local function on_delete_minion(obj)
	--wrong
	if obj.charName=='dontdothis' then
		--this is likely to lead to bugsplats
	end
	
	--correct, only check ptrs here
	if obj.ptr==someobj.ptr then
		someobj = nil
	end
end

local function on_delete_particle(obj)
	--wrong
	if obj.charName=='dontdothis' then
		--this is likely to lead to bugsplats
	end
	
	--correct, only check ptrs here
	if obj.ptr==someobj.ptr then
		someobj = nil
	end
end

local function on_delete_missile(obj)
	--wrong
	if obj.charName=='dontdothis' then
		--this is likely to lead to bugsplats
	end
	
	--correct, only check ptrs here
	if obj.ptr==someobj.ptr then
		someobj = nil
	end
end

cb.add(cb.create_minion, on_create_minion)
cb.add(cb.create_particle, on_delete_particle)
cb.add(cb.create_missile, on_delete_missile)
```
Do not use the buffManager, use obj.buff instead.<br>

#Paid Script Conditions
In an effort to reward the community developers for all their hard work and dedication we will now allow the sales of third-party scripts.

* 1a. Only "Community Developers" qualify to sell third party scripts
* 1b. To obtain the "Community Developers" status:
*    -User must display proficiency with the lua language 
*    -Communication with administration and users must be professional
* 2a. Trial time must be offered for all paid scripts
* 2b. Trial time must be a minimum of 3 days
* 3a. Scripts are limited in cost to 5.00USD/30 days
* 3b. 1-time payments may be offered by the author as an alternative payment method (condition 3a must still be offered)
* 4a. Conditions are subject to change at anytime without notice
* 4b. Third party scripts are not affiliated with HanBOT nor any staff of HanBOT
* 4c. Arbitration will not be offered by the HanBOT staff in cases of dispute