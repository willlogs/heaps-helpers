package ecs;

import utils.Vector2;

class BoxCollider extends Collider {
    public var width:Float;
    public var height:Float;

    private static var debugMode : Bool = true;

    public function new(attachee:GameObject, center:Vector2, width:Float, height:Float) {
        this.width = width;
        this.height = height;
        super(attachee, center);

        if(debugMode){
            var customGraphics = new h2d.Graphics(attachee.scene);
            customGraphics.beginFill(0xff0000, 0.3);
            customGraphics.drawRect(attachee.obj.x + center.x - width/2, attachee.obj.y + center.y - height/2, width, height);
            customGraphics.endFill();
        }
    }

    public override function GetTop():Float {
        return this.center.y + height / 2 + attachee.obj.y;
    }

    public override function GetBottom():Float {
        return this.center.y - height / 2 + attachee.obj.y;
    }

    public override function GetLeft():Float {
        return this.center.x - width / 2 + attachee.obj.x;
    }

    public override function GetRight():Float {
        return this.center.x + width / 2 + attachee.obj.x;
    }

    public override function GetCenter():Vector2 {
        return Vector2.sum(super.GetCenter(), new Vector2(0, 0));
    }
}