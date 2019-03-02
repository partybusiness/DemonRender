# DemonRender
A stupid shader trick to render 2D billboard monsters in Unity

This relies on instanced rendering in Unity, which allows you to pass properties to each instance. In this case, we pass the rotation of each demon and an "expression" value, which will select rows and columns from the demon's texture.

The vertices of the mesh are actually collapsed to a point and when rendered the shader offsets their position relative to the camera based on the secondary UVs. In theory I could have used a single set of UVs but I'd need to do extra math.

In my original method, I just rotated the UVs to face the camera around the 0,0,0 point, but that assumed that the 0,0,0 point for the mesh was consistent. Once the meshes are batched together, they actually share a 0,0,0 point and each mesh's vertices are offset. So that's why I collapse the vertices to a point in the mesh.

This could be accomplished with a particle system, too, but I've been playing with instance mesh rendering and stupid shader tricks, so this is the way I did it.
