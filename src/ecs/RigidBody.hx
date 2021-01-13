package ecs;

import utils.Vector2;

class RigidBody extends ecs.Component{
    public var velocity:Vector2;
    public var velocityOffset:Vector2;
    public var gravity:Vector2;
    public var affectedByGravity:Bool;
    public var isTrigger:Bool = false;
    public var colliderNormals : List<{n: Vector2, err: Float}> = new List<{n: Vector2, err: Float}>();
    public var errTolerance : Float = 0.1;
    public var friction : Float = 0.05;

    public function new(attachee:ecs.GameObject, affectedByGravity:Bool = false, isTrigger:Bool = false, friction:Float = 0){
        super(attachee);

        type = "RigidBody";

        velocity = new Vector2(40, 0);
        gravity = new Vector2();
        gravity.y = 20 * 100;

        this.affectedByGravity = affectedByGravity;
        this.isTrigger = isTrigger;
        this.friction = friction;
    }

    public override function fixedUpdate() {
        var dt = Main.fixedDeltaTime;
        for(normal in colliderNormals){
            var normalVector : Vector2 = new Vector2(-normal.n.x, -normal.n.y);
            velocity.NeutralizeBy(normalVector);

            if(friction > 0){
                velocity = RigidBody.ApplyFriction(velocity, normal.n, friction);
            }
            
            if(normal.err > errTolerance){
                attachee.obj.x += normal.n.x * normal.err * dt * 20;
                attachee.obj.y += normal.n.y * normal.err * dt * 20;
            }

            velocity.x = Math.abs(velocity.x) < 0.01 ? 0 : velocity.x;
            velocity.y = Math.abs(velocity.y) < 0.01 ? 0 : velocity.y;
        }
        colliderNormals.clear();

        attachee.obj.x += velocity.x * dt;
        attachee.obj.y += velocity.y * dt;

        if(affectedByGravity) {
            velocity.x += gravity.x * dt;
            velocity.y += gravity.y * dt;
        }
    }

    public static function ApplyFriction(velocity: Vector2, normal: Vector2, friction: Float) : Vector2 {
        var dot = velocity.Normalized().Dot(normal.Normalized());
        var extent = 1 - Math.abs(dot);
        var oneMinusExtent = 1 - extent;

        friction = 1 - friction;
        friction *= extent;

        return new Vector2(velocity.x * friction + velocity.x * oneMinusExtent, velocity.y);
    }
}