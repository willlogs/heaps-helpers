package ecs;

import utils.Vector2;

class BoxCollider extends Collider {
    public var width:Float;
    public var height:Float;
    public var edges:List<{center: Vector2, normal: Vector2}> = new List<{center: Vector2, normal: Vector2}>();

    public function new(attachee:GameObject, center:Vector2, width:Float, height:Float) {
        this.width = width;
        this.height = height;
        super(attachee, center);
        updateEdges();
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

    public override function update(dt:Float) {
        super.update(dt);

        if(Main.DebugMode){
            Main.customGraphics.beginFill(0xff0000, 0.3);
            Main.customGraphics.drawRect(attachee.obj.x + center.x - width/2, attachee.obj.y + center.y - height/2, width, height);
            Main.customGraphics.endFill();
        }
    }

    private function updateEdges() {
        edges.clear();
        var center = GetCenter();
        edges.push({center: Vector2.sum(center, new Vector2(width, 0)), normal: new Vector2(1, 0)});
        edges.push({center: Vector2.sum(center, new Vector2(-width, 0)), normal: new Vector2(-1, 0)});
        edges.push({center: Vector2.sum(center, new Vector2(0, height)), normal: new Vector2(0, 1)});
        edges.push({center: Vector2.sum(center, new Vector2(0, -height)), normal: new Vector2(0, -1)});
    }
}