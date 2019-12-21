package ecs;

class GameObject{
    public var components = new List<ecs.Component>();
    public var scene : h2d.Scene;
    public var obj : h2d.Object;
    public var name : String;
    public var tag : Int;

    public function new(scene:h2d.Scene, x:Float = -1, y:Float = -1, n:String = "GO", t:Int = 0){
        trace("new game object created!");
        this.scene = scene;
        
        if(x == -1){
            x = scene.width * 0.5;
        }
        if(y == -1){
            y = scene.height * 0.5;
        }

        obj = new h2d.Object(scene);
        obj.setPosition(x, y);

        name = n;
        tag = t;

        Main.UpdateList.add(this);
    }

    public function AddComponent(c:ecs.Component){
        trace("adding a component");
        components.add(c);
        c.scene = scene;
    }

    public function RemoveComponent(c:ecs.Component){
        trace("removing a component");
        components.remove(c);
    }

    public function GetComponent(type:String):Component{
        var comps = components.filter(function(c) return c.type == type);

        if(comps.length > 0){
            return comps.first();
        }
        return null;
    }

    public function update(dt:Float){
        for(item in components){
            item.update(dt);
        }
    }
}