package ecs;

import utils.Vector2;

class RigidBody extends ecs.Component{
    public var velocity:Vector2;
    public var velocityOffset:Vector2;
    public var gravity:Vector2;
    public var affectedByGravity:Bool;

    public function new(attachee:ecs.GameObject, abg:Bool = false){
        super(attachee);

        type = "RigidBody";

        velocity = new Vector2();
        gravity = new Vector2();
        gravity.y = 10 * 100;

        affectedByGravity = abg;
    }

    public override function update(dt:Float) {
        attachee.obj.x += velocity.x * dt;
        attachee.obj.y += velocity.y * dt;
        if(affectedByGravity) {
            velocity.x += gravity.x * dt;
            velocity.y += gravity.y * dt;
        }
    }
}