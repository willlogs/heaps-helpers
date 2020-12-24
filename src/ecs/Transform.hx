package ecs;

class Transform extends ecs.Component{
    
    public function new(attachee:ecs.GameObject, x:Float, y:Float){
        super(attachee);
    }
}