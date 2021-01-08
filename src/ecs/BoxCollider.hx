package ecs;

import utils.Vector2;

class BoxCollider extends Collider {
    public var width:Float;
    public var height:Float;
    public var edges:List<Edge> = new List<Edge>();

    public function new(attachee:GameObject, center:Vector2, width:Float, height:Float, staticity:Bool = false) {
        this.width = width;
        this.height = height;
        super(attachee, center, staticity);
        updateEdges();
    }

    public override function GetTop():Float {
        return this.center.y - height / 2 + attachee.obj.y;
    }

    public override function GetBottom():Float {
        return this.center.y + height / 2 + attachee.obj.y;
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
        var left = GetLeft();
        var right = GetLeft();
        var top = GetLeft();
        var bottom = GetLeft();
        
        edges.push(new Edge(Vector2.sum(center, new Vector2(width, 0)), new Vector2(1, 0), new Vector2(right, top), new Vector2(right, bottom))); // right
        edges.push(new Edge(Vector2.sum(center, new Vector2(-width, 0)), new Vector2(1, 0), new Vector2(left, top), new Vector2(left, bottom))); // left
        edges.push(new Edge(Vector2.sum(center, new Vector2(0, height)), new Vector2(1, 0), new Vector2(left, bottom), new Vector2(right, bottom))); // down
        edges.push(new Edge(Vector2.sum(center, new Vector2(0, -height)), new Vector2(1, 0), new Vector2(left, top), new Vector2(right, top))); // up
    }
}