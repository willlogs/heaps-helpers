package ecs;

import utils.Vector2;

class RigidBody extends ecs.Component{
    public var velocity:Vector2;
    public var velocityOffset:Vector2;
    public var gravity:Vector2;
    public var affectedByGravity:Bool;
    public var isTrigger:Bool = false;
    public var colliderNormals : List<Vector2> = new List<Vector2>();

    public function new(attachee:ecs.GameObject, affectedByGravity:Bool = false, isTrigger:Bool = false){
        super(attachee);

        type = "RigidBody";

        velocity = new Vector2();
        gravity = new Vector2();
        gravity.y = 10 * 100;

        this.affectedByGravity = affectedByGravity;
        this.isTrigger = isTrigger;
    }

    public override function update(dt:Float) {
        for(normal in colliderNormals){
            velocity.NeutralizeBy(normal);
        }
        colliderNormals.clear();

        attachee.obj.x += velocity.x * dt;
        attachee.obj.y += velocity.y * dt;

        if(affectedByGravity) {
            velocity.x += gravity.x * dt;
            velocity.y += gravity.y * dt;
        }
    }
}