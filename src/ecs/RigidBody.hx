package ecs;

import utils.Vector2;

class RigidBody extends ecs.Component{
    public var velocity:Vector2;
    public var velocityOffset:Vector2;
    public var gravity:Vector2;
    public var affectedByGravity:Bool;
    public var isTrigger:Bool = false;
    public var colliderNormals : List<{n: Vector2, err: Float}> = new List<{n: Vector2, err: Float}>();
    public var errTolerance : Float = 1;

    public function new(attachee:ecs.GameObject, affectedByGravity:Bool = false, isTrigger:Bool = false){
        super(attachee);

        type = "RigidBody";

        velocity = new Vector2(0, 0);
        gravity = new Vector2();
        gravity.y = 20 * 100;

        this.affectedByGravity = affectedByGravity;
        this.isTrigger = isTrigger;
    }

    public override function fixedUpdate() {
        var dt = Main.fixedDeltaTime;
        for(normal in colliderNormals){
            velocity.NeutralizeBy(normal.n);
            
            if(normal.err > errTolerance){
                attachee.obj.x += normal.n.x * normal.err * dt * 5;
                attachee.obj.y += normal.n.y * normal.err * dt * 5;
            }
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