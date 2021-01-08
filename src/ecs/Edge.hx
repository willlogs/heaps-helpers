package ecs;

import utils.Vector2;

class Edge {
    public var center: Vector2;
    public var normal: Vector2;
    public var p1 : Vector2;
    public var p2 : Vector2;

    public function new(center:Vector2, normal:Vector2, p1: Vector2, p2: Vector2) {
        this.center = center;
        this.normal = normal;
        this.p1 = p1;
        this.p2 = p2;
    }
}